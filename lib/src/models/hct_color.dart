import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

class HctColor implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double tone;

  const HctColor(this.hue, this.chroma, this.tone);

  @override
  ColorIQ toColor() {
    final int argb = mcu.Hct.from(hue, chroma, tone).toInt();
    return ColorIQ(argb);
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HctColor darken([final double amount = 20]) {
    return HctColor(hue, chroma, max(0, tone - amount));
  }

  @override
  HctColor brighten([final double amount = 20]) {
    return HctColor(hue, chroma, min(100, tone + amount));
  }

  @override
  HctColor lighten([final double amount = 20]) {
    return HctColor(hue, chroma, min(100, tone + amount));
  }

  @override
  HctColor saturate([final double amount = 25]) {
    return HctColor(hue, chroma + amount, tone);
  }

  @override
  HctColor desaturate([final double amount = 25]) {
    return HctColor(hue, max(0, chroma - amount), tone);
  }

  @override
  HctColor intensify([final double amount = 10]) {
    return HctColor(hue, chroma + amount, max(0, tone - (amount / 2)));
  }

  @override
  HctColor deintensify([final double amount = 10]) {
    return HctColor(hue, max(0, chroma - amount), min(100, tone + (amount / 2)));
  }

  @override
  HctColor accented([final double amount = 15]) {
    // Increase chroma and tone to make it pop.
    return HctColor(hue, chroma + amount, min(100, tone + (amount / 2)));
  }

  @override
  HctColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHct();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HctColor get inverted => toColor().inverted.toHct();

  @override
  HctColor get grayscale => toColor().grayscale.toHct();

  @override
  HctColor whiten([final double amount = 20]) => toColor().whiten(amount).toHct();

  @override
  HctColor blacken([final double amount = 20]) => toColor().blacken(amount).toHct();

  @override
  HctColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toHct();

  @override
  HctColor toHct() => this;

  @override
  HctColor fromHct(final HctColor hct) => hct;

  @override
  HctColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHct();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (hue >= 90 && hue < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HctColor copyWith({final double? hue, final double? chroma, final double? tone}) {
    return HctColor(
      hue ?? this.hue,
      chroma ?? this.chroma,
      tone ?? this.tone,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    final List<HctColor> results = <HctColor>[];
    for (int i = 0; i < 5; i++) {
        final double delta = (i - 2) * 10.0;
        final double newTone = (tone + delta).clamp(0.0, 100.0);
        results.add(HctColor(hue, chroma, newTone));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHct())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHct())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHct();

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
  HctColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toHct();

  @override
  HctColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toHct();

  @override
  HctColor adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toHct();

  @override
  HctColor get complementary => toColor().complementary.toHct();

  @override
  HctColor warmer([final double amount = 20]) => toColor().warmer(amount).toHct();

  @override
  HctColor cooler([final double amount = 20]) => toColor().cooler(amount).toHct();

  @override
  List<HctColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toHct()).toList();

  @override
  List<HctColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toHct()).toList();

  @override
  List<HctColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toHct()).toList();

  @override
  List<HctColor> square() => toColor().square().map((final ColorIQ c) => c.toHct()).toList();

  @override
  List<HctColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toHct()).toList();

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
      'type': 'HctColor',
      'hue': hue,
      'chroma': chroma,
      'tone': tone,
    };
  }

  @override
  String toString() => 'HctColor(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, tone: ${tone.toStringAsFixed(2)})';
}
