import 'dart:math' as math;

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

/// Represents a color in the HCL(uv) color space, which is a perceptually
/// uniform color space derived from the CIELUV color space. HCL(uv) is
/// particularly useful for data visualization and creating color palettes
/// because changes in its values correspond more closely to how humans
/// perceive color differences.
///
/// [HclUv] has three components:
/// - **H (Hue):** The type of color (e.g., red, green, blue). It is represented
///   as an angle on the color wheel, typically from 0 to 360 degrees.
/// - **C (Chroma):** The "colorfulness" or "saturation" of the color. A chroma
///   of 0 represents a grayscale color (achromatic), while higher values
///   indicate a more vivid color. The maximum chroma varies depending on the
///   hue and lightness.
/// - **L (Luminance/Lightness):** The perceived brightness of the color, ranging
///   from 0 (black) to 100 (white).
///
/// This color space aims to make it easier to create palettes where colors
/// have the same perceived brightness and colorfulness, even if their hues
/// are different.
class HclUv extends CommonIQ implements ColorSpacesIQ {
  /// The hue component of the color, representing the type of color.
  ///
  /// Expressed as an angle on the color wheel, ranging from 0 to 360 degrees.
  final double h; // Hue (0-360)
  /// The chroma component, representing the "colorfulness" or intensity.
  ///
  /// A value of 0 is grayscale, while higher values are more vivid. The theoretical
  /// maximum is around 180, but it varies with hue and lightness.
  final double c; // Chroma (0-~180)
  /// The luminance (or lightness) component of the color.
  ///
  /// Ranges from 0 (black) to 100 (white).
  final double l; // Luminance/Lightness (0-100)

