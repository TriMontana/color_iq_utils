import 'dart:math';
import 'dart:math' as math;

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';

/// A representation of a color in the CIE L*u*v* color space.
///
/// The CIE L*u*v* color space is a perceptually uniform color space that is
/// particularly useful for calculating color differences. It is designed so
/// that the same geometric distance in the color space corresponds to the same
/// perceived color difference.
///
/// - `l`: Lightness, ranging from 0 (black) to 100 (white).
/// - `u`: Position on the green-red axis. Negative values are greenish,
///   positive values are reddish.
/// - `v`: Position on the blue-yellow axis. Negative values are bluish,
///   positive values are yellowish.
class CIELuv extends CommonIQ implements ColorSpacesIQ {
  /// The lightness component of the color.
  ///
  /// Ranges from 0 (black) to 100 (white).
  final double l;

  /// The green-red component of the color.
  final double u;

  /// The blue-yellow component of the color.
  final double v;

  const CIELuv(this.l, this.u, this.v,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String> names = kEmptyNames})
      : super(hexId, alpha: alpha, names: names);

  @override
  int get value => super.colorId ?? CIELuv.toHexId(l, u, v);

  //
  // super.alt(hexId ?? LuvColor.toHexId(l, u, v),
  //     a: alpha, names: names ?? const <String>[]);

  /// Creates a [CIELuv] from a 32-bit integer ARGB value.
  factory CIELuv.fromInt(final int argb) {
    // Normalize to [0,1]
    final LinRGB rn = argb.redLinearized;
    final LinRGB gn = argb.greenLinearized;
    final LinRGB bn = argb.blueLinearized;

    final XYZ xyz = XYZ.xyzFromRgbLinearized(rn, gn, bn);
    return _xyzToLuv(xyz.x, xyz.y, xyz.z);
  }

  static CIELuv _xyzToLuv(final double X, final double Y, final double Z) {
    // D65 reference white
    // ignore: constant_identifier_names
    const double Xn = 95.047;
    // ignore: constant_identifier_names
    const double Yn = 100.000;
    // ignore: constant_identifier_names
    const double Zn = 108.883;

    // Compute u', v' for the sample
    final double denom = X + 15 * Y + 3 * Z;
    final double uPrime = denom == 0 ? 0 : (4 * X) / denom;
    final double vPrime = denom == 0 ? 0 : (9 * Y) / denom;

    // Compute u'n, v'n for the reference white
    const double denomN = Xn + 15 * Yn + 3 * Zn;
    const double uPrimeN = (4 * Xn) / denomN;
    const double vPrimeN = (9 * Yn) / denomN;

    // Compute L*
    final double yr = Y / Yn;
    double L;
    if (yr <= (6 / 29) * (6 / 29) * (6 / 29)) {
      L = (29 * 29 * 29 / 3) * yr;
    } else {
      L = 116 * math.pow(yr, 1 / 3).toDouble() - 16;
    }

    // Avoid NaN if L=0
    if (L == 0) return const CIELuv(0, 0, 0);

    // Compute u* and v*
    final double uStar = 13 * L * (uPrime - uPrimeN);
    final double vStar = 13 * L * (vPrime - vPrimeN);

    return CIELuv(L, uStar, vStar);
  }

  /// Creates a 32-bit hex ARGB value from L, u, v components.
  ///
  /// This is a stand-alone static method that converts CIE L*u*v* color
  /// components directly to an ARGB integer value.
  ///
  /// [l] The lightness component (0-100).
  /// [u] The green-red component.
  /// [v] The blue-yellow component.
  ///
  /// Returns an integer representing the color in ARGB format.
  static int toHexId(final double l, final double u, final double v) {
    if (l == 0) {
      return hxBlack; // 0xFF000000; // Black
    }

    const double refX = 95.047;
    const double refY = 100.0;
    final double refZ = kWhitePointD65[2];
    final double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    final double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    final double uPrime = u / (13 * l) + refU;
    final double vPrime = v / (13 * l) + refV;

    final double y =
        l > 8 ? refY * pow((l + 16) / 116, 3).toDouble() : refY * l / 903.3;

    final double denominator = vPrime * 4;
    double x = 0;
    double z = 0;
    if (denominator != 0) {
      x = (9 * y * uPrime) / denominator;
      z = (9 * y / vPrime - x - 15 * y) / 3;
    }

    return XYZ(x, y, z).value;
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  @override
  CIELuv whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  CIELuv blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  CIELuv lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final CIELuv otherLuv = (other is CIELuv) ? other : other.toColor().toLuv();
    if (t == 1.0) return otherLuv;

    return CIELuv(
      l + (otherLuv.l - l) * t,
      u + (otherLuv.u - u) * t,
      v + (otherLuv.v - v) * t,
    );
  }

  @override
  CIELuv darken([final double amount = 20]) {
    return CIELuv(max(0, l - amount), u, v);
  }

  @override
  CIELuv saturate([final double amount = 25]) {
    return toColor().saturate(amount).toLuv();
  }

  @override
  CIELuv desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toLuv();
  }

  @override
  CIELuv accented([final double amount = 15]) {
    return toColor().accented(amount).toLuv();
  }

  @override
  CIELuv simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toLuv();
  }

  @override
  CIELuv lighten([final double amount = 20]) {
    return CIELuv(min(100, l + amount), u, v);
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  CIELuv copyWith({final double? l, final double? u, final double? v}) {
    return CIELuv(l ?? this.l, u ?? this.u, v ?? this.v);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toLuv())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toLuv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toLuv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toLuv();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  CIELuv blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toLuv();

  @override
  CIELuv opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toLuv();

  @override
  CIELuv adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toLuv();

  @override
  CIELuv get complementary => toColor().complementary.toLuv();

  @override
  CIELuv warmer([final double amount = 20]) => toColor().warmer(amount).toLuv();

  @override
  CIELuv cooler([final double amount = 20]) => toColor().cooler(amount).toLuv();

  @override
  List<CIELuv> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toLuv())
      .toList();

  @override
  List<CIELuv> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toLuv()).toList();

  @override
  List<CIELuv> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toLuv())
          .toList();

  @override
  List<CIELuv> square() =>
      toColor().square().map((final ColorIQ c) => c.toLuv()).toList();

  @override
  List<CIELuv> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toLuv())
      .toList();

  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());

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
    return <String, dynamic>{'type': 'LuvColor', 'l': l, 'u': u, 'v': v};
  }

  @override
  String toString() => 'LuvColor(l: ${l.toStrTrimZeros(3)}, ' //
      'u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
