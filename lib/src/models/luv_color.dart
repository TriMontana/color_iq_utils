import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'xyz_color.dart';

class LuvColor implements ColorSpacesIQ {
  final double l;
  final double u;
  final double v;

  const LuvColor(this.l, this.u, this.v);


  XyzColor toXyz() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;
    
    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    double yOut = (l + 16) / 116;
    if (pow(yOut, 3) > 0.008856) {
      yOut = pow(yOut, 3).toDouble();
    } else {
      yOut = (yOut - 16 / 116) / 7.787;
    }

    double uTemp = u / (13 * l) + refU;
    double vTemp = v / (13 * l) + refV;
    
    if (l == 0) {
        uTemp = 0;
        vTemp = 0;
    }

    double yFinal = yOut * 100;
    double xFinal = -(9 * yFinal * uTemp) / ((uTemp - 4) * vTemp - uTemp * vTemp);
    double zFinal = (9 * yFinal - (15 * vTemp * yFinal) - (vTemp * xFinal)) / (3 * vTemp);

    return XyzColor(xFinal, yFinal, zFinal);
  }
  
  Color toColor() => toXyz().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  LuvColor lighten([double amount = 20]) {
    return LuvColor(min(100, l + amount), u, v);
  }

  @override
  String toString() => 'LuvColor(l: ${l.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
