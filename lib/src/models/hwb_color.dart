import '../color_interfaces.dart';
import 'color.dart';
import 'hsv_color.dart';

class HwbColor implements ColorSpacesIQ {
  final double h;
  final double w;
  final double b;

  const HwbColor(this.h, this.w, this.b);

  Color toColor() {
      double ratio = w + b;
      double wNorm = w;
      double bNorm = b;
      if (ratio > 1) {
          wNorm /= ratio;
          bNorm /= ratio;
      }
      
      double v = 1 - bNorm;
      double s = (v == 0) ? 0 : 1 - wNorm / v;
      
      return HsvColor(h, s, v).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HwbColor darken([double amount = 20]) {
    return toColor().darken(amount).toHwb();
  }

  @override
  HwbColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toHwb();
  }

  @override
  String toString() => 'HwbColor(h: ${h.toStringAsFixed(2)}, w: ${w.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
