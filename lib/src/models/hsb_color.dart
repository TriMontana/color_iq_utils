import '../color_interfaces.dart';
import 'color.dart';
import 'hsv_color.dart';
import 'dart:math';

class HsbColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double b;

  const HsbColor(this.h, this.s, this.b);

  Color toColor() {
      return HsvColor(h, s, b).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HsbColor lighten([double amount = 20]) {
    return HsbColor(h, s, min(1.0, b + amount / 100));
  }

  @override
  String toString() => 'HsbColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
