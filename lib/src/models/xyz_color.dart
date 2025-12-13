import 'dart:math';

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
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
class XYZ extends CommonIQ {
  final double x;
  final double y;
  final double z;

  const XYZ(this.x, this.y, this.z,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? XYZ.hexIdFromXYZ(x, y, z);

  factory XYZ.fromInt(final int hexId) {
    final List<double> lst = xyzFromArgb(hexId);
    return XYZ(lst[0], lst[1], lst[2], hexId: hexId);
  }

  /// Converts this color to XYZ.
  static XYZ xyxFromRgb(final Iq255 red, final Iq255 green, final Iq255 blue) =>
      XYZ.xyzFromRgbLinearized(
          red.linearized, green.linearized, blue.linearized);

  /// Converts this color to XYZ.  Values are expected to be in the range of 0.0 to 1.0
  /// and are expected to be in the sRGB color space, not linearized.
  static XYZ xyxFromSRgb(final double r, final double g, final double b) => XYZ
      .xyzFromRgbLinearized(srgbToLinear(r), srgbToLinear(g), srgbToLinear(b));

  /// Converts this color to XYZ.
  static XYZ xyzFromRgbLinearized(final LinRGB redLinearized,
      final LinRGB greenLinearized, final LinRGB blueLinearized) {
    final List<double> xyzList = matrixMultiply(
        <double>[redLinearized.val, greenLinearized.val, blueLinearized.val],
        srgbToXyzMatrix);
    // Convert 0-1 range to 0-100 range
    return XYZ(xyzList[0] * 100, xyzList[1] * 100, xyzList[2] * 100,
        hexId:
            argbFromXyz(xyzList[0] * 100, xyzList[1] * 100, xyzList[2] * 100));
  }

  static ColorIQ xyzToColor(final double x, final double y, final double z) =>
      ColorIQ(argbFromXyz(x, y, z));

  static int hexIdFromXYZ(final double x, final double y, final double z) =>
      argbFromXyz(x, y, z);

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
  CIELuv toLuv() {
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

    return CIELuv(l, uOut, vOut);
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  XYZ copyWith(
      {final double? x,
      final double? y,
      final double? z,
      final Percent? alpha}) {
    return XYZ(x ?? this.x, y ?? this.y, z ?? this.z, alpha: alpha ?? super.a);
  }

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'XyzColor', 'x': x, 'y': y, 'z': z};
  }

  XYZ accented([final double amount = 15]) {
    return toColor().accented(amount).xyz;
  }

  @override
  String toString() =>
      'XyzColor(x: ${x.toStrTrimZeros(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';
}
