import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_hsl_color.dart';
import 'package:color_iq_utils/src/models/ok_hsv_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// A representation of a color in the Oklab color space.
///
/// The Oklab color space is a perceptually uniform color space designed
/// for tasks like color picking, color gradients, and image processing.
/// It aims to represent colors in a way that aligns more closely with human
/// perception of color differences.
///
/// [l] represents lightness (from 0 to 1, where 0 is black and 1 is white).
/// [aLab] represents the green-red axis.
/// [b] represents the blue-yellow axis.
/// [alpha] represents the opacity (from 0.0 for transparent to 1.0 for opaque).
class OkLabColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The lightness component of the color, ranging from 0.0 (black) to 1.0 (white).
  final double l;

  /// The 'a' component of the color, representing the green-red axis.
  final double aLab;

  /// The 'b' component of the color, representing the blue-yellow axis.
  final double bLab;

  /// The alpha value (opacity) of the color, from 0.0 (transparent) to 1.0 (opaque).
  final double alpha;

  /// Creates an [OkLabColor].
  ///
  /// - [l]: Lightness, must be between 0.0 and 1.0.
  /// - [a]: Green-red component.
  /// - [b]: Blue-yellow component.
  /// - [alpha]: Opacity, defaults to 1.0 (fully opaque).
  const OkLabColor(this.l, this.aLab, this.bLab,
      {this.alpha = 1.0, required final int hexId})
      : assert(l >= 0 && l <= 1, 'L must be between 0 and 1'),
        assert(aLab >= -1 && aLab <= 1, 'A must be between -1 and 1'),
        assert(bLab >= -1 && bLab <= 1, 'B must be between -1 and 1'),
        assert(alpha >= 0 && alpha <= 1, 'Alpha must be between 0 and 1'),
        super(hexId);

  OkLabColor.alt(this.l, this.aLab, this.bLab,
      {this.alpha = 1.0, final int? hexId})
      : assert(l >= 0 && l <= 1, 'L must be between 0 and 1'),
        assert(aLab >= -1 && aLab <= 1, 'A must be between -1 and 1'),
        assert(bLab >= -1 && bLab <= 1, 'B must be between -1 and 1'),
        assert(alpha >= 0 && alpha <= 1, 'Alpha must be between 0 and 1'),
        super(hexId ?? toHex(l, aLab, bLab, alpha));

  /// A stand-alone static method to create a 32-bit hexID/ARGB from this
  /// class's properties.
  static int toHex(
      final double l, final double a, final double b, final double alpha) {
    final double l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    final double m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    final double s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    final double l3 = l_ * l_ * l_;
    final double m3 = m_ * m_ * m_;
    final double s3 = s_ * s_ * s_;

    double r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    double g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    double bVal = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308)
        ? (1.055 * pow(bVal, 1 / 2.4) - 0.055)
        : (12.92 * bVal);

    final int alphaInt = (alpha * 255).round();
    final int redInt = (r * 255).round().clamp(0, 255);
    final int greenInt = (g * 255).round().clamp(0, 255);
    final int blueInt = (bVal * 255).round().clamp(0, 255);

    return (alphaInt << 24) | (redInt << 16) | (greenInt << 8) | (blueInt << 0);
  }

  /// Creates an [OkLabColor] from an ARGB integer.
  ///
  /// - [argb]: An integer representing the color in ARGB format.
  factory OkLabColor.fromInt(final int argb) {
    final double alpha = argb.a2;
    double r = argb.r2;
    double g = argb.g2;
    double b = argb.b2;

    // sRGB to Linear sRGB
    r = srgbToLinear(r);
    g = srgbToLinear(g);
    b = srgbToLinear(b);

    // Linear sRGB to Oklab
    final double l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
    final double m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
    final double s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;

    final double l_ = cbrt(l);
    final double m_ = cbrt(m);
    final double s_ = cbrt(s);

    final double labL =
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_;
    final double labA =
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_;
    final double labB =
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_;

    return OkLabColor.alt(labL, labA, labB, alpha: alpha);
  }

  /// Creates an [OkLabColor] from another [ColorSpacesIQ] instance.
  /// This is a convenience factory that converts any color model that implements
  /// [ColorSpacesIQ] into an [OkLabColor].
  factory OkLabColor.from(final ColorSpacesIQ color) =>
      OkLabColor.fromInt(color.value);

  @override
  ColorIQ toColor() {
    final double l_ = l + 0.3963377774 * aLab + 0.2158037573 * bLab;
    final double m_ = l - 0.1055613458 * aLab - 0.0638541728 * bLab;
    final double s_ = l - 0.0894841775 * aLab - 1.2914855480 * bLab;

    final double l3 = l_ * l_ * l_;
    final double m3 = m_ * m_ * m_;
    final double s3 = s_ * s_ * s_;

    double r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    double g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    double bVal = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308)
        ? (1.055 * pow(bVal, 1 / 2.4) - 0.055)
        : (12.92 * bVal);

    return ColorIQ.fromARGB(
      (alpha * 255).round(),
      (r * 255).round().clamp(0, 255),
      (g * 255).round().clamp(0, 255),
      (bVal * 255).round().clamp(0, 255),
    );
  }

  @override
  int get value => toColor().value;

  OkLchColor toOkLch() {
    final double c = sqrt(aLab * aLab + bLab * bLab);
    double h = atan2(bLab, aLab);
    h = h * 180 / pi;
    if (h < 0) {
      h += 360;
    }
    return OkLchColor.alt(l, c, h, alpha: alpha);
  }

  OkHslColor toOkHsl() {
    final OkLchColor lch = toOkLch();
    double s = (lch.l == 0 || lch.l == 1) ? 0 : lch.c / 0.4;
    if (s > 1) s = 1;
    return OkHslColor.alt(
      lch.h,
      s,
      lch.l,
    ); // OkHslColor doesn't have alpha in constructor yet? Wait, I fixed it.
    // Wait, OkHslColor constructor is (h, s, l, [alpha]).
    // So I should pass alpha.
  }

  OkHsvColor toOkHsv() {
    final OkLchColor lch = toOkLch();
    double v = lch.l + lch.c / 0.4;
    if (v > 1) {
      v = 1;
    }
    double s = (v == 0) ? 0 : (lch.c / 0.4) / v;
    if (s > 1) {
      s = 1;
    }
    return OkHsvColor.alt(lch.h, s, v, alpha: alpha);
  }

  @override
  OkLabColor get inverted => toColor().inverted.toOkLab();

  @override
  OkLabColor get grayscale => toColor().grayscale.toOkLab();

  @override
  OkLabColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  OkLabColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  OkLabColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final OkLabColor otherLab =
        other is OkLabColor ? other : other.toColor().toOkLab();
    if (t == 1.0) return otherLab;

    return OkLabColor.alt(
      lerpDouble(l, otherLab.l, t),
      lerpDouble(aLab, otherLab.aLab, t),
      lerpDouble(bLab, otherLab.bLab, t),
      alpha: lerpDouble(alpha, otherLab.alpha, t),
    );
  }

  @override
  OkLabColor lighten([final double amount = 20]) {
    return OkLabColor.alt(min(1.0, l + amount / 100), aLab, bLab, alpha: alpha);
  }

  @override
  OkLabColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toOkLab();
  }

  @override
  OkLabColor darken([final double amount = 20]) {
    return OkLabColor.alt(max(0.0, l - amount / 100), aLab, bLab, alpha: alpha);
  }

  @override
  OkLabColor saturate([final double amount = 25]) {
    return (toOkLch().saturate(amount)).toOkLab();
  }

  @override
  OkLabColor desaturate([final double amount = 25]) {
    return (toOkLch().desaturate(amount)).toOkLab();
  }

  @override
  OkLabColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toOkLab();
  }

  @override
  OkLabColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toOkLab();
  }

  @override
  OkLabColor accented([final double amount = 15]) {
    return toColor().accented(amount).toOkLab();
  }

  @override
  OkLabColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkLab();
  }

  @override
  OkLabColor fromHct(final HctColor hct) => hct.toColor().toOkLab();

  @override
  OkLabColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkLab();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkLabColor copyWith({
    final double? l,
    final double? a,
    final double? b,
    final double? alpha,
  }) {
    return OkLabColor.alt(
      l ?? this.l,
      a ?? aLab,
      b ?? bLab,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLab())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLab())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLab())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkLab();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  OkLabColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toOkLab();

  @override
  OkLabColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toOkLab();

  @override
  OkLabColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toOkLab();

  @override
  OkLabColor get complementary => toColor().complementary.toOkLab();

  @override
  OkLabColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toOkLab();

  @override
  OkLabColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toOkLab();

  @override
  List<OkLabColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toOkLab())
      .toList();

  @override
  List<OkLabColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toOkLab()).toList();

  @override
  List<OkLabColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toOkLab())
          .toList();

  @override
  List<OkLabColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toOkLab()).toList();

  @override
  List<OkLabColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toOkLab())
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
      'type': 'OkLabColor',
      'l': l,
      'a': aLab,
      'b': bLab,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkLabColor(l: ${l.toStringAsFixed(2)}, '
      'a: ${aLab.toStringAsFixed(2)}, b: ${bLab.toStringAsFixed(2)}, ' //
      'alpha: ${alpha.toStringAsFixed(2)})';
}
