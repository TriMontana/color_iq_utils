import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class Cam16Color implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double j;
  final double q;
  final double m;
  final double s;

  const Cam16Color(this.hue, this.chroma, this.j, this.q, this.m, this.s);

  Color toColor() {
      // This is complex, usually requires viewing conditions.
      // MCU library has Cam16.
      // We can use MCU to convert back to Int.
      // But MCU Cam16 doesn't have direct toInt().
      // It has toXyzInViewingConditions.
      // For simplicity, we might convert to Hct first if possible?
      // Hct is based on Cam16.
      // Hct.from(hue, chroma, tone) -> tone is Lightness (J-like but not exactly J).
      // Let's assume we can use Hct as a bridge if J ~ Tone.
      // Or we can use the Cam16 class from MCU if we can construct it.
      // mcu.Cam16.fromJch(j, c, h);
      final cam16 = mcu.Cam16.fromJch(j, chroma, hue);
      final int argb = cam16.toInt();
      return Color(argb);
  }
  
  @override
  int get value => toColor().value;
  
  @override
  Cam16Color darken([double amount = 20]) {
    return Cam16Color(hue, chroma, max(0, j - amount), q, m, s);
  }

  @override
  Cam16Color saturate([double amount = 25]) {
    return Cam16Color(hue, chroma + amount, j, q, m, s);
  }

  @override
  Cam16Color desaturate([double amount = 25]) {
    return Cam16Color(hue, max(0, chroma - amount), j, q, m, s);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  Cam16Color get inverted => toColor().inverted.toCam16();

  @override
  Cam16Color get grayscale => toColor().grayscale.toCam16();

  @override
  Cam16Color whiten([double amount = 20]) => toColor().whiten(amount).toCam16();

  @override
  Cam16Color blacken([double amount = 20]) => toColor().blacken(amount).toCam16();

  @override
  Cam16Color lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toCam16();

  @override
  Cam16Color lighten([double amount = 20]) {
    return Cam16Color(hue, chroma, min(100, j + amount), q, m, s);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  Cam16Color fromHct(HctColor hct) => hct.toColor().toCam16();

  @override
  Cam16Color adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toCam16();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  @override
  String toString() => 'Cam16Color(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, j: ${j.toStringAsFixed(2)})';
}
