import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart' as mcu;

export 'color_wheels.dart';
export 'utils/color_blindness.dart';

/// An abstract base class providing common properties for color representations.
///
/// `CommonIQ` serves as a foundational building block for various color
/// model implementations within the library. It encapsulates shared attributes
/// such as a unique color ID, a list of associated names, and an alpha
/// (transparency) value.
///
/// By extending or mixing in `CommonIQ`, concrete color classes inherit a
/// standardized structure for these common properties.
abstract class CommonIQ with ColorModelsMixin {
  /// An optional integer identifier for the color, often used for mapping to
  /// predefined color palettes or databases.
  final int? colorId;

  /// A list of human-readable names associated with the color (e.g., "Red", "Sky Blue").
  final List<String> names;

  /// The alpha (transparency) value of the color, represented as a [Percent].
  final Percent alpha;

  const CommonIQ(this.colorId,
      {this.alpha = Percent.max, this.names = kEmptyNames});
}

/// A common parent class and interface for all color models.
///
/// `ColorSpacesIQ` defines a standard contract for color representations,
/// enabling seamless conversion and manipulation across various color models.
/// It ensures that any color object can be converted to other models,
/// manipulated (e.g., lightened, saturated), and analyzed (e.g., luminance,
/// contrast) in a consistent manner.
abstract interface class ColorSpacesIQ {
  /// The 32-bit integer representing the ARGB color value.
  ///
  /// This is the canonical representation used for conversions and interoperability.
  int get value;

  /// A list of names associated with the color, if any.
  List<String> get names;

  /// A hex string representation of the color, e.g., "#FF0000" for red.
  String get hexStr => value.toHexStr;

  /// The relative luminance of this color.
  ///
  /// The value is in a range of `0.0` for darkest black to `1.0` for lightest
  /// white. This is a linear value, not perceptual. This is typically cached
  /// because it is expensive to compute.
  double get luminance => computeLuminanceViaHexId(value);

  /// Converts the color to the standard ARGB [ColorIQ] format.
  ColorIQ toColor() => ColorIQ(value);

  /// Converts this color to HCTColor.
  HctColor toHctColor() => HctColor.fromInt(value);

  /// Converts this color to the CAM16 color space.
  /// CAM16 is a color appearance model used for calculating perceptual
  /// attributes like hue, chroma, and lightness.  Note: This uses
  /// [Cam16] from MaterialColorUtilities (not Cam16Color), as it is frequently
  /// used for distance computations
  mcu.Cam16 toCam16() => mcu.Cam16.fromInt(value);

  /// Converts this color to HSL (Hue, Saturation, Lightness).
  HSL toHslColor() => HSL.fromInt(value);

  /// Converts this color to HSV (Hue, Saturation, Value).
  HSV toHsvColor() => HSV.fromInt(value);

  /// Converts this color to XYZ (CIE 1931).
  XYZ toXyyColor() => XYZ.fromInt(value);

  /// Converts this color to the Oklab color space.
  OkLabColor toOkLab() => OkLabColor.fromInt(value);

  /// Converts this color to the Oklch color space.
  OkLCH toOkLch() => OkLCH.fromInt(value);

  /// Returns the white point of the color space (XYZ values).
  /// Default is D65.
  List<double> get whitePoint => kWhitePointD65;

  // ======= Methods To Implement =========  //

  ColorSlice closestColorSlice();

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

  /// Whitens the color by mixing with white. [amount] is 0-100.
  ColorSpacesIQ whiten([final double amount = 20]);

  /// Blackens the color by mixing with black. [amount] is 0-100.
  ColorSpacesIQ blacken([final double amount = 20]);

  /// Linearly interpolates between this color and [other]. [t] is 0.0-1.0.
  ColorSpacesIQ lerp(final ColorSpacesIQ other, final double t);

  /// Adjusts the transparency of the color.
  /// Maximum Transparency (fully invisible) = Alpha 0x00 (0)
  /// Minimum Transparency (fully opaque) = Alpha 0xFF (255)
  ColorSpacesIQ increaseTransparency([final Percent amount = Percent.v20]);
  ColorSpacesIQ decreaseTransparency([final Percent amount = Percent.v20]);

  /// Creates a new instance of this color type from an HCT color.
  /// Intensifies the color by increasing chroma and slightly decreasing tone.
  ColorSpacesIQ intensify([final double amount = 10]);

  /// De-intensifies (mutes) the color by decreasing chroma and slightly increasing tone.
  ColorSpacesIQ deintensify([final double amount = 10]);

  /// Creates an accented version of this color.
  /// Increases chroma and brightness to make the color stand out.
  ColorSpacesIQ accented([final double amount = 15]);

  /// Simulates color blindness on this color.
  ColorSpacesIQ simulate(final ColorBlindnessType type);

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
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());

  /// Calculates the distance to another color ID using Cam16-UCS.
  double distanceToArgb(final int argb) => toCam16().distance(argb.toCam16);

  /// Calculates the contrast ratio with another color (1.0 to 21.0).
  double contrastWith(final ColorSpacesIQ other);

  /// Checks if the color is within the specified gamut.
  /// Default is [Gamut.sRGB].
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]);

  /// Converts the color to a JSON map.
  Map<String, dynamic> toJson();
}
