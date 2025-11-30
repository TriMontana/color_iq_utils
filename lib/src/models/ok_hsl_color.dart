import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lab_color.dart';


class OkHslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const OkHslColor(this.h, this.s, this.l);

  OkLabColor toOkLab() {
      // Approximate conversion via OkLch
      // s is roughly c/0.4 for s=1.
      double c = s * 0.4;
      // l is l.
      // h is h.
      // This is a simplification as OkHSL is more complex, but for now we use this approximation or delegate if we had a proper conversion.
      // Actually, let's use the reverse of what we did in OkLab.toOkHsl
      // s = (l==0 or l==1) ? 0 : c/0.4.
      // So c = s * 0.4.
      // This is only valid if we assume the max chroma is 0.4 which is an approximation for sRGB gamut in Oklab.
      double hRad = h * pi / 180;
      return OkLabColor(l, c * cos(hRad), c * sin(hRad));
  }
  
  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkHslColor darken([double amount = 20]) {
    return OkHslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  OkHslColor saturate([double amount = 25]) {
    return OkHslColor(h, min(1.0, s + amount / 100), l);
  }

  @override
  OkHslColor desaturate([double amount = 25]) {
    return OkHslColor(h, max(0.0, s - amount / 100), l);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkHslColor get inverted => toColor().inverted.toOkHsl();

  @override
  OkHslColor get grayscale => toColor().grayscale.toOkHsl();

  @override
  OkHslColor whiten([double amount = 20]) => toColor().whiten(amount).toOkHsl();

  @override
  OkHslColor blacken([double amount = 20]) => toColor().blacken(amount).toOkHsl();

  @override
  OkHslColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkHsl();

  @override
  OkHslColor lighten([double amount = 20]) {
    return OkHslColor(h, s, min(1.0, l + amount / 100));
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkHslColor fromHct(HctColor hct) => hct.toColor().toOkHsl();

  @override
  OkHslColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsl();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  @override
  String toString() => 'OkHslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
