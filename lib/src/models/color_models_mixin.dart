import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:material_color_utilities/hct/cam16.dart';

mixin ColorModelsMixin {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;

  int get alphaInt => value.alphaInt;
  int get red => value.redInt;
  int get green => value.greenInt;
  int get blue => value.blueInt;
  double get a => value.a2;
  double get r => value.r2;
  double get g => value.g2;
  double get b => value.b2;

  /// The white point of the color space.
  ///
  /// Defaults to the D65 standard illuminant, which is used for sRGB and HCT.
  /// See [kWhitePointD65] for the exact values.
  List<double> get whitePoint => kWhitePointD65;

  /// The relative luminance of this color.
  ///
  /// The value is in a range of `0.0` for darkest black to `1.0` for lightest
  /// white. This is a linear value, not perceptual.
  double get luminance => computeLuminance(r, g, b);

  /// Converts this color the Cam16 instance from MaterialColorUtilities,
  /// used extensively for calculating distance
  Cam16 toCam16() => Cam16.fromInt(value);

  /// Converts this color to HSL.
  ///
  /// The hue value is in the range of 0 to 360, and the saturation and
  // lightness values are in the range of 0 to 1.
  HslColor toHslColor() => HslColor.fromInt(value);

  /// Converts this color to OkLab.
  OkLabColor toOkLab() => OkLabColor.fromInt(value);

  /// A measure of the perceptual difference between two colors.
  ///
  /// A value of 0 means the colors are identical, and a value of 100 means
  /// they are the furthest apart.
  ///
  /// The distance is calculated in the CAM16-UCS color space.
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());
}
