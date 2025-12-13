import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/hct/src/hct_solver.dart';
import 'package:material_color_utilities/utils/color_utils.dart';

/// HCT, hue, chroma, and tone. A color system that provides a perceptually
/// accurate color measurement system that can also accurately render what
/// colors will appear as in different lighting environments.
/// credit: Adapted from material_color_utilities
/// See also [HctData]
@Deprecated('Use Hct Data')
class HctColor extends CommonIQ implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double tone;

  /// 0 <= [hue] < 360; invalid values are corrected.
  /// 0 <= [chroma] <= ?; Informally, colorfulness. The color returned may be
  ///    lower than the requested chroma. Chroma has a different maximum for any
  ///    given hue and tone.
  /// 0 <= [tone] <= 100; informally, lightness. Invalid values are corrected.
  /// credit: Adapted from material_color_utilities
  static HctColor from(
    final double hue,
    final double chroma,
    final double tone, {
    int? argb,
    final List<String> names = kEmptyNames,
  }) {
    argb ??= HctSolver.solveToInt(hue, chroma, tone);
    return HctColor(hue, chroma, tone, argb: argb, names: names);
  }

  @override
  int get value => super.colorId ?? HctSolver.solveToInt(hue, chroma, tone);

  /// Primary constructor.
  /// credit: Adapted from material_color_utilities
  const HctColor(this.hue, this.chroma, this.tone,
      {final int? argb,
      final Percent alpha = Percent.max,
      final List<String> names = kEmptyNames})
      : super(argb, alpha: alpha, names: names);

  factory HctColor.fromInt(
    final int argb, {
    final double? h,
    final double? c,
    final double? t,
    final List<String>? names,
  }) {
    final Cam16 cam16 = Cam16.fromInt(argb);
    final double hue = h?.assertRangeHue('fromInt') ?? cam16.hue;
    final double chroma = c?.assertRangeChroma('fromInt') ?? cam16.chroma;
    final double tone =
        t?.assertRange0to100('fromInt') ?? ColorUtils.lstarFromArgb(argb);
    return HctColor(hue, chroma, tone, argb: argb, names: names ?? kEmptyNames);
  }

  /// Secondary constructor.
  /// credit: Adapted from material_color_utilities
  factory HctColor.alt(
    final double h,
    final double c,
    final double t, {
    final int? argb,
    final List<String>? names,
  }) {
    final double hue = h.assertRangeHue('HctColor.alt');
    final double chroma = c.assertRangeChroma('HctColor.alt');
    final double tone = t.assertRange0to100('HctColor.alt');
    final int hexID = argb ?? HctSolver.solveToInt(hue, chroma, tone);

    return HctColor(hue, chroma, tone,
        argb: hexID, names: names ?? const <String>[]);
  }

  HctColor withChroma(final double nuChroma, {final List<String>? names}) =>
      HctColor(hue, nuChroma, tone, argb: value, names: names ?? kEmptyNames);

  /// Converts this HCT color to a [CMYK].
  CMYK toCMYK() => CMYK.fromInt(value);

  /// Returns the ARGB integer representation of this color.
  int toInt() => value;

  /// Decreases the [tone] of this color by the given [amount].
  /// The resulting color will be darker.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 20.
  @override
  HctColor darken([final double amount = 20]) {
    amount.assertRange0to100('darken');
    final double nuTone = max(kMinTone, tone - amount);
    final int hexID = HctSolver.solveToInt(hue, chroma, nuTone);
    return HctColor(hue, chroma, nuTone, argb: hexID);
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
    final int hexID = HctSolver.solveToInt(hue, chroma, nuTone);
    return HctColor(hue, chroma, nuTone, argb: hexID);
  }

  /// Increases the [tone] of this color by the given [amount].
  /// The resulting color will be lighter.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 20.
  @override
  HctColor lighten([final double amount = 20]) {
    amount.assertRange0to100('lighten');
    final double nuTone = min(kMaxTone, tone + amount);
    final int hexID = HctSolver.solveToInt(hue, chroma, nuTone);
    return HctColor(hue, chroma, nuTone, argb: hexID);
  }

  /// Increases the [chroma] of this color by the given [amount].
  /// The resulting color will be more saturated.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 25.
  @override
  HctColor saturate([final double amount = 25]) {
    amount.assertRange0to100('saturate');
    final double nuChroma = min(kMaxChroma, chroma + amount);
    final int hexID = HctSolver.solveToInt(hue, nuChroma, tone);
    return HctColor(hue, nuChroma, tone, argb: hexID);
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
    final int hexID = HctSolver.solveToInt(hue, nuChroma, tone);
    return HctColor(hue, nuChroma, tone, argb: hexID);
  }

  HctColor intensify([final double amount = 10]) {
    amount.assertRange0to100('intensify');
    final double nuChroma = min(kMaxChroma, chroma + amount);
    final double nuTone = max(kMinTone, tone - (amount / 2));
    final int hexID = HctSolver.solveToInt(hue, nuChroma, nuTone);
    return HctColor(hue, nuChroma, nuTone, argb: hexID);
  }

  /// Decreases the [chroma] of this color by the given [amount] and increases
  /// the [tone] by half of the [amount]. This makes the color less intense
  /// and lighter.
  ///
  /// The resulting color will be less intense and slightly lighter.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 10.
  HctColor deintensify([final double amount = 10]) {
    amount.assertRange0to100('deintensify');
    final double nuChroma = max(kMinChroma, chroma - amount);
    final double nuTone = min(kMaxTone, tone + (amount / 2));
    final int hexID = HctSolver.solveToInt(hue, nuChroma, nuTone);
    return HctColor(hue, nuChroma, nuTone, argb: hexID);
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
    final int hexID = HctSolver.solveToInt(hue, nuChroma, nuTone);
    return HctColor(hue, nuChroma, nuTone, argb: hexID);
  }

  @override
  HctColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHctColor();
  }

  @Deprecated('Use Hct Data')
  HctColor get grayscale => HctColor(hue, 0, tone, argb: value);

  @override
  HctColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HctColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HctColor lerp(final ColorSpacesIQ other, final double t) {
    final HctColor otherHct = other.toHctColor();
    final double newHue = lerpHue(hue, otherHct.hue, t);
    final double newChroma =
        (chroma + (otherHct.chroma - chroma) * t).clampChromaHct;
    final double newTone = (tone + (otherHct.tone - tone) * t).clampToneHct;
    final int hexID = HctSolver.solveToInt(newHue, newChroma, newTone);
    return HctColor(newHue, newChroma, newTone, argb: hexID);
  }

  @override
  HctColor toHctColor() => this;

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  HctColor copyWith({
    final double? hue,
    final double? chroma,
    final double? tone,
    final int? argb,
  }) {
    final double nuHue = hue ?? this.hue;
    final double nuChroma = chroma ?? this.chroma;
    final double nuTone = tone ?? this.tone;
    final int nuArgb = argb ?? HctSolver.solveToInt(nuHue, nuChroma, nuTone);

    return HctColor.alt(
      nuHue,
      nuChroma,
      nuTone,
      argb: nuArgb,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    final List<HctColor> results = <HctColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 10.0;
      final double newTone = (tone + delta).clampToneHct;
      results.add(HctColor.alt(hue, chroma, newTone));
    }
    return results;
  }

  @override
  List<HctColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <HctColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<HctColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <HctColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  HctColor get random {
    final Random rng = Random();
    return HctColor.alt(
      rng.nextDouble() * 360.0,
      rng.nextDouble() * 150.0,
      rng.nextDouble() * 100.0,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is HctColor) {
      const double epsilon = 0.001;
      return (hue - other.hue).abs() < epsilon &&
          (chroma - other.chroma).abs() < epsilon &&
          (tone - other.tone).abs() < epsilon &&
          (alpha.val - other.alpha.val).abs() < epsilon;
    }
    return false;
  }

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HctColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HctColor opaquer([final double amount = 20]) {
    return this;
  }

  @override
  HctColor adjustHue([final double amount = 20]) {
    return copyWith(hue: (hue + amount) % 360);
  }

  @override
  HctColor get complementary => flipHue();

  /// Returns a new color with the hue rotated by 180 degrees.
  HctColor flipHue() {
    final double newHue = (hue + 180) % 360;
    return copyWith(hue: newHue);
  }

  @override
  HctColor warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    final double delta = ((targetHue - hue + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return copyWith(hue: (hue + shift) % 360);
  }

  @override
  HctColor cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    final double delta = ((targetHue - hue + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return copyWith(hue: (hue + shift) % 360);
  }

  @override
  List<HctColor> generateBasicPalette() => <HctColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<HctColor> tonesPalette() => List<HctColor>.generate(
        6,
        (final int index) =>
            copyWith(tone: (index / 5 * 100).clamp(0.0, 100.0)),
      );

  @override
  List<HctColor> analogous({final int count = 5, final double offset = 30}) {
    final List<HctColor> results = <HctColor>[];
    final double step = (offset * 2) / (count - 1);
    final double startHue = (hue - offset + 360) % 360;

    for (int i = 0; i < count; i++) {
      final double h = (startHue + step * i) % 360;
      results.add(copyWith(hue: h));
    }

    return results;
  }

  @override
  List<HctColor> square() {
    final double hue2 = (hue + 90) % 360;
    final double hue3 = (hue + 180) % 360;
    final double hue4 = (hue + 270) % 360;

    return <HctColor>[
      this,
      copyWith(hue: hue2),
      copyWith(hue: hue3),
      copyWith(hue: hue4),
    ];
  }

  @override
  List<HctColor> tetrad({final double offset = 60}) {
    final double hue2 = (hue + offset) % 360;
    final double hue3 = (hue + 180) % 360;
    final double hue4 = (hue2 + 180) % 360;
    return <HctColor>[
      this,
      copyWith(hue: hue2),
      copyWith(hue: hue3),
      copyWith(hue: hue4),
    ];
  }

  @override
  List<HctColor> split({final double offset = 30}) => <HctColor>[
        this,
        copyWith(hue: (hue + 180 - offset) % 360),
        copyWith(hue: (hue + 180 + offset) % 360),
      ];

  @override
  List<HctColor> triad({final double offset = 120}) => <HctColor>[
        this,
        copyWith(hue: (hue + offset) % 360),
        copyWith(hue: (hue - offset + 360) % 360),
      ];

  @override
  List<HctColor> twoTone({final double offset = 60}) => <HctColor>[
        this,
        copyWith(hue: (hue + offset) % 360),
      ];

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

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
  String toString() => 'HctColor(hue: ${hue.toStrTrimZeros(3)}, ' //
      'chroma: ${chroma.toStrTrimZeros(3)}, tone: ${tone.toStrTrimZeros(3)})';
}
