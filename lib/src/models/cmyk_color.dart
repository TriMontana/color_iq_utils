
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class CmykColor implements ColorSpacesIQ {
  final double c;
  final double m;
  final double y;
  final double k;

  const CmykColor(this.c, this.m, this.y, this.k);

  @override
  Color toColor() {
    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);
    return Color.fromARGB(255, r.round().clamp(0, 255), g.round().clamp(0, 255), b.round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  @override
  bool operator ==(Object other) => other is CmykColor && other.c == c && other.m == m && other.y == y && other.k == k;
  
  @override
  CmykColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toCmyk();
  }

  @override
  CmykColor darken([double amount = 20]) {
    return toColor().darken(amount).toCmyk();
  }

  @override
  CmykColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toCmyk();
  }
  

  @override
  CmykColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toCmyk();
  }

  @override
  CmykColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toCmyk();
  }

  @override
  CmykColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toCmyk();
  }

  @override
  CmykColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toCmyk();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  CmykColor get inverted => toColor().inverted.toCmyk();

  @override
  CmykColor get grayscale => toColor().grayscale.toCmyk();

  @override
  CmykColor whiten([double amount = 20]) => toColor().whiten(amount).toCmyk();

  @override
  CmykColor blacken([double amount = 20]) => toColor().blacken(amount).toCmyk();

  @override
  CmykColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toCmyk();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  CmykColor fromHct(HctColor hct) => hct.toColor().toCmyk();

  @override
  CmykColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toCmyk();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  CmykColor copyWith({double? c, double? m, double? y, double? k}) {
    return CmykColor(
      c ?? this.c,
      m ?? this.m,
      y ?? this.y,
      k ?? this.k,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toCmyk()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toCmyk())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toCmyk())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toCmyk();

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
  CmykColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toCmyk();

  @override
  CmykColor opaquer([double amount = 20]) => toColor().opaquer(amount).toCmyk();

  @override
  CmykColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toCmyk();

  @override
  CmykColor get complementary => toColor().complementary.toCmyk();

  @override
  CmykColor warmer([double amount = 20]) => toColor().warmer(amount).toCmyk();

  @override
  CmykColor cooler([double amount = 20]) => toColor().cooler(amount).toCmyk();

  @override
  List<CmykColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toCmyk()).toList();

  @override
  List<CmykColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toCmyk()).toList();

  @override
  List<CmykColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toCmyk()).toList();

  @override
  List<CmykColor> square() => toColor().square().map((c) => c.toCmyk()).toList();

  @override
  List<CmykColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toCmyk()).toList();

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
      'type': 'CmykColor',
      'c': c,
      'm': m,
      'y': y,
      'k': k,
    };
  }

  @override
  String toString() => 'CmykColor(c: ${c.toStringAsFixed(2)}, m: ${m.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';
}
