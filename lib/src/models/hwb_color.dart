import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';

/// A representation of color in the HWB (Hue, Whiteness, Blackness) color model.
///
/// HWB is designed to be more intuitive for humans to understand. It's a cylindrical
/// representation of the RGB color model, similar to HSL and HSV.
///
/// - **Hue (h):** The type of color, represented as an angle from 0 to 360 degrees.
///   0 is red, 120 is green, 240 is blue.
/// - **Whiteness (w):** The amount of white mixed with the hue, from 0 to 1 (or 0% to 100%).
/// - **Blackness (b):** The amount of black mixed with the hue, from 0 to 1 (or 0% to 100%).
///
/// One constraint of the HWB model is that the sum of whiteness and blackness
/// cannot exceed 1 (or 100%). If `w + b > 1`, the values are normalized.
///
/// This class provides methods to ops HWB colors to other color spaces,
/// perform color manipulations (like darkening, saturating), and generate color palettes.
class HwbColor extends CommonIQ implements ColorSpacesIQ {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The whiteness component of the color, ranging from 0.0 to 1.0.
  final double w;

  /// The blackness component of the color, ranging from 0.0 to 1.0.
  final double blackness;

  const HwbColor(
    this.h,
    this.w,
    this.blackness, {
    final int? hexId,
    final List<String> names = kEmptyNames,
    final Percent alpha = Percent.max,
  }) : super(hexId, names: names, alpha: alpha);

  @override
  int get value => super.colorId ?? HwbColor.hexIdFromHWB(h, w, blackness);

  /// Creates a 32-bit hex ID (ARGB) from HWB values.
  ///
  /// This is a utility method for creating a color value directly from HWB
  /// components without instantiating an `HwbColor` object.
  static int hexIdFromHWB(
    final double h,
    final double w,
    final double b, [
    final Percent alpha = Percent.max,
  ]) {
    // This is an inline conversion, avoiding creating intermediate color objects.
    // It mirrors the logic in toColor() -> Hsv.toColor() -> Rgb.toColor().
    double wNorm = w;
    double bNorm = b;
    final double ratio = w + b;
    if (ratio > 1) {
      wNorm /= ratio;
      bNorm /= ratio;
    }

    final double v = 1 - bNorm;
    final double s = (v == 0) ? 0 : 1 - wNorm / v;

    return HSV(Hue(h), Percent(s), Percent(v), a: alpha).hexId;
  }

// /// Represents a color in the HWB color space.
// class HWB {
//   /// Hue (0.0 to 360.0)
//   final double h;
//   /// Whiteness (0.0 to 1.0)
//   final double w;
//   /// Blackness (0.0 to 1.0)
//   final double b;
//   HWB(this.h, this.w, this.b);
// }

  /// Converts a 32-bit ARGB color ID to HWB components (Hue, Whiteness, Blackness).
  ///
  /// @param argb32 The 32-bit integer color ID (e.g., 0xFFRRGGBB).
  /// @returns An HWB object.
  static HwbColor fromInt(final int argb32) {
    // final Color color = Color(argb32);

    // Normalize R, G, B to the range [0.0, 1.0]
    final double r = argb32.r;
    final double g = argb32.g;
    final double b = argb32.b;

    // Find the maximum (M) and minimum (m) components
    final double max = math.max(r, math.max(g, b));
    final double min = math.min(r, math.min(g, b));

    final double delta = max - min;

    // --- 1. Calculate Blackness (B) and Whiteness (W) ---

    // Blackness (B): The amount of black added, proportional to the minimum component.
    // B = 1 - max(R, G, B)
    final double blackness = 1.0 - max;

    // Whiteness (W): The amount of white added, proportional to the minimum component.
    // W = min(R, G, B)
    final double whiteness = min;

    // --- 2. Calculate Hue (H) ---

    double hue;

    if (delta == 0.0) {
      // Achromatic (Gray-scale): Hue is undefined, usually 0 or 360.
      hue = 0.0;
    } else if (max == r) {
      // Red is the largest component
      hue = (g - b) / delta;
    } else if (max == g) {
      // Green is the largest component
      hue = 2.0 + (b - r) / delta;
    } else {
      // max == b
      // Blue is the largest component
      hue = 4.0 + (r - g) / delta;
    }

    // Convert H from [0, 6) to degrees [0, 360)
    hue *= 60.0;
    if (hue < 0.0) {
      hue += 360.0;
    }

    // --- 3. Final Clamping and Normalization ---

    // HWB requires W + B + C_pure <= 1.0, where C_pure = 1 - W - B = delta
    // Since we derived W and B from min and max, W + B + delta == 1 is guaranteed.

    return HwbColor(
      hue.clamp(0.0, 360.0),
      whiteness.clamp(0.0, 1.0),
      blackness.clamp(0.0, 1.0),
      hexId: argb32,
    );
  }

  @override
  ColorIQ toColor() {
    final double ratio = w + b;
    double wNorm = w;
    double bNorm = b;
    if (ratio > 1) {
      wNorm /= ratio;
      bNorm /= ratio;
    }

    final double v = 1 - bNorm;
    final Percent s =
        Percent(((v == 0) ? 0 : 1 - wNorm / v).clamp(0.0, 1.0).toDouble());

    return HSV(Hue(h), s, Percent(v), a: a).toColor();
  }

