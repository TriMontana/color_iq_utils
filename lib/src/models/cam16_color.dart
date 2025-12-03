import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;

class Cam16Color with ColorModelsMixin implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double j;
  final double q;
  final double m;
  final double s;
  final double alpha;

  const Cam16Color(
    this.hue,
    this.chroma,
    this.j,
    this.q,
    this.m,
    this.s, [
    this.alpha = 1.0,
  ]);

  @override
  ColorIQ toColor() {
    // This is complex, usually requires viewing conditions.
    // MCU library has Cam16.
    // We can use MCU to convert back to Int.
    // But MCU Cam16 doesn't have direct toInt().
    // It has toXyzInViewingConditions.
    // For simplicity, we might convert to Hct first if possible?
    // Hct is based on Cam16.
    // Hct.from(hue, chroma, tone) -> tone is Lightness (J-like but not exactly J).
    // Let's assume we can use Hct as a bridge if J ~ Tone.
    // Or we can use the Cam16 class from MCU if we can construct it.
    // mcu.Cam16.fromJch(j, c, h);
    final mcu.Cam16 cam16 = mcu.Cam16.fromJch(j, chroma, hue);
    final int argb = cam16.toInt();
    // Restore alpha
    return ColorIQ(argb).copyWith(a: (alpha * 255).round());
  }

  @override
  int get value => toColor().value;

  mcu.Cam16 get toMcuCam16 {
    return mcu.Cam16.fromInt(value);
  }

  @override
  Cam16Color darken([final double amount = 20]) {
    return Cam16Color(hue, chroma, max(0, j - amount), q, m, s, alpha);
  }

  @override
  Cam16Color saturate([final double amount = 25]) {
    return Cam16Color(hue, chroma + amount, j, q, m, s, alpha);
  }

  @override
  Cam16Color desaturate([final double amount = 25]) {
    return Cam16Color(hue, max(0, chroma - amount), j, q, m, s, alpha);
  }

  @override
  Cam16Color intensify([final double amount = 10]) {
    return toColor().intensify(amount).toCam16Color();
  }

  @override
  Cam16Color deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toCam16Color();
  }

  @override
  Cam16Color accented([final double amount = 15]) {
    return toColor().accented(amount).toCam16Color();
  }

  @override
  Cam16Color simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toCam16Color();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  Cam16Color get inverted => toColor().inverted.toCam16Color();

  @override
  Cam16Color get grayscale => toColor().grayscale.toCam16Color();

  @override
  Cam16Color whiten([final double amount = 20]) =>
      toColor().whiten(amount).toCam16Color();

  @override
  Cam16Color blacken([final double amount = 20]) =>
      toColor().blacken(amount).toCam16Color();

  @override
  Cam16Color lerp(final ColorSpacesIQ other, final double t) =>
      (toColor().lerp(other, t) as ColorIQ).toCam16Color();

  @override
  Cam16Color lighten([final double amount = 20]) {
    return Cam16Color(hue, chroma, min(100, j + amount), q, m, s, alpha);
  }

  @override
  Cam16Color brighten([final double amount = 20]) {
    return toColor().brighten(amount).toCam16Color();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  Cam16Color fromHct(final HctColor hct) => hct.toColor().toCam16Color();

  @override
  Cam16Color adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toCam16Color();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  Cam16Color copyWith({
    final double? hue,
    final double? chroma,
    final double? j,
    final double? q,
    final double? m,
    final double? s,
    final double? alpha,
  }) {
    return Cam16Color(
      hue ?? this.hue,
      chroma ?? this.chroma,
      j ?? this.j,
      q ?? this.q,
      m ?? this.m,
      s ?? this.s,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toCam16Color())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toCam16Color())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toCam16Color())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toCam16Color();

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
  Cam16Color blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toCam16Color();

  @override
  Cam16Color opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toCam16Color();

  @override
  Cam16Color adjustHue([final double amount = 20]) {
    final double newHue = (hue + amount) % 360;
    return copyWith(hue: newHue);
  }

  @override
  Cam16Color get complementary {
    return adjustHue(180);
  }

  @override
  Cam16Color warmer([final double amount = 20]) =>
      toColor().warmer(amount).toCam16Color();

  @override
  Cam16Color cooler([final double amount = 20]) =>
      toColor().cooler(amount).toCam16Color();

  @override
  List<Cam16Color> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toCam16Color())
      .toList();

  @override
  List<Cam16Color> tonesPalette() =>
      List<double>.generate(10, (final int i) => (i + 1) * 10.0)
          .map((final double tone) => fromHct(HctColor.alt(hue, chroma, tone)))
          .toList();

  @override
  List<Cam16Color> analogous({final int count = 5, final double offset = 30}) {
    final List<Cam16Color> palette = <Cam16Color>[];
    final int half = count ~/ 2;
    for (int i = -half; i <= half; i++) {
      if (i == 0) {
        palette.add(this);
        continue;
      }
      palette.add(adjustHue(i * offset));
    }
    return palette;
  }

  @override
  List<Cam16Color> square() {
    return <Cam16Color>[this, adjustHue(90), adjustHue(180), adjustHue(270)];
  }

  @override
  List<Cam16Color> tetrad({final double offset = 60}) {
    if (offset < 0 || offset > 180) {
      throw ArgumentError.value(
        offset,
        'offset',
        'Offset must be between 0 and 180.',
      );
    }

    return <Cam16Color>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double distanceTo(final ColorSpacesIQ other) =>
      toMcuCam16.distance(mcu.Cam16.fromInt(other.value));

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => kWhitePointD65;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'Cam16Color',
      'hue': hue,
      'chroma': chroma,
      'j': j,
      'q': q,
      'm': m,
      's': s,
      'alpha': alpha,
    };
  }

  @override
  String toString() =>
      'Cam16Color(hue: ${hue.toStringAsFixed(2)}, ' //
      'chroma: ${chroma.toStringAsFixed(2)}, ' //
      'j: ${j.toStringAsFixed(2)}, ' //
      'alpha: ${alpha.toStringAsFixed(2)})';

  @override
  mcu.Cam16 toCam16() => mcu.Cam16.fromInt(value);
}
