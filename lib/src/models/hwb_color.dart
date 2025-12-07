import 'dart:math';
import 'dart:math' as math;

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
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
/// This class provides methods to convert HWB colors to other color spaces,
/// perform color manipulations (like darkening, saturating), and generate color palettes.
class HwbColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The whiteness component of the color, ranging from 0.0 to 1.0.
  final double w;

  /// The blackness component of the color, ranging from 0.0 to 1.0.
  final double blackness;

  /// The alpha (transparency) component of the color, ranging from 0.0 to 1.0.
  Percent get alpha => super.a;

  HwbColor(this.h, this.w, this.blackness,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String>? names})
      : super.alt(hexId ?? HwbColor.hexIdFromHWB(h, w, blackness, alpha),
            a: alpha,
            names: names ??
                names ??
                <String>[
                  ColorNames.generateDefaultNameFromInt(
                      hexId ?? HwbColor.hexIdFromHWB(h, w, blackness, alpha))
                ]);

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

    return HsvColor(h, s, Percent(v), alpha: alpha).value;
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
    final double s = (v == 0) ? 0 : 1 - wNorm / v;

    return HsvColor(h, s, Percent(v), alpha: alpha).toColor();
  }

  @override
  HwbColor darken([final double amount = 20]) {
    return copyWith(b: (blackness + amount / 100).clamp(0.0, 1.0));
  }

  @override
  HwbColor brighten([final double amount = 20]) {
    return copyWith(b: (blackness - amount / 100).clamp(0.0, 1.0));
  }

  @override
  HwbColor saturate([final double amount = 25]) {
    // Saturation in HWB is 1 - w - b.
    // To saturate, we decrease w and b.
    // Let's scale them down.
    final double scale = 1.0 - (amount / 100.0);
    return HwbColor(h, w * scale, blackness * scale, alpha: alpha);
  }

  @override
  HwbColor desaturate([final double amount = 25]) {
    // To desaturate, we move towards gray.
    // Gray has w + b = 1.
    // We can lerp towards a gray version of this color.
    // A simple gray version preserves lightness.
    // For HWB, middle gray is 0.5, 0.5.
    // Or we can just increase w and b?
    // Let's use lerp to a grayscale target.
    // Ideally we'd find the grayscale color with same lightness.
    // But for simplicity and standard behavior, let's lerp to a neutral gray
    // or just increase w and b.
    // Let's try increasing w and b to fill the gap to 1.0.
    final double gap = 1.0 - w - b;
    if (gap <= 0) return this;

    final double add = gap * (amount / 100.0) * 0.5;
    return HwbColor(h, w + add, blackness + add, alpha: alpha);
  }

  @override
  HwbColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
  HwbColor deintensify([final double amount = 10]) {
    return desaturate(amount);
  }

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

  @override
  HctColor toHctColor() => toColor().toHctColor();

  @override
  HwbColor fromHct(final HctColor hct) => HwbColor.fromInt(hct.toInt());

  @override
  HwbColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHwb();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (h >= 90 && h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HwbColor copyWith({
    final double? h,
    final double? whiteness,
    final double? b,
    final Percent? alpha,
  }) {
    return HwbColor(h ?? this.h, whiteness ?? w, b ?? blackness,
        alpha: alpha ?? super.a);
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
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HwbColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHwb();

  @override
  HwbColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHwb();

  @override
  HwbColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toHwb();

  @override
  HwbColor get complementary => toColor().complementary.toHwb();

  @override
  HwbColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHwb();

  @override
  HwbColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHwb();

  @override
  List<HwbColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHwb())
      .toList();

  @override
  List<HwbColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHwb()).toList();

  @override
  List<HwbColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHwb())
          .toList();

  @override
  List<HwbColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHwb()).toList();

  @override
  List<HwbColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHwb())
      .toList();

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
      'blackness': b,
      'alpha': alpha,
    };
  }

  @override
  String toString() =>
      'HwbColor(h: ${h.toStrTrimZeros(3)}, w: ${w.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
