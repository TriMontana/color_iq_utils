import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class HspColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double p;

  const HspColor(this.h, this.s, this.p);

  Color toColor() {
    return Color.fromARGB(255, 0, 0, 0); 
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HspColor darken([double amount = 20]) {
    return toColor().darken(amount).toHsp();
  }

  @override
  HspColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toHsp();
  }

  @override
  HspColor saturate([double amount = 25]) {
    return HspColor(h, min(1.0, s + amount / 100), p);
  }

  @override
  HspColor desaturate([double amount = 25]) {
    return HspColor(h, max(0.0, s - amount / 100), p);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HspColor get inverted => toColor().inverted.toHsp();

  @override
  HspColor get grayscale => toColor().grayscale.toHsp();

  @override
  HspColor whiten([double amount = 20]) => toColor().whiten(amount).toHsp();

  @override
  HspColor blacken([double amount = 20]) => toColor().blacken(amount).toHsp();

  @override
  HspColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsp();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HspColor fromHct(HctColor hct) => hct.toColor().toHsp();

  @override
  HspColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsp();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  @override
  String toString() => 'HspColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, p: ${p.toStringAsFixed(2)})';
}
