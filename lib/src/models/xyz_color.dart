import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'lab_color.dart';
import 'luv_color.dart';

class XyzColor implements ColorSpacesIQ {
  final double x;
  final double y;
  final double z;

  const XyzColor(this.x, this.y, this.z);

  Color toColor() {
    double xTemp = x / 100;
    double yTemp = y / 100;
    double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double b = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    b = (b > 0.0031308) ? (1.055 * pow(b, 1 / 2.4) - 0.055) : (12.92 * b);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  LabColor toLab() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    double xTemp = x / refX;
    double yTemp = y / refY;
    double zTemp = z / refZ;

    xTemp = (xTemp > 0.008856) ? pow(xTemp, 1 / 3).toDouble() : (7.787 * xTemp) + (16 / 116);
    yTemp = (yTemp > 0.008856) ? pow(yTemp, 1 / 3).toDouble() : (7.787 * yTemp) + (16 / 116);
    zTemp = (zTemp > 0.008856) ? pow(zTemp, 1 / 3).toDouble() : (7.787 * zTemp) + (16 / 116);

    double l = (116 * yTemp) - 16;
    double a = 500 * (xTemp - yTemp);
    double b = 200 * (yTemp - zTemp);

    return LabColor(l, a, b);
  }

  LuvColor toLuv() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    double u = (4 * x) / (x + (15 * y) + (3 * z));
    double v = (9 * y) / (x + (15 * y) + (3 * z));

    double yTemp = y / 100.0;
    yTemp = (yTemp > 0.008856) ? pow(yTemp, 1 / 3).toDouble() : (7.787 * yTemp) + (16 / 116);

    double l = (116 * yTemp) - 16;
    double uOut = 13 * l * (u - refU);
    double vOut = 13 * l * (v - refV);
    
    if (x + 15 * y + 3 * z == 0) {
      uOut = 0;
      vOut = 0;
    }

    return LuvColor(l, uOut, vOut);
  }
  
  @override
  XyzColor lighten([double amount = 20]) {
    return toLab().lighten(amount).toXyz();
  }

  @override
  String toString() => 'XyzColor(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';
}
