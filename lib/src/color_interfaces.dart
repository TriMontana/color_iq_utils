import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/maps/lrv_maps.dart';
import 'package:material_color_utilities/hct/cam16.dart' as mcucam16;

export 'color_wheels.dart';
export 'utils/color_blindness.dart';

/// A common parent class and interface for all color models.
abstract class ColorSpacesIQ {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  /// The 32-bit alpha-red-green-blue integer value.
  final int value;
  final Percent a;
  final double r;
  final double g;
  final double b;
  final int redInt;
  final int greenInt;
  final int blueInt;
  final Percent? lrv;
  final List<String> names;

  /// Constructs a color from an integer.
  const ColorSpacesIQ(this.value,
      {required this.a,
      final double? r,
      final double? g,
      final double? b,
      this.lrv,
      final int? redIntVal,
      final int? greenIntVal,
      final int? blueIntVal,
      this.names = const <String>[]})
      : r = r ?? (value >> 16 & 0xFF) / 255.0,
        g = g ?? (value >> 8 & 0xFF) / 255.0,
        b = b ?? (value & 0xFF) / 255.0,
        redInt = redIntVal ?? (value >> 16 & 0xFF),
        greenInt = greenIntVal ?? (value >> 8 & 0xFF),
        blueInt = blueIntVal ?? (value & 0xFF);
  const ColorSpacesIQ.alt({
    required this.value,
    required this.a,
    final double? r,
    final double? g,
    final double? b,
    this.lrv,
    final int? redIntVal,
    final int? greenIntVal,
    final int? blueIntVal,
    this.names = const <String>[],
  })  : // a = a ?? (value >> 24 & 0xFF) / 255.0,
        r = r ?? (value >> 16 & 0xFF) / 255.0,
        g = g ?? (value >> 8 & 0xFF) / 255.0,
        b = b ?? (value & 0xFF) / 255.0,
        redInt = redIntVal ?? (value >> 16 & 0xFF),
        greenInt = greenIntVal ?? (value >> 8 & 0xFF),
        blueInt = blueIntVal ?? (value & 0xFF);

  double get alphaLinearized => linearizeColorComponentDart(a);
  double get redLinearized => linearizeColorComponentDart(r);
  double get greenLinearized => linearizeColorComponentDart(g);
  double get blueLinearized => linearizeColorComponentDart(b);
  int get alphaInt => value >> 24 & 0xFF;

  List<int> get argb255Ints => <int>[alphaInt, redInt, greenInt, blueInt];
  List<int> get rgba255Ints => <int>[redInt, greenInt, blueInt, alphaInt];
  List<int> get rgb255Ints => <int>[redInt, greenInt, blueInt];
  List<double> get rgbaLinearized =>
      <double>[redLinearized, greenLinearized, blueLinearized, alphaLinearized];
  RgbaDoubles get rgbasNormalized => (r: r, g: g, b: b, a: a);
  RgbaInts get rgbaInts => (
        alpha: value.alphaInt,
        red: redInt,
        green: value.greenInt,
        blue: value.blueInt
      );
  RgbaDoubles get rgbaDoubles => (a: a, r: r, g: g, b: b);

  /// Returns the relative luminance of this color (0.0 - 1.0).
  Percent get toLRV => lrv ?? mapLRVs.getOrCreate(value);

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

  /// Returns the grayscale value of the color.
  int toGrayscale({final GrayscaleMethod method = GrayscaleMethod.luma}) {
    return GrayscaleConverter.toGrayscale(value, method: method);
  }

  /// Returns the grayscale version of the color.
  ColorSpacesIQ get grayscale => toHctColor().withChroma(0);

  ColorSpacesIQ get inverted {
    return ColorIQ.fromARGB(
        alphaInt, 255 - redInt, 255 - greenInt, 255 - blueInt);
  }

  /// Converts the color to the standard ARGB [ColorIQ] format.
  ColorIQ toColor() => ColorIQ(value);

  /// Converts this color to HCTColor.
  HctColor toHctColor() => HctColor.fromInt(value);

  /// Converts this color to HCTColor.
  ColorSpacesIQ fromHct(final HctColor hct);

  /// Converts this color to the CAM16 color space.
  /// CAM16 is a color appearance model used for calculating perceptual
  /// attributes like hue, chroma, and lightness.  Note: This uses
  /// [Cam16] from MaterialColorUtilities (not Cam16Color), as it is frequently
  /// used for distance computations
  mcucam16.Cam16 toCam16() => mcucam16.Cam16.fromInt(value);

  /// Converts this color to CAM16Color.
  Cam16Color toCam16Color() => Cam16Color.fromInt(value);

  /// Converts this color to HSL (Hue, Saturation, Lightness).
  HslColor toHslColor() => HslColor.fromInt(value);

  /// Converts this color to HSV (Hue, Saturation, Value).
  HsvColor toHsvColor() => HsvColor.fromInt(value);

  /// Converts this color to XYZ (CIE 1931).
  XYZ toXyyColor() => XYZ.fromInt(value);

  /// Converts this color to the Oklab color space.
  OkLabColor toOkLab() => OkLabColor.fromInt(value);

  /// Converts this color to the Oklch color space.
  OkLCH toOkLch() => OkLCH.fromInt(value);

  /// Returns the closest color slice from the HCT color wheel.
  ColorSlice closestColorSlice() {
    ColorSlice? closest;
    double minDistance = double.infinity;

    for (final ColorSlice slice in hctSlices) {
      final double dist = distanceTo(slice.color);
      if (dist < minDistance) {
        minDistance = dist;
        closest = slice;
      }
    }
    return closest!;
  }

  /// Returns the transparency (alpha) as a double (0.0-1.0).
  double get transparency => a.val;

  /// Returns the color temperature (Warm or Cool), as determined by the color space
  ColorTemperature get temperature {
    final HslColor hsl = toHslColor();
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (hsl.h >= 90 && hsl.h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Returns the white point of the color space (XYZ values).
  /// Default is D65.
  List<double> get whitePoint => kWhitePointD65;

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

  /// Adjusts the transparency of the color. [amount] is 0-100.
  ColorSpacesIQ adjustTransparency([final double amount = 20]);

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

  double distanceToArgb(final int argb) => toCam16().distance(argb.toCam16);

  /// Calculates the contrast ratio with another color (1.0 to 21.0).
  double contrastWith(final ColorSpacesIQ other);

  /// Checks if the color is within the specified gamut.
  /// Default is [Gamut.sRGB].
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]);

  /// Converts the color to a JSON map.
  Map<String, dynamic> toJson();
}