  HclUv(this.h, this.c, this.l,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String> names = kEmptyNames})
      : super(hexId, names: names, alpha: alpha);

  /// Converts a Flutter Color (sRGB) to HCL based on the CIELUV color space.
  static HclUv colorToHclUv(final ColorIQ color) {
    // --- 1. RGB to Linear RGB ---
    // Inverse Gamma Correction (sRGB to Linear)
    final double r = color.r.linearize;
    final double g = color.g.linearize;
    final double b = color.b.linearize;

    // --- 2. Linear RGB to CIEXYZ (D65) ---
    final double x = (r * 0.4124564) + (g * 0.3575761) + (b * 0.1804375);
    final double y = (r * 0.2126729) + (g * 0.7151522) + (b * 0.0721750);
    final double z = (r * 0.0193339) + (g * 0.1191920) + (b * 0.9503041);

    // --- 3. CIEXYZ to CIELUV --- These are the same as the regular WhitePoint but
    // divided by 100, i.e. 0.95047 vs. 95.047
    // Reference White Point (D65 standard)
    const double refX = 0.95047;
    const double refY = 1.00000;
    const double refZ = 1.08883;

    // Calculate u' and v' for the reference white
    const double denominatorRef = refX + (15.0 * refY) + (3.0 * refZ);
    const double refU = (4.0 * refX) / denominatorRef;
    const double refV = (9.0 * refY) / denominatorRef;

    // Calculate u' and v' for the target color
    double denominator = x + (15.0 * y) + (3.0 * z);
    if (denominator == 0.0) denominator = 1.0; // Prevent div by zero for black

    final double targetU = (4.0 * x) / denominator;
    final double targetV = (9.0 * y) / denominator;

    // Calculate L* (Lightness)
    const double epsilon = 0.008856;
    const double kappa = 903.3;

    final double yRatio = y / refY;
    final double lStar = (yRatio > epsilon)
        ? (116.0 * math.pow(yRatio, 1.0 / 3.0) - 16.0)
        : (kappa * yRatio);

    // Calculate u* and v*
    final double uStar = 13.0 * lStar * (targetU - refU);
    final double vStar = 13.0 * lStar * (targetV - refV);

    // --- 4. CIELUV to HCL(uv) ---
    // H = arctan(v*, u*)
    double hue = math.atan2(vStar, uStar) * (180.0 / math.pi);
    if (hue < 0) hue += 360.0;

    // C = sqrt(u*^2 + v*^2)
    final double chroma = math.sqrt((uStar * uStar) + (vStar * vStar));

    return HclUv(hue, chroma, lStar);
  }

  /// Converts HCL(uv) values back to a Flutter Color.
  /// @param h Hue (0.0 - 360.0)
  /// @param c Chroma (0.0 - ~180.0)
  /// @param l Luminance/Lightness (0.0 - 100.0)
  static ColorIQ hclUvToColor(final double h, final double c, final double l) {
    // --- 1. HCL(uv) to CIELUV ---
    // Convert Hue to radians
    final double hRad = h * (math.pi / 180.0);

    // Calculate u* and v*
    final double uStar = c * math.cos(hRad);
    final double vStar = c * math.sin(hRad);
    final double lStar = l;

    // --- 2. CIELUV to CIEXYZ (D65) ---
    const double refX = 0.95047;
    const double refY = 1.00000;
    const double refZ = 1.08883;

    // Calculate u'_n and v'_n (Reference White)
    const double denominatorRef = refX + (15.0 * refY) + (3.0 * refZ);
    const double refU = (4.0 * refX) / denominatorRef;
    const double refV = (9.0 * refY) / denominatorRef;

    // Calculate Y (Luminance)
    double y;
    if (lStar > 8.0) {
      y = refY * math.pow((lStar + 16.0) / 116.0, 3.0);
    } else {
      y = refY * (lStar / 903.3);
    }

    // Calculate u' and v'
    // Avoid division by zero if L* is 0 (Black)
    double uPrime, vPrime;
    if (lStar <= 0.0) {
      uPrime = refU;
      vPrime = refV;
    } else {
      uPrime = (uStar / (13.0 * lStar)) + refU;
      vPrime = (vStar / (13.0 * lStar)) + refV;
    }

    // Calculate X and Z
    double x, z;
    // Avoid division by zero if v' is 0
    if (vPrime == 0.0) {
      x = 0.0;
      z = 0.0;
    } else {
      x = y * (9.0 * uPrime) / (4.0 * vPrime);
      z = y * (12.0 - (3.0 * uPrime) - (20.0 * vPrime)) / (4.0 * vPrime);
    }

    // --- 3. CIEXYZ to Linear RGB ---
    // Standard sRGB Matrix (XYZ -> RGB)
    final double rLin = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
    final double gLin = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
    final double bLin = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;

    // // --- 4. Linear RGB to sRGB (Gamma Correction) ---
    // double gammaCorrect(final double linear) {
    //   if (linear <= 0.0031308) {
    //     return 12.92 * linear;
    //   } else {
    //     return 1.055 * math.pow(linear, 1.0 / 2.4) - 0.055;
    //   }
    // }

    final double r = gammaCorrect(rLin);
    final double g = gammaCorrect(gLin);
    final double b = gammaCorrect(bLin);

    // --- 5. Clamp and Convert to Color ---
    // HCL values can mathematically produce colors outside the sRGB gamut (r/g/b > 1.0 or < 0.0).
    // We clamp them to displayable range.
    int toInt(final double val) => (val.clamp(0.0, 1.0) * 255.0).round();

    return ColorIQ.fromArgbInts(
      255, // Full Opacity
      toInt(r),
      toInt(g),
      toInt(b),
    );
  }

  @override
  String toString() =>
      'HCL(uv): ${h.toStringAsFixed(1)}°, ${c.toStringAsFixed(1)}, ${l.toStringAsFixed(1)}';

  @override
  ColorSpacesIQ accented([final double amount = 15]) {
    // TODO: implement accented
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ adjustHue([final double amount = 20]) {
    // TODO: implement adjustHue
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> analogous(
      {final int count = 5, final double offset = 30}) {
    // TODO: implement analogous
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ blacken([final double amount = 20]) {
    // TODO: implement blacken
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ blend(final ColorSpacesIQ other, [final double amount = 50]) {
    // TODO: implement blend
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ brighten([final double amount = 20]) {
    // TODO: implement brighten
    throw UnimplementedError();
  }

  @override
  // TODO: implement complementary
  ColorSpacesIQ get complementary => throw UnimplementedError();

  @override
  double contrastWith(final ColorSpacesIQ other) {
    // TODO: implement contrastWith
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ cooler([final double amount = 20]) {
    // TODO: implement cooler
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ darken([final double amount = 20]) {
    // TODO: implement darken
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    // TODO: implement darkerPalette
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> generateBasicPalette() {
    // TODO: implement generateBasicPalette
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ intensify([final double amount = 10]) {
    // TODO: implement intensify
    throw UnimplementedError();
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    // TODO: implement isEqual
    throw UnimplementedError();
  }

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    // TODO: implement isWithinGamut
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ lerp(final ColorSpacesIQ other, final double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ lighten([final double amount = 20]) {
    // TODO: implement lighten
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    // TODO: implement lighterPalette
    throw UnimplementedError();
  }

  @override
  // TODO: implement monochromatic
  List<ColorSpacesIQ> get monochromatic => throw UnimplementedError();

  @override
  ColorSpacesIQ opaquer([final double amount = 20]) {
    // TODO: implement opaquer
    throw UnimplementedError();
  }

  @override
  // TODO: implement random
  ColorSpacesIQ get random => throw UnimplementedError();

  @override
  ColorSpacesIQ saturate([final double amount = 25]) {
    // TODO: implement saturate
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ simulate(final ColorBlindnessType type) {
    // TODO: implement simulate
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> square() {
    // TODO: implement square
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> tetrad({final double offset = 60}) {
    // TODO: implement tetrad
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  List<ColorSpacesIQ> tonesPalette() {
    // TODO: implement tonesPalette
    throw UnimplementedError();
  }

  @override
  // TODO: implement value
  int get value => throw UnimplementedError();

  @override
  ColorSpacesIQ warmer([final double amount = 20]) {
    // TODO: implement warmer
    throw UnimplementedError();
  }

  @override
  ColorSpacesIQ whiten([final double amount = 20]) {
    // TODO: implement whiten
    throw UnimplementedError();
  }
}
