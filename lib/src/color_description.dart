import 'color_interfaces.dart';
import 'models/hsl_color.dart';

/// Provides functionality to describe and classify colors.
class ColorDescriptor {
  /// Describes the given [color] using a combination of adjectives and the color name.
  ///
  /// Examples:
  /// - "Very Light Red"
  /// - "Pastel Blue"
  /// - "Deep Green"
  /// - "Dark Grayish Orange"
  static String describe(ColorSpacesIQ color) {
    final hsl = color.toColor().toHsl();
    final h = hsl.h;
    final s = hsl.s;
    final l = hsl.l;

    // 1. Handle Achromatic Colors (Grays)
    if (s < 0.03) {
      if (l > 0.98) return "White";
      if (l < 0.02) return "Black";
      if (l > 0.80) return "Very Light Gray";
      if (l > 0.60) return "Light Gray";
      if (l > 0.40) return "Gray";
      if (l > 0.20) return "Dark Gray";
      return "Very Dark Gray";
    }

    // 2. Get the base hue name
    // 2. Get the base hue name
    String hueName = getColorNameFromHue(h);

    // 3. Determine Adjectives
    String adjective = "";

    // Lightness/Saturation Matrix
    if (l > 0.95) {
      return "White (Tinted)"; // Or "Very Pale $hueName"
    } else if (l > 0.85) {
      if (s < 0.30) {
        adjective = "Pale"; // High L, Low S
      } else {
        adjective = "Very Light"; // High L, Mid/High S
      }
    } else if (l > 0.70) {
      if (s < 0.40) {
        adjective = "Pastel"; // High-Mid L, Low-Mid S
      } else if (s > 0.80) {
        adjective = "Vivid Light"; // High-Mid L, High S
      } else {
        adjective = "Light";
      }
    } else if (l > 0.40) { // Mid Lightness (0.4 - 0.7)
      if (s < 0.20) {
        adjective = "Grayish";
      } else if (s < 0.50) {
        adjective = "Muted"; // Or Dull
      } else if (s > 0.85) {
        adjective = "Vivid";
      } else {
        adjective = "Medium"; // Often omitted, just the color name
      }
    } else if (l > 0.20) { // Dark (0.2 - 0.4)
      if (s < 0.30) {
        adjective = "Dark Grayish";
      } else if (s > 0.80) {
        adjective = "Deep"; // Dark and Saturated
      } else {
        adjective = "Dark";
      }
    } else { // Very Dark (< 0.2)
       if (s > 0.80) {
         adjective = "Very Deep";
       } else {
         adjective = "Very Dark";
       }
    }

    // Clean up "Medium" as it's often implicit
    if (adjective == "Medium") {
      return hueName;
    }

    return "$adjective $hueName";
  }
}
