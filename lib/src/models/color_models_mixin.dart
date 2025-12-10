import 'dart:math';

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/maps/lrv_maps.dart';
import 'package:color_iq_utils/src/maps/registry.dart';
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
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/hct/src/hct_solver.dart';

// First, define the "Menu" of available models and the "Contract" that every model must fulfill.
/// The menu of available math models
enum ColorModel { hct, hsv, hsl, rgb }

/// The Strategy Interface
/// All logic classes must implement these standard transformations.
abstract class ManipulationStrategy {
  const ManipulationStrategy();

  int lighten(final int argb, final double amount);
  int darken(final int argb, final double amount);
  int saturate(final int argb, final double amount);
  int desaturate(final int argb, final double amount);
  int rotateHue(final int argb, final double amount);

  /// Intensifies the color by increasing chroma and slightly decreasing tone (half of factor).
  int intensify(final int argb, {final Percent amount = Percent.v15});

  /// De-intensifies (mutes) the color by decreasing chroma and slightly increasing tone (half of factor).
  int deintensify(final int argb, {final Percent amount = Percent.v15});
}

/// A mixin that provides common color model conversion methods.
mixin ColorModelsMixin {
  /// Returns the 32-bit integer ID (ARGB) of this color.
  int get value;

  /// A hex string representation of the color, e.g., "#FF0000" for red.
  String get hexStr => value.toHexStr;
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

  ArgbInts get rgbaInts =>
      (alpha: alphaInt, red: red, green: green, blue: blue);
  RgbInts get rgbInts => (red: red, green: green, blue: blue);
  ArgbDoubles get rgbaDoubles => (a: a, r: r, g: g, b: b);
  List<LinRGB> get rgbaLinearized =>
      <LinRGB>[redLinearized, greenLinearized, blueLinearized, alphaLinearized];
  List<double> get linearSrgb =>
      <double>[redLinearized, greenLinearized, blueLinearized];

  List<int> get argb255Ints => <int>[alphaInt, red, green, blue];
  ArgbDoubles get rgbasNormalized => (r: r.val, g: g.val, b: b.val, a: a.val);

  /// Returns the transparency (alpha) as a double (0.0-1.0).
  double get transparency => value.a;

  /// The white point of the color space.
  ///
  /// Defaults to the D65 standard illuminant, which is used for sRGB and HCT.
  /// See [kWhitePointD65] for the exact values.
  List<double> get whitePoint => kWhitePointD65;

  /// The descriptive name of this color.
  ///
  String get descriptiveName => ColorNamerSuperSimple.instance.name(toColor());

  /// The relative luminance of this color, 0.0 to 1.0.
  /// This is a linear value, not perceptual. This is typically cached
  /// because it is expensive to compute.
  double get luminance => computeLuminanceViaHexId(value);

  /// Same as luminance, but stored in global cache.
  Percent get toLrv => mapLRVs.getOrCreate(value);

  Brightness get brightness => calculateBrightness(toLrv);

  bool get isDark => brightness == Brightness.dark;

  bool get isLight => brightness == Brightness.light;

  ColorIQ toColor() => (this is ColorIQ)
      ? (this as ColorIQ)
      : (colorRegistry[value] ?? ColorIQ(value));

  /// Converts this color the Cam16 instance from MaterialColorUtilities,
  /// used extensively for calculating distance
  Cam16 toCam16() {
    if (this is Cam16) {
      return this as Cam16;
    }
    // Convert to Cam16 (MaterialColorUtilities)
    return Cam16.fromInt(value);
  }

  HctColor toHctColor() =>
      (this is HctColor) ? (this as HctColor) : HctColor.fromInt(value);

  /// Converts this color to HSL.
  ///
  /// The hue value is in the range of 0 to 360, and the saturation and
  // lightness values are in the range of 0 to 1.
  HSL toHslColor() => (this is HSL) ? (this as HSL) : HSL.fromInt(value);

  HSV toHsvColor() => (this is HSV) ? this as HSV : HSV.fromInt(value);

  /// Converts this color to OkLab.
  OkLabColor toOkLab() =>
      (this is OkLabColor) ? this as OkLabColor : OkLabColor.fromInt(value);

  OkLCH toOkLch() => (this is OkLCH) ? (this as OkLCH) : OkLCH.fromInt(value);

  CMYK toCmyk() => (this is CMYK) ? this as CMYK : CMYK.fromInt(value);

  XYZ toXyyColor() => (this is XYZ) ? (this as XYZ) : XYZ.fromInt(value);

  LuvColor toLuv() =>
      (this is LuvColor) ? this as LuvColor : LuvColor.fromInt(value);

  ColorTemperature get temperature {
    final HSL hsl = toHslColor();
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (hsl.h >= 90 && hsl.h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  // /// A measure of the perceptual difference between two colors.
  // ///
  // /// A value of 0 means the colors are identical, and a value of 100 means
  // /// they are the furthest apart.
  // ///
  // /// The distance is calculated in the CAM16-UCS color space.
  //  double distanceTo(final int other) =>
  //       toCam16().distance(other.toCam16());

  double distanceToArgb(final int otherColorId) =>
      toCam16().distance(otherColorId.toCam16);

  /// Returns the grayscale value of the color.
  /// Converts a 32-bit ARGB color to grayscale using the given [method].
  int toGrayscale({final GrayscaleMethod method = GrayscaleMethod.luma}) =>
      GrayscaleConverter.toGrayscale(value, method: method);

  int get inverted => rgbToHexID(
      red: 255 - red, green: 255 - green, blue: 255 - blue, alpha: alphaInt);

  // ColorSpacesIQ deintensify([final double amount = 10]) =>
  //     toHctColor().deintensify(amount);

  /// Decreases the transparency of a color by moving the Alpha channel closer to 255 (opaque).
  /// -- Maximum Transparency (fully invisible) = Alpha 0x00 (0)
  /// -- Minimum Transparency (fully opaque) = Alpha 0xFF (255)
  /// @param color The original Color.
  /// @param factor The fraction of opacity to add (0.0 to 1.0).
  ///               A factor of 0.5 means 50% of the remaining transparency will be filled.
  /// @returns A new Color instance with decreased transparency.
  ColorSpacesIQ decreaseTransparency([final Percent amount = Percent.v20]) {
    final ColorIQ color = toColor();
    if (amount.val == 0) {
      return color;
    }
    final double currentOpacity = a.val;
    final double transparencyGap = 1.0 - currentOpacity;

    // 2. Calculate the amount of the gap to fill: transparencyGap * factor
    // Example: If alpha is 0.5, gap is 0.5. If factor is 0.4, fill 0.5 * 0.4 = 0.2
    // New alpha is currentOpacity + amountToFill = 0.5 + 0.2 = 0.7
    final double amountToFill = transparencyGap * amount.val;
    return color.withValues(aVal: Percent(currentOpacity + amountToFill));
  }

  /// Increases the transparency of a color by moving the Alpha channel closer to 0.
  /// -- Maximum Transparency (fully invisible) = Alpha 0x00 (0)
  /// -- Minimum Transparency (fully opaque) = Alpha 0xFF (255)
  ///
  /// @param color The original Color.
  /// @param factor The fraction of transparency to add (0.0 to 1.0).
  ///               A factor of 0.5 means 50% of the current opacity will be removed.
  /// @returns A new Color instance with increased transparency.
  ColorSpacesIQ increaseTransparency([final Percent amount = Percent.v20]) {
    final ColorIQ color = toColor();
    if (amount.val == 0) {
      return color;
    }

    final double currentAlpha = a.val;
    // 2. Calculate the new alpha: currentAlpha * (1.0 - factor)
    // Example: If alpha is 0.8 and factor is 0.5, new alpha is 0.8 * 0.5 = 0.4
    final Percent newAlphaDouble = Percent(currentAlpha * (1.0 - amount.value));

    return color.withValues(aVal: newAlphaDouble);
  }

  /// Returns the closest color slice from the HCT color wheel.
  ColorSlice closestColorSlice() {
    ColorSlice? closest;
    double minDistance = double.infinity;

    for (final ColorSlice slice in hctSlices) {
      final double dist = distanceToArgb(slice.color.hexId);
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

  ColorSpacesIQ brighten([final Percent amount = Percent.v20]) {
    return toHsvColor().brighten(amount).toColor();
  }

  // Calculate
  double calculateLrvAsPercent() {
    // Decode RGB
    final int r = (value >> 16) & 0xFF;
    final int g = (value >> 8) & 0xFF;
    final int b = value & 0xFF;

    final double linR = r.linearizeUint8;
    final double linG = g.linearizeUint8;
    final double linB = b.linearizeUint8;

    // Standard Luminance Formula
    final double y = (0.2126 * linR) + (0.7152 * linG) + (0.0722 * linB);

    // Scale to 0-100 range for standard LRV usage
    return (y * 100.0);
  }
}
