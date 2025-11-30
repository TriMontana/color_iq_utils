import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lab_color.dart';

class OkLchColor implements ColorSpacesIQ {
  final double l;
  final double c;
  final double h;

  const OkLchColor(this.l, this.c, this.h);

  OkLabColor toOkLab() {
    double hRad = h * pi / 180;
    return OkLabColor(l, c * cos(hRad), c * sin(hRad));
  }
  
  @override
  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkLchColor darken([double amount = 20]) {
    return OkLchColor(max(0.0, l - amount / 100), c, h);
  }

  @override
  OkLchColor saturate([double amount = 25]) {
    return OkLchColor(l, c + amount / 100, h);
  }

  @override
  OkLchColor desaturate([double amount = 25]) {
    return OkLchColor(l, max(0.0, c - amount / 100), h);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkLchColor get inverted => toColor().inverted.toOkLch();

  @override
  OkLchColor get grayscale => toColor().grayscale.toOkLch();

  @override
  OkLchColor whiten([double amount = 20]) => toColor().whiten(amount).toOkLch();

  @override
  OkLchColor blacken([double amount = 20]) => toColor().blacken(amount).toOkLch();

  @override
  OkLchColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkLch();

  @override
  OkLchColor lighten([double amount = 20]) {
    return OkLchColor(min(1.0, l + amount / 100), c, h);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkLchColor fromHct(HctColor hct) => hct.toColor().toOkLch();

  @override
  OkLchColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkLch();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkLchColor copyWith({double? l, double? c, double? h}) {
    return OkLchColor(
      l ?? this.l,
      c ?? this.c,
      h ?? this.h,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toOkLch()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toOkLch())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toOkLch())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toOkLch();

  @override
  bool isEqual(ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  String toString() => 'OkLchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
