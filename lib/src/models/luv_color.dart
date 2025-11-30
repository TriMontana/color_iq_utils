import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';


class LuvColor implements ColorSpacesIQ {
  final double l;
  final double u;
  final double v;

  const LuvColor(this.l, this.u, this.v);

  @override
  Color toColor() {
    double y = (l + 16) / 116;
    double x, z;
    if (l == 0) {
      x = 0;
      z = 0;
    } else {
      double u0 = 4 * 95.047 / (95.047 + 15 * 100.0 + 3 * 108.883);
      double v0 = 9 * 100.0 / (95.047 + 15 * 100.0 + 3 * 108.883);
      double a = 1 / 3 * (52 * l / (u + 13 * l * u0) - 1);
      double b = -5 * y;
      double c = -1 / 3;
      double d = y * (39 * l / (v + 13 * l * v0) - 5);
      x = (d - b) / (a - c);
      z = x * a + b;
    }

    double x3 = x * x * x;
    double y3 = y * y * y;
    double z3 = z * z * z;

    double xn = 95.047;
    double yn = 100.0;
    double zn = 108.883;

    double r = xn * ((x3 > 0.008856) ? x3 : ((x - 16 / 116) / 7.787));
    double g = yn * ((y3 > 0.008856) ? y3 : ((y - 16 / 116) / 7.787));
    double bVal = zn * ((z3 > 0.008856) ? z3 : ((z - 16 / 116) / 7.787));

    double rS = r / 100;
    double gS = g / 100;
    double bS = bVal / 100;

    double rL = rS * 3.2406 + gS * -1.5372 + bS * -0.4986;
    double gL = rS * -0.9689 + gS * 1.8758 + bS * 0.0415;
    double bL = rS * 0.0557 + gS * -0.2040 + bS * 1.0570;

    rL = (rL > 0.0031308) ? (1.055 * pow(rL, 1 / 2.4) - 0.055) : (12.92 * rL);
    gL = (gL > 0.0031308) ? (1.055 * pow(gL, 1 / 2.4) - 0.055) : (12.92 * gL);
    bL = (bL > 0.0031308) ? (1.055 * pow(bL, 1 / 2.4) - 0.055) : (12.92 * bL);

    return Color.fromARGB(255, (rL * 255).round().clamp(0, 255), (gL * 255).round().clamp(0, 255), (bL * 255).round().clamp(0, 255));
  }
  @override
  int get value => toColor().value;
  
  @override
  LuvColor darken([double amount = 20]) {
    return LuvColor(max(0, l - amount), u, v);
  }

  @override
  LuvColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toLuv();
  }

  @override
  LuvColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toLuv();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  LuvColor get inverted => toColor().inverted.toLuv();

  @override
  LuvColor get grayscale => toColor().grayscale.toLuv();

  @override
  LuvColor whiten([double amount = 20]) => toColor().whiten(amount).toLuv();

  @override
  LuvColor blacken([double amount = 20]) => toColor().blacken(amount).toLuv();

  @override
  LuvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toLuv();

  @override
  LuvColor lighten([double amount = 20]) {
    return LuvColor(min(100, l + amount), u, v);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  LuvColor fromHct(HctColor hct) => hct.toColor().toLuv();

  @override
  LuvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toLuv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LuvColor copyWith({double? l, double? u, double? v}) {
    return LuvColor(
      l ?? this.l,
      u ?? this.u,
      v ?? this.v,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toLuv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toLuv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toLuv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toLuv();

  @override
  bool isEqual(ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  String toString() => 'LuvColor(l: ${l.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
