import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class DisplayP3Color implements ColorSpacesIQ {
  final double r;
  final double g;
  final double b;

  const DisplayP3Color(this.r, this.g, this.b);

  @override
  Color toColor() {
      // Gamma decoding (P3 to Linear)
      double rLin = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
      double gLin = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
      double bLin = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);
      
      // Display P3 Linear to XYZ (D65)
      // Matrix inverse of the one used in conversion
      double x = rLin * 0.4865709 + gLin * 0.2656677 + bLin * 0.1982173;
      double y = rLin * 0.2289746 + gLin * 0.6917385 + bLin * 0.0792869;
      double z = rLin * 0.0000000 + gLin * 0.0451134 + bLin * 1.0439444;
      
      // XYZ (D65) to sRGB Linear
      double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
      double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
      double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;
      
      // sRGB Linear to sRGB (Gamma encoded)
      rS = (rS > 0.0031308) ? (1.055 * pow(rS, 1 / 2.4) - 0.055) : (12.92 * rS);
      gS = (gS > 0.0031308) ? (1.055 * pow(gS, 1 / 2.4) - 0.055) : (12.92 * gS);
      bS = (bS > 0.0031308) ? (1.055 * pow(bS, 1 / 2.4) - 0.055) : (12.92 * bS);
      
      return Color.fromARGB(255, (rS * 255).round().clamp(0, 255), (gS * 255).round().clamp(0, 255), (bS * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  DisplayP3Color darken([double amount = 20]) {
    return toColor().darken(amount).toDisplayP3();
  }

  @override
  DisplayP3Color brighten([double amount = 20]) {
    return toColor().brighten(amount).toDisplayP3();
  }

  @override
  DisplayP3Color saturate([double amount = 25]) {
    return toColor().saturate(amount).toDisplayP3();
  }

  @override
  DisplayP3Color desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toDisplayP3();
  }

  @override
  DisplayP3Color intensify([double amount = 10]) {
    return toColor().intensify(amount).toDisplayP3();
  }

  @override
  DisplayP3Color deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toDisplayP3();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  DisplayP3Color get inverted => toColor().inverted.toDisplayP3();

  @override
  DisplayP3Color get grayscale => toColor().grayscale.toDisplayP3();

  @override
  DisplayP3Color whiten([double amount = 20]) => toColor().whiten(amount).toDisplayP3();

  @override
  DisplayP3Color blacken([double amount = 20]) => toColor().blacken(amount).toDisplayP3();

  @override
  DisplayP3Color lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toDisplayP3();

  @override
  DisplayP3Color lighten([double amount = 20]) {
    return toColor().lighten(amount).toDisplayP3();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  DisplayP3Color fromHct(HctColor hct) => hct.toColor().toDisplayP3();

  @override
  DisplayP3Color adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toDisplayP3();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  DisplayP3Color copyWith({double? r, double? g, double? b}) {
    return DisplayP3Color(
      r ?? this.r,
      g ?? this.g,
      b ?? this.b,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toDisplayP3()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toDisplayP3())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toDisplayP3())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toDisplayP3();

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
  DisplayP3Color blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toDisplayP3();

  @override
  DisplayP3Color opaquer([double amount = 20]) => toColor().opaquer(amount).toDisplayP3();

  @override
  DisplayP3Color adjustHue([double amount = 20]) => toColor().adjustHue(amount).toDisplayP3();

  @override
  DisplayP3Color get complementary => toColor().complementary.toDisplayP3();

  @override
  DisplayP3Color warmer([double amount = 20]) => toColor().warmer(amount).toDisplayP3();

  @override
  DisplayP3Color cooler([double amount = 20]) => toColor().cooler(amount).toDisplayP3();

  @override
  List<DisplayP3Color> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toDisplayP3()).toList();

  @override
  List<DisplayP3Color> tonesPalette() => toColor().tonesPalette().map((c) => c.toDisplayP3()).toList();

  @override
  List<DisplayP3Color> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toDisplayP3()).toList();

  @override
  List<DisplayP3Color> square() => toColor().square().map((c) => c.toDisplayP3()).toList();

  @override
  List<DisplayP3Color> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toDisplayP3()).toList();

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
      'type': 'DisplayP3Color',
      'r': r,
      'g': g,
      'b': b,
      'opacity': transparency,
    };
  }

  @override
  String toString() => 'DisplayP3Color(r: ${r.toStringAsFixed(4)}, g: ${g.toStringAsFixed(4)}, b: ${b.toStringAsFixed(4)}, opacity: ${transparency.toStringAsFixed(2)})';
}
