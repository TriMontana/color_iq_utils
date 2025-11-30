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
  HsluvColor lighten([double amount = 20]) {
    return HsluvColor(h, s, min(100, l + amount));
  }

  @override
  String toString() => 'HsluvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
