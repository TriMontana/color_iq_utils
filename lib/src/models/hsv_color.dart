import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/argb_color.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// A representation of a color in the HSV (Hue, Saturation, Value) color space.
///
/// HSV is a cylindrical color model that remaps the RGB primary colors into
/// dimensions that are more intuitive for humans to understand.
/// - Hue (h): The type of color (e.g., red, green, blue). It is represented as an angle from 0 to 360 degrees.
/// - Saturation (s): The "purity" or intensity of the color. It ranges from 0.0 (gray) to 1.0 (fully saturated).
/// - Value (v): The brightness or lightness of the color. It ranges from 0.0 (black) to 1.0 (full brightness).
///
/// This class provides methods to ops from HSV to other color spaces
/// and to perform various color manipulations like adjusting brightness,
/// saturation, and finding harmonies.
/// See also [ColorIQ]
class HSV implements ColorWheelInf {
  final double h;
  final Percent saturation;
  final Percent value;
  final Percent a;
  final int? colorId;

  const HSV(this.h, this.saturation, this.value,
      {this.a = Percent.max, this.colorId});

  const HSV.fromAHSV(this.a, this.h, this.saturation, this.value,
      {this.colorId});

  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  static HSV fromRgbValues({
    required final Percent r,
    required final Percent g,
    required final Percent b,
    final Percent alpha = Percent.max,
    final int? hexId,
  }) {
    final double max = math.max(r.val, math.max(g.val, b.val));
    final double min = math.min(r.val, math.min(g.val, b.val));
    final double delta = max - min;

    final double hue = getHue(r.val, g.val, b.val, max, delta);
    final Percent saturation = Percent(max == 0.0 ? 0.0 : delta / max);
    final Percent value = Percent(max);

    return HSV(
      hue,
      saturation,
      value,
      a: alpha,
      colorId:
          hexId ?? HSV.hexIdFromHSV(hue, saturation.val, value.val, alpha.val),
    );
  }

  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  static HSV fromInt(final int hexId) =>
      HSV.fromRgbValues(r: hexId.r2, g: hexId.g2, b: hexId.b2, alpha: hexId.a2);

  static HSV fromColor(final ColorIQ color) {
    final AppColor argb = color.argb;
    return HSV.fromRgbValues(r: argb.r, g: argb.g, b: argb.b, alpha: argb.a);
  }

  /// Converts this color to HSV.
  static HSV fromARGB(final AppColor argb) =>
      HSV.fromRgbValues(r: argb.r, g: argb.g, b: argb.b, alpha: argb.a);

  @override
  int get hexId => colorId ?? HSV.hexIdFromHSV(h, saturation, value, a.val);

  @override
  Cam16 get cam16 => Cam16.fromInt(hexId);

  /// Creates a 32-bit integer ARGB value from HSV components.
  ///
  /// [h] is the hue, specified as a value between 0 and 360.
  /// [s] is the saturation, specified as a value between 0.0 and 1.0.
  /// [v] is the value, specified as a value between 0.0 and 1.0.
  /// [alpha] is the alpha channel, specified as a value between 0.0 and 1.0.
  static int hexIdFromHSV(final double h, final double s, final double v,
      [final double alpha = 1.0]) {
    final double chroma = s * v;
    final double secondary = chroma * (1.0 - (((h / 60.0) % 2.0) - 1.0).abs());
    final double match = v - chroma;

    return colorFromHue(alpha, h, chroma, secondary, match).value;
  }

  /// Returns this color in RGB.
  ColorIQ toColor() {
    final double chroma = saturation * value.val;
    final double secondary = chroma * (1.0 - (((h / 60.0) % 2.0) - 1.0).abs());
    final double match = value.val - chroma;

    return colorFromHue(a.val, h, chroma, secondary, match);
  }

  static HSV fromJson(final Map<String, dynamic> json) {
    return HSV(
      json['hue'],
      json['saturation'],
      Percent(json['value']),
      a: json['alpha'] ?? 1.0,
    );
  }

  @override
  String toString() => 'HsvColor(h: ${h.toStrTrimZeros(3)}, ' //
      's: ${saturation.toStrTrimZeros(3)}, v: ${value.toStringAsFixed(2)}, '
      'a: ${a.toStringAsFixed(2)})';

  @override
  ColorSlice closestColorSlice() => hexId.closestColorSlice();
}

/// Extension methods for HSV
extension HSVColorHelper on HSV {
  HSV darken([final double amount = 20]) =>
      copyWith(value: Percent(max(0.0, value.val - amount / 100)));

  HSV whiten([final double amount = 20]) => lerp(cWhite.hsv, amount / 100);

  HSV blacken([final double amount = 20]) => lerp(cBlack.hsv, amount / 100);

  HSV withValue(final Percent nuValue) => copyWith(value: nuValue);

  /// Returns a copy of this color with the [saturation] parameter replaced with
  /// the given value.
  HSV withSaturation(final Percent saturation) =>
      copyWith(saturation: saturation);

