import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class HslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const HslColor(this.h, this.s, this.l);

  Color toColor() {
      double c = (1 - (2 * l - 1).abs()) * s;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = l - c / 2;
      
      double r = 0, g = 0, b = 0;
      if (h < 60) {
          r = c; g = x; b = 0;
      } else if (h < 120) {
          r = x; g = c; b = 0;
      } else if (h < 180) {
          r = 0; g = c; b = x;
      } else if (h < 240) {
          r = 0; g = x; b = c;
      } else if (h < 300) {
          r = x; g = 0; b = c;
      } else {
          r = c; g = 0; b = x;
      }
      
      return Color.fromARGB(255, ((r + m) * 255).round().clamp(0, 255), ((g + m) * 255).round().clamp(0, 255), ((b + m) * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HslColor darken([double amount = 20]) {
    return HslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  HslColor saturate([double amount = 25]) {
    return HslColor(h, min(1.0, s + amount / 100), l);
  }

  @override
  HslColor desaturate([double amount = 25]) {
    return HslColor(h, max(0.0, s - amount / 100), l);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HslColor get inverted => toColor().inverted.toHsl();

  @override
  HslColor get grayscale => toColor().grayscale.toHsl();

  @override
  HslColor whiten([double amount = 20]) => toColor().whiten(amount).toHsl();

  @override
  HslColor blacken([double amount = 20]) => toColor().blacken(amount).toHsl();

  @override
  HslColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsl();

  @override
  HslColor lighten([double amount = 20]) {
    return HslColor(h, s, min(1.0, l + amount / 100));
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HslColor fromHct(HctColor hct) => hct.toColor().toHsl();

  @override
  HslColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsl();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (h >= 90 && h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  @override
  String toString() => 'HslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
