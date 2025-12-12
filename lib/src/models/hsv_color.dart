import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/argb_color.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_data.dart';
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
class HSV extends CommonIQ implements ColorWheelInf, ColorSpacesIQ {
  final Hue h;
  final Percent saturation;
  final Percent valueHsv;

  const HSV(this.h, this.saturation, this.valueHsv,
      {final Percent a = Percent.max, final int? colorId})
      : super(colorId, alpha: a);

  const HSV.alt(
      {required this.h,
      required final Percent s,
      required final Percent v,
      final Percent a = Percent.max,
      final int? colorId})
      : saturation = s,
        valueHsv = v,
        super(colorId, alpha: a);

  const HSV.fromAHSV(final Percent a, this.h, this.saturation, this.valueHsv,
      {final int? colorId})
      : super(colorId, alpha: a);

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

    final Hue hue = getHue(r.val, g.val, b.val, max, delta);
    final Percent saturation = Percent(max == 0.0 ? 0.0 : delta / max);
    final Percent value = Percent(max);

    return HSV(
      hue,
      saturation,
      value,
      a: alpha,
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
  int get value => hexId;

  @override
  int get hexId =>
      super.colorId ?? HSV.hexIdFromHSV(h, saturation, valueHsv, alpha.val);

  @override
  Cam16 get cam16 => Cam16.fromInt(hexId);

  @override
  String get hexStr => hexId.toHexStr;

  /// Creates a 32-bit integer ARGB value from HSV components.
  ///
  /// [h] is the hue, specified as a value between 0 and 360.
  /// [s] is the saturation, specified as a value between 0.0 and 1.0.
  /// [v] is the value, specified as a value between 0.0 and 1.0.
  /// [alpha] is the alpha channel, specified as a value between 0.0 and 1.0.
  static int hexIdFromHSV(final double h, final double s, final Percent v,
      [final double alpha = 1.0]) {
    final double chroma = s * v.val;
    final double secondary = chroma * (1.0 - (((h / 60.0) % 2.0) - 1.0).abs());
    final double match = v.val - chroma;

    return colorFromHue(alpha, h, chroma, secondary, match).value;
  }

  /// Returns this color in RGB.
  @override
  ColorIQ toColor() {
    final double chroma = saturation * valueHsv.val;
    final double secondary =
        chroma * (1.0 - (((h.val / 60.0) % 2.0) - 1.0).abs());
    final double match = valueHsv.val - chroma;

    return colorFromHue(alpha.val, h, chroma, secondary, match);
  }

  static HSV fromJson(final Map<String, dynamic> json) {
    return HSV(
      json['hue'],
      json['saturation'],
      Percent(json['value']),
      a: Percent(json['alpha'] ?? 1.0),
    );
  }

  @override
  String toString() => 'HsvColor(h: ${h.toStrTrimZeros(3)}, ' //
      's: ${saturation.toStrTrimZeros(3)}, v: ${valueHsv.toStrTrimZeros(2)}, '
      'a: ${alpha.toStrTrimZeros(3)})';

  String toStringIQ() => 'HsvColor(h: ${h.toStrTrimZeros(3)}, ' //
      's: ${saturation.toStrTrimZeros(3)}, v: ${valueHsv.toStrTrimZeros(2)}, '
      'a: ${alpha.toStrTrimZeros(3)}) - $hexStr';

  @override
  ColorSlice closestColorSlice() => hexId.closestColorSlice();

  @override
  HctData get hct => HctData.fromInt(hexId);

  @override
  double toneDifference(final ColorWheelInf other) {
    return hct.toneDifference(other);
  }

  @override
  HSV darken([final double amount = 20]) =>
      copyWith(val: Percent(max(0.0, valueHsv.val - amount / 100)));

  @override
  HSV whiten([final double amount = 20]) => lerp(cWhite.hsv, amount / 100);

  @override
  HSV blacken([final double amount = 20]) => lerp(cBlack.hsv, amount / 100);

  HSV withValue(final Percent nuValue) => copyWith(val: nuValue);

  /// Returns a copy of this color with the [saturation] parameter replaced with
  /// the given value.
  HSV withSaturation(final Percent saturation) =>
      copyWith(saturation: saturation);

  @override
  HSV lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final HSV otherHsv = other is HSV ? other : other.toColor().hsv;

    if (t == 1.0) {
      return otherHsv;
    }

    return HSV(
      lerpHue(h, otherHsv.h, t),
      saturation.lerpTo(otherHsv.saturation, t),
      valueHsv.lerpTo(otherHsv.valueHsv, t),
    );
  }

