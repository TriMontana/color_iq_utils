import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

import 'luv_color.dart';

class HsluvColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const HsluvColor(this.h, this.s, this.l);

  LuvColor toLuv() {
    // TODO: Implement proper HSLuv to Luv conversion.
    // For now returning a grayscale Luv color based on Lightness.
    return LuvColor(l, 0, 0);
  }

  @override
  Color toColor() => toLuv().toColor();
  
  @override
  int get value => toColor().value;

  @override
  HsluvColor darken([double amount = 20]) {
    return HsluvColor(h, s, max(0, l - amount));
  }

  @override
  HsluvColor saturate([double amount = 25]) {
    return HsluvColor(h, min(100, s + amount), l);
  }

  @override
  HsluvColor desaturate([double amount = 25]) {
    return HsluvColor(h, max(0, s - amount), l);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HsluvColor get inverted => toColor().inverted.toHsluv();

  @override
  HsluvColor get grayscale => toColor().grayscale.toHsluv();

  @override
  HsluvColor whiten([double amount = 20]) => toColor().whiten(amount).toHsluv();

  @override
  HsluvColor blacken([double amount = 20]) => toColor().blacken(amount).toHsluv();

  @override
  HsluvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsluv();

  @override
  HsluvColor lighten([double amount = 20]) {
    return HsluvColor(h, s, min(100, l + amount));
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HsluvColor fromHct(HctColor hct) => hct.toColor().toHsluv();

  @override
  HsluvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsluv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  HsluvColor copyWith({double? h, double? s, double? l}) {
    return HsluvColor(
      h ?? this.h,
      s ?? this.s,
      l ?? this.l,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toHsluv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toHsluv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toHsluv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toHsluv();

  @override
  bool isEqual(ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HsluvColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHsluv();

  @override
  HsluvColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHsluv();

  @override
  HsluvColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHsluv();

  @override
  HsluvColor get complementary => toColor().complementary.toHsluv();

  @override
  HsluvColor warmer([double amount = 20]) => toColor().warmer(amount).toHsluv();

  @override
  HsluvColor cooler([double amount = 20]) => toColor().cooler(amount).toHsluv();

  @override
  List<HsluvColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHsluv()).toList();

  @override
  List<HsluvColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHsluv()).toList();

  @override
  List<HsluvColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHsluv()).toList();

  @override
  List<HsluvColor> square() => toColor().square().map((c) => c.toHsluv()).toList();

  @override
  List<HsluvColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHsluv()).toList();

  @override
  String toString() => 'HsluvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
