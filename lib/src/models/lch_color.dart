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

  @override
  String toString() => 'LchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
