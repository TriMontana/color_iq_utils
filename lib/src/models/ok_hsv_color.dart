import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lab_color.dart';


class OkHsvColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double v;

  const OkHsvColor(this.h, this.s, this.v);

  OkLabColor toOkLab() {
      // Reverse of OkLab.toOkHsv
      // v = l + c/0.4
      // s = (c/0.4) / v
      // -> c/0.4 = s * v
      // -> c = s * v * 0.4
      // -> l = v - c/0.4 = v - s*v = v(1-s)
      double c = s * v * 0.4;
      double l = v * (1 - s);
      double hRad = h * pi / 180;
      return OkLabColor(l, c * cos(hRad), c * sin(hRad));
  }
  
  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkHsvColor darken([double amount = 20]) {
    return OkHsvColor(h, s, max(0.0, v - amount / 100));
  }

  @override
  OkHsvColor saturate([double amount = 25]) {
    return OkHsvColor(h, min(1.0, s + amount / 100), v);
  }

  @override
  OkHsvColor desaturate([double amount = 25]) {
    return OkHsvColor(h, max(0.0, s - amount / 100), v);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkHsvColor get inverted => toColor().inverted.toOkHsv();

  @override
  OkHsvColor get grayscale => toColor().grayscale.toOkHsv();

  @override
  OkHsvColor whiten([double amount = 20]) => toColor().whiten(amount).toOkHsv();

  @override
  OkHsvColor blacken([double amount = 20]) => toColor().blacken(amount).toOkHsv();

  @override
  OkHsvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkHsv();

  @override
  OkHsvColor lighten([double amount = 20]) {
    return OkHsvColor(h, s, min(1.0, v + amount / 100));
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkHsvColor fromHct(HctColor hct) => hct.toColor().toOkHsv();

  @override
  OkHsvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  @override
  String toString() => 'OkHsvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
