import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:material_color_utilities/hct/src/hct_solver.dart';

/// HCT, hue, chroma, and tone. A color system that provides a perceptually
/// accurate color measurement system that can also accurately render what
/// colors will appear as in different lighting environments.
/// credit: Adapted from material_color_utilities
class HctColor implements ColorSpacesIQ {
  late final double hue;
  late final double chroma;
  late final double tone;
  late final int argb;

  /// 0 <= [hue] < 360; invalid values are corrected.
  /// 0 <= [chroma] <= ?; Informally, colorfulness. The color returned may be
  ///    lower than the requested chroma. Chroma has a different maximum for any
  ///    given hue and tone.
  /// 0 <= [tone] <= 100; informally, lightness. Invalid values are corrected.
  /// credit: Adapted from material_color_utilities
  static HctColor from(
    final double hue,
    final double chroma,
    final double tone,
  ) {
    final int argb = HctSolver.solveToInt(hue, chroma, tone);
    return HctColor(hue, chroma, tone, argb);
  }

  /// Primary constructor.
  /// credit: Adapted from material_color_utilities
  HctColor(this.hue, this.chroma, this.tone, this.argb)
    : assert(tone >= kMinTone && tone <= kMaxTone, 'Invalid Tone: $tone'),
      assert(
        chroma >= kMinChroma && chroma <= kMaxChroma,
        'Invalid Chroma: $chroma',
      ),
      assert(hue >= 0.0 && hue < kMaxTone, 'Invalid Hue: $hue');

  factory HctColor.alt(
    final double hue,
    final double chroma,
    final double tone, {
    final int? argb,
  }) {
    assert(tone >= kMinTone && tone <= kMaxTone, 'Invalid Tone: $tone');
    assert(
      chroma >= kMinChroma && chroma <= kMaxChroma,
      'Invalid Chroma: $chroma',
    );
    assert(hue >= 0.0 && hue < kMaxTone, 'Invalid Hue: $hue');
    return HctColor(
      hue,
      chroma,
      tone,
      argb ?? HctSolver.solveToInt(hue, chroma, tone),
    );
  }

  @override
  ColorIQ toColor() => ColorIQ(argb);

  @override
  int get value => argb;

  @override
  HctColor darken([final double amount = 20]) {
    amount.assertRange0to100('darken');
    final double nuTone = max(kMinTone, tone - amount);
    final int argb = HctSolver.solveToInt(hue, chroma, nuTone);
    return HctColor(hue, chroma, nuTone, argb);
  }

  /// Increases the [tone] of this color by the given [amount].
  /// The resulting color will be brighter.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 20.
  @override
  HctColor brighten([final double amount = 20]) {
    amount.assertRange0to100('brighten');
    final double nuTone = min(kMaxTone, tone + amount);
    final int argb = HctSolver.solveToInt(hue, chroma, nuTone);
    return HctColor(hue, chroma, nuTone, argb);
  }

  @override
  HctColor lighten([final double amount = 20]) {
    amount.assertRange0to100('lighten');
    final double nuTone = min(kMaxTone, tone + amount);
    final int argb = HctSolver.solveToInt(hue, chroma, nuTone);
    return HctColor(hue, chroma, nuTone, argb);
  }

  @override
  HctColor saturate([final double amount = 25]) {
    amount.assertRange0to100('saturate');
    final double nuChroma = min(kMaxChroma, chroma + amount);
    final int argb = HctSolver.solveToInt(hue, nuChroma, tone);
    return HctColor(hue, nuChroma, tone, argb);
  }

  /// Decreases the [chroma] of this color by the given [amount].
  /// The resulting color will be less saturated.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 25.
  @override
  HctColor desaturate([final double amount = 25]) {
    amount.assertRange0to100('desaturate');
    final double nuChroma = max(kMinChroma, chroma - amount);
    final int argb = HctSolver.solveToInt(hue, nuChroma, tone);
    return HctColor(hue, nuChroma, tone, argb);
  }

  @override
  HctColor intensify([final double amount = 10]) {
    amount.assertRange0to100('intensify');
    final double nuChroma = min(kMaxChroma, chroma + amount);
    final double nuTone = max(kMinTone, tone - (amount / 2));
    final int argb = HctSolver.solveToInt(hue, nuChroma, nuTone);
    return HctColor(hue, nuChroma, nuTone, argb);
  }

  /// Decreases the [chroma] of this color by the given [amount] and increases
  /// the [tone] by half of the [amount]. This makes the color less intense
  /// and lighter.
  ///
  /// The resulting color will be less intense and slightly lighter.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 10.
  @override
  HctColor deintensify([final double amount = 10]) {
    amount.assertRange0to100('deintensify');
    final double nuChroma = max(kMinChroma, chroma - amount);
    final double nuTone = min(kMaxTone, tone + (amount / 2));
    final int argb = HctSolver.solveToInt(hue, nuChroma, nuTone);
    return HctColor(hue, nuChroma, nuTone, argb);
  }

  /// Increases the [chroma] of this color by the given [amount] and the
  /// [tone] by half of the [amount]. This makes the color more vibrant and
  /// slightly lighter, making it "pop".
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 15.
  @override
  HctColor accented([final double amount = 15]) {
    amount.assertRange0to100('accented');
    final double nuChroma = min(kMaxChroma, chroma + amount);
    final double nuTone = min(kMaxTone, tone + (amount / 2));
    final int argb = HctSolver.solveToInt(hue, nuChroma, nuTone);
    return HctColor(hue, nuChroma, nuTone, argb);
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
  HctColor whiten([final double amount = 20]) =>
      toColor().whiten(amount).toHct();

  @override
  HctColor blacken([final double amount = 20]) =>
      toColor().blacken(amount).toHct();

  @override
  HctColor lerp(final ColorSpacesIQ other, final double t) {
    final HctColor otherHct = other.toHct();
    final double newHue = lerpHue(hue, otherHct.hue, t);
    final double newChroma = (chroma + (otherHct.chroma - chroma) * t);
    final double newTone = (tone + (otherHct.tone - tone) * t);
    return HctColor.from(newHue, newChroma, newTone);
  }

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
  HctColor copyWith({
    final double? hue,
    final double? chroma,
    final double? tone,
  }) {
    return HctColor(hue ?? this.hue, chroma ?? this.chroma, tone ?? this.tone);
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
  HctColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHct();

  @override
  HctColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHct();

  @override
  HctColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toHct();

  @override
  HctColor get complementary => toColor().complementary.toHct();

  @override
  HctColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHct();

  @override
  HctColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHct();

  @override
  List<HctColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHct())
      .toList();

  @override
  List<HctColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHct()).toList();

  @override
  List<HctColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHct())
          .toList();

  @override
  List<HctColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHct()).toList();

  @override
  List<HctColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHct())
      .toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

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
  String toString() =>
      'HctColor(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, tone: ${tone.toStringAsFixed(2)})';
}
