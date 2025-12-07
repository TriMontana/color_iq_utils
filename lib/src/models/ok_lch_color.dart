import 'dart:math';
import 'dart:math' as math;

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';

/// A color model that represents colors in the Oklch color space.
///
/// Oklch is a cylindrical representation of the Oklab color space, designed to
/// be perceptually uniform. It's particularly useful for creating color palettes
/// and for color manipulations like changing lightness or chroma while
/// preserving the perceived hue.
///
/// [l] is the perceived lightness (0-1).
/// [c] is the chroma (distance from the neutral axis, similar to saturation).
/// [h] is the hue angle (0-360).
/// [alpha] is the transparency (0-1).
class OkLCH extends ColorSpacesIQ with ColorModelsMixin {
  final Percent l;
  final double c;
  final double h;
  final Percent alpha;

  OkLCH(this.l, this.c, this.h,
      {this.alpha = Percent.max, final int? hexId, final List<String>? names})
      : assert(l >= 0 && l <= 1, 'L must be between 0 and 1'),
        assert(c >= 0, 'C must be non-negative'),
        assert(h >= 0 && h <= 360, 'H must be between 0 and 360'),
        super.alt(hexId ?? toHexID(l, c, h, alpha: alpha),
            a: alpha, names: names ?? const <String>[]);

