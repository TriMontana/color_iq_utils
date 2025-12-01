import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lab_color.dart';

class OkLchColor implements ColorSpacesIQ {
  final double l;
  final double c;
  final double h;
  final double alpha;

  const OkLchColor(this.l, this.c, this.h, [this.alpha = 1.0]);

  OkLabColor toOkLab() {
    double hRad = h * pi / 180;
    return OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha);
  }
  
  @override
  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkLchColor darken([double amount = 20]) {
    return OkLchColor(max(0.0, l - amount / 100), c, h, alpha);
  }

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkLchColor get inverted => toColor().inverted.toOkLch();

  @override
  OkLchColor get grayscale => toColor().grayscale.toOkLch();

  @override
  OkLchColor whiten([double amount = 20]) => toColor().whiten(amount).toOkLch();

  @override
  OkLchColor blacken([double amount = 20]) => toColor().blacken(amount).toOkLch();

  @override
  OkLchColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkLch();

  @override
  OkLchColor lighten([double amount = 20]) {
    return OkLchColor(min(1.0, l + amount / 100), c, h, alpha);
  }

  @override
  OkLchColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toOkLch();
  }

  @override
  OkLchColor saturate([double amount = 25]) {
    return OkLchColor(l, c + amount / 100, h, alpha);
  }

  @override
  OkLchColor desaturate([double amount = 25]) {
    return OkLchColor(l, max(0.0, c - amount / 100), h, alpha);
  }

  @override
  OkLchColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toOkLch();
  }

  @override
  OkLchColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toOkLch();
  }

  @override
  OkLchColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toOkLch();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkLchColor fromHct(HctColor hct) => hct.toColor().toOkLch();

  @override
  OkLchColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkLch();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkLchColor copyWith({double? l, double? c, double? h, double? alpha}) {
    return OkLchColor(
      l ?? this.l,
      c ?? this.c,
      h ?? this.h,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toOkLch()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toOkLch())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toOkLch())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toOkLch();

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
  OkLchColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toOkLch();

  @override
  OkLchColor opaquer([double amount = 20]) => toColor().opaquer(amount).toOkLch();

  @override
  OkLchColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toOkLch();

  @override
  OkLchColor get complementary => toColor().complementary.toOkLch();

  @override
  OkLchColor warmer([double amount = 20]) => toColor().warmer(amount).toOkLch();

  @override
  OkLchColor cooler([double amount = 20]) => toColor().cooler(amount).toOkLch();

  @override
  List<OkLchColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> square() => toColor().square().map((c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toOkLch()).toList();

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
      'type': 'OkLchColor',
      'l': l,
      'c': c,
      'h': h,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkLchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
