import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/css_colors.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

/// Public entry point for working with Dart.ui.color.
/// Mirrors [ColorIQ] but offers convenient constructors for common inputs.
class Color extends ColorIQ {
  /// Create a color from a 32-bit ARGB integer (0xAARRGGBB).
  Color(super.value);

  /// Create a color from individual ARGB components.
  Color.fromARGB(super.a, super.r, super.g, super.b) : super.fromARGB();

  /// Create an opaque color from RGB components.
  factory Color.fromRgb(final int r, final int g, final int b) =>
      Color.fromARGB(255, r, g, b);

  /// Parse a hex string such as `#FF00FF` or `FF00FF` (ARGB or RGB).
  factory Color.fromHex(final String hex) {
    final String normalized = hex.trim().startsWith('#')
        ? hex.trim()
        : '#${hex.trim()}';
    final ColorSpacesIQ parsed = CssColor.fromCssString(normalized);
    return Color(parsed.toColor().value);
  }

  /// Parse any supported CSS color string into a [Color].
  factory Color.fromCss(final String css) =>
      Color(CssColor.fromCssString(css).toColor().value);

  /// Recreate a [Color] from the JSON map produced by [ColorIQ.toJson].
  factory Color.fromJson(final Map<String, dynamic> json) {
    final ColorSpacesIQ parsed = ColorIQ.fromJson(json);
    return Color(parsed.toColor().value);
  }

  /// Generate a random opaque color.
  static Color randomColor() {
    final Random rng = Random();
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
