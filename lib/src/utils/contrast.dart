import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/models/hsluv.dart';

/// WCAG conformance levels.
enum WcagLevel {
  aa,
  aaa,
}

/// Extension methods for WCAG contrast checks.
extension WcagExtensions on ColorSpacesIQ {
  /// Checks if the color meets the specified WCAG contrast level against a background.
  ///
  /// [background] The background color.
  /// [level] The WCAG level (AA or AAA). Default is AA.
  /// [isLargeText] Whether the text is large (>= 18pt or >= 14pt bold). Default is false.
  ///
  /// WCAG 2.1 Requirements:
  /// - AA Normal: 4.5:1
  /// - AA Large: 3.0:1
  /// - AAA Normal: 7.0:1
  /// - AAA Large: 4.5:1
  bool meetsWcag(final ColorSpacesIQ background,
      {final WcagLevel level = WcagLevel.aa, final bool isLargeText = false}) {
    final double ratio = contrastWith(background);
    double threshold;

    if (level == WcagLevel.aa) {
      threshold = isLargeText ? 3.0 : 4.5;
    } else {
      // AAA
      threshold = isLargeText ? 4.5 : 7.0;
    }

    return ratio >= threshold;
  }

  /// Returns the highest WCAG level met for normal text.
  /// Returns null if not even AA Large (3.0) is met? No, let's return a description or enum.
  /// Actually, let's keep it simple.
}

class Contrast {
  static double contrastRatio(final double lighterL, final double darkerL) {
    // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-procedure
    final double lighterY = Hsluv.lToY(lighterL);
    final double darkerY = Hsluv.lToY(darkerL);
    return (lighterY + 0.05) / (darkerY + 0.05);
  }

  static double lighterMinL(final double r) {
    return Hsluv.yToL((r - 1) / 20);
  }

  static double darkerMaxL(final double r, final double lighterL) {
    final double lighterY = Hsluv.lToY(lighterL);
    final double maxY = (20 * lighterY - r + 1) / (20 * r);
    return Hsluv.yToL(maxY);
  }
}
