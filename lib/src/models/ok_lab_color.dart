import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';
import 'ok_lch_color.dart';
import 'ok_hsl_color.dart';
import 'ok_hsv_color.dart';

class OkLabColor implements ColorSpacesIQ {
  final double l;
  final double a;
  final double b;

  const OkLabColor(this.l, this.a, this.b);

  Color toColor() {
    double l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    double m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    double s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    double l3 = l_ * l_ * l_;
    double m3 = m_ * m_ * m_;
    double s3 = s_ * s_ * s_;

    double r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    double g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    double bVal = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308) ? (1.055 * pow(bVal, 1 / 2.4) - 0.055) : (12.92 * bVal);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (bVal * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  OkLchColor toOkLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi;
    if (h < 0) h += 360;
    return OkLchColor(l, c, h);
  }
  
  OkHslColor toOkHsl() {
      OkLchColor lch = toOkLch();
      double s = (lch.l == 0 || lch.l == 1) ? 0 : lch.c / 0.4; 
      if (s > 1) s = 1;
      return OkHslColor(lch.h, s, lch.l);
  }
  
  OkHsvColor toOkHsv() {
      OkLchColor lch = toOkLch();
      double v = lch.l + lch.c / 0.4;
      if (v > 1) v = 1;
      double s = (v == 0) ? 0 : (lch.c / 0.4) / v;
      if (s > 1) s = 1;
      return OkHsvColor(lch.h, s, v);
  }

  @override
  OkLabColor darken([double amount = 20]) {
    return OkLabColor(max(0.0, l - amount / 100), a, b);
  }

  @override
  OkLabColor lighten([double amount = 20]) {
    return OkLabColor(min(1.0, l + amount / 100), a, b);
  }

  @override
  String toString() => 'OkLabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
