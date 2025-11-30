
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

  Color toColor() {
    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);
    return Color.fromARGB(255, r.round(), g.round(), b.round());
  }
  
  @override
  int get value => toColor().value;

  @override
  bool operator ==(Object other) => other is CmykColor && other.c == c && other.m == m && other.y == y && other.k == k;
  
  @override
  int get hashCode => Object.hash(c, m, y, k);
  
  @override
  CmykColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toCmyk();
  }

  @override
  CmykColor darken([double amount = 20]) {
    return toColor().darken(amount).toCmyk();
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

  @override
  String toString() => 'CmykColor(c: ${c.toStringAsFixed(2)}, m: ${m.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';
}
