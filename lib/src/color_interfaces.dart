import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:material_color_utilities/hct/cam16.dart';

export 'color_blindness.dart';
export 'color_wheels.dart';

/// A common parent class and interface for all color models.
abstract class ColorSpacesIQ {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  /// The 32-bit alpha-red-green-blue integer value.
  final int value;
  final double a;
  final double r;
  final double g;
  final double b;
  final int redInt;
  final double? lrv;

  /// Constructs a color from an integer.
  const ColorSpacesIQ(this.value,
      {final double? a,
      final double? r,
      final double? g,
      final double? b,
      this.lrv,
      final int? redIntVal})
      : a = a ?? (value >> 24 & 0xFF) / 255.0,
        r = r ?? (value >> 16 & 0xFF) / 255.0,
        g = g ?? (value >> 8 & 0xFF) / 255.0,
        b = b ?? (value & 0xFF) / 255.0,
        redInt = redIntVal ?? (value >> 16 & 0xFF);
  const ColorSpacesIQ.alt({
    required this.value,
    final double? a,
    final double? r,
    final double? g,
    final double? b,
    this.lrv,
    final int? redIntVal,
  })  : a = a ?? (value >> 24 & 0xFF) / 255.0,
        r = r ?? (value >> 16 & 0xFF) / 255.0,
        g = g ?? (value >> 8 & 0xFF) / 255.0,
        b = b ?? (value & 0xFF) / 255.0,
        redInt = redIntVal ?? (value >> 16 & 0xFF);

  double get alphaLinearized => linearizeColorComponentDart(a);
  double get redLinearized => linearizeColorComponentDart(r);
  double get greenLinearized => linearizeColorComponentDart(g);
  double get blueLinearized => linearizeColorComponentDart(b);

  List<int> get argb255Ints =>
      <int>[value.alphaInt, redInt, value.greenInt, value.blueInt];
  List<int> get rgba255Ints =>
      <int>[redInt, value.greenInt, value.blueInt, value.alphaInt];
  List<int> get rgb255Ints => <int>[redInt, value.greenInt, value.blueInt];
  List<double> get rgbaLinearized =>
      <double>[redLinearized, greenLinearized, blueLinearized, alphaLinearized];

  /// Returns the relative luminance of this color (0.0 - 1.0).
  double get toLRV =>
      lrv ??
      (0.2126 * redLinearized +
          0.7152 * greenLinearized +
          0.0722 * blueLinearized);