  @override
  HSV lighten([final double amount = 20]) =>
      copyWith(val: Percent(min(1.0, valueHsv.val + amount / 100)));

  @override
  HSV brighten([final Percent amount = Percent.v20]) =>
      copyWith(val: Percent(min(1.0, valueHsv.val + amount.val)));

  HSV intensify([final double amount = 20]) {
    final Percent factor = Percent(amount / 100);
    final Percent newSat = (saturation + factor).clampToPercent;
    final Percent newVal = (valueHsv + factor).clampToPercent;
    return copyWith(saturation: newSat, val: newVal);
  }

  HSV deintensify([final double amount = 20]) {
    final Percent factor = Percent(amount / 100);
    final Percent newSat = (saturation - factor).clampToPercent;
    final Percent newVal = (valueHsv - factor).clampToPercent;
    return copyWith(saturation: newSat, val: newVal);
  }

  @override
  HSV saturate([final double amount = 25]) {
    final Percent pAmount = Percent(amount / 100);
    return copyWith(saturation: min(1.0, saturation + pAmount).clampToPercent);
  }

  @override
  HSV desaturate([final double amount = 25]) {
    final Percent pAmount = Percent(amount / 100);
    return copyWith(saturation: Percent(max(0.0, saturation - pAmount)));
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  HSV copyWith({
    final Hue? hue,
    final Percent? saturation,
    final Percent? val,
    final Percent? alpha,
  }) {
    return HSV(hue ?? h, saturation ?? this.saturation, val ?? valueHsv,
        a: alpha ?? this.alpha);
  }

  @override
  HSV blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HSV opaquer([final double amount = 20]) {
    final Percent x = min(1.0, alpha.val + amount / 100).clampToPercent;
    return HSV(h, saturation, valueHsv, a: x);
  }

  @override
  HSV adjustHue([final double amount = 20]) =>
      copyWith(hue: wrapHue(h.val + amount));

  @override
  HSV get complementary => adjustHue(180);

  @override
  HSV accented([final double amount = 15]) => intensify(amount);

  @override
  HSV decreaseTransparency([final Percent amount = Percent.v20]) =>
      copyWith(alpha: min(1.0, alpha + amount).clampToPercent);

  @override
  HSV increaseTransparency([final Percent amount = Percent.v20]) =>
      copyWith(alpha: max(0.0, alpha - amount).clampToPercent);

  @override
  List<HSV> get monochromatic {
    final List<HSV> results = <HSV>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 10;
      results.add(withValue((valueHsv + Percent(delta / 100)).clampToPercent));
    }
    return results;
  }

