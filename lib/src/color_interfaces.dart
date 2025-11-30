/// A common interface for all color models.
abstract class ColorSpacesIQ {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;

  /// Lightens the color by the given [amount] (0-100).
  ColorSpacesIQ lighten([double amount = 20]);

  /// Darkens the color by the given [amount] (0-100).
  ColorSpacesIQ darken([double amount = 20]);

  /// Saturates the color by the given [amount] (0-100).
  ColorSpacesIQ saturate([double amount = 25]);

  /// Desaturates the color by the given [amount] (0-100).
  ColorSpacesIQ desaturate([double amount = 25]);

  /// Returns the delinearized gamut corrected sRGB values [r, g, b, a] (0-255).
  List<int> get srgb;

  /// Returns the linearized ARGB (not gamma corrected) values [r, g, b, a] (0.0-1.0).
  List<double> get linearSrgb;

  /// Returns the inverted color.
  ColorSpacesIQ get inverted;

  /// Returns the grayscale version of this color.
  ColorSpacesIQ get grayscale;

  /// Whitens the color by mixing it with white by the given [amount] (0-100).
  ColorSpacesIQ whiten([double amount = 20]);

  /// Blackens the color by mixing it with black by the given [amount] (0-100).
  ColorSpacesIQ blacken([double amount = 20]);

  /// Linearly interpolates to another [other] color by [t] (0.0-1.0).
  ColorSpacesIQ lerp(ColorSpacesIQ other, double t);
}
