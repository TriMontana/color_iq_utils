import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';

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
  String toString() => 'CmykColor(c: ${c.toStringAsFixed(2)}, m: ${m.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';
}
