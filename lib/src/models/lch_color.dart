import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/lab_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';

/// A representation of a color in the CIE L*C*h° color space.
///
/// L*C*h° is a cylindrical representation of the CIE L*a*b* color space.
/// It is designed to be more perceptually uniform and intuitive than other color models.
///
/// - **L (Lightness):** Represents the lightness of the color, ranging from 0 (black) to 100 (white).
/// - **C (Chroma):** Represents the saturation or "purity" of the color. A value of 0 is grayscale,
///   and higher values indicate a more vivid color.
/// - **h (Hue):** Represents the hue angle, ranging from 0 to 360 degrees.
///
/// This class provides methods to ops to and from other color spaces,
/// perform color manipulations, and generate color palettes.
class LchColor extends CommonIQ implements ColorSpacesIQ {
  /// The lightness component of the color (0-100).
  final double l;

  /// The chroma (saturation) component of the color.
  final double c;

  /// The hue component of the color in degrees (0-360).
  final double h;

  const LchColor(
    this.l,
    this.c,
    this.h, {
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? LchColor.hexIdFromLCH(l, c, h);

  /// Converts CIELCH components to a 32-bit ARGB integer (Color ID).
  /// This implementation relies on the standard CIELab/CIEXYZ transformations.
  /// @param l Lightness (0 to 100)
  /// @param c Chroma (0 to ~134)
  /// @param h Hue (0.0 to 360.0)
  /// @param alpha Alpha value (0 to 255)
  static int hexIdFromLCH(
    final double l,
    final double c,
    final double h, [
    final Percent alpha = Percent.max,
  ]) {
    // 1. LCH to Lab Conversion
    final double hRad = h * math.pi / 180.0;
    final double a = c * math.cos(hRad);
    final double b = c * math.sin(hRad);

    // 2. Lab to XYZ (Requires complex matrix inversion and power functions)
    final XYZ xyz = labToXYZ(l, a, b); //

    // 3. XYZ to sRGB (Requires complex matrix and gamma correction)
    final (:int red, :int green, :int blue) = xyzToRgb(xyz.x, xyz.y, xyz.z); //

    final int alphaInt = alpha.toInt0to255;

    // 4. Combine into 32-bit ARGB integer
    // ARGB is (Alpha << 24) | (Red << 16) | (Green << 8) | (Blue)
    return (alphaInt << 24) | (red << 16) | (green << 8) | blue;
  }

  CIELab toLab() {
    final double hRad = h * pi / 180;
    final double a = c * cos(hRad);
    final double b = c * sin(hRad);
    return CIELab(l, a, b);
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
  LchColor accented([final double amount = 15]) {
    return toColor().accented(amount).toLch();
  }

  @override
  LchColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toLch();
  }

  @override
  LchColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  LchColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  LchColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;

    final LchColor otherLch =
        (other is LchColor) ? other : other.toColor().toLch();

    if (t == 1.0) return otherLch;

    double newHue = h;
    final double thisC = c;
    final double otherC = otherLch.c;

    // Handle achromatic hues (if chroma is near zero, preserve the other hue)
    // White has C ~ 0.011, so we need a higher threshold than 1e-4.
    const double kAchromaticThreshold = 0.05;
    if (thisC < kAchromaticThreshold && otherC > kAchromaticThreshold) {
      newHue = otherLch.h;
    } else if (otherC < kAchromaticThreshold && thisC > kAchromaticThreshold) {
      newHue = h;
    } else if (thisC < kAchromaticThreshold && otherC < kAchromaticThreshold) {
      newHue = h; // Both achromatic, keep current or 0
    } else {
      // Shortest path interpolation for hue
      final double diff = otherLch.h - h;
      if (diff.abs() <= 180) {
        newHue += diff * t;
      } else {
        if (diff > 0) {
          newHue += (diff - 360) * t;
        } else {
          newHue += (diff + 360) * t;
        }
      }
    }

    newHue %= 360;
    if (newHue < 0) newHue += 360;

    return LchColor(
      l + (otherLch.l - l) * t,
      thisC + (otherC - thisC) * t,
      newHue,
    );
  }

  @override
  LchColor darken([final double amount = 20]) {
    return LchColor(max(0.0, l - amount), c, h);
  }

  @override
  LchColor lighten([final double amount = 20]) {
    return LchColor(min(100.0, l + amount), c, h);
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  LchColor copyWith({final double? l, final double? c, final double? h}) {
    return LchColor(l ?? this.l, c ?? this.c, h ?? this.h);
  }

  @override
  List<LchColor> get monochromatic {
    return <LchColor>[
      darken(20),
      darken(10),
      this,
      lighten(10),
      lighten(20),
    ];
  }

  @override
  List<LchColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <LchColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<LchColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <LchColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  ColorSpacesIQ get random {
    final Random rng = Random();
    return LchColor(
      rng.nextDouble() * 100,
      rng.nextDouble() * 134,
      rng.nextDouble() * 360,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is! LchColor) {
      return value == other.value;
    }
    const double epsilon = 0.001;
    return (l - other.l).abs() < epsilon &&
        (c - other.c).abs() < epsilon &&
        (h - other.h).abs() < epsilon;
  }

  @override
  LchColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  LchColor opaquer([final double amount = 20]) {
    // LCH doesn't store alpha in this implementation
    return this;
  }

  @override
  LchColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return copyWith(h: newHue);
  }

  @override
  LchColor get complementary => adjustHue(180);

  @override
  LchColor warmer([final double amount = 20]) {
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
  LchColor cooler([final double amount = 20]) {
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
  List<LchColor> generateBasicPalette() {
    return <LchColor>[
      lighten(40),
      lighten(20),
      this,
      darken(20),
      darken(40),
    ];
  }

  @override
  List<LchColor> tonesPalette() {
    // Create tones by reducing chroma (moving towards gray)
    return <LchColor>[
      this,
      LchColor(l, c * 0.85, h),
      LchColor(l, c * 0.70, h),
      LchColor(l, c * 0.55, h),
      LchColor(l, c * 0.40, h),
    ];
  }

  @override
  List<LchColor> analogous({final int count = 5, final double offset = 30}) {
    final List<LchColor> palette = <LchColor>[];
    final double startHue = h - ((count - 1) / 2) * offset;
    for (int i = 0; i < count; i++) {
      double newHue = (startHue + i * offset) % 360;
      if (newHue < 0) newHue += 360;
      palette.add(copyWith(h: newHue));
    }
    return palette;
  }

  @override
  List<LchColor> square() {
    return <LchColor>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<LchColor> tetrad({final double offset = 60}) {
    return <LchColor>[
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
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      return toLab().isWithinGamut(gamut);
    }
    return true;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'LchColor', 'l': l, 'c': c, 'h': h};
  }

  @override
  String toString() => 'LchColor(l: ${l.toStrTrimZeros(2)}, ' //
      'c: ${c.toStringAsFixed(2)}, h: ${h.toStrTrimZeros(3)})';
}
