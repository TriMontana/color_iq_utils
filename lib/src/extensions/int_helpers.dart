import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// Extension for integers
extension IntHelperIQ on int {
  Iq255 get toIq255 => Iq255.getIq255(this);
  String get toHexStr => '0x${toRadixString(16).toUpperCase().padLeft(8, '0')}';
  ArgbInts get rgbaInts => hexIdToComponents(this);
  ArgbDoubles get rgbaDoubles => hexIdToNormalizedComponents(this);

  int get clamp0to255 => clampInt(this, min: 0, max: 255);

  /// Returns the closest color slice from the HCT color wheel.
  ColorSlice closestColorSlice() {
    ColorSlice? closest;
    double minDistance = double.infinity;

    for (final ColorSlice slice in hctSlices) {
      final double dist = distanceTo(slice.color.hexId);
      if (dist < minDistance) {
        minDistance = dist;
        closest = slice;
      }
    }
    return closest!;
  }

  double distanceTo(final int other) {
    final Cam16 cam1 = Cam16.fromInt(this);
    final Cam16 cam2 = Cam16.fromInt(other);
    return cam1.distance(cam2);
  }

  /// Normalizes a single 8-bit integer channel (0-255) to a double (0.0-1.0).
  ///
  /// This is typically used for individual color channels (like red, green, or blue).
  /// It masks the integer to ensure it's treated as an 8-bit value,
  /// then divides by 255.0 to scale it to the 0.0-1.0 range.
  Percent get normalized => Percent(((this & 0xFF) / 255.0).clamp0to1);
  double get factored => normalized;
  // The structure of the 32-bit integer is: AARRGGBB
  /// Shifts the Alpha byte 24 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get alpha => ((this >> 24) & 0xFF);
  int get alphaInt => (0xff000000 & this) >> 24;

  /// Shifts the Red byte 16 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get red => ((this >> 16) & 0xFF);
  int get redInt => (0x00ff0000 & this) >> 16;
  Iq255 get redIQ => redInt.toIq255;
  LinRGB get redLinearized => redIQ.linearized;

  /// Shifts the Green byte 8 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get green => ((this >> 8) & 0xFF);
  int get greenInt => (0x0000ff00 & this) >> 8;
  Iq255 get greenIQ => greenInt.toIq255;
  LinRGB get greenLinearized => greenIQ.linearized;

  /// Shifts the Blue byte 0 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get blue => (this & 0xFF);
  int get blueInt => (0x000000ff & this) >> 0;

  double get a => (alpha / kMax8bit).clamp0to1;
  Percent get a2 => Percent((((this >> 24) & 0xFF) / 255.0).clamp0to1);
  LinRGB get alphaLinearized => srgbToLinear(a2);
  double get r => (red / kMax8bit).clamp0to1;
  Percent get r2 => Percent((((this >> 16) & 0xFF) / 255.0).clamp0to1);

  double get g => (green / kMax8bit).clamp0to1;
  Percent get g2 => Percent((((this >> 8) & 0xFF) / 255.0).clamp0to1);
  double get b => (blue / kMax8bit).clamp0to1;
  Percent get b2 => Percent(((this & 0xFF) / 255.0).clamp0to1);
  LinRGB get blueLinearized => srgbToLinear(b2);

  Percent get toLRV => computeLuminanceViaLinearized(
      redLinearized, greenLinearized, blueLinearized);

  // Helper for Linearization (The expensive part)
  LinRGB get linearizeUint8 {
    final double val = assertRange0to255('linearizeUint8') / 255.0;
    // The expensive power function that prevents const
    return (val <= 0.04045)
        ? LinRGB(val / 12.92)
        : LinRGB(math.pow((val + 0.055) / 1.055, 2.4).toDouble().clamp0to1);
  }

  Cam16 get toCam16 => Cam16.fromInt(this);
  HctData get toHctColor => HctData.fromInt(this);

  int assertRange0to255([final String? message]) {
    if (this < 0 || this > 255) {
      throw ArgumentError('${message.orEmpty}--$errorMsg0to255--$this');
    }
    return this;
  }

  int assertRange0to100int([final String? message]) {
    if (this < 0 || this > 100) {
      throw ArgumentError(message ?? 'Value must be between 0 and 100--$this');
    }
    return this;
  }

  /// Determines the closest [ColorFamilyHTML] for this color value.
  ///
  /// Compares the color against representative colors from each family
  /// using Euclidean distance in RGB color space.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// ColorFamily family = myColor.closestColorFamily(); // ColorFamily.red
  /// ```
  ColorFamilyHTML closestColorFamily() {
    // Extract RGB components from this color
    final int r = (this >> 16) & 0xFF;
    final int g = (this >> 8) & 0xFF;
    final int b = this & 0xFF;

    // Representative colors for each family (using pure/typical colors)
    final Map<ColorFamilyHTML, (int, int, int)> familyColors =
        <ColorFamilyHTML, (int, int, int)>{
      ColorFamilyHTML.red: (255, 0, 0),
      ColorFamilyHTML.orange: (255, 165, 0),
      ColorFamilyHTML.yellow: (255, 255, 0),
      ColorFamilyHTML.green: (0, 128, 0),
      ColorFamilyHTML.cyan: (0, 255, 255),
      ColorFamilyHTML.blue: (0, 0, 255),
      ColorFamilyHTML.purple: (128, 0, 128),
      ColorFamilyHTML.pink: (255, 192, 203),
      ColorFamilyHTML.brown: (165, 42, 42),
      ColorFamilyHTML.white: (255, 255, 255),
      ColorFamilyHTML.gray: (128, 128, 128),
      ColorFamilyHTML.black: (0, 0, 0),
    };

    // Find the family with minimum distance
    ColorFamilyHTML? closestFamily;
    double minDistance = double.infinity;

    for (final MapEntry<ColorFamilyHTML, (int, int, int)> entry
        in familyColors.entries) {
      final (int fr, int fg, int fb) = entry.value;
      // Calculate Euclidean distance in RGB space
      final double distance =
          ((r - fr) * (r - fr) + (g - fg) * (g - fg) + (b - fb) * (b - fb))
              .toDouble();

      if (distance < minDistance) {
        minDistance = distance;
        closestFamily = entry.key;
      }
    }

    return closestFamily!;
  }

