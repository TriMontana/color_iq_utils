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
  HsbColor darken([double amount = 20]) {
    return HsbColor(h, s, max(0.0, b - amount / 100));
  }

  @override
  HsbColor lighten([double amount = 20]) {
    return HsbColor(h, s, min(1.0, b + amount / 100));
  }

  @override
  HsbColor saturate([double amount = 25]) {
    return HsbColor(h, min(1.0, s + amount / 100), b);
  }

  @override
  HsbColor desaturate([double amount = 25]) {
    return HsbColor(h, max(0.0, s - amount / 100), b);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HsbColor get inverted => toColor().inverted.toHsb();

  @override
  HsbColor get grayscale => HsbColor(h, 0.0, b);

  @override
  HsbColor whiten([double amount = 20]) => toColor().whiten(amount).toHsb();

  @override
  HsbColor blacken([double amount = 20]) => toColor().blacken(amount).toHsb();

  @override
  HsbColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsb();

  @override
  String toString() => 'HsbColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
