import 'dart:math';

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/maps/lrv_maps.dart';
import 'package:color_iq_utils/src/models/cam16_color.dart';
import 'package:color_iq_utils/src/models/cmyk_color.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:color_iq_utils/src/models/luv_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';
import 'package:color_iq_utils/src/utils/misc_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart' as mcu;
import 'package:material_color_utilities/hct/src/hct_solver.dart';

/// A mixin that provides common color model conversion methods.
mixin ColorModelsMixin {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;
  // int get alpha => value.alphaInt;
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

  LinRGB get alphaLinear => linearizeColorComponentDart(a);
  LinRGB get redLinear => linearizeColorComponentDart(r);
  LinRGB get greenLinear => linearizeColorComponentDart(g);
  LinRGB get blueLinear => linearizeColorComponentDart(b);

  RgbaInts get rgbaInts =>
      (alpha: alphaInt, red: red, green: green, blue: blue);
  RgbInts get rgbInts => (red: red, green: green, blue: blue);
  RgbaDoubles get rgbaDoubles => (a: a, r: r, g: g, b: b);
  List<LinRGB> get rgbaLinearized =>
      <LinRGB>[redLinearized, greenLinearized, blueLinearized, alphaLinearized];
  List<double> get linearSrgb =>
      <double>[redLinearized, greenLinearized, blueLinearized];

  List<int> get argb255Ints => <int>[alphaInt, red, green, blue];
  RgbaDoubles get rgbasNormalized => (r: r.val, g: g.val, b: b.val, a: a.val);

  /// Returns the transparency (alpha) as a double (0.0-1.0).
  double get transparency => value.a;

  /// The white point of the color space.
  ///
  /// Defaults to the D65 standard illuminant, which is used for sRGB and HCT.
  /// See [kWhitePointD65] for the exact values.
  List<double> get whitePoint => kWhitePointD65;

  String get descriptiveName => ColorNamerSuperSimple.instance.name(toColor());

  /// The relative luminance of this color.
  ///
  /// The value is in a range of `0.0` for darkest black to `1.0` for lightest
  /// white. This is a linear value, not perceptual.
  double get luminance => computeLuminance(r, g, b);

  Percent get toLRV => mapLRVs.getOrCreate(value);

  Brightness get brightness => calculateBrightness(toLRV);

  bool get isDark => brightness == Brightness.dark;

  bool get isLight => brightness == Brightness.light;

  ColorIQ toColor() => (this is ColorIQ) ? (this as ColorIQ) : ColorIQ(value);

  Cam16Color toCam16Color() =>
      (this is Cam16Color) ? (this as Cam16Color) : Cam16Color.fromInt(value);

  /// Converts this color the Cam16 instance from MaterialColorUtilities,
  /// used extensively for calculating distance
  mcu.Cam16 toCam16() {
    if (this is mcu.Cam16) {
      return this as mcu.Cam16;
    }
    // Convert to Cam16 (MaterialColorUtilities)
    return mcu.Cam16.fromInt(value);
  }

  HctColor toHctColor() =>
      (this is HctColor) ? (this as HctColor) : HctColor.fromInt(value);

  /// Converts this color to HSL.
  ///
  /// The hue value is in the range of 0 to 360, and the saturation and
  // lightness values are in the range of 0 to 1.
  HslColor toHslColor() =>
      (this is HslColor) ? (this as HslColor) : HslColor.fromInt(value);

  HsvColor toHsvColor() =>
      (this is HsvColor) ? this as HsvColor : HsvColor.fromInt(value);

  /// Converts this color to OkLab.
  OkLabColor toOkLab() =>
      (this is OkLabColor) ? this as OkLabColor : OkLabColor.fromInt(value);

  OkLCH toOkLch() => (this is OkLCH) ? (this as OkLCH) : OkLCH.fromInt(value);

  CmykColor toCmyk() =>
      (this is CmykColor) ? this as CmykColor : CmykColor.fromInt(value);

  XYZ toXyyColor() => (this is XYZ) ? (this as XYZ) : XYZ.fromInt(value);

  LuvColor toLuv() =>
      (this is LuvColor) ? this as LuvColor : LuvColor.fromInt(value);

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

  double distanceToArgb(final int argb) => toCam16().distance(argb.toCam16);

  /// Returns the grayscale value of the color.
  /// Converts a 32-bit ARGB color to grayscale using the given [method].
  int toGrayscale({final GrayscaleMethod method = GrayscaleMethod.luma}) =>
      GrayscaleConverter.toGrayscale(value, method: method);

  int get inverted => rgbToHexID(
      red: 255 - red, green: 255 - green, blue: 255 - blue, alpha: alphaInt);

  ColorSpacesIQ deintensify([final double amount = 10]) =>
      toHctColor().deintensify(amount);

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

  /// Decreases the [chroma] of this color by the given [amount].
  /// The resulting color will be less saturated.
  ///
  /// The [amount] must be between 0 and 100.
  /// Defaults to 25.

  ColorSpacesIQ desaturate([final double amount = 25]) {
    amount.assertRange0to100('desaturate');
    final HctColor hct = toHctColor();
    final double nuChroma = max(kMinChroma, hct.chroma - amount);
    final int hexID = HctSolver.solveToInt(hct.hue, nuChroma, hct.tone);
    return hct.copyWith(chroma: nuChroma, argb: hexID);
  }
}
