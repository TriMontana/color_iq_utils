import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';

class HctColor implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double tone;

  const HctColor(this.hue, this.chroma, this.tone);

  Color toColor() {
      return Color(mcu.Hct.from(hue, chroma, tone).toInt());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HctColor darken([double amount = 20]) {
    return HctColor(hue, chroma, max(0, tone - amount));
  }

  @override
  HctColor lighten([double amount = 20]) {
    return HctColor(hue, chroma, min(100, tone + amount));
  }

  @override
  HctColor saturate([double amount = 25]) {
    return HctColor(hue, chroma + amount, tone);
  }

  @override
  HctColor desaturate([double amount = 25]) {
    return HctColor(hue, max(0, chroma - amount), tone);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HctColor get inverted => toColor().inverted.toHct();

  @override
  HctColor get grayscale => toColor().grayscale.toHct();

  @override
  HctColor whiten([double amount = 20]) => toColor().whiten(amount).toHct();

  @override
  HctColor blacken([double amount = 20]) => toColor().blacken(amount).toHct();

  @override
  HctColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHct();

  @override
  HctColor toHct() => this;

  @override
  HctColor fromHct(HctColor hct) => hct;

  @override
  HctColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHct();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (hue >= 90 && hue < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  @override
  String toString() => 'HctColor(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, tone: ${tone.toStringAsFixed(2)})';
}
