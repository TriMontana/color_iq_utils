import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

/// A representation of a color in the Hunter Lab color space.
///
/// The Hunter Lab color space is a color space designed to be more perceptually
/// uniform than the CIEXYZ color space. It was developed by Richard S. Hunter
/// as a simpler alternative to CIE 1931 color space for many applications.
///
/// This model has three components:
/// - `l`: Lightness, ranging from 0 (black) to 100 (diffuse white).
/// - `a`: The green-red opponent axis. Negative values are green, positive values are red.
/// - `b`: The blue-yellow opponent axis. Negative values are blue, positive values are yellow.
///
/// The `a` and `b` axes are theoretically unbounded but are practically
/// limited by the gamut of real-world colors.
///
class HunterLabColor extends CommonIQ implements ColorSpacesIQ {
  final double l;
  final double aLab;
  final double bLab;

  const HunterLabColor(this.l, this.aLab, this.bLab,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String> names = kEmptyNames})
      : super(hexId, alpha: alpha, names: names);

  @override
  int get value =>
      super.colorId ??
      HunterLabColor.hexIdFromHunter(l, aLab, bLab, alpha: alpha);

  /// A stand-alone static method to create a 32-bit hexID/ARGB from l, aLab, bLab.
  static int hexIdFromHunter(
      final double l, final double aLab, final double bLab,
      {final Percent alpha = Percent.max}) {
    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    final double y = pow(l / 100.0, 2) * yn;
    final double x = (aLab / 175.0 * (l / 100.0) + y / yn) * xn;
    final double z = (y / yn - bLab / 70.0 * (l / 100.0)) * zn;

    final double xTemp = x / 100;
    final double yTemp = y / 100;
    final double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double bVal = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308)
        ? (1.055 * pow(bVal, 1 / 2.4) - 0.055)
        : (12.92 * bVal);

    final int red = (r * 255).round().clamp(0, 255);
    final int green = (g * 255).round().clamp(0, 255);
    final int blue = (bVal * 255).round().clamp(0, 255);
    final int alphaVal = alpha.toInt0to255;

    return (alphaVal << 24) | // Alpha
        (red << 16) | // Red
        (green << 8) | // Green
        blue; // Blue
  }

  @override
  HunterLabColor darken([final double amount = 20]) {
    return HunterLabColor(max(0, l - amount), aLab, bLab);
  }

  @override
  HunterLabColor saturate([final double amount = 25]) {
    final double scale = 1.0 + (amount / 100.0);
    return HunterLabColor(l, aLab * scale, bLab * scale);
  }

  @override
  HunterLabColor desaturate([final double amount = 25]) {
    final double scale = 1.0 - (amount / 100.0);
    return HunterLabColor(l, aLab * scale, bLab * scale);
  }

  @override
  HunterLabColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
  HunterLabColor deintensify([final double amount = 10]) => desaturate(amount);

  @override
  HunterLabColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  HunterLabColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHunterLab();
  }

  @override
  HunterLabColor whiten([final double amount = 20]) =>
      lerp(cWhite, amount / 100);

  @override
  HunterLabColor blacken([final double amount = 20]) =>
      lerp(cBlack, amount / 100);

  @override
  HunterLabColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HunterLabColor otherLab =
        other is HunterLabColor ? other : other.toColor().toHunterLab();
    if (t == 1.0) return otherLab;

    return HunterLabColor(
      lerpDouble(l, otherLab.l, t),
      lerpDouble(aLab, otherLab.aLab, t),
      lerpDouble(bLab, otherLab.bLab, t),
    );
  }

  @override
  HunterLabColor lighten([final double amount = 20]) {
    return HunterLabColor(min(100, l + amount), aLab, bLab);
  }

  @override
  HunterLabColor brighten([final double amount = 20]) {
    return HunterLabColor(l, max(100, aLab + amount), bLab);
  }

  @override
  HunterLabColor fromHct(final HctColor hct) => hct.toColor().toHunterLab();

  @override
  HunterLabColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHunterLab();
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HunterLabColor copyWith(
      {final double? lStar, final double? aStar, final double? bStar}) {
    return HunterLabColor(lStar ?? l, aStar ?? aLab, bStar ?? bLab);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toHunterLab())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHunterLab())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHunterLab())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHunterLab();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  HunterLabColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHunterLab();

  @override
  HunterLabColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHunterLab();

  @override
  HunterLabColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toHunterLab();

  @override
  HunterLabColor get complementary => toColor().complementary.toHunterLab();

  @override
  HunterLabColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHunterLab();

  @override
  HunterLabColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHunterLab();

  @override
  List<HunterLabColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHunterLab())
      .toList();

  @override
  List<HunterLabColor> tonesPalette() => toColor()
      .tonesPalette()
      .map((final ColorIQ c) => c.toHunterLab())
      .toList();

  @override
  List<HunterLabColor> analogous({
    final int count = 5,
    final double offset = 30,
  }) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHunterLab())
          .toList();

  @override
  List<HunterLabColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHunterLab()).toList();

  @override
  List<HunterLabColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHunterLab())
      .toList();

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HunterLabColor',
      'l': l,
      'a': aLab,
      'b': bLab
    };
  }

  @override
  String toString() => 'HunterLabColor(l: ${l.toStrTrimZeros(3)}, ' //
      'a: ${aLab.toStrTrimZeros(3)}, b: ${bLab.toStringAsFixed(2)})';
}
