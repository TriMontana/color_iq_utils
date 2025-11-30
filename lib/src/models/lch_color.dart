import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
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
  LchColor lighten([double amount = 20]) {
    return LchColor(min(100, l + amount), c, h);
  }

  @override
  String toString() => 'LchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
