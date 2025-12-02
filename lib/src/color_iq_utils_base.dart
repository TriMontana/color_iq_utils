import 'dart:math';

import 'css_colors.dart';
import 'color_interfaces.dart';
import 'models/coloriq.dart';

/// Public entry point for working with Dart.ui.color.
/// Mirrors [ColorIQ] but offers convenient constructors for common inputs.
class Color extends ColorIQ {
  /// Create a color from a 32-bit ARGB integer (0xAARRGGBB).
  const Color(super.value);

  /// Create a color from individual ARGB components.
  const Color.fromARGB(super.a, super.r, super.g, super.b) : super.fromARGB();

  /// Create an opaque color from RGB components.
  factory Color.fromRgb(int r, int g, int b) => Color.fromARGB(255, r, g, b);

  /// Parse a hex string such as `#FF00FF` or `FF00FF` (ARGB or RGB).
  factory Color.fromHex(String hex) {
    final normalized = hex.trim().startsWith('#') ? hex.trim() : '#${hex.trim()}';
    final parsed = CssColor.fromCssString(normalized);
    return Color(parsed.toColor().value);
  }

  /// Parse any supported CSS color string into a [Color].
  factory Color.fromCss(String css) => Color(CssColor.fromCssString(css).toColor().value);

  /// Recreate a [Color] from the JSON map produced by [ColorIQ.toJson].
  factory Color.fromJson(Map<String, dynamic> json) {
    final parsed = ColorIQ.fromJson(json);
    return Color(parsed.toColor().value);
  }

  /// Generate a random opaque color.
  static Color randomColor() {
    final rng = Random();
    return Color.fromARGB(
      255,
      rng.nextInt(256),
      rng.nextInt(256),
      rng.nextInt(256),
    );
  }
}

/// Convenient alias for the shared color-space interface.
typedef ColorSpace = ColorSpacesIQ;
