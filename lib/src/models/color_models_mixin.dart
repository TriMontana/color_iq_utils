import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/cmyk_color.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/luv_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';
import 'package:material_color_utilities/hct/cam16.dart' as mcu;

/// A mixin that provides common color model conversion methods.
mixin ColorModelsMixin {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;

  int get alphaInt => value.alphaInt;
  int get red => value.redInt;
  int get green => value.greenInt;
  int get blue => value.blueInt;
  Percent get a => value.a2;
  Percent get r => value.r2;
  Percent get g => value.g2;
  Percent get b => value.b2;
  LinRGB get redLinearized => value.redLinearized;
  LinRGB get greenLinearized => value.greenLinearized;
  LinRGB get blueLinearized => value.blueLinearized;
  LinRGB get alphaLinearized => value.alphaLinearized;

  RgbaInts get rgbaInts =>
      (alpha: alphaInt, red: red, green: green, blue: blue);
  RgbInts get rgbInts => (red: red, green: green, blue: blue);
  RgbaDoubles get rgbaDoubles => (a: a, r: r, g: g, b: b);
  List<LinRGB> get rgbaLinearized =>
      <LinRGB>[redLinearized, greenLinearized, blueLinearized, alphaLinearized];
  List<double> get linearSrgb =>
      <double>[redLinearized, greenLinearized, blueLinearized];

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
  mcu.Cam16 toCam16() {
    if (this is mcu.Cam16) {
      return this as mcu.Cam16;
    }
    // Convert to Cam16 (MaterialColorUtilities)
    return mcu.Cam16.fromInt(value);
  }

  /// Converts this color to HSL.
  ///
  /// The hue value is in the range of 0 to 360, and the saturation and
  // lightness values are in the range of 0 to 1.
  HslColor toHslColor() {
    if (this is HslColor) {
      return this as HslColor;
    }
    return HslColor.fromInt(value);
  }

  /// Converts this color to OkLab.
  OkLabColor toOkLab() {
    if (this is OkLabColor) {
      return this as OkLabColor;
    }
    return OkLabColor.fromInt(value);
  }

  OkLCH toOkLch() {
    if (this is OkLCH) {
      return this as OkLCH;
    }
    return OkLCH.fromInt(value);
  }

  CmykColor toCmyk() {
    if (this is CmykColor) {
      return this as CmykColor;
    }
    return CmykColor.fromInt(value);
  }

  HctColor toHctColor() {
    if (this is HctColor) {
      return this as HctColor;
    }
    return HctColor.fromInt(value);
  }

  LuvColor toLuv() {
    if (this is LuvColor) {
      return this as LuvColor;
    }
    return LuvColor.fromInt(value);
  }

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

  /// A measure of the perceptual difference between two colors.
  ///
  /// A value of 0 means the colors are identical, and a value of 100 means
  /// they are the furthest apart.
  ///
  /// The distance is calculated in the CAM16-UCS color space.
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());
}
