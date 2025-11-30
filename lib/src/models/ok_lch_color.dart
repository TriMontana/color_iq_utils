import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'ok_lab_color.dart';

class OkLchColor implements ColorSpacesIQ {
  final double l;
  final double c;
  final double h;

  const OkLchColor(this.l, this.c, this.h);

  OkLabColor toOkLab() {
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);
    return OkLabColor(l, a, b);
  }

  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkLchColor darken([double amount = 20]) {
    return OkLchColor(max(0.0, l - amount / 100), c, h);
  }

  @override
  OkLchColor lighten([double amount = 20]) {
    return OkLchColor(min(1.0, l + amount / 100), c, h);
  }

  @override
  OkLchColor saturate([double amount = 25]) {
    return OkLchColor(l, c + amount / 100, h);
  }

  @override
  OkLchColor desaturate([double amount = 25]) {
    return OkLchColor(l, max(0.0, c - amount / 100), h);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkLchColor get inverted => toColor().inverted.toOkLch();

  @override
  OkLchColor get grayscale => toColor().grayscale.toOkLch();

  @override
  OkLchColor whiten([double amount = 20]) => toColor().whiten(amount).toOkLch();

  @override
  OkLchColor blacken([double amount = 20]) => toColor().blacken(amount).toOkLch();

  @override
  OkLchColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkLch();

  @override
  String toString() => 'OkLchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
