import 'color_interfaces.dart';

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
  bool meetsWcag(ColorSpacesIQ background, {WcagLevel level = WcagLevel.aa, bool isLargeText = false}) {
    final ratio = contrastWith(background);
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
