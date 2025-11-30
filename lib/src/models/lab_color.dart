import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'xyz_color.dart';
import 'lch_color.dart';

class LabColor implements ColorSpacesIQ {
  final double l;
  final double a;
  final double b;

  const LabColor(this.l, this.a, this.b);

  XyzColor toXyz() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    double yTemp = (l + 16) / 116;
    double xTemp = a / 500 + yTemp;
    double zTemp = yTemp - b / 200;

    double x3 = pow(xTemp, 3).toDouble();
    double y3 = pow(yTemp, 3).toDouble();
    double z3 = pow(zTemp, 3).toDouble();

    double xOut = (x3 > 0.008856) ? x3 : (xTemp - 16 / 116) / 7.787;
    double yOut = (y3 > 0.008856) ? y3 : (yTemp - 16 / 116) / 7.787;
    double zOut = (z3 > 0.008856) ? z3 : (zTemp - 16 / 116) / 7.787;

    return XyzColor(xOut * refX, yOut * refY, zOut * refZ);
  }

  Color toColor() => toXyz().toColor();
  
  @override
  int get value => toColor().value;

  LchColor toLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi;
    if (h < 0) h += 360;
    return LchColor(l, c, h);
  }
  
  @override
  LabColor lighten([double amount = 20]) {
    return LabColor(min(100, l + amount), a, b);
  }

  @override
  LabColor darken([double amount = 20]) {
    return LabColor(max(0, l - amount), a, b);
  }

  @override
  String toString() => 'LabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
