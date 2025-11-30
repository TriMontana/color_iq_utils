import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'hsv_color.dart';
import 'dart:math';

class HsbColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double b;

  const HsbColor(this.h, this.s, this.b);

  Color toColor() {
      // HSB is the same as HSV, just B instead of V
      return HsvColor(h, s, b).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HsbColor darken([double amount = 20]) {
    return HsbColor(h, s, max(0.0, b - amount / 100));
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
  HsbColor get grayscale => toColor().grayscale.toHsb();

  @override
  HsbColor whiten([double amount = 20]) => toColor().whiten(amount).toHsb();

  @override
  HsbColor blacken([double amount = 20]) => toColor().blacken(amount).toHsb();

  @override
  HsbColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsb();

  @override
  HsbColor lighten([double amount = 20]) {
    return HsbColor(h, s, min(1.0, b + amount / 100));
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HsbColor fromHct(HctColor hct) => hct.toColor().toHsb();

  @override
  HsbColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsb();
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
  String toString() => 'HsbColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
