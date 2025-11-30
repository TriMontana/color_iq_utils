import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
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
  HwbColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toHwb();
  }

  @override
  HwbColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toHwb();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HwbColor get inverted => toColor().inverted.toHwb();

  @override
  HwbColor get grayscale => toColor().grayscale.toHwb();

  @override
  HwbColor whiten([double amount = 20]) => toColor().whiten(amount).toHwb();

  @override
  HwbColor blacken([double amount = 20]) => toColor().blacken(amount).toHwb();

  @override
  HwbColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHwb();

  @override
  HwbColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toHwb();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HwbColor fromHct(HctColor hct) => hct.toColor().toHwb();

  @override
  HwbColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHwb();
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
  String toString() => 'HwbColor(h: ${h.toStringAsFixed(2)}, w: ${w.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
