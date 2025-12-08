import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/argb_color.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

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
///
class HSV extends CommonIQ implements ColorSpacesIQ {
  final double h;
  final double s;
  final Percent v;

  const HSV(this.h, this.s, this.v,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String>? names})
      : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  const HSV.fromAHSV(final Percent alpha, this.h, this.s, this.v,
      {final int? hexId, final List<String>? names})
      : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? HSV.hexIdFromHSV(h, s, v, alpha.val);

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

  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  static HSV fromRgbValues(
      {required final Percent r,
      required final Percent g,
      required final Percent b,
      final Percent alpha = Percent.max,
      final int? hexId}) {
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
      alpha: alpha,
      hexId:
          hexId ?? HSV.hexIdFromHSV(hue, saturation.val, value.val, alpha.val),
    );
  }

  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  static HSV fromInt(final int hexId) {
    return HSV.fromRgbValues(
        r: hexId.r2, g: hexId.g2, b: hexId.b2, alpha: hexId.a2);
  }

  static HSV fromColor(final ColorIQ color) {
    final ARGBColor argb = color.argb;
    return HSV.fromRgbValues(r: argb.r, g: argb.g, b: argb.b, alpha: argb.a);
  }

  /// Converts this color to HSV.
  static HSV fromARGB(final ARGBColor argb) {
    return HSV.fromRgbValues(r: argb.r, g: argb.g, b: argb.b, alpha: argb.a);
  }

  /// Returns this color in RGB.
  ColorIQ toColor2() {
    final double chroma = s * v.val;
    final double secondary = chroma * (1.0 - (((h / 60.0) % 2.0) - 1.0).abs());
    final double match = v.val - chroma;

    return colorFromHue(alpha.val, h, chroma, secondary, match);
  }

  @override
  HSV darken([final double amount = 20]) =>
      copyWith(value: Percent(max(0.0, v.val - amount / 100)));

  @override
  HSV whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HSV blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HSV lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HSV otherHsv = other is HSV ? other : other.toColor().hsv;
    if (t == 1.0) {
      return otherHsv;
    }

    return HSV(
      lerpHue(h, otherHsv.h, t),
      lerpDouble(s, otherHsv.s, t),
      v.lerpTo(otherHsv.v, t),
    );
  }

  @override
  HSV lighten([final double amount = 20]) =>
      copyWith(value: Percent(min(1.0, v.val + amount / 100)));

  @override
  HSV brighten([final double amount = 20]) {
    return copyWith(value: Percent(min(1.0, v.val + amount / 100)));
  }

  @override
  HSV saturate([final double amount = 25]) =>
      copyWith(saturation: min(1.0, s + amount / 100));

  @override
  HSV desaturate([final double amount = 25]) {
    return copyWith(saturation: Percent(max(0.0, s - amount / 100)));
  }

  @override
  HSV intensify([final double amount = 10]) =>
      copyWith(saturation: min(1.0, s + amount / 100));

  @override
  HSV deintensify([final double amount = 10]) =>
      copyWith(saturation: max(0.0, s - amount / 100));

  @override
  HSV accented([final double amount = 15]) {
    // Accented usually means more saturated.
    return intensify(amount);
  }

  @override
  HSV simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).hsv;
  }

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (h >= 90 && h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HSV copyWith({
    final double? hue,
    final double? saturation,
    final Percent? value,
    final Percent? alpha,
  }) {
    return HSV(hue ?? h, saturation ?? s, value ?? v, alpha: alpha ?? super.a);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).hsv)
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).hsv)
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).hsv)
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).hsv;

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HSV blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HSV opaquer([final double amount = 20]) {
    final double x = min(1.0, alpha.val + amount / 100);
    return HSV(h, s, v, alpha: Percent(x));
  }

  @override
  HSV adjustHue([final double amount = 20]) =>
      copyWith(hue: wrapHue(h + amount));

  @override
  HSV get complementary => adjustHue(180);

  /// amount = stepDegrees
  @override
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

  @override
  HSV cooler([final double amount = 20]) => toColor().cooler(amount).hsv;

  @override
  List<HSV> generateBasicPalette() =>
      toColor().generateBasicPalette().map((final ColorIQ c) => c.hsv).toList();

  @override
  List<HSV> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.hsv).toList();

  @override
  List<HSV> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.hsv)
          .toList();

  @override
  List<HSV> square() =>
      toColor().square().map((final ColorIQ c) => c.hsv).toList();

  @override
  List<HSV> tetrad({final double offset = 60}) =>
      toColor().tetrad(offset: offset).map((final ColorIQ c) => c.hsv).toList();

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HsvColor',
      'hue': h,
      'saturation': s,
      'value': v,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HsvColor(h: ${h.toStrTrimZeros(3)}, ' //
      's: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)}, a: ${alpha.toStringAsFixed(2)})';
}