  @override
  List<HSV> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <HSV>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
    ];
  }

  @override
  List<HSV> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <HSV>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
    ];
  }

  @override
  HSV get random {
    final Random rng = Random();
    return HSV(
      Hue(rng.nextDouble() * 360.0),
      Percent(rng.nextDouble()),
      Percent(rng.nextDouble()),
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) => hexId == other.value;

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    // HSV is typically defined within sRGB range [0-1] for S and V.
    if (gamut == Gamut.sRGB) {
      return saturation.val >= 0 &&
          saturation.val <= 1 &&
          valueHsv.val >= 0 &&
          valueHsv.val <= 1;
    }
    return toColor().isWithinGamut(gamut);
  }

  @override
  HSV simulate(final ColorBlindnessType type) {
    // Simulation requires RGB space. Convert, simulate, convert back.
    // This avoids returning ColorIQ.
    final int simulatedHex = toColor().simulate(type).value;
    return HSV.fromInt(simulatedHex);
  }

  @override
  List<HSV> tonesPalette() {
    // Gray in HSV is (0, 0, 0.5) roughly, or just desaturated.
    // ColorIQ uses 0xFF808080 which is HSV(0, 0, 0.502).
    const HSV gray = HSV(Hue.zero, Percent.zero, Percent(0.50196));
    return <HSV>[
      this,
      lerp(gray, 0.15),
      lerp(gray, 0.30),
      lerp(gray, 0.45),
      lerp(gray, 0.60),
    ];
  }

  @override
  List<HSV> analogous({
    final int count = 5,
    final double offset = 30,
  }) {
    final List<HSV> palette = <HSV>[];
    final double startHue = h.val - ((count - 1) / 2) * offset;
    for (int i = 0; i < count; i++) {
      double newHue = (startHue + i * offset) % 360;
      if (newHue < 0) {
        newHue += 360;
      }
      palette.add(copyWith(hue: Hue(newHue)));
    }
    return palette;
  }

  @override
  List<HSV> square() {
    return <HSV>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<HSV> tetrad({final double offset = 60}) {
    return <HSV>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  HSV warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) {
      diff -= 360;
    }
    if (diff < -180) {
      diff += 360;
    }

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) {
      newHue += 360;
    }
    if (newHue >= 360) {
      newHue -= 360;
    }

    return copyWith(hue: Hue(newHue));
  }

  @override
  HSV cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) {
      diff -= 360;
    }
    if (diff < -180) {
      diff += 360;
    }

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) {
      newHue += 360;
    }
    if (newHue >= 360) {
      newHue -= 360;
    }

    return copyWith(hue: Hue(newHue));
  }

  @override
  List<HSV> generateBasicPalette() {
    return <HSV>[
      lighten(40),
      lighten(20),
      this,
      darken(20),
      darken(40),
    ];
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HsvColor',
      'hue': h,
      'saturation': saturation,
      'value': valueHsv.val,
      'alpha': alpha,
    };
  }

  String createStr([final int precision = 4]) =>
      'const HSV.alt(h: Hue(${h.toStrTrimZeros(precision)}), ' //
      's: ${saturation.toPercentStr(precision)}, '
      'v: ${valueHsv.toPercentStr(precision)}, '
      'a: ${alpha.toPercentStr(precision)}),';
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
        hsv.withValue((hsv.valueHsv.val + (amount / 100)).clampToPercent);
    return modified.toColor().value;
  }

  // ... implement others using HSV math
  @override
  int darken(final int argb, final double amount) {
    final HSV hsv = HSV.fromInt(argb);
    final HSV modified =
        hsv.withValue((hsv.valueHsv.val - (amount / 100)).clampToPercent);
    return modified.toColor().value;
  }

  @override
  int saturate(final int argb, final double amount) {
    final HSV hsv = HSV.fromInt(argb);
    final HSV modified = hsv
        .withSaturation((hsv.saturation.val + (amount / 100)).clampToPercent);
    return modified.toColor().value;
  }

  @override
  int desaturate(final int argb, final double amount) {
    final HSV hsv = HSV.fromInt(argb);
    final HSV modified = hsv
        .withSaturation((hsv.saturation.val - (amount / 100)).clampToPercent);
    return modified.toColor().value;
  }

  @override
  int rotateHue(final int argb, final double amount) {
    final HSV hsv = HSV.fromInt(argb);
    double newHue = (hsv.h.val + amount) % 360;
    if (newHue < 0) {
      newHue += 360;
    }
    final HSV modified = hsv.copyWith(hue: Hue(newHue));
    return modified.toColor().value;
  }

  /// Intensifies the color by increasing chroma and slightly decreasing tone (half of factor).
  @override
  int intensify(final int argb,
      {final Percent amount = Percent.v15, HSV? hsv}) {
    hsv ??= HSV.fromInt(argb);

    // Increase Saturation and Value
    final Percent newSat = (hsv.saturation + amount).clampToPercent;
    final Percent newVal = (hsv.valueHsv.val - amount.half).clampToPercent;

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
    final Percent newVal = hsv.valueHsv - amount.half;

    return hsv.withSaturation(newSat).withValue(newVal).toColor().value;
  }
}
