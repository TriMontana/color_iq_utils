import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class HunterLabColor implements ColorSpacesIQ {
  final double l;
  final double a;
  final double b;

  const HunterLabColor(this.l, this.a, this.b);

  @override
  Color toColor() {
    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    double y = pow(l / 100.0, 2) * yn;
    double x = (a / 175.0 * (l / 100.0) + y / yn) * xn;
    double z = (y / yn - b / 70.0 * (l / 100.0)) * zn;

    double xTemp = x / 100;
    double yTemp = y / 100;
    double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double bVal = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308) ? (1.055 * pow(bVal, 1 / 2.4) - 0.055) : (12.92 * bVal);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (bVal * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HunterLabColor darken([double amount = 20]) {
    return HunterLabColor(max(0, l - amount), a, b);
  }

  @override
  HunterLabColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toHunterLab();
  }

  @override
  HunterLabColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toHunterLab();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HunterLabColor get inverted => toColor().inverted.toHunterLab();

  @override
  HunterLabColor get grayscale => toColor().grayscale.toHunterLab();

  @override
  HunterLabColor whiten([double amount = 20]) => toColor().whiten(amount).toHunterLab();

  @override
  HunterLabColor blacken([double amount = 20]) => toColor().blacken(amount).toHunterLab();

  @override
  HunterLabColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHunterLab();

  @override
  HunterLabColor lighten([double amount = 20]) {
    return HunterLabColor(min(100, l + amount), a, b);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HunterLabColor fromHct(HctColor hct) => hct.toColor().toHunterLab();

  @override
  HunterLabColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHunterLab();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  HunterLabColor copyWith({double? l, double? a, double? b}) {
    return HunterLabColor(
      l ?? this.l,
      a ?? this.a,
      b ?? this.b,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toHunterLab()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toHunterLab())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toHunterLab())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toHunterLab();

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
  HunterLabColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHunterLab();

  @override
  HunterLabColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHunterLab();

  @override
  HunterLabColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHunterLab();

  @override
  HunterLabColor get complementary => toColor().complementary.toHunterLab();

  @override
  HunterLabColor warmer([double amount = 20]) => toColor().warmer(amount).toHunterLab();

  @override
  HunterLabColor cooler([double amount = 20]) => toColor().cooler(amount).toHunterLab();

  @override
  List<HunterLabColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHunterLab()).toList();

  @override
  List<HunterLabColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHunterLab()).toList();

  @override
  List<HunterLabColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHunterLab()).toList();

  @override
  List<HunterLabColor> square() => toColor().square().map((c) => c.toHunterLab()).toList();

  @override
  List<HunterLabColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHunterLab()).toList();

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
      'type': 'HunterLabColor',
      'l': l,
      'a': a,
      'b': b,
    };
  }

  @override
  String toString() => 'HunterLabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
