import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import '../color_interfaces.dart';
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
  String toString() => 'HctColor(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, tone: ${tone.toStringAsFixed(2)})';
}
