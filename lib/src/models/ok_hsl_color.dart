import 'dart:math';
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';


class OkHslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const OkHslColor(this.h, this.s, this.l);

  @override
  ColorIQ toColor() {
      // Approximate conversion via OkLch
      // s is roughly c/0.4 for s=1.
      // l is roughly L.
      
      final double L = l;
      final double C = s * 0.4; // Approximation
      final double hue = h;
      
      return OkLchColor(L, C, hue).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  OkHslColor darken([final double amount = 20]) {
    return OkHslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkHslColor get inverted => toColor().inverted.toOkHsl();

  @override
  OkHslColor get grayscale => toColor().grayscale.toOkHsl();

  @override
  OkHslColor whiten([final double amount = 20]) => toColor().whiten(amount).toOkHsl();

  @override
  OkHslColor blacken([final double amount = 20]) => toColor().blacken(amount).toOkHsl();

  @override
  OkHslColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toOkHsl();

  @override
  OkHslColor lighten([final double amount = 20]) {
    return OkHslColor(h, s, min(1.0, l + amount / 100));
  }

  @override
  OkHslColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toOkHsl();
  }

  @override
  OkHslColor saturate([final double amount = 25]) {
    return OkHslColor(h, min(1.0, s + amount / 100), l);
  }

  @override
  OkHslColor desaturate([final double amount = 25]) {
    return OkHslColor(h, max(0.0, s - amount / 100), l);
  }

  @override
  OkHslColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toOkHsl();
  }

  @override
  OkHslColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toOkHsl();
  }

  @override
  OkHslColor accented([final double amount = 15]) {
    return toColor().accented(amount).toOkHsl();
  }

  @override
  OkHslColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkHsl();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkHslColor fromHct(final HctColor hct) => hct.toColor().toOkHsl();

  @override
  OkHslColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsl();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkHslColor copyWith({final double? h, final double? s, final double? l}) {
    return OkHslColor(
      h ?? this.h,
      s ?? this.s,
      l ?? this.l,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsl()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsl())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsl())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkHsl();

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
  OkHslColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toOkHsl();

  @override
  OkHslColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toOkHsl();

  @override
  OkHslColor adjustHue([final double amount = 20]) {
      double newHue = (h + amount) % 360;
      if (newHue < 0) newHue += 360;
      return OkHslColor(newHue, s, l);
  }

  @override
  OkHslColor get complementary => adjustHue(180);

  @override
  OkHslColor warmer([final double amount = 20]) => toColor().warmer(amount).toOkHsl();

  @override
  OkHslColor cooler([final double amount = 20]) => toColor().cooler(amount).toOkHsl();

  @override
  List<OkHslColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> square() => toColor().square().map((final ColorIQ c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toOkHsl()).toList();

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
      'type': 'OkHslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': transparency,
    };
  }

  @override
  String toString() => 'OkHslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
