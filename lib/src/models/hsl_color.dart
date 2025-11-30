import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';

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
      if (h < 60) { r = c; g = x; b = 0; }
      else if (h < 120) { r = x; g = c; b = 0; }
      else if (h < 180) { r = 0; g = c; b = x; }
      else if (h < 240) { r = 0; g = x; b = c; }
      else if (h < 300) { r = x; g = 0; b = c; }
      else { r = c; g = 0; b = x; }
      
      return Color.fromARGB(255, ((r + m) * 255).round(), ((g + m) * 255).round(), ((b + m) * 255).round());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HslColor darken([double amount = 20]) {
    return HslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  HslColor lighten([double amount = 20]) {
    return HslColor(h, s, min(1.0, l + amount / 100));
  }

  @override
  String toString() => 'HslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
