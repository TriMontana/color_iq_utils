import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

/// A representation of a color in the HSV (Hue, Saturation, Value) color space.
///
/// HSV is a cylindrical color model that remaps the RGB primary colors into
/// dimensions that are more intuitive for humans to understand.
/// - Hue (h): The type of color (e.g., red, green, blue). It is represented as an angle from 0 to 360 degrees.
/// - Saturation (s): The "purity" or intensity of the color. It ranges from 0.0 (gray) to 1.0 (fully saturated).
/// - Value (v): The brightness or lightness of the color. It ranges from 0.0 (black) to 1.0 (full brightness).
///
/// This class provides methods to convert from HSV to other color spaces
/// and to perform various color manipulations like adjusting brightness,
/// saturation, and finding harmonies.
///
class HsvColor extends ColorSpacesIQ with ColorModelsMixin {
  final double h;
  final double s;
  final double v;
  Percent get alpha => super.a;

  const HsvColor(this.h, this.s, this.v,
      {final Percent alpha = Percent.max, required final int hexId})
      : super(hexId, a: alpha);
  HsvColor.alt(this.h, this.s, this.v,
      {final Percent alpha = Percent.max, final int? hexId})
      : super(hexId ?? HsvColor.toHexId(h, s, v, alpha), a: alpha);

  /// Creates a 32-bit integer ARGB value from HSV components.
  ///
  /// [h] is the hue, specified as a value between 0 and 360.
  /// [s] is the saturation, specified as a value between 0.0 and 1.0.
  /// [v] is the value, specified as a value between 0.0 and 1.0.
  /// [alpha] is the alpha channel, specified as a value between 0.0 and 1.0.
  static int toHexId(final double h, final double s, final double v,
      [final double alpha = 1.0]) {
    final double c = v * s;
    final double x = c * (1 - ((h / 60) % 2 - 1).abs());
    final double m = v - c;

    double r = 0, g = 0, b = 0;
    if (h < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (h < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }

    final int argb = ((alpha * 255).round() << 24) |
        (((r + m) * 255).round().clamp(0, 255) << 16) |
        (((g + m) * 255).round().clamp(0, 255) << 8) |
        ((b + m) * 255).round().clamp(0, 255);
    return argb;
  }

  @override
  ColorIQ toColor() => ColorIQ(toHexId(h, s, v, alpha));

  @override
  HsvColor darken([final double amount = 20]) {
    return HsvColor.alt(h, s, max(0.0, v - amount / 100), alpha: alpha);
  }

  @override
  HsvColor get inverted => toColor().inverted.toHsv();

  @override
  HsvColor get grayscale => toColor().grayscale.toHsv();

  @override
  HsvColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HsvColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HsvColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HsvColor otherHsv =
        other is HsvColor ? other : other.toColor().toHsv();
    if (t == 1.0) {
      return otherHsv;
    }

    return HsvColor.alt(
      lerpHue(h, otherHsv.h, t),
      lerpDouble(s, otherHsv.s, t),
      lerpDouble(v, otherHsv.v, t),
    );
  }

  @override
  HsvColor lighten([final double amount = 20]) =>
      copyWith(value: min(1.0, v + amount / 100));

  @override
  HsvColor brighten([final double amount = 20]) {
    return HsvColor.alt(h, s, min(1.0, v + amount / 100), alpha: alpha);
  }

  @override
  HsvColor saturate([final double amount = 25]) =>
      copyWith(saturation: min(1.0, s + amount / 100));

  @override
  HsvColor desaturate([final double amount = 25]) {
    return HsvColor.alt(h, max(0.0, s - amount / 100), v, alpha: alpha);
  }

  @override
  HsvColor intensify([final double amount = 10]) =>
      copyWith(saturation: min(1.0, s + amount / 100));

  @override
  HsvColor deintensify([final double amount = 10]) =>
      copyWith(saturation: max(0.0, s - amount / 100));

  @override
  HsvColor accented([final double amount = 15]) {
    // Accented usually means more saturated.
    return intensify(amount);
  }

  @override
  HsvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsv();
  }

  @override
  HsvColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsv();
  }

  @override
  double get transparency => toColor().transparency;

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
  HsvColor copyWith({
    final double? hue,
    final double? saturation,
    final double? value,
    final Percent? alpha,
  }) {
    return HsvColor.alt(hue ?? h, saturation ?? s, value ?? v,
        alpha: alpha ?? super.a);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsv())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsv();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HsvColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HsvColor opaquer([final double amount = 20]) {
    final double x = min(1.0, alpha.val + amount / 100);
    return HsvColor.alt(h, s, v, alpha: Percent(x));
  }

  @override
  HsvColor adjustHue([final double amount = 20]) =>
      copyWith(hue: wrapHue(h + amount));

  @override
  HsvColor get complementary => adjustHue(180);

  @override
  HsvColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHsv();

  @override
  HsvColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHsv();

  @override
  List<HsvColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHsv())
      .toList();

  @override
  List<HsvColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHsv()).toList();

  @override
  List<HsvColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHsv())
          .toList();

  @override
  List<HsvColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHsv()).toList();

  @override
  List<HsvColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHsv())
      .toList();

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

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

  @override
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());

  @override
  ColorSpacesIQ fromHct(final HctColor hct) {
    return HctColor.fromInt(value);
  }
}
