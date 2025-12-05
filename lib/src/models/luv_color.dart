import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
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
class LuvColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The lightness component of the color.
  ///
  /// Ranges from 0 (black) to 100 (white).
  final double l;

  /// The green-red component of the color.
  final double u;

  /// The blue-yellow component of the color.
  final double v;

  /// Creates a new `LuvColor`.
  const LuvColor(this.l, this.u, this.v,
      {required final int hexId, final Percent alpha = Percent.max})
      : super(hexId, a: alpha);
  LuvColor.alt(this.l, this.u, this.v,
      {final int? hexId, final Percent alpha = Percent.max})
      : super(hexId ?? LuvColor.toHexId(l, u, v), a: alpha);

  /// Creates a [LuvColor] from a 32-bit integer ARGB value.
  factory LuvColor.fromInt(final int argb) {
    return ColorIQ(argb).toLuv();
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
    const double refZ = 108.883;
    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

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

    return XyzColor.alt(x, y, z).value;
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  @override
  LuvColor get inverted => toColor().inverted.toLuv();

  @override
  LuvColor get grayscale => toColor().grayscale.toLuv();

  @override
  LuvColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  LuvColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  LuvColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final LuvColor otherLuv =
        (other is LuvColor) ? other : other.toColor().toLuv();
    if (t == 1.0) return otherLuv;

    return LuvColor.alt(
      l + (otherLuv.l - l) * t,
      u + (otherLuv.u - u) * t,
      v + (otherLuv.v - v) * t,
    );
  }

  @override
  LuvColor darken([final double amount = 20]) {
    return LuvColor.alt(max(0, l - amount), u, v);
  }

  @override
  LuvColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).toLuv();
  }

  @override
  LuvColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toLuv();
  }

  @override
  LuvColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toLuv();
  }

  @override
  LuvColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toLuv();
  }

  @override
  LuvColor accented([final double amount = 15]) {
    return toColor().accented(amount).toLuv();
  }

  @override
  LuvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toLuv();
  }

  @override
  LuvColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toLuv();
  }

  @override
  LuvColor lighten([final double amount = 20]) {
    return LuvColor.alt(min(100, l + amount), u, v);
  }

  @override
  HctColor toHctColor() => toColor().toHctColor();

  @override
  LuvColor fromHct(final HctColor hct) => hct.toColor().toLuv();

  @override
  LuvColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toLuv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LuvColor copyWith({final double? l, final double? u, final double? v}) {
    return LuvColor.alt(l ?? this.l, u ?? this.u, v ?? this.v);
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
  LuvColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toLuv();

  @override
  LuvColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toLuv();

  @override
  LuvColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toLuv();

  @override
  LuvColor get complementary => toColor().complementary.toLuv();

  @override
  LuvColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toLuv();

  @override
  LuvColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toLuv();

  @override
  List<LuvColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toLuv())
      .toList();

  @override
  List<LuvColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toLuv()).toList();

  @override
  List<LuvColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toLuv())
          .toList();

  @override
  List<LuvColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toLuv()).toList();

  @override
  List<LuvColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toLuv())
      .toList();

  @override
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
