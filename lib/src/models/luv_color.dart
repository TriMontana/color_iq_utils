import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'coloriq.dart';
import 'hct_color.dart';
import 'xyz_color.dart';


class LuvColor implements ColorSpacesIQ {
  final double l;
  final double u;
  final double v;

  const LuvColor(this.l, this.u, this.v);

  @override
  ColorIQ toColor() {
    if (l == 0) {
      return const ColorIQ.fromARGB(255, 0, 0, 0);
    }

    const double refX = 95.047;
    const double refY = 100.0;
    const double refZ = 108.883;
    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    final double uPrime = u / (13 * l) + refU;
    final double vPrime = v / (13 * l) + refV;

    final double y = l > 8 ? refY * pow((l + 16) / 116, 3).toDouble() : refY * l / 903.3;

    final double denominator = vPrime * 4;
    double x = 0;
    double z = 0;
    if (denominator != 0) {
      x = (9 * y * uPrime) / denominator;
      z = (9 * y / vPrime - x - 15 * y) / 3;
    }

    return XyzColor(x, y, z).toColor();
  }

  @override
  int get value => toColor().value;

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  LuvColor get inverted => toColor().inverted.toLuv();

  @override
  LuvColor get grayscale => toColor().grayscale.toLuv();

  @override
  LuvColor whiten([double amount = 20]) => toColor().whiten(amount).toLuv();

  @override
  LuvColor blacken([double amount = 20]) => toColor().blacken(amount).toLuv();

  @override
  LuvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as ColorIQ).toLuv();

  @override
  LuvColor darken([double amount = 20]) {
    return LuvColor(max(0, l - amount), u, v);
  }

  @override
  LuvColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toLuv();
  }

  @override
  LuvColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toLuv();
  }

  @override
  LuvColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toLuv();
  }

  @override
  LuvColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toLuv();
  }

  @override
  LuvColor accented([double amount = 15]) {
    return toColor().accented(amount).toLuv();
  }

  @override
  LuvColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toLuv();
  }

  @override
  LuvColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toLuv();
  }

  @override
  LuvColor lighten([double amount = 20]) {
    return LuvColor(min(100, l + amount), u, v);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  LuvColor fromHct(HctColor hct) => hct.toColor().toLuv();

  @override
  LuvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toLuv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LuvColor copyWith({double? l, double? u, double? v}) {
    return LuvColor(
      l ?? this.l,
      u ?? this.u,
      v ?? this.v,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as ColorIQ).toLuv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as ColorIQ).toLuv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as ColorIQ).toLuv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toLuv();

  @override
  bool isEqual(ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  LuvColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toLuv();

  @override
  LuvColor opaquer([double amount = 20]) => toColor().opaquer(amount).toLuv();

  @override
  LuvColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toLuv();

  @override
  LuvColor get complementary => toColor().complementary.toLuv();

  @override
  LuvColor warmer([double amount = 20]) => toColor().warmer(amount).toLuv();

  @override
  LuvColor cooler([double amount = 20]) => toColor().cooler(amount).toLuv();

  @override
  List<LuvColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toLuv()).toList();

  @override
  List<LuvColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toLuv()).toList();

  @override
  List<LuvColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toLuv()).toList();

  @override
  List<LuvColor> square() => toColor().square().map((c) => c.toLuv()).toList();

  @override
  List<LuvColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toLuv()).toList();

  @override
  double distanceTo(ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) => toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'LuvColor',
      'l': l,
      'u': u,
      'v': v,
    };
  }

  @override
  String toString() => 'LuvColor(l: ${l.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