  HSV lerp(final HSV otherHsv, final double t) {
    if (t == 0.0) return this;

    if (t == 1.0) {
      return otherHsv;
    }

    return HSV(
      lerpHue(h, otherHsv.h, t),
      saturation.lerpTo(otherHsv.saturation, t),
      value.lerpTo(otherHsv.value, t),
    );
  }

  HSV lighten([final double amount = 20]) =>
      copyWith(value: Percent(min(1.0, value.val + amount / 100)));

  HSV brighten([final Percent amount = Percent.v20]) =>
      copyWith(value: Percent(min(1.0, value.val + amount.val)));

  HSV intensify([final Percent factor = Percent.v20]) {
    final Percent newSat = (saturation + factor).clampToPercent;
    final Percent newVal = (value + factor).clampToPercent;
    return copyWith(saturation: newSat, value: newVal);
  }

  HSV deintensify([final Percent factor = Percent.v20]) {
    final Percent newSat = (saturation - factor).clampToPercent;
    final Percent newVal = (value - factor).clampToPercent;
    return copyWith(saturation: newSat, value: newVal);
  }

  HSV saturate([final Percent amount = Percent.v25]) =>
      copyWith(saturation: min(1.0, saturation + amount).clampToPercent);

  HSV desaturate([final Percent amount = Percent.v25]) =>
      copyWith(saturation: Percent(max(0.0, saturation - amount)));

  /// Creates a copy of this color with the given fields replaced with the new values.
  HSV copyWith({
    final double? hue,
    final Percent? saturation,
    final Percent? value,
    final Percent? alpha,
  }) {
    return HSV(hue ?? h, saturation ?? this.saturation, value ?? this.value,
        a: alpha ?? a);
  }

  HSV blend(final HSV other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  HSV opaquer([final double amount = 20]) {
    final double x = min(1.0, a.val + amount / 100);
    return HSV(h, saturation, value, a: Percent(x));
  }

  HSV adjustHue([final double amount = 20]) =>
      copyWith(hue: wrapHue(h + amount));

  HSV get complementary => adjustHue(180);

  /// amount = stepDegrees
  HSV warmer([final double amount = 20]) {
    // 2. Define the new Hue, shifting counter-clockwise (reducing the angle).
    // The Hue is wrapped using the modulo operator to stay within [0, 360).
    // Adjust the hue to make it warmer (shift towards red)
    // Shift hue toward warmer side (lower hue values are red/yellow).
    double newHue = (h - amount) % 360.0;
    // Ensure the result is positive
    if (newHue < 0) {
      newHue += 360.0;
    }
    return copyWith(hue: newHue);
  }

  HSV cooler([final double amount = 20]) => toColor().cooler(amount).hsv;

  List<HSV> generateBasicPalette() =>
      toColor().generateBasicPalette().map((final ColorIQ c) => c.hsv).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HsvColor',
      'hue': h,
      'saturation': saturation,
      'value': value,
      'alpha': a,
    };
  }

  String createStr([final int precision = 4]) =>
      'HsvColor(h: ${h.toStrTrimZeros(precision)}, ' //
      's: ${saturation.toStringAsFixed(precision)}, v: ${value.toStringAsFixed(precision)}, '
      'a: ${a.toStringAsFixed(precision)})';
}

// --- HSV Strategy ---
class HsvStrategy extends ManipulationStrategy {
  const HsvStrategy();

  @override
  int lighten(final int argb, final double amount, {HSV? hsv}) {
    // HSV "Lighten" usually means increasing Value (Brightness)
    // or decreasing Saturation depending on your definition.
    // Let's assume increasing Value here:
    hsv ??= HSV.fromInt(argb);
    final HSV modified =
        hsv.withValue((hsv.value.val + (amount / 100)).clampToPercent);
    return modified.toColor().value;
  }

  // ... implement others using HSV math
  @override
  int darken(final int argb, final double amount) =>
      0; // Implementation hidden for brevity
  @override
  int saturate(final int argb, final double amount) => 0;
  @override
  int desaturate(final int argb, final double amount) => 0;
  @override
  int rotateHue(final int argb, final double amount) => 0;

  /// Intensifies the color by increasing chroma and slightly decreasing tone (half of factor).
  @override
  int intensify(final int argb,
      {final Percent amount = Percent.v15, HSV? hsv}) {
    hsv ??= HSV.fromInt(argb);

    // Increase Saturation and Value
    final Percent newSat = (hsv.saturation + amount).clampToPercent;
    final Percent newVal = (hsv.value.val - amount.half).clampToPercent;

    return hsv.withSaturation(newSat).withValue(newVal).toColor().value;
  }

  /// De-intensifies (mutes) the color by decreasing chroma and
  /// slightly increasing tone (half of factor).
  @override
  int deintensify(final int argb,
      {final Percent amount = Percent.v15, HSV? hsv}) {
    hsv ??= HSV.fromInt(argb);

    // Decrease Saturation and Value
    final Percent newSat = (hsv.saturation - amount);
    final Percent newVal = hsv.value - amount.half;

    return hsv.withSaturation(newSat).withValue(newVal).toColor().value;
  }
}
