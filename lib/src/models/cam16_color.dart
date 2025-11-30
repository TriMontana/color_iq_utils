import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import '../color_interfaces.dart';
import 'color.dart';

class Cam16Color implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double j;
  final double m;
  final double s;
  final double q;

  const Cam16Color(this.hue, this.chroma, this.j, this.m, this.s, this.q);

  Color toColor() {
      return Color(mcu.Cam16.fromJch(j, chroma, hue).toInt());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  Cam16Color lighten([double amount = 20]) {
    return Cam16Color(hue, chroma, min(100, j + amount), m, s, q);
  }

  @override
  String toString() => 'Cam16Color(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, j: ${j.toStringAsFixed(2)})';
}
