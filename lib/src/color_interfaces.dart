/// A common interface for all color models.
abstract class ColorSpacesIQ {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;

  /// Lightens the color by the given [amount] (0-100).
  ColorSpacesIQ lighten([double amount = 20]);

  /// Darkens the color by the given [amount] (0-100).
  ColorSpacesIQ darken([double amount = 20]);
}
