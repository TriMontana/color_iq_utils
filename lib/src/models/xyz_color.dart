import 'dart:math';

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsluv.dart';
import 'package:color_iq_utils/src/models/lab_color.dart';
import 'package:color_iq_utils/src/models/luv_color.dart';

/// The CIE 1931 XYZ color space. This color space is based on the CIE 1931 RGB color space,
/// but it has been transformed so that all of its color matching functions are non-negative.
/// The XYZ color space is also known as the CIE 1931 color space or the CIE XYZ color space.
///
/// The XYZ color space is a three-dimensional color space. The three dimensions are represented
/// by the letters X, Y, and Z. The X dimension represents the amount of red light in a color,
/// the Y dimension represents the amount of green light in a color, and the Z dimension
/// represents the amount of blue light in a color.
///
/// The XYZ color space is a device-independent color space. This means that the colors in the
/// XYZ color space will look the same regardless of the device that is used to display them.
/// This is in contrast to device-dependent color spaces, such as the RGB color space, where
/// the colors can vary depending on the device that is used to display them.
class XyzColor extends ColorSpacesIQ with ColorModelsMixin {
  final double x;
  final double y;
  final double z;

  const XyzColor(this.x, this.y, this.z,
      {required final int hexId, final Percent alpha = Percent.max})
      : super(hexId, a: alpha);
  XyzColor.alt(this.x, this.y, this.z,
      {final int? hexId, final Percent alpha = Percent.max})
      : super(hexId ?? argbFromXyz(x, y, z), a: alpha);
  factory XyzColor.fromInt(final int hexId) {
    final List<double> lst = xyzFromArgb(hexId);
    return XyzColor(lst[0], lst[1], lst[2], hexId: hexId);
  }

  /// Converts this color to XYZ.
  static XyzColor xyxFromRgb(final int red, final int green, final int blue) =>
      xyzFromRgbLinearized(
          linearized(red), linearized(green), linearized(blue));

  /// Converts this color to XYZ.  Values are expected to be in the range of 0.0 to 1.0
  /// and are expected to be in the sRGB color space, not linearized.
  static XyzColor xyxFromSRgb(final double r, final double g, final double b) =>
      xyzFromRgbLinearized(srgbToLinear(r), srgbToLinear(g), srgbToLinear(b));

  /// Converts this color to XYZ.
  static XyzColor xyzFromRgbLinearized(final double redLinearized,
      final double greenLinearized, final double blueLinearized) {
    final List<double> xyzList = matrixMultiply(
        <double>[redLinearized, greenLinearized, blueLinearized],
        srgbToXyzMatrix);
    return XyzColor(xyzList[0], xyzList[1], xyzList[2],
        hexId: argbFromXyz(xyzList[0], xyzList[1], xyzList[2]));
  }

  static ColorIQ xyzToColor(final double x, final double y, final double z) =>
      ColorIQ(argbFromXyz(x, y, z));

  static int xyzToHexId(final double x, final double y, final double z) {
    return argbFromXyz(x, y, z);
  }

  RgbDoubles toRgbTuple() {
    final List<double> lst = Hsluv.xyzToRgb(<double>[x, y, z]);
    return (r: lst[0], g: lst[1], b: lst[2]);
  }

  LabColor toLab() {
    final List<double> lst = labFromXYZ(x, y, z);
    return LabColor(lst[0], lst[1], lst[2],
        hexId: argbFromLab(lst[0], lst[1], lst[2]));
  }

  @override
  LuvColor toLuv() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    final double u = (4 * x) / (x + (15 * y) + (3 * z));
    final double v = (9 * y) / (x + (15 * y) + (3 * z));

    double yTemp = y / 100.0;
    yTemp = (yTemp > 0.008856)
        ? pow(yTemp, 1 / 3).toDouble()
        : (7.787 * yTemp) + (16 / 116);

    final double l = (116 * yTemp) - 16;
    double uOut = 13 * l * (u - refU);
    double vOut = 13 * l * (v - refV);

    if (x + 15 * y + 3 * z == 0) {
      uOut = 0;
      vOut = 0;
    }

    return LuvColor.alt(l, uOut, vOut);
  }

  @override
  XyzColor get inverted => toColor().inverted.toXyz();

  @override
  XyzColor get grayscale => toColor().grayscale.toXyz();

  @override
  XyzColor whiten([final double amount = 20]) =>
      toColor().whiten(amount).toXyz();

  @override
  XyzColor blacken([final double amount = 20]) =>
      toColor().blacken(amount).toXyz();

  @override
  XyzColor lighten([final double amount = 20]) {
    return toColor().lighten(amount).toXyz();
  }

  @override
  XyzColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toXyz();
  }

  @override
  XyzColor darken([final double amount = 20]) {
    return toColor().darken(amount).toXyz();
  }

  @override
  XyzColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).toXyz();
  }

  @override
  XyzColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toXyz();
  }

  @override
  XyzColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toXyz();
  }

  @override
  XyzColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toXyz();
  }

  @override
  XyzColor accented([final double amount = 15]) {
    return toColor().accented(amount).toXyz();
  }

  @override
  XyzColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toXyz();
  }

  @override
  XyzColor lerp(final ColorSpacesIQ other, final double t) =>
      (toColor().lerp(other, t) as ColorIQ).toXyz();

  @override
  XyzColor fromHct(final HctColor hct) => hct.toColor().toXyz();

  @override
  XyzColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toXyz();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  XyzColor copyWith(
      {final double? x,
      final double? y,
      final double? z,
      final Percent? alpha}) {
    return XyzColor.alt(x ?? this.x, y ?? this.y, z ?? this.z,
        alpha: alpha ?? super.a);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toXyz())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toXyz())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toXyz())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toXyz();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  XyzColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toXyz();

  @override
  XyzColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toXyz();

  @override
  XyzColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toXyz();

  @override
  XyzColor get complementary => toColor().complementary.toXyz();

  @override
  XyzColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toXyz();

  @override
  XyzColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toXyz();

  @override
  List<XyzColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toXyz())
      .toList();

  @override
  List<XyzColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toXyz()).toList();

  @override
  List<XyzColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toXyz())
          .toList();

  @override
  List<XyzColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toXyz()).toList();

  @override
  List<XyzColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toXyz())
      .toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      // Convert to sRGB linear
      final double xTemp = x / 100;
      final double yTemp = y / 100;
      final double zTemp = z / 100;

      double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
      double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
      double b = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

      // Gamma correction
      r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
      g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
      b = (b > 0.0031308) ? (1.055 * pow(b, 1 / 2.4) - 0.055) : (12.92 * b);

      const double epsilon = 0.0001;
      return r >= -epsilon &&
          r <= 1.0 + epsilon &&
          g >= -epsilon &&
          g <= 1.0 + epsilon &&
          b >= -epsilon &&
          b <= 1.0 + epsilon;
    }
    return true;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'XyzColor', 'x': x, 'y': y, 'z': z};
  }

  @override
  String toString() =>
      'XyzColor(x: ${x.toStrTrimZeros(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';

  @override
  ColorIQ toColor() => ColorIQ(value);
}
