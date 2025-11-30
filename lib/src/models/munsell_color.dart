import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class MunsellColor implements ColorSpacesIQ {
  final String hue;
  final double munsellValue;
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma);

  @override
  Color toColor() {
      return Color.fromARGB(255, 0, 0, 0);
  }
  
  @override
  int get value => toColor().value;
  
  @override
  MunsellColor darken([double amount = 20]) {
    return toColor().darken(amount).toMunsell();
  }

  @override
  MunsellColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toMunsell();
  }

  @override
  MunsellColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toMunsell();
  }

  @override
  List<int> get srgb => toColor().srgb;

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
  MunsellColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toMunsell();

  @override
  MunsellColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toMunsell();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  MunsellColor fromHct(HctColor hct) => hct.toColor().toMunsell();

  @override
  MunsellColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toMunsell();
  }

  @override
  double get transparency => toColor().transparency;

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
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toMunsell()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toMunsell())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toMunsell())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toMunsell();

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
  MunsellColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toMunsell();

  @override
  MunsellColor opaquer([double amount = 20]) => toColor().opaquer(amount).toMunsell();

  @override
  MunsellColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toMunsell();

  @override
  MunsellColor get complementary => toColor().complementary.toMunsell();

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
  String toString() => 'MunsellColor(hue: $hue, value: ${munsellValue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)})';
}
