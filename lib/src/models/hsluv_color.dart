import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'luv_color.dart';

class HsluvColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const HsluvColor(this.h, this.s, this.l);

  Color toColor() {
      double c = s; 
      double hRad = h * pi / 180;
      double u = c * cos(hRad);
      double v = c * sin(hRad);
      return LuvColor(l, u, v).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HsluvColor darken([double amount = 20]) {
    return HsluvColor(h, s, max(0, l - amount));
  }

  @override
  HsluvColor lighten([double amount = 20]) {
    return HsluvColor(h, s, min(100, l + amount));
  }

  @override
  HsluvColor saturate([double amount = 25]) {
    return HsluvColor(h, min(100, s + amount), l);
  }

  @override
  HsluvColor desaturate([double amount = 25]) {
    return HsluvColor(h, max(0, s - amount), l);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HsluvColor get inverted => toColor().inverted.toHsluv();

  @override
  HsluvColor get grayscale => toColor().grayscale.toHsluv();

  @override
  HsluvColor whiten([double amount = 20]) => toColor().whiten(amount).toHsluv();

  @override
  HsluvColor blacken([double amount = 20]) => toColor().blacken(amount).toHsluv();

  @override
  HsluvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsluv();

  @override
  String toString() => 'HsluvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