  @override
  HwbColor darken([final double amount = 20]) =>
      copyWith(b: (blackness + amount / 100).clamp(0.0, 1.0));

  @override
  HwbColor brighten([final Percent amount = Percent.v20]) =>
      copyWith(b: max(0.0, blackness - amount));

  @override
  HwbColor saturate([final double amount = 25]) {
    // Saturation in HWB is 1 - w - b.
    // To saturate, we decrease w and b.
    // Let's scale them down.
    final double scale = 1.0 - (amount / 100.0);
    return copyWith(whiteness: w * scale, b: blackness * scale);
  }

  @override
  HwbColor desaturate([final double amount = 25]) {
    // To desaturate, we move towards gray.

    final double gap = 1.0 - w - b;
    if (gap <= 0) {
      return this;
    }

    final double add = gap * (amount / 100.0) * 0.5;
    return copyWith(whiteness: w + add, b: blackness + add);
  }

  HwbColor intensify([final double amount = 10]) => saturate(amount);

  HwbColor deintensify([final double amount = 10]) => desaturate(amount);

  @override
  HwbColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  HwbColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHwb();
  }

  @override
  HwbColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HwbColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HwbColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HwbColor otherHwb =
        other is HwbColor ? other : other.toColor().toHwb();
    if (t == 1.0) {
      return otherHwb;
    }

    return HwbColor(
      lerpHue(h, otherHwb.h, t),
      lerpDouble(w, otherHwb.w, t),
      lerpDouble(blackness, otherHwb.blackness, t),
    );
  }

  @override
  HwbColor lighten([final double amount = 20]) {
    return toColor().lighten(amount).toHwb();
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  HwbColor copyWith({
    final double? h,
    final double? whiteness,
    final double? b,
    final Percent? alpha,
  }) {
    final double nuHue = h ?? this.h;
    final double nuWhiteness = whiteness ?? w;
    final double nuBlackness = b ?? this.b;
    final Percent nuAlpha = alpha ?? a;
    final int newColorID =
        HwbColor.hexIdFromHWB(nuHue, nuWhiteness, nuBlackness, nuAlpha);
    return HwbColor(h ?? this.h, whiteness ?? w, b ?? blackness,
        hexId: newColorID, alpha: alpha ?? super.a);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => <ColorSpacesIQ>[
        blacken(20),
        blacken(10),
        this,
        whiten(10),
        whiten(20),
      ];

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <ColorSpacesIQ>[
      whiten(s),
      whiten(s * 2),
      whiten(s * 3),
      whiten(s * 4),
      whiten(s * 5),
    ];
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <ColorSpacesIQ>[
      blacken(s),
      blacken(s * 2),
      blacken(s * 3),
      blacken(s * 4),
      blacken(s * 5),
    ];
  }

  @override
  ColorSpacesIQ get random {
    final Random rng = Random();
    final double h = rng.nextDouble() * 360;
    final double w = rng.nextDouble();
    // b must be <= 1 - w to be valid HWB, but constructor handles normalization if needed.
    // However, generating valid HWB is better.
    final double b = rng.nextDouble() * (1.0 - w);
    return HwbColor(h, w, b);
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is! HwbColor) {
      return value == other.value;
    }
    const double epsilon = 0.001;
    return (h - other.h).abs() < epsilon &&
        (w - other.w).abs() < epsilon &&
        (blackness - other.blackness).abs() < epsilon &&
        (alpha.val - other.alpha.val).abs() < epsilon;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HwbColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HwbColor opaquer([final double amount = 20]) {
    final double newAlpha = min(1.0, alpha.val + amount / 100);
    return copyWith(alpha: Percent(newAlpha));
  }

  @override
  HwbColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return copyWith(h: newHue);
  }

  @override
  HwbColor get complementary => adjustHue(180);

  @override
  HwbColor warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return copyWith(h: newHue);
  }

  @override
  HwbColor cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return copyWith(h: newHue);
  }

  @override
  List<HwbColor> generateBasicPalette() {
    return <HwbColor>[
      whiten(40),
      whiten(20),
      this,
      blacken(20),
      blacken(40),
    ];
  }

  @override
  List<HwbColor> tonesPalette() {
    // Mix with gray (h, 0.5, 0.5)
    final HwbColor gray = HwbColor(h, 0.5, 0.5);
    return <HwbColor>[
      this,
      lerp(gray, 0.15),
      lerp(gray, 0.30),
      lerp(gray, 0.45),
      lerp(gray, 0.60),
    ];
  }

  @override
  List<HwbColor> analogous({final int count = 5, final double offset = 30}) {
    final List<HwbColor> palette = <HwbColor>[];
    final double startHue = h - ((count - 1) / 2) * offset;
    for (int i = 0; i < count; i++) {
      double newHue = (startHue + i * offset) % 360;
      if (newHue < 0) newHue += 360;
      palette.add(copyWith(h: newHue));
    }
    return palette;
  }

  @override
  List<HwbColor> square() {
    return <HwbColor>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<HwbColor> tetrad({final double offset = 60}) {
    return <HwbColor>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HwbColor',
      'hue': h,
      'whiteness': w,
      'blackness': blackness,
      'alpha': alpha,
    };
  }

  @override
  String toString() =>
      'HwbColor(h: ${h.toStrTrimZeros(3)}, w: ${w.toStringAsFixed(2)}, b: ${blackness.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