  /// Creates a 32-bit ARGB hex value from Oklch values.
  ///
  /// This is a stand-alone static method that converts Oklch color
  /// components directly to an integer representation of an ARGB color.
  static int toHexID(final Percent l, final double c, final double h,
      {final Percent alpha = Percent.max}) {
    final double hRad = h * pi / 180;
    final OkLabColor okLab =
        OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha: alpha);
    return okLab.value;
  }

  /// Converts a 32-bit ARGB color ID to OkLCH components.
  static OkLCH fromInt(final int argb32) {
    final LinRGB lr = argb32.redLinearized;
    final LinRGB lg = argb32.greenLinearized;
    final LinRGB lb = argb32.blueLinearized;

    final LmsPrime lmsPrime = linearRgbToLmsPrime(lr, lg, lb);

    // 4. Convert L' M' S' to Oklab (L, a, b)
    // Oklab Matrix
    final double oklabL = 0.2104542553 * lmsPrime.lPrime +
        0.7936177850 * lmsPrime.mPrime -
        0.0040720468 * lmsPrime.sPrime;
    final double oklabA = 1.9779984951 * lmsPrime.lPrime -
        2.4285922050 * lmsPrime.mPrime +
        0.4505937102 * lmsPrime.sPrime;
    final double oklabB = 0.0259040371 * lmsPrime.lPrime +
        0.7827717662 * lmsPrime.mPrime -
        0.8086757660 * lmsPrime.sPrime;

    // 5. Convert Oklab (L, a, b) to OkLCH (L, C, H)
    // L is Lightness [0, 1].
    // C is Chroma (Euclidean distance from origin).
    final double c = math.sqrt(oklabA * oklabA + oklabB * oklabB);

    // H is Hue angle (using atan2 for correct quadrant)
    double h = math.atan2(oklabB, oklabA) * 180.0 / math.pi;

    // Normalize Hue to the range [0.0, 360.0)
    if (h < 0) {
      h += 360.0;
    }

    return OkLCH(Percent(oklabL.clamp(0.0, 1.0)), c, h,
        alpha: argb32.a2, hexId: argb32);
  }

  @override
  OkLabColor toOkLab() {
    final double hRad = h * pi / 180;
    return OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha: alpha);
  }

  @override
  OkLCH darken([final double amount = 20]) {
    final double x = max(0.0, l.value - amount / 100);
    return copyWith(l: Percent(x));
  }

  @override
  OkLCH get inverted => toColor().inverted.toOkLch();

  @override
  OkLCH get grayscale => OkLCH(l, 0.0, h, alpha: alpha);

  @override
  OkLCH whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  OkLCH blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  OkLCH lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final OkLCH otherOkLch = other is OkLCH ? other : other.toColor().toOkLch();
    if (t == 1.0) return otherOkLch;

    double newHue = h;
    final double thisC = c;
    final double otherC = otherOkLch.c;

    // Handle achromatic hues (if chroma is near zero, preserve the other hue)
    // White has C ~ 0.0, but let's use a safe threshold.
    const double kAchromaticThreshold = 0.02;
    if (thisC < kAchromaticThreshold && otherC > kAchromaticThreshold) {
      newHue = otherOkLch.h;
    } else if (otherC < kAchromaticThreshold && thisC > kAchromaticThreshold) {
      newHue = h;
    } else if (thisC < kAchromaticThreshold && otherC < kAchromaticThreshold) {
      newHue = h;
    } else {
      return OkLCH(
        l.lerpTo(otherOkLch.l, t),
        lerpDouble(c, otherOkLch.c, t),
        lerpHue(h, otherOkLch.h, t),
      );
    }

    return OkLCH(
      l.lerpTo(otherOkLch.l, t),
      lerpDouble(c, otherOkLch.c, t),
      newHue,
    );
  }

  @override
  OkLCH lighten([final double amount = 20]) {
    final double x = min(1.0, l.value + amount / 100);
    return copyWith(l: Percent(x));
  }

  @override
  OkLCH brighten([final double amount = 20]) {
    return toColor().brighten(amount).toOkLch();
  }

  @override
  OkLCH saturate([final double amount = 25]) {
    return OkLCH(l, c + amount / 100, h, alpha: alpha);
  }

  @override
  OkLCH desaturate([final double amount = 25]) {
    return OkLCH(l, max(0.0, c - amount / 100), h, alpha: alpha);
  }

  @override
  OkLCH intensify([final double amount = 10]) {
    return toColor().intensify(amount).toOkLch();
  }

  @override
  OkLCH deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toOkLch();
  }

  @override
  OkLCH accented([final double amount = 15]) {
    return toColor().accented(amount).toOkLch();
  }

  @override
  OkLCH simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkLch();
  }

  @override
  OkLCH fromHct(final HctColor hct) => hct.toColor().toOkLch();

  @override
  OkLCH adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkLch();
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkLCH copyWith({
    final Percent? l,
    final double? c,
    final double? h,
    final Percent? alpha,
  }) {
    return OkLCH(
      l ?? this.l,
      c ?? this.c,
      h ?? this.h,
      alpha: alpha ?? super.a,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLch())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLch())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLch())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkLch();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  OkLCH blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toOkLch();

  @override
  OkLCH opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toOkLch();

  @override
  OkLCH adjustHue([final double amount = 20]) {
    return OkLCH(l, c, (h + amount) % 360, alpha: alpha);
  }

  @override
  OkLCH get complementary => adjustHue(180);

  @override
  OkLCH warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    return OkLCH(l, c, lerpHue(h, targetHue, amount / 100), alpha: alpha);
  }

  @override
  OkLCH cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    return OkLCH(l, c, lerpHue(h, targetHue, amount / 100), alpha: alpha);
  }

  @override
  List<OkLCH> generateBasicPalette() {
    return <OkLCH>[
      this,
      complementary,
      adjustHue(120),
      adjustHue(240),
    ];
  }

  @override
  List<OkLCH> tonesPalette() {
    return <OkLCH>[
      OkLCH(const Percent(0.95), c, h, alpha: alpha), // 50
      OkLCH(const Percent(0.9), c, h, alpha: alpha), // 100
      OkLCH(const Percent(0.8), c, h, alpha: alpha), // 200
      OkLCH(const Percent(0.7), c, h, alpha: alpha), // 300
      OkLCH(const Percent(0.6), c, h, alpha: alpha), // 400
      OkLCH(const Percent(0.5), c, h, alpha: alpha), // 500
      OkLCH(const Percent(0.4), c, h, alpha: alpha), // 600
      OkLCH(const Percent(0.3), c, h, alpha: alpha), // 700
      OkLCH(const Percent(0.2), c, h, alpha: alpha), // 800
      OkLCH(const Percent(0.1), c, h, alpha: alpha), // 900
    ];
  }

  @override
  List<OkLCH> analogous({final int count = 5, final double offset = 30}) {
    final List<OkLCH> palette = <OkLCH>[];
    final double startHue = h - ((count - 1) / 2) * offset;
    for (int i = 0; i < count; i++) {
      palette.add(OkLCH(l, c, (startHue + i * offset) % 360, alpha: alpha));
    }
    return palette;
  }

  @override
  List<OkLCH> square() {
    return <OkLCH>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<OkLCH> tetrad({final double offset = 60}) {
    return <OkLCH>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'OkLchColor',
      'l': l,
      'c': c,
      'h': h,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkLchColor(l: ${l.toStrTrimZeros(3)}, ' //
      'c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
