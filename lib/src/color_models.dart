import 'dart:math';

/// A color represented by red, green, blue, and alpha components.
class Color {
  /// The 32-bit alpha-red-green-blue integer value.
  final int value;

  /// Construct a color from the lower 32 bits of an [int].
  ///
  /// The bits are interpreted as follows:
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  const Color(this.value);

  /// Construct a color from 4 integers, a, r, g, b.
  ///
  /// [a], [r], [g], [b] must be in the range 0-255.
  const Color.fromARGB(int a, int r, int g, int b)
      : value = (((a & 0xff) << 24) |
                ((r & 0xff) << 16) |
                ((g & 0xff) << 8) |
                ((b & 0xff) << 0)) &
            0xFFFFFFFF;

  /// The alpha channel of this color in an 8-bit value.
  int get alpha => (value >> 24) & 0xFF;

  /// The red channel of this color in an 8-bit value.
  int get red => (value >> 16) & 0xFF;

  /// The green channel of this color in an 8-bit value.
  int get green => (value >> 8) & 0xFF;

  /// The blue channel of this color in an 8-bit value.
  int get blue => value & 0xFF;

  /// Converts this color to CMYK.
  CmykColor toCmyk() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CmykColor(0, 0, 0, 1);
    }

    double c = (1.0 - r - k) / (1.0 - k);
    double m = (1.0 - g - k) / (1.0 - k);
    double y = (1.0 - b - k) / (1.0 - k);

    return CmykColor(c, m, y, k);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Color && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Color(0x${value.toRadixString(16).padLeft(8, '0')})';
}

/// A color represented by cyan, magenta, yellow, and black components.
class CmykColor {
  /// Cyan component (0.0 to 1.0).
  final double c;

  /// Magenta component (0.0 to 1.0).
  final double m;

  /// Yellow component (0.0 to 1.0).
  final double y;

  /// Black component (0.0 to 1.0).
  final double k;

  const CmykColor(this.c, this.m, this.y, this.k);

  /// Converts this CMYK color to RGB [Color].
  Color toColor() {
    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);

    return Color.fromARGB(255, r.round(), g.round(), b.round());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CmykColor &&
        other.c == c &&
        other.m == m &&
        other.y == y &&
        other.k == k;
  }

  @override
  int get hashCode => Object.hash(c, m, y, k);

  @override
  String toString() =>
      'CmykColor(c: ${c.toStringAsFixed(2)}, m: ${m.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';
}
