import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'ok_lab_color.dart';


class OkHslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const OkHslColor(this.h, this.s, this.l);

  OkLabColor toOkLab() {
    double c = s * 0.4; 
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);
    return OkLabColor(l, a, b);
  }

  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkHslColor darken([double amount = 20]) {
    return OkHslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  OkHslColor lighten([double amount = 20]) {
    return OkHslColor(h, s, min(1.0, l + amount / 100));
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
  List<int> get srgb => toColor().srgb;

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
  OkHslColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkHsl();

  @override
  String toString() => 'OkHslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
