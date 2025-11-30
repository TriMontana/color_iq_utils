import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'ok_lab_color.dart';


class OkHsvColor implements ColorSpacesIQ {
  final double hue;
  final double saturation;
  final double v; // Renamed from value to v to avoid conflict with ColorSpacesIQ.value
  final double alpha;

  const OkHsvColor(this.hue, this.saturation, this.v, [this.alpha = 1.0]);

  OkLabColor toOkLab() {
      // Reverse of OkLab.toOkHsv
      // v = l + c/0.4
      // s = (c/0.4) / v
      // -> c/0.4 = s * v
      // -> c = s * v * 0.4
      // -> l = v - c/0.4 = v - s*v = v(1-s)
      double c = saturation * v * 0.4;
      double l = v * (1 - saturation);
      double hRad = hue * pi / 180;
      return OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha);
  }
  
  @override
  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value; 
  
  @override
  OkHsvColor darken([double amount = 20]) {
    return OkHsvColor(hue, saturation, max(0.0, v - amount / 100), alpha);
  }

  @override
  OkHsvColor saturate([double amount = 25]) {
    return OkHsvColor(hue, min(1.0, saturation + amount / 100), v, alpha);
  }

  @override
  OkHsvColor desaturate([double amount = 25]) {
    return OkHsvColor(hue, max(0.0, saturation - amount / 100), v, alpha);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkHsvColor get inverted => toColor().inverted.toOkHsv();

  @override
  OkHsvColor get grayscale => toColor().grayscale.toOkHsv();

  @override
  OkHsvColor whiten([double amount = 20]) => toColor().whiten(amount).toOkHsv();

  @override
  OkHsvColor blacken([double amount = 20]) => toColor().blacken(amount).toOkHsv();

  @override
  OkHsvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toOkHsv();

  @override
  OkHsvColor lighten([double amount = 20]) {
    return OkHsvColor(hue, saturation, min(1.0, v + amount / 100), alpha);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkHsvColor fromHct(HctColor hct) => hct.toColor().toOkHsv();

  @override
  OkHsvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkHsvColor copyWith({double? hue, double? saturation, double? v, double? alpha}) {
    return OkHsvColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      v ?? this.v,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toOkHsv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toOkHsv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toOkHsv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toOkHsv();

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
  OkHsvColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toOkHsv();

  @override
  OkHsvColor opaquer([double amount = 20]) => toColor().opaquer(amount).toOkHsv();

  @override
  OkHsvColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toOkHsv();

  @override
  OkHsvColor get complementary => toColor().complementary.toOkHsv();

  @override
  OkHsvColor warmer([double amount = 20]) => toColor().warmer(amount).toOkHsv();

  @override
  OkHsvColor cooler([double amount = 20]) => toColor().cooler(amount).toOkHsv();

  @override
  List<OkHsvColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> square() => toColor().square().map((c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toOkHsv()).toList();

  @override
  double distanceTo(ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) => toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'OkHsvColor',
      'hue': hue,
      'saturation': saturation,
      'value': v,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkHsvColor(h: ${hue.toStringAsFixed(2)}, s: ${saturation.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
