import 'dart:math';
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';


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
      final double c = saturation * v * 0.4;
      final double l = v * (1 - saturation);
      final double hRad = hue * pi / 180;
      return OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha);
  }
  
  @override
  ColorIQ toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value; 
  
  @override
  OkHsvColor darken([final double amount = 20]) {
    return OkHsvColor(hue, saturation, max(0.0, v - amount / 100), alpha);
  }

  @override
  OkHsvColor brighten([final double amount = 20]) {
    return OkHsvColor(hue, saturation, min(1.0, v + amount / 100), alpha);
  }

  @override
  OkHsvColor saturate([final double amount = 25]) {
    return OkHsvColor(hue, min(1.0, saturation + amount / 100), v, alpha);
  }

  @override
  OkHsvColor desaturate([final double amount = 25]) {
    return OkHsvColor(hue, max(0.0, saturation - amount / 100), v, alpha);
  }

  @override
  OkHsvColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toOkHsv();
  }

  @override
  OkHsvColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toOkHsv();
  }

  @override
  OkHsvColor accented([final double amount = 15]) {
    return toColor().accented(amount).toOkHsv();
  }

  @override
  OkHsvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkHsv();
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
  OkHsvColor whiten([final double amount = 20]) => toColor().whiten(amount).toOkHsv();

  @override
  OkHsvColor blacken([final double amount = 20]) => toColor().blacken(amount).toOkHsv();

  @override
  OkHsvColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toOkHsv();

  @override
  OkHsvColor lighten([final double amount = 20]) {
    return OkHsvColor(hue, saturation, min(1.0, v + amount / 100), alpha);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkHsvColor fromHct(final HctColor hct) => hct.toColor().toOkHsv();

  @override
  OkHsvColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkHsvColor copyWith({final double? hue, final double? saturation, final double? v, final double? alpha}) {
    return OkHsvColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      v ?? this.v,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkHsv();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  OkHsvColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toOkHsv();

  @override
  OkHsvColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toOkHsv();

  @override
  OkHsvColor adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toOkHsv();

  @override
  OkHsvColor get complementary => toColor().complementary.toOkHsv();

  @override
  OkHsvColor warmer([final double amount = 20]) => toColor().warmer(amount).toOkHsv();

  @override
  OkHsvColor cooler([final double amount = 20]) => toColor().cooler(amount).toOkHsv();

  @override
  List<OkHsvColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> square() => toColor().square().map((final ColorIQ c) => c.toOkHsv()).toList();

  @override
  List<OkHsvColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toOkHsv()).toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) => toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
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