  /// Finds the closest [HtmlEN] color to this color value.
  ///
  /// Compares the color against all HTML colors using Euclidean distance
  /// in RGB color space.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// HTML closest = myColor.closestHTMLColor(); // HTML.lightCoral
  /// ```
  HtmlEN closestHTMLColor() {
    final int r = (this >> 16) & 0xFF;
    final int g = (this >> 8) & 0xFF;
    final int b = this & 0xFF;

    HtmlEN? closestColor;
    double minDistance = double.infinity;

    for (final HtmlEN htmlColor in HtmlEN.values) {
      final int hr = (htmlColor.value >> 16) & 0xFF;
      final int hg = (htmlColor.value >> 8) & 0xFF;
      final int hb = htmlColor.value & 0xFF;

      final double distance =
          ((r - hr) * (r - hr) + (g - hg) * (g - hg) + (b - hb) * (b - hb))
              .toDouble();

      if (distance < minDistance) {
        minDistance = distance;
        closestColor = htmlColor;
      }
    }

    return closestColor!;
  }

  /// Determines the closest [ColorFamilyHTML] for this color value using CAM16-based distance.
  ///
  /// Uses perceptually uniform CAM16/HCT color space for more accurate
  /// color family matching based on human perception.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// ColorFamily family = myColor.closestColorFamilyPerceptual(); // ColorFamily.red
  /// ```
  ColorFamilyHTML closestColorFamilyPerceptual() {
    final ColorIQ thisColor = ColorIQ(this);
    final HctColor hct1 = thisColor.toHctColor();

    // Representative colors for each family (using pure/typical colors)
    final Map<ColorFamilyHTML, HTML> familyColors = <ColorFamilyHTML, HTML>{
      ColorFamilyHTML.red: cRed,
      ColorFamilyHTML.orange: cOrangeHtml,
      ColorFamilyHTML.yellow: cYellow,
      ColorFamilyHTML.green: cGreenHtml,
      ColorFamilyHTML.cyan: cCyan,
      ColorFamilyHTML.blue: cBlue,
      ColorFamilyHTML.purple: cPurpleHtml,
      ColorFamilyHTML.pink: cPink,
      ColorFamilyHTML.brown: cBrownHtml,
      ColorFamilyHTML.white: cWhite,
      ColorFamilyHTML.gray: cGray,
      ColorFamilyHTML.black: cBlack,
    };

    // Find the family with minimum perceptual distance
    ColorFamilyHTML? closestFamily;
    double minDistance = double.infinity;

    for (final MapEntry<ColorFamilyHTML, ColorIQ> entry
        in familyColors.entries) {
      final HctColor hct2 = entry.value.toHctColor();

      // Calculate perceptual distance using CAM16/HCT
      // Convert to Cartesian coordinates for distance calculation
      final double h1Rad = hct1.hue * pi / 180;
      final double h2Rad = hct2.hue * pi / 180;

      final double a1 = hct1.chroma * cos(h1Rad);
      final double b1 = hct1.chroma * sin(h1Rad);
      final double a2 = hct2.chroma * cos(h2Rad);
      final double b2 = hct2.chroma * sin(h2Rad);

      final double dTone = hct1.tone - hct2.tone;
      final double da = a1 - a2;
      final double db = b1 - b2;

      final double distance = sqrt(dTone * dTone + da * da + db * db);

      if (distance < minDistance) {
        minDistance = distance;
        closestFamily = entry.key;
      }
    }

    return closestFamily!;
  }

  /// Finds the closest [HtmlEN] color to this color value using CAM16-based distance.
  ///
  /// Uses perceptually uniform CAM16/HCT color space for more accurate
  /// color matching based on human perception rather than simple RGB distance.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// HTML closest = myColor.closestHTMLColorPerceptual(); // HTML.lightCoral
  /// ```
  HtmlEN closestHTMLColorPerceptual() {
    final ColorIQ thisColor = ColorIQ(this);

    HtmlEN? closestColor;
    double minDistance = double.infinity;

    for (final HtmlEN htmlColor in HtmlEN.values) {
      // Use the distanceTo method which uses CAM16/HCT
      final double distance = thisColor.distanceTo(ColorIQ(htmlColor.value));

      if (distance < minDistance) {
        minDistance = distance;
        closestColor = htmlColor;
      }
    }

    return closestColor!;
  }
}
