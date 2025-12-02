import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'coloriq.dart';
import 'hct_color.dart';

class MunsellColor implements ColorSpacesIQ {
  final String hue;
  final double munsellValue;
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma);

  @override
  ColorIQ toColor() {
      // Munsell conversion is complex and usually requires lookup tables.
      // For this implementation, we will return a placeholder or approximate if possible.
      // Since we don't have the tables, we'll return Black or throw.
      // Or better, return a neutral gray based on Value.
      // Value 0-10 maps to L* 0-100 roughly.
      int grayVal = (munsellValue * 25.5).round().clamp(0, 255);
      return ColorIQ.fromARGB(255, grayVal, grayVal, grayVal);
  }
  
  @override
  int get value => toColor().value;
  
  @override
  MunsellColor darken([double amount = 20]) {
    // Decrease Value
    return MunsellColor(hue, (munsellValue - (amount / 10)).clamp(0.0, 10.0), chroma);
  }

  @override
  MunsellColor brighten([double amount = 20]) {
    // Increase Value
    return MunsellColor(hue, (munsellValue + (amount / 10)).clamp(0.0, 10.0), chroma);
  }

  @override
  MunsellColor saturate([double amount = 25]) {
    // Increase Chroma
    return MunsellColor(hue, munsellValue, chroma + (amount / 5)); // Arbitrary scale
  }

  @override
  MunsellColor desaturate([double amount = 25]) {
    // Decrease Chroma
    return MunsellColor(hue, munsellValue, max(0.0, chroma - (amount / 5)));
  }

  @override
  MunsellColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toMunsell();
  }

  @override
  MunsellColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toMunsell();
  }

  @override
  MunsellColor accented([double amount = 15]) {
    return toColor().accented(amount).toMunsell();
  }

  @override
  MunsellColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toMunsell();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  MunsellColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toMunsell();

  @override
  MunsellColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toMunsell();

  @override
  MunsellColor get complementary => toColor().complementary.toMunsell();

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  MunsellColor opaquer([double amount = 20]) => toColor().opaquer(amount).toMunsell();



  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  MunsellColor get inverted => toColor().inverted.toMunsell();

  @override
  MunsellColor get grayscale => toColor().grayscale.toMunsell();

  @override
  MunsellColor whiten([double amount = 20]) => toColor().whiten(amount).toMunsell();

  @override
  MunsellColor blacken([double amount = 20]) => toColor().blacken(amount).toMunsell();

  @override
  MunsellColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as ColorIQ).toMunsell();

  @override
  MunsellColor lighten([double amount = 20]) {
    // Increase Value
    return MunsellColor(hue, (munsellValue + (amount / 10)).clamp(0.0, 10.0), chroma);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  MunsellColor fromHct(HctColor hct) => hct.toColor().toMunsell();

  @override
  MunsellColor adjustTransparency([double amount = 20]) {
    // Munsell doesn't have alpha, so we ignore or return as is (conceptually)
    // But interface requires returning same type.
    // Since we don't store alpha, we can't really adjust it.
    return this; 
  }

  @override
  double get transparency => 0.0;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  MunsellColor copyWith({String? hue, double? munsellValue, double? chroma}) {
    return MunsellColor(
      hue ?? this.hue,
      munsellValue ?? this.munsellValue,
      chroma ?? this.chroma,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as ColorIQ).toMunsell()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as ColorIQ).toMunsell())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as ColorIQ).toMunsell())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toMunsell();

  @override
  bool isEqual(ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  @override
  MunsellColor warmer([double amount = 20]) => toColor().warmer(amount).toMunsell();

  @override
  MunsellColor cooler([double amount = 20]) => toColor().cooler(amount).toMunsell();

  @override
  List<MunsellColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toMunsell()).toList();

  @override
  List<MunsellColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toMunsell()).toList();

  @override
  List<MunsellColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toMunsell()).toList();

  @override
  List<MunsellColor> square() => toColor().square().map((c) => c.toMunsell()).toList();

  @override
  List<MunsellColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toMunsell()).toList();

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
      'type': 'MunsellColor',
      'hue': hue,
      'value': munsellValue, // Using munsellValue to avoid conflict with value getter
      'chroma': chroma,
    };
  }

  @override
  String toString() => 'MunsellColor(hue: $hue, value: ${munsellValue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)})';
}
