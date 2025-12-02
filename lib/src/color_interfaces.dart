import 'models/hct_color.dart';
import 'models/coloriq.dart';
import 'color_wheels.dart';
export 'color_wheels.dart';
import 'color_temperature.dart';
import 'color_blindness.dart';
export 'color_blindness.dart';

/// A common interface for all color models.
abstract class ColorSpacesIQ {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;

  /// Lightens the color by the given [amount] (0-100).
  ColorSpacesIQ lighten([double amount = 20]);

  /// Darkens the color by the given [amount] (0-100).
  ColorSpacesIQ darken([double amount = 20]);

  /// Brightens the color by the given [amount] (0-100).
  /// Increases the brightness/value (HSV Value).
  ColorSpacesIQ brighten([double amount = 20]);

  /// Saturates the color by the given [amount] (0-100).
  ColorSpacesIQ saturate([double amount = 25]);

  /// Desaturates the color by the given [amount] (0-100).
  ColorSpacesIQ desaturate([double amount = 25]);

  /// Returns the sRGB components (0-255).
  List<int> get srgb;

  /// Returns the linear sRGB components (0.0-1.0).
  List<double> get linearSrgb;

  /// Returns the inverted color.
  ColorSpacesIQ get inverted;

  /// Returns the grayscale version of this color.
  ColorSpacesIQ get grayscale;

  /// Whitens the color by mixing with white. [amount] is 0-100.
  ColorSpacesIQ whiten([double amount = 20]);

  /// Blackens the color by mixing with black. [amount] is 0-100.
  ColorSpacesIQ blacken([double amount = 20]);

  /// Linearly interpolates between this color and [other]. [t] is 0.0-1.0.
  ColorSpacesIQ lerp(ColorSpacesIQ other, double t);
  
  /// Adjusts the transparency of the color. [amount] is 0-100.
  ColorSpacesIQ adjustTransparency([double amount = 20]);


  /// Converts the color to the standard ARGB [ColorIQ] format.
  ColorIQ toColor();

  /// Converts this color to HCT.
  HctColor toHct();

  /// Creates a new instance of this color type from an HCT color.
  /// Intensifies the color by increasing chroma and slightly decreasing tone.
  ColorSpacesIQ intensify([double amount = 10]);

  /// Deintensifies (mutes) the color by decreasing chroma and slightly increasing tone.
  ColorSpacesIQ deintensify([double amount = 10]);

  /// Creates an accented version of this color.
  /// Increases chroma and brightness to make the color stand out.
  ColorSpacesIQ accented([double amount = 15]);

  ColorSpacesIQ fromHct(HctColor hct);

  /// Simulates color blindness on this color.
  ColorSpacesIQ simulate(ColorBlindnessType type);

  /// Returns the transparency (alpha) as a double (0.0-1.0).
  double get transparency;

  /// Returns the color temperature (Warm or Cool).
  ColorTemperature get temperature;

  List<ColorSpacesIQ> get monochromatic;

  /// Returns a palette of 5 colors progressively lighter.
  /// [step] is the percentage increment (0-100). If null, steps are equidistant to white.
  List<ColorSpacesIQ> lighterPalette([double? step]);

  /// Returns a palette of 5 colors progressively darker.
  /// [step] is the percentage increment (0-100). If null, steps are equidistant to black.
  List<ColorSpacesIQ> darkerPalette([double? step]);

  /// Returns a random color of the same type.
  ColorSpacesIQ get random;

  /// Compares this color with another color.
  bool isEqual(ColorSpacesIQ other);

  /// Returns the brightness of this color (light or dark).
  Brightness get brightness;

  /// Returns the relative luminance of this color (0.0 - 1.0).
  double get luminance;

  /// Blends this color with [other] by the given [amount] (0-100).
  /// Default is 50%.
  ColorSpacesIQ blend(ColorSpacesIQ other, [double amount = 50]);

  /// Makes the color more opaque by the given [amount] (0-100).
  /// Default is 20%.
  ColorSpacesIQ opaquer([double amount = 20]);

  /// Adjusts the hue of the color by the given [amount] (degrees).
  /// Default is +20 degrees.
  ColorSpacesIQ adjustHue([double amount = 20]);

  /// Returns the complementary color.
  ColorSpacesIQ get complementary;

  /// Returns true if the color is dark.
  bool get isDark => brightness == Brightness.dark;

  /// Returns true if the color is light.
  bool get isLight => brightness == Brightness.light;

  /// Makes the color warmer (shifts hue towards red/orange) by the given [amount] (0-100).
  /// Default is 20%.
  ColorSpacesIQ warmer([double amount = 20]);

  /// Makes the color cooler (shifts hue towards blue) by the given [amount] (0-100).
  /// Default is 20%.
  ColorSpacesIQ cooler([double amount = 20]);

  /// Returns a basic palette of 7 colors:
  /// [darkest, darker, dark, base, light, lighter, lightest].
  List<ColorSpacesIQ> generateBasicPalette();

  /// Returns a tones palette (base color mixed with grays).
  /// Returns 5 colors blending towards gray.
  List<ColorSpacesIQ> tonesPalette();

  /// Returns analogous colors.
  /// [count] can be 3 or 5.
  /// [offset] is the hue offset in degrees (default 30).
  List<ColorSpacesIQ> analogous({int count = 5, double offset = 30});

  /// Returns a square harmony palette (4 colors).
  /// Base, +90, +180, +270 degrees.
  List<ColorSpacesIQ> square();

  /// Returns a tetradic (rectangle) harmony palette (4 colors).
  /// Base, +60, +180, +240 degrees (default offset 60).
  /// [offset] is the hue offset for the second color pair (default 60).
  List<ColorSpacesIQ> tetrad({double offset = 60});

  /// Calculates the distance to another color using Cam16-UCS.
  double distanceTo(ColorSpacesIQ other);

  /// Calculates the contrast ratio with another color (1.0 to 21.0).
  double contrastWith(ColorSpacesIQ other);

  /// Returns the closest color slice from the HCT color wheel.
  ColorSlice closestColorSlice();

  /// Checks if the color is within the specified gamut.
  /// Default is [Gamut.sRGB].
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]);

  /// Returns the white point of the color space (XYZ values).
  /// Default is D65.
  List<double> get whitePoint;

  /// Converts the color to a JSON map.
  Map<String, dynamic> toJson();
}

/// The brightness of a color.
enum Brightness {
  dark,
  light,
}

/// Common color gamuts.
enum Gamut {
  sRGB,
  displayP3,
  rec2020,
  adobeRgb,
  proPhotoRgb,
}
