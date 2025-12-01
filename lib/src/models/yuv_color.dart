import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class YuvColor implements ColorSpacesIQ {
  final double y;
  final double u;
  final double v;

  const YuvColor(this.y, this.u, this.v);

  @override
  Color toColor() {
    double r = y + 1.13983 * v;
    double g = y - 0.39465 * u - 0.58060 * v;
    double b = y + 2.03211 * u;
    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  YuvColor darken([double amount = 20]) {
    return toColor().darken(amount).toYuv();
  }

  @override
  YuvColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toYuv();
  }

  @override
  YuvColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toYuv();
  }

  @override
  YuvColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toYuv();
  }

  @override
  YuvColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toYuv();
  }

  @override
  YuvColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toYuv();
  }

  @override
  YuvColor accented([double amount = 15]) {
    return toColor().accented(amount).toYuv();
  }

  @override
  YuvColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toYuv();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  YuvColor get inverted => toColor().inverted.toYuv();

  @override
  YuvColor get grayscale => toColor().grayscale.toYuv();

  @override
  YuvColor whiten([double amount = 20]) => toColor().whiten(amount).toYuv();

  @override
  YuvColor blacken([double amount = 20]) => toColor().blacken(amount).toYuv();

  @override
  YuvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toYuv();

  @override
  YuvColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toYuv();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  YuvColor fromHct(HctColor hct) => hct.toColor().toYuv();

  @override
  YuvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toYuv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  YuvColor copyWith({double? y, double? u, double? v}) {
    return YuvColor(
      y ?? this.y,
      u ?? this.u,
      v ?? this.v,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toYuv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toYuv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toYuv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toYuv();

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
  YuvColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toYuv();

  @override
  YuvColor opaquer([double amount = 20]) => toColor().opaquer(amount).toYuv();

  @override
  YuvColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toYuv();

  @override
  YuvColor get complementary => toColor().complementary.toYuv();

  @override
  YuvColor warmer([double amount = 20]) => toColor().warmer(amount).toYuv();

  @override
  YuvColor cooler([double amount = 20]) => toColor().cooler(amount).toYuv();

  @override
  List<YuvColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toYuv()).toList();

  @override
  List<YuvColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toYuv()).toList();

  @override
  List<YuvColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toYuv()).toList();

  @override
  List<YuvColor> square() => toColor().square().map((c) => c.toYuv()).toList();

  @override
  List<YuvColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toYuv()).toList();

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
      'type': 'YuvColor',
      'y': y,
      'u': u,
      'v': v,
    };
  }

  @override
  String toString() => 'YuvColor(y: ${y.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
