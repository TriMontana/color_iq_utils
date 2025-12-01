import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lab_color.dart';
import 'ok_lch_color.dart';


class OkHslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const OkHslColor(this.h, this.s, this.l);

  @override
  ColorIQ toColor() {
      // Approximate conversion via OkLch
      // s is roughly c/0.4 for s=1.
      // l is roughly L.
      
      double L = l;
      double C = s * 0.4; // Approximation
      double hue = h;
      
      return OkLchColor(L, C, hue).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  OkHslColor darken([double amount = 20]) {
    return OkHslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkHslColor get inverted => toColor().inverted.toOkHsl();

  @override
  OkHslColor get grayscale => toColor().grayscale.toOkHsl();

  @override
  OkHslColor whiten([double amount = 20]) => toColor().whiten(amount).toOkHsl();

  @override
  OkHslColor blacken([double amount = 20]) => toColor().blacken(amount).toOkHsl();

  @override
  OkHslColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as ColorIQ).toOkHsl();

  @override
  OkHslColor lighten([double amount = 20]) {
    return OkHslColor(h, s, min(1.0, l + amount / 100));
  }

  @override
  OkHslColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toOkHsl();
  }

  @override
  OkHslColor saturate([double amount = 25]) {
    return OkHslColor(h, min(1.0, s + amount / 100), l);
  }

  @override
  OkHslColor desaturate([double amount = 25]) {
    return OkHslColor(h, max(0.0, s - amount / 100), l);
  }

  @override
  OkHslColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toOkHsl();
  }

  @override
  OkHslColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toOkHsl();
  }

  @override
  OkHslColor accented([double amount = 15]) {
    return toColor().accented(amount).toOkHsl();
  }

  @override
  OkHslColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toOkHsl();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkHslColor fromHct(HctColor hct) => hct.toColor().toOkHsl();

  @override
  OkHslColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsl();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkHslColor copyWith({double? h, double? s, double? l}) {
    return OkHslColor(
      h ?? this.h,
      s ?? this.s,
      l ?? this.l,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as ColorIQ).toOkHsl()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as ColorIQ).toOkHsl())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as ColorIQ).toOkHsl())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkHsl();

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
  OkHslColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toOkHsl();

  @override
  OkHslColor opaquer([double amount = 20]) => toColor().opaquer(amount).toOkHsl();

  @override
  OkHslColor adjustHue([double amount = 20]) {
      var newHue = (h + amount) % 360;
      if (newHue < 0) newHue += 360;
      return OkHslColor(newHue, s, l);
  }

  @override
  OkHslColor get complementary => adjustHue(180);

  @override
  OkHslColor warmer([double amount = 20]) => toColor().warmer(amount).toOkHsl();

  @override
  OkHslColor cooler([double amount = 20]) => toColor().cooler(amount).toOkHsl();

  @override
  List<OkHslColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> square() => toColor().square().map((c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toOkHsl()).toList();

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
      'type': 'OkHslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': transparency,
    };
  }

  @override
  String toString() => 'OkHslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
