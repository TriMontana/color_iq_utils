import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// Extension for integers
extension IntHelperIQ on int {
  String get toHexStr => '0x${toRadixString(16).toUpperCase().padLeft(8, '0')}';

  // The structure of the 32-bit integer is: AARRGGBB
  /// Shifts the Alpha byte 24 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get alpha => ((this >> 24) & 0xFF);
  int get alphaInt => (0xff000000 & this) >> 24;

  /// Shifts the Red byte 16 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get red => ((this >> 16) & 0xFF);
  int get redInt => (0x00ff0000 & this) >> 16;

  /// Shifts the Green byte 8 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get green => ((this >> 8) & 0xFF);
  int get greenInt => (0x0000ff00 & this) >> 8;

  /// Shifts the Blue byte 0 bits to the right, placing it in the lowest
  /// 8 bits. The & 0xFF mask ensures only that byte remains.
  int get blue => (this & 0xFF);
  int get blueInt => (0x000000ff & this) >> 0;

  double get a => (alpha / kMax8bit).clamp0to1;
  double get a2 => (((this >> 24) & 0xFF) / 255.0).clamp0to1;
  double get alphaLinearized => srgbToLinear(a2);
  double get r => (red / kMax8bit).clamp0to1;
  double get r2 => (((this >> 16) & 0xFF) / 255.0).clamp0to1;
  double get redLinearized => srgbToLinear(r2);
  double get g => (green / kMax8bit).clamp0to1;
  double get g2 => (((this >> 8) & 0xFF) / 255.0).clamp0to1;
  double get greenLinearized => srgbToLinear(g2);
  double get b => (blue / kMax8bit).clamp0to1;
  double get b2 => ((this & 0xFF) / 255.0).clamp0to1;
  double get blueLinearized => srgbToLinear(b2);

  int assertRange0to255([final String? message]) {
    if (this < 0 || this > 255) {
      throw ArgumentError(message ?? 'Value must be between 0 and 255--$this');
    }
    return this;
  }

  int assertRange0to100int([final String? message]) {
    if (this < 0 || this > 100) {
      throw ArgumentError(message ?? 'Value must be between 0 and 100--$this');
    }
    return this;
  }

  /// Determines the closest [ColorFamily] for this color value.
  ///
  /// Compares the color against representative colors from each family
  /// using Euclidean distance in RGB color space.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// ColorFamily family = myColor.closestColorFamily(); // ColorFamily.red
  /// ```
  ColorFamily closestColorFamily() {
    // Extract RGB components from this color
    final int r = (this >> 16) & 0xFF;
    final int g = (this >> 8) & 0xFF;
    final int b = this & 0xFF;

    // Representative colors for each family (using pure/typical colors)
    final Map<ColorFamily, (int, int, int)> familyColors =
        <ColorFamily, (int, int, int)>{
      ColorFamily.red: (255, 0, 0),
      ColorFamily.orange: (255, 165, 0),
      ColorFamily.yellow: (255, 255, 0),
      ColorFamily.green: (0, 128, 0),
      ColorFamily.cyan: (0, 255, 255),
      ColorFamily.blue: (0, 0, 255),
      ColorFamily.purple: (128, 0, 128),
      ColorFamily.pink: (255, 192, 203),
      ColorFamily.brown: (165, 42, 42),
      ColorFamily.white: (255, 255, 255),
      ColorFamily.gray: (128, 128, 128),
      ColorFamily.black: (0, 0, 0),
    };

    // Find the family with minimum distance
    ColorFamily? closestFamily;
    double minDistance = double.infinity;

    for (final MapEntry<ColorFamily, (int, int, int)> entry
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

  /// Finds the closest [HTML] color to this color value.
  ///
  /// Compares the color against all HTML colors using Euclidean distance
  /// in RGB color space.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// HTML closest = myColor.closestHTMLColor(); // HTML.lightCoral
  /// ```
  HTML closestHTMLColor() {
    final int r = (this >> 16) & 0xFF;
    final int g = (this >> 8) & 0xFF;
    final int b = this & 0xFF;

    HTML? closestColor;
    double minDistance = double.infinity;

    for (final HTML htmlColor in HTML.values) {
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

  /// Determines the closest [ColorFamily] for this color value using CAM16-based distance.
  ///
  /// Uses perceptually uniform CAM16/HCT color space for more accurate
  /// color family matching based on human perception.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// ColorFamily family = myColor.closestColorFamilyPerceptual(); // ColorFamily.red
  /// ```
  ColorFamily closestColorFamilyPerceptual() {
    final ColorIQ thisColor = ColorIQ(this);
    final HctColor hct1 = thisColor.toHct();

    // Representative colors for each family (using pure/typical colors)
    final Map<ColorFamily, ColorIQ> familyColors = <ColorFamily, ColorIQ>{
      ColorFamily.red: cRed,
      ColorFamily.orange: ColorIQ(0xFFFFA500),
      ColorFamily.yellow: ColorIQ(0xFFFFFF00),
      ColorFamily.green: cGreen,
      ColorFamily.cyan: ColorIQ(0xFF00FFFF),
      ColorFamily.blue: ColorIQ(0xFF0000FF),
      ColorFamily.purple: ColorIQ(0xFF800080),
      ColorFamily.pink: ColorIQ(0xFFFFC0CB),
      ColorFamily.brown: ColorIQ(0xFFA52A2A),
      ColorFamily.white: cWhite,
      ColorFamily.gray: cGray,
      ColorFamily.black: cBlack,
    };

    // Find the family with minimum perceptual distance
    ColorFamily? closestFamily;
    double minDistance = double.infinity;

    for (final MapEntry<ColorFamily, ColorIQ> entry in familyColors.entries) {
      final HctColor hct2 = entry.value.toHct();

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

  /// Finds the closest [HTML] color to this color value using CAM16-based distance.
  ///
  /// Uses perceptually uniform CAM16/HCT color space for more accurate
  /// color matching based on human perception rather than simple RGB distance.
  ///
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// HTML closest = myColor.closestHTMLColorPerceptual(); // HTML.lightCoral
  /// ```
  HTML closestHTMLColorPerceptual() {
    final ColorIQ thisColor = ColorIQ(this);

    HTML? closestColor;
    double minDistance = double.infinity;

    for (final HTML htmlColor in HTML.values) {
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
