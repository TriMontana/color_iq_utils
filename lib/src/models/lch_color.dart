import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'lab_color.dart';

class LchColor implements ColorSpacesIQ {
  final double l;
  final double c;
  final double h;

  const LchColor(this.l, this.c, this.h);

  LabColor toLab() {
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);
    return LabColor(l, a, b);
  }

  @override
  Color toColor() => toLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  LchColor darken([double amount = 20]) {
    return LchColor(max(0, l - amount), c, h);
  }

  @override
  LchColor lighten([double amount = 20]) {
    return LchColor(min(100, l + amount), c, h);
  }

  @override
  LchColor saturate([double amount = 25]) {
    return LchColor(l, c + amount, h);
  }

  @override
  LchColor desaturate([double amount = 25]) {
    return LchColor(l, max(0, c - amount), h);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  LchColor get inverted => toColor().inverted.toLch();

  @override
  LchColor get grayscale => toColor().grayscale.toLch();

  @override
  LchColor whiten([double amount = 20]) => toColor().whiten(amount).toLch();

  @override
  LchColor blacken([double amount = 20]) => toColor().blacken(amount).toLch();

  @override
  LchColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toLch();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  LchColor fromHct(HctColor hct) => hct.toColor().toLch();

  @override
  LchColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toLch();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LchColor copyWith({double? l, double? c, double? h}) {
    return LchColor(
      l ?? this.l,
      c ?? this.c,
      h ?? this.h,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toLch()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toLch())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toLch())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toLch();

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
  LchColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toLch();

  @override
  LchColor opaquer([double amount = 20]) => toColor().opaquer(amount).toLch();

  @override
  LchColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toLch();

  @override
  LchColor get complementary => toColor().complementary.toLch();

  @override
  LchColor warmer([double amount = 20]) => toColor().warmer(amount).toLch();

  @override
  LchColor cooler([double amount = 20]) => toColor().cooler(amount).toLch();

  @override
  List<LchColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toLch()).toList();

  @override
  List<LchColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toLch()).toList();

  @override
  List<LchColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toLch()).toList();

  @override
  List<LchColor> square() => toColor().square().map((c) => c.toLch()).toList();

  @override
  List<LchColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toLch()).toList();

  @override
  double distanceTo(ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      return toLab().isWithinGamut(gamut);
    }
    return true;
  }

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'LchColor',
      'l': l,
      'c': c,
      'h': h,
    };
  }

  @override
  String toString() => 'LchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
