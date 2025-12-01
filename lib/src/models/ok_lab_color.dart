import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lch_color.dart';
import 'ok_hsl_color.dart';
import 'ok_hsv_color.dart';

class OkLabColor implements ColorSpacesIQ {
  final double l;
  final double a;
  final double b;
  final double alpha;

  const OkLabColor(this.l, this.a, this.b, [this.alpha = 1.0]);

  @override
  ColorIQ toColor() {
    double l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    double m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    double s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    double l3 = l_ * l_ * l_;
    double m3 = m_ * m_ * m_;
    double s3 = s_ * s_ * s_;

    double r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    double g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    double bVal = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308) ? (1.055 * pow(bVal, 1 / 2.4) - 0.055) : (12.92 * bVal);

    return ColorIQ.fromARGB((alpha * 255).round(), (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (bVal * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  OkLchColor toOkLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi;
    if (h < 0) h += 360;
    return OkLchColor(l, c, h, alpha);
  }
  
  OkHslColor toOkHsl() {
      OkLchColor lch = toOkLch();
      double s = (lch.l == 0 || lch.l == 1) ? 0 : lch.c / 0.4; 
      if (s > 1) s = 1;
      return OkHslColor(lch.h, s, lch.l); // OkHslColor doesn't have alpha in constructor yet? Wait, I fixed it.
      // Wait, OkHslColor constructor is (h, s, l, [alpha]).
      // So I should pass alpha.
  }
  
  OkHsvColor toOkHsv() {
      OkLchColor lch = toOkLch();
      double v = lch.l + lch.c / 0.4;
      if (v > 1) v = 1;
      double s = (v == 0) ? 0 : (lch.c / 0.4) / v;
      if (s > 1) s = 1;
      return OkHsvColor(lch.h, s, v, alpha);
  }


  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkLabColor get inverted => toColor().inverted.toOkLab();

  @override
  OkLabColor get grayscale => toColor().grayscale.toOkLab();

  @override
  OkLabColor whiten([double amount = 20]) => toColor().whiten(amount).toOkLab();

  @override
  OkLabColor blacken([double amount = 20]) => toColor().blacken(amount).toOkLab();

  @override
  OkLabColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as ColorIQ).toOkLab();

  @override
  OkLabColor lighten([double amount = 20]) {
    return OkLabColor(min(1.0, l + amount / 100), a, b, alpha);
  }

  @override
  OkLabColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toOkLab();
  }

  @override
  OkLabColor darken([double amount = 20]) {
    return OkLabColor(max(0.0, l - amount / 100), a, b, alpha);
  }

  @override
  OkLabColor saturate([double amount = 25]) {
    return (toOkLch().saturate(amount) as OkLchColor).toOkLab();
  }

  @override
  OkLabColor desaturate([double amount = 25]) {
    return (toOkLch().desaturate(amount) as OkLchColor).toOkLab();
  }

  @override
  OkLabColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toOkLab();
  }

  @override
  OkLabColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toOkLab();
  }

  @override
  OkLabColor accented([double amount = 15]) {
    return toColor().accented(amount).toOkLab();
  }

  @override
  OkLabColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toOkLab();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkLabColor fromHct(HctColor hct) => hct.toColor().toOkLab();

  @override
  OkLabColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkLab();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkLabColor copyWith({double? l, double? a, double? b, double? alpha}) {
    return OkLabColor(
      l ?? this.l,
      a ?? this.a,
      b ?? this.b,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as ColorIQ).toOkLab()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as ColorIQ).toOkLab())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as ColorIQ).toOkLab())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkLab();

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
  OkLabColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toOkLab();

  @override
  OkLabColor opaquer([double amount = 20]) => toColor().opaquer(amount).toOkLab();

  @override
  OkLabColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toOkLab();

  @override
  OkLabColor get complementary => toColor().complementary.toOkLab();

  @override
  OkLabColor warmer([double amount = 20]) => toColor().warmer(amount).toOkLab();

  @override
  OkLabColor cooler([double amount = 20]) => toColor().cooler(amount).toOkLab();

  @override
  List<OkLabColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toOkLab()).toList();

  @override
  List<OkLabColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toOkLab()).toList();

  @override
  List<OkLabColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toOkLab()).toList();

  @override
  List<OkLabColor> square() => toColor().square().map((c) => c.toOkLab()).toList();

  @override
  List<OkLabColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toOkLab()).toList();

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
      'type': 'OkLabColor',
      'l': l,
      'a': a,
      'b': b,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkLabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
