import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';

class HunterLabColor implements ColorSpacesIQ {
  final double l;
  final double a;
  final double b;

  const HunterLabColor(this.l, this.a, this.b);

  Color toColor() {
    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    double y = pow(l / 100.0, 2) * yn;
    double x = (a / 175.0 * (l / 100.0) + y / yn) * xn;
    double z = (y / yn - b / 70.0 * (l / 100.0)) * zn;

    double xTemp = x / 100;
    double yTemp = y / 100;
    double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double bVal = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308) ? (1.055 * pow(bVal, 1 / 2.4) - 0.055) : (12.92 * bVal);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (bVal * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HunterLabColor darken([double amount = 20]) {
    return HunterLabColor(max(0, l - amount), a, b);
  }

  @override
  HunterLabColor lighten([double amount = 20]) {
    return HunterLabColor(min(100, l + amount), a, b);
  }

  @override
  String toString() => 'HunterLabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
