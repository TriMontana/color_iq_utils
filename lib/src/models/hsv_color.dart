import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';

class HsvColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double v;

  const HsvColor(this.h, this.s, this.v);

  Color toColor() {
      double c = v * s;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = v - c;
      
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
  HsvColor lighten([double amount = 20]) {
    return HsvColor(h, s, min(1.0, v + amount / 100));
  }

  @override
  String toString() => 'HsvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