  /// Returns the brightness of this color (light or dark).
  Brightness get brightness {
    // Based on ThemeData.estimateBrightnessForColor
    final double relativeLuminance = toLRV;
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold) {
      return Brightness.light;
    }
    return Brightness.dark;
  }

  /// Returns true if the color is dark.
  bool get isDark => brightness == Brightness.dark;

  /// Returns true if the color is light.
  bool get isLight => brightness == Brightness.light;

  int toGrayscale({final GrayscaleMethod method = GrayscaleMethod.luma}) {
    return GrayscaleConverter.toGrayscale(value, method: method);
  }

  /// Lightens the color by the given [amount] (0-100).
  ColorSpacesIQ lighten([final double amount = 20]);

  /// Darkens the color by the given [amount] (0-100).
  ColorSpacesIQ darken([final double amount = 20]);

  /// Brightens the color by the given [amount] (0-100).
  /// Increases the brightness/value (HSV Value).
  ColorSpacesIQ brighten([final double amount = 20]);

  /// Saturates the color by the given [amount] (0-100).
  ColorSpacesIQ saturate([final double amount = 25]);

  /// Desaturates the color by the given [amount] (0-100).
  ColorSpacesIQ desaturate([final double amount = 25]);

  /// Returns the inverted color.
  ColorSpacesIQ get inverted;

  /// Returns the grayscale version of this color.
  ColorSpacesIQ get grayscale;

  /// Whitens the color by mixing with white. [amount] is 0-100.
  ColorSpacesIQ whiten([final double amount = 20]);

  /// Blackens the color by mixing with black. [amount] is 0-100.
  ColorSpacesIQ blacken([final double amount = 20]);

  /// Linearly interpolates between this color and [other]. [t] is 0.0-1.0.
  ColorSpacesIQ lerp(final ColorSpacesIQ other, final double t);

  /// Adjusts the transparency of the color. [amount] is 0-100.
  ColorSpacesIQ adjustTransparency([final double amount = 20]);

  /// Converts the color to the standard ARGB [ColorIQ] format.
  ColorIQ toColor();

  /// Converts this color to HCTColor.
  HctColor toHctColor();

  ColorSpacesIQ fromHct(final HctColor hct);

  /// Converts this color to the CAM16 color space.
  /// CAM16 is a color appearance model used for calculating perceptual
  /// attributes like hue, chroma, and lightness.  Note: This uses
  /// [Cam16] from MaterialColorUtilities (not Cam16Color), as it is frequently
  /// used for distance computations
  Cam16 toCam16();

  /// Converts this color to HSL (Hue, Saturation, Lightness).
  HslColor toHslColor();

  /// Converts this color to the Oklab color space.
  OkLabColor toOkLab();

  /// Creates a new instance of this color type from an HCT color.
  /// Intensifies the color by increasing chroma and slightly decreasing tone.
  ColorSpacesIQ intensify([final double amount = 10]);

  /// Deintensifies (mutes) the color by decreasing chroma and slightly increasing tone.
  ColorSpacesIQ deintensify([final double amount = 10]);

  /// Creates an accented version of this color.
  /// Increases chroma and brightness to make the color stand out.
  ColorSpacesIQ accented([final double amount = 15]);

  /// Simulates color blindness on this color.
  ColorSpacesIQ simulate(final ColorBlindnessType type);

  /// Returns the transparency (alpha) as a double (0.0-1.0).
  double get transparency;

  /// Returns the color temperature (Warm or Cool).
  ColorTemperature get temperature;

  /// Returns a monochromatic palette.
  /// A monochromatic color scheme consists of variations of a single hue.
  /// This method returns a list of 5 colors, including shades (darker) and
  /// tints (lighter) of the base color.
  List<ColorSpacesIQ> get monochromatic;

  /// Returns a palette of 5 colors progressively lighter.
  /// [step] is the percentage increment (0-100). If null, steps are equidistant to white.
  List<ColorSpacesIQ> lighterPalette([final double? step]);

  /// Returns a palette of 5 colors progressively darker.
  /// [step] is the percentage increment (0-100). If null, steps are equidistant to black.
  List<ColorSpacesIQ> darkerPalette([final double? step]);

  /// Returns a random color of the same type.
  ColorSpacesIQ get random;

  /// Compares this color with another color.
  bool isEqual(final ColorSpacesIQ other);

  /// Blends this color with [other] by the given [amount] (0-100).
  /// Default is 50%.
  ColorSpacesIQ blend(final ColorSpacesIQ other, [final double amount = 50]);

  /// Makes the color more opaque by the given [amount] (0-100).
  /// Default is 20%.
  ColorSpacesIQ opaquer([final double amount = 20]);

  /// Adjusts the hue of the color by the given [amount] (degrees).
  /// Default is +20 degrees.
  ColorSpacesIQ adjustHue([final double amount = 20]);

  /// Returns the complementary color.
  ColorSpacesIQ get complementary;

  /// Makes the color warmer (shifts hue towards red/orange) by the given [amount] (0-100).
  /// Default is 20%.
  ColorSpacesIQ warmer([final double amount = 20]);

  /// Makes the color cooler (shifts hue towards blue) by the given [amount] (0-100).
  /// Default is 20%.
  ColorSpacesIQ cooler([final double amount = 20]);

  /// Returns a basic palette of 7 colors:
  /// [darkest, darker, dark, base, light, lighter, lightest].
  List<ColorSpacesIQ> generateBasicPalette();

  /// Returns a tones palette (base color mixed with grays).
  /// Returns 5 colors blending towards gray.
  List<ColorSpacesIQ> tonesPalette();

  /// Returns analogous colors.
  /// [count] can be 3 or 5.
  /// [offset] is the hue offset in degrees (default 30).
  List<ColorSpacesIQ> analogous({
    final int count = 5,
    final double offset = 30,
  });

  /// Returns a square harmony palette (4 colors).
  /// Base, +90, +180, +270 degrees.
  List<ColorSpacesIQ> square();

  /// Returns a tetradic (rectangle) harmony palette (4 colors).
  /// Base, +60, +180, +240 degrees (default offset 60).
  /// [offset] is the hue offset for the second color pair (default 60).
  List<ColorSpacesIQ> tetrad({final double offset = 60});

  /// Calculates the distance to another color using Cam16-UCS.
  double distanceTo(final ColorSpacesIQ other);

  /// Calculates the contrast ratio with another color (1.0 to 21.0).
  double contrastWith(final ColorSpacesIQ other);

  /// Returns the closest color slice from the HCT color wheel.
  ColorSlice closestColorSlice();

  /// Checks if the color is within the specified gamut.
  /// Default is [Gamut.sRGB].
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]);

  /// Returns the white point of the color space (XYZ values).
  /// Default is D65.
  List<double> get whitePoint;

  /// Converts the color to a JSON map.
  Map<String, dynamic> toJson();
}
