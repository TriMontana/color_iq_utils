import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'ok_lab_color.dart';


class OkHsvColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double v;

  const OkHsvColor(this.h, this.s, this.v);

  OkLabColor toOkLab() {
     double l = v * (1 - s / 2);
     double c = v * s * 0.4;
     double hRad = h * pi / 180;
     double a = c * cos(hRad);
     double b = c * sin(hRad);
     return OkLabColor(l, a, b);
  }

  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkHsvColor lighten([double amount = 20]) {
    return OkHsvColor(h, s, min(1.0, v + amount / 100));
  }

  @override
  String toString() => 'OkHsvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
