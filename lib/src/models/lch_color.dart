import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/lab_color.dart';

class LchColor implements ColorSpacesIQ {
  final double l;
  final double c;
  final double h;

  const LchColor(this.l, this.c, this.h);

  LabColor toLab() {
    final double hRad = h * pi / 180;
    final double a = c * cos(hRad);
    final double b = c * sin(hRad);
    return LabColor(l, a, b);
  }

  @override
  ColorIQ toColor() => toLab().toColor();

  @override
  LchColor saturate([final double amount = 25]) {
    return LchColor(l, c + amount, h);
  }

  @override
  LchColor desaturate([final double amount = 25]) {
    return LchColor(l, max(0, c - amount), h);
  }

  @override
  LchColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toLch();
  }

  @override
  LchColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toLch();
  }

  @override
  LchColor accented([final double amount = 15]) {
    return toColor().accented(amount).toLch();
  }

  @override
  LchColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toLch();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  LchColor get inverted => toColor().inverted.toLch();

  @override
  LchColor get grayscale => toColor().grayscale.toLch();

  @override
  LchColor whiten([final double amount = 20]) =>
      toColor().whiten(amount).toLch();

  @override
  LchColor blacken([final double amount = 20]) =>
      toColor().blacken(amount).toLch();

  @override
  LchColor lerp(final ColorSpacesIQ other, final double t) =>
      (toColor().lerp(other, t) as ColorIQ).toLch();

  @override
  int get value => toColor().value;

  @override
  LchColor darken([final double amount = 20]) {
    return LchColor(max(0.0, l - amount), c, h);
  }

  @override
  LchColor lighten([final double amount = 20]) {
    return LchColor(min(100.0, l + amount), c, h);
  }

  @override
  LchColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toLch();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  LchColor fromHct(final HctColor hct) => hct.toColor().toLch();

  @override
  LchColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toLch();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LchColor copyWith({final double? l, final double? c, final double? h}) {
    return LchColor(l ?? this.l, c ?? this.c, h ?? this.h);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toLch())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toLch())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toLch())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toLch();

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
  LchColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toLch();

  @override
  LchColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toLch();

  @override
  LchColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toLch();

  @override
  LchColor get complementary => toColor().complementary.toLch();

  @override
  LchColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toLch();

  @override
  LchColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toLch();

  @override
  List<LchColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toLch())
      .toList();

  @override
  List<LchColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toLch()).toList();

  @override
  List<LchColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toLch())
          .toList();

  @override
  List<LchColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toLch()).toList();

  @override
  List<LchColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toLch())
      .toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      return toLab().isWithinGamut(gamut);
    }
    return true;
  }

  @override
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'LchColor', 'l': l, 'c': c, 'h': h};
  }

  @override
  String toString() =>
      'LchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
