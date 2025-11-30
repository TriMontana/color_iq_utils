import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class MunsellColor implements ColorSpacesIQ {
  final String hue;
  final double munsellValue;
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma);

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

  @override
  String toString() => 'MunsellColor(hue: $hue, value: ${munsellValue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)})';
}
