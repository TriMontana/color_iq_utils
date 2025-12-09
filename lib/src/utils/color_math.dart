import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';

/// Add gamma correction to a linear RGB component, aka delinear or delinearized
const double Function(double linearComponent) delinearize =
    linearToSrgb; // aka gammaCorrect
const double Function(double linearComponent) gammaCorrect = linearToSrgb;
const double Function(double linearComponent) fromLinear = linearToSrgb;
const double Function(double srgbComponent) linearize = srgbToLinear;
const double Function(double srgbComponent) toLinear = srgbToLinear;
const LinRGB Function(double nonLinearVal, {String? msg}) removeGamma = eotf;
const Percent Function(double linearRgb, {String? msg}) applyGamma = oetf;

// -------------------------------------------------------------------
// ARGB & Component Extraction
// -------------------------------------------------------------------
typedef RgbInts = ({int red, int green, int blue});
typedef RgbDoubles = ({double r, double g, double b});
typedef RgbaInts = ({int alpha, int red, int green, int blue});
typedef RgbaDoubles = ({double a, double r, double g, double b});

/// Returns the alpha, red, green, and blue components of a color in ARGB format.
List<int> argbToComponents(final int argb) {
  return <int>[argb >> 24 & 255, argb >> 16 & 255, argb >> 8 & 255, argb & 255];
}

/// Returns the alpha, red, green, and blue components of a color in ARGB format.
///
/// This is a convenience method that returns a record with named fields.
///
/// [argb] is the 32-bit integer representing the color.
///
/// Returns a record [RgbaInts].
RgbaInts hexIdToComponents(final int argb) {
  final int alpha = (argb >> 24) & 0xFF;
  final int red = (argb >> 16) & 0xFF;
  final int green = (argb >> 8) & 0xFF;
  final int blue = argb & 0xFF;
  return (alpha: alpha, red: red, green: green, blue: blue);
}

/// Returns the normalized alpha, red, green, and blue components of a color in ARGB format.
///
/// This is a convenience method that returns a record with named fields.
///
/// [argb] is the 32-bit integer representing the color.
///
/// Returns a record [RgbaDoubles] where each component is between 0.0 and 1.0.
RgbaDoubles hexIdToNormalizedComponents(final int argb) {
  final double an = (((argb >> 24) & 0xFF) / 255.0).clamp(0.0, 1.0);
  final double rn = (((argb >> 16) & 0xFF) / 255.0).clamp(0.0, 1.0);
  final double gn = (((argb >> 8) & 0xFF) / 255.0).clamp(0.0, 1.0);
  final double bn = (((argb) & 0xFF) / 255.0).clamp(0.0, 1.0);
  return (a: an, r: rn, g: gn, b: bn);
}

/// Returns the alpha component of a color in ARGB format.
int alphaFromArgb(final int argb) {
  return argb >> 24 & 255;
}

/// Returns the red component of a color in ARGB format.
int redFromArgb(final int argb) {
  return argb >> 16 & 255;
}

/// Returns the green component of a color in ARGB format.
int greenFromArgb(final int argb) {
  return argb >> 8 & 255;
}

/// Returns the blue component of a color in ARGB format.
int blueFromArgb(final int argb) {
  return argb & 255;
}

/// Returns whether a color in ARGB format is opaque.
bool isOpaque(final int argb) => alphaFromArgb(argb) >= 255;

/// Converts a color from RGB components to ARGB format.
int argbFromRgb(final int red, final int green, final int blue,
    [final int alpha = 255]) {
  red.assertRange0to255('argbFromRgba:   red');
  green.assertRange0to255('argbFromRgba: green');
  blue.assertRange0to255('argbFromRgba: blue');
  alpha.assertRange0to255('argbFromRgba: alpha');
  return (alpha << 24) | (red << 16) | (green << 8) | blue;
}

// -------------------------------------------------------------------
// RGB/Hex & Float/Int Conversions
// -------------------------------------------------------------------

/// Converts RGB(A) components to a 32-bit ARGB hex integer.
/// All components must be 8-bit unsigned integers (0-255).
int rgbToHexID({
  required final int red,
  required final int green,
  required final int blue,
  final int alpha = 255,
}) {
  red.assertRange0to255('rgbToHexID:   red');
  green.assertRange0to255('rgbToHexID: green');
  blue.assertRange0to255('rgbToHexID: blue');
  alpha.assertRange0to255('rgbToHexID: alpha');
  // Compose ARGB 32-bit integer: (alpha << 24) | (red << 16) | (green << 8) | blue
  final int hexVal = (alpha << 24) | (red << 16) | (green << 8) | blue;
  return (hexVal & 0xFFFFFFFF);
}

/// CREDIT: Dart.ui library
int floatToInt8(final double x) {
  return (x * 255.0).round().clamp(0, 255);
}

/// Converts RGB(A) double values (0.0–1.0) to a 32-bit ARGB hex integer.
/// Alpha defaults to 1.0 (fully opaque).
int rgbDoublesToHexId({
  required final double r,
  required final double g,
  required final double b,
  final double a = maxFloat8,
}) {
  // Clamp and ops each channel to Uint8 (0–255)
  final int alpha = floatToInt8Hex(a);
  final int red = floatToInt8Hex(r);
  final int green = floatToInt8Hex(g);
  final int blue = floatToInt8Hex(b);

  return rgbToHexID(red: red, green: green, blue: blue, alpha: alpha);
}

/// Converts RGB(A) double values (0.0–1.0) to a 32-bit ARGB hex integer.
/// Alpha defaults to 1.0 (fully opaque).
int percentsToHexId({
  required final Percent r,
  required final Percent g,
  required final Percent b,
  final Percent a = Percent.max,
}) =>
    ((a.value * 255).round() << 24 |
        (r.value * 255).round() << 16 |
        (g.value * 255).round() << 8 |
        (b.value * 255).round());

/// Converts RGB(A) double values (0.0–1.0) to a 32-bit ARGB hex integer.
/// Alpha defaults to 1.0 (fully opaque).
int doublesToHexId({
  required final double r,
  required final double g,
  required final double b,
  final double a = 1.0,
}) {
  r.assertRange0to1('doublesToHexId-r');
  g.assertRange0to1('doublesToHexId-g');
  b.assertRange0to1('doublesToHexId-b');
  a.assertRange0to1('doublesToHexId-a');
  return ((a * 255).round() << 24 |
      (r * 255).round() << 16 |
      (g * 255).round() << 8 |
      (b * 255).round());
}

/// Returns the 8-bit hex number from a double value in the range
/// of 0.0 to 1.0 symbol of a single r,g,b.  See warning in Dart library
/// about lossy potentialities.
/// CREDIT: from Dart [Color] class, lib\ui\painting.dart
int floatToInt8Hex(
  final double dbl0to1, {
  final String? msg,
  final double? tolerance,
}) {
  // clamp within specified tolerance
  final double percent = dbl0to1.assertPercentage(
    msg: msg,
    tolerance: tolerance,
  );
  // must have (val * 255.0).round()) & 0xff) or   (val * 255.0).round().clamp(0, 255);
  // (r * 255.0).round().clamp(0, 255)
  return (percent * 255.0).round().clamp(0, 255);
}

// -------------------------------------------------------------------
// sRGB & Linear RGB Conversions
// -------------------------------------------------------------------
/// Returns a brightness value between 0 for darkest and 1 for lightest.
///
/// Represents the relative luminance of the color. This value is computationally
/// expensive to calculate.  Note that this uses a different cutoff
/// than most other linearize functions
///
/// See <https://en.wikipedia.org/wiki/Relative_luminance>.
/// See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
Percent computeLuminance(final double r, final double g, final double b) {
// assert(colorSpace != ColorSpace.extendedSRGB);
  final double R =
      linearizeColorComponentDart(r.assertRange0to1('computeLuminance-r'));
  final double G =
      linearizeColorComponentDart(g.assertRange0to1('computeLuminance-g'));
  final double B =
      linearizeColorComponentDart(b.assertRange0to1('computeLuminance-b'));
  return computeLuminanceViaLinearized(R, G, B);
}

/// Returns a brightness value between 0 for darkest and 1 for lightest.
///
/// Represents the relative luminance of the color. This value is computationally
/// expensive to calculate.  Note that this uses a different cutoff
/// than most other linearize functions
///
/// See <https://en.wikipedia.org/wiki/Relative_luminance>.
/// See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
Percent computeLuminanceViaLinearized(final double redLinearized,
    final double greenLinearized, final double blueLinearized) {
  redLinearized.assertRange0to1('computeLuminanceViaLinearized-redLinearized');
  greenLinearized
      .assertRange0to1('computeLuminanceViaLinearized-greenLinearized');
  blueLinearized
      .assertRange0to1('computeLuminanceViaLinearized-blueLinearized');
  return Percent(0.2126 * redLinearized +
      0.7152 * greenLinearized +
      0.0722 * blueLinearized);
}

/// Returns a brightness value between 0 for darkest and 1 for lightest.
///
/// Represents the relative luminance of the color. This value is computationally
/// expensive to calculate.  Note that this uses a different cutoff
/// than most other linearize functions
///
/// See <https://en.wikipedia.org/wiki/Relative_luminance>.
/// See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
double computeLuminanceViaHexId(final int hexId) =>
    computeLuminanceViaLinearized(
        hexId.redLinearized, hexId.greenLinearized, hexId.blueLinearized);

/// Returns a brightness value between 0 for darkest and 1 for lightest.
///
/// Represents the relative luminance of the color. This value is computationally
/// expensive to calculate.  Note that this uses a different cutoff
/// than most other linearize functions
///
/// See <https://en.wikipedia.org/wiki/Relative_luminance>.
/// See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
Percent computeLuminanceViaInts(
        final int red, final int green, final int blue) =>
    computeLuminance(red.normalized, green.normalized, blue.normalized);

// See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
// This is Dart specific; it uses a different cutoff
LinRGB linearizeColorComponentDart(final double srgbComponent) {
  // clamp within specified tolerance
  srgbComponent.assertRange0to1('linearizeColorComponentDart');
  if (srgbComponent <= 0.03928) {
    return LinRGB((srgbComponent / 12.92).clamp(0.0, 1.0));
  }
  return LinRGB(
      pow((srgbComponent + 0.055) / 1.055, 2.4).toDouble().clamp(0.0, 1.0));
}

/// Converts a normalized sRGB (gamma-encoded) double component [0.0 - 1.0]
/// to a linear intensity sRGB double component [0.0 - 1.0].
/// These follow the official sRGB transfer function (IEC 61966-2-1),
/// used for WCAG, color science, XYZ conversion, etc.
/// This is the official sRGB EOTF/OETF (Electro-Optical Transfer Function).
///
/// This is also known as "linearization" or "inverse gamma correction."
LinRGB srgbToLinear(final double srgbComponent) {
  // clamp within specified tolerance
  srgbComponent.assertRange0to1('srgbToLinear');
  // sRGB standard specifies a linear segment near zero for better precision.
  if (srgbComponent <= 0.04045) {
    // Linear segment: c / 12.92
    return LinRGB((srgbComponent / 12.92).clamp(0.0, 1.0));
  }
  // Non-linear segment: ((c + 0.055) / 1.055) ^ 2.4
  return LinRGB(
      pow((srgbComponent + 0.055) / 1.055, 2.4).toDouble().clamp(0.0, 1.0));
}

/// Converts a linear intensity sRGB double component [0.0 - 1.0]
/// back to a gamma-encoded (delinearized) sRGB double component [0.0 - 1.0].
///
/// This is also known as 'delinearize' or "gamma correction."
Percent linearToSrgb(final double linearComponent) {
  // clamp within specified tolerance
  linearComponent.assertRange0to1('linearToSrgb');
  // sRGB standard defines the inverse of the linearization function.
  if (linearComponent <= 0.0031308) {
    // Inverse linear segment: c * 12.92
    return Percent((linearComponent * 12.92).clamp(0.0, 1.0));
  }
  // Inverse non-linear segment: 1.055 * c^(1/2.4) - 0.055
  return Percent(
      (1.055 * pow(linearComponent, 1.0 / 2.4) - 0.055).clamp(0.0, 1.0));
}

/// Converts an sRGB color (with 8-bit integer components) to a list
/// of linear RGB values (0.0-1.0).
///
/// [r], [g], and [b] are the 8-bit red, green, and blue components (0-255).
///
/// Returns a list of three doubles `[r, g, b]` where each component
/// has been converted to its linear equivalent in the range of 0.0 to 1.0.
/// This is useful for color space conversions and calculations.
List<double> rgbToLinearRgb(final int r, final int g, final int b) {
  // clamp within specified tolerance
  r.assertRange0to255('rgbToLinearRgb-r');
  g.assertRange0to255('rgbToLinearRgb-g');
  b.assertRange0to255('rgbToLinearRgb-b');
  return <double>[
    srgbToLinear(r / 255.0),
    srgbToLinear(g / 255.0),
    srgbToLinear(b / 255.0),
  ];
}

/// Converts a color from linear RGB components to ARGB format.
/// CREDIT: MaterialColorUtilities
int argbFromLinrgb(final List<double> linrgb) {
  final int r =
      delinearized100Based(linrgb[0].assertRange0to1('argbFromLinrgb-r'));
  final int g =
      delinearized100Based(linrgb[1].assertRange0to1('argbFromLinrgb-g'));
  final int b =
      delinearized100Based(linrgb[2].assertRange0to1('argbFromLinrgb-b'));
  return argbFromRgb(r, g, b);
}

// -------------------------------------------------------------------
// Material Color Utilities - Linear/sRGB Conversions (0-100 scale)
// -------------------------------------------------------------------

/// Linearizes an RGB component.
/// Note that this method multiplies the result by 100.0
/// [rgbComponent] 0 <= rgb_component <= 255, represents R/G/B
/// channel
/// Returns 0.0 <= output <= 100.0, color channel converted to
/// linear RGB space
/// CREDIT: MaterialColorUtilities
double linearized(final int rgbComponent) {
  rgbComponent.assertRange0to255('linearized-rgbComponent');
  final double normalized = rgbComponent / 255.0;
  if (normalized <= 0.040449936) {
    return normalized / 12.92 * 100.0; // Note multiplication here
  } else {
    return pow((normalized + 0.055) / 1.055, 2.4).toDouble() * 100.0;
  }
}

/// Delinearizes an RGB component.
/// NOTE: This is 100-based, not 1.0 based
/// [rgbComponent] 0.0 <= rgb_component <= 100.0, represents linear
/// R/G/B channel
/// Returns 0 <= output <= 255, color channel converted to regular
/// RGB space
/// CREDIT: MaterialColorUtilities
int delinearized100Based(final double rgbComponent) {
  final double normalized = rgbComponent / 100.0;
  double delinearized = 0.0;
  if (normalized <= 0.0031308) {
    delinearized = normalized * 12.92;
  } else {
    delinearized = 1.055 * pow(normalized, 1.0 / 2.4).toDouble() - 0.055;
  }
  return clampInt((delinearized * 255.0).round(), min: 0, max: 255);
}

// -------------------------------------------------------------------
// Hue & Angle Utilities
// -------------------------------------------------------------------

/// Ensures that a hue value is within the range of `[0, 360)`.
///
/// If the hue is negative, it will be wrapped to the positive equivalent.
/// For example, `-10` will become `350`.
double wrapHue(final double hue) {
  final double mod = hue % 360.0;
  return mod < 0 ? mod + 360.0 : mod;
}

/// Sanitizes a degree measure as an integer.
///
/// Returns a degree measure between 0 (inclusive) and 360
/// (exclusive).
/// CREDIT: MaterialColorUtilities
int sanitizeDegreesInt(int degrees) {
  degrees = degrees % 360;
  if (degrees < 0) {
    degrees = degrees + 360;
  }
  return degrees;
}

/// Sanitizes a degree measure as a floating-point number.
///
/// Returns a degree measure between 0.0 (inclusive) and 360.0
/// (exclusive).
/// CREDIT: MaterialColorUtilities
double sanitizeDegreesDouble(double degrees) {
  degrees = degrees % 360.0;
  if (degrees < 0) {
    degrees = degrees + 360.0;
  }
  return degrees;
}

/// Distance of two points on a circle, represented using degrees.
/// CREDIT: MaterialColorUtilities
double differenceDegrees(final double a, final double b) {
  return 180.0 - ((a - b).abs() - 180.0).abs();
}

/// Sign of direction change needed to travel from one angle to
/// another.
///
/// For angles that are 180 degrees apart from each other, both
/// directions have the same travel distance, so either direction is
/// shortest. The value 1.0 is returned in this case.
///
/// [from] The angle travel starts from, in degrees.
/// [to] The angle travel ends at, in degrees.
/// Returns -1 if decreasing from leads to the shortest travel
/// distance, 1 if increasing from leads to the shortest travel
/// distance.
/// CREDIT: MaterialColorUtilities
double rotationDirection(final double from, final double to) {
  final double increasingDifference = sanitizeDegreesDouble(to - from);
  return increasingDifference <= 180.0 ? 1.0 : -1.0;
}

// -------------------------------------------------------------------
// Interpolation
// -------------------------------------------------------------------

/// Linearly interpolates between two hues.
///
/// This function takes the shortest path around the color wheel.
/// [a] is the starting hue, in degrees.
/// [b] is the ending hue, in degrees.
/// [t] is the interpolation factor, in the range [0, 1].
double lerpHue(double a, double b, final double t) {
  t.assertRange0to1('lerpHue');
  final double delta = b - a;
  if (delta.abs() > 180.0) {
    if (delta > 0.0) {
      a += 360.0;
    } else {
      b += 360.0;
    }
  }
  return (a + (b - a) * t) % 360.0;
}

/// Linearly interpolates between two hues.
///
/// This function takes the shortest path around the color wheel.
///
/// [start] is the starting hue, in degrees.
/// [end] is the ending hue, in degrees.
/// [t] is the interpolation factor, in the range `[0, 1]`.
/// Returns the interpolated hue.
double lerpHueB(final double start, final double end, final double t) {
  t.assertRange0to1('lerpHueB');
  final double delta = ((end - start + 540.0) % 360.0) - 180.0;
  return wrapHue(start + delta * t);
}

/// Linearly interpolates between two numbers.
/// CREDIT: Dart.ui library
/// Similar to `lerpDouble` from Flutter's `dart:ui` library.
///
/// [a] is the starting value.
/// [b] is the ending value.
/// [t] is the interpolation factor, in the range `[0, 1]`.
///
/// Throws an assertion error if [t] is outside the range `[0, 1]`,
/// or if [a] or [b] are non-finite.
double lerpDouble(final double a, final double b, final double t) {
  assert(!a.isNaN, 'Cannot interpolate between Invalid Numbers');
  assert(!b.isNaN, 'Cannot interpolate between Invalid Numbers');
  if (a == b) {
    return a.toDouble();
  }

  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  t.assertRange0to1('lerpDouble');
  return a * (1.0 - t) + b * t;
}

/// Linearly interpolate between two doubles.
/// CREDIT: Dart.ui library
/// Same as [lerpDouble] but specialized for non-null `double` type.
double lerpDoubleB(final double start, final double end, final double t) =>
    start + (end - start) * t;

/// Linearly interpolate between two doubles.
/// CREDIT: Dart.ui library
/// Same as [lerpDouble] but specialized for non-null `double` type.
double lerpDoubleDart(final double a, final double b, final double t) {
  // This doesn't match _lerpInt to preserve specific behaviors when dealing
  // with infinity and nan.
  return a * (1.0 - t) + b * t;
}

/// Linearly interpolate between two integers.
/// CREDIT: Dart.ui library
/// Same as [lerpDouble] but specialized for non-null `int` type.
double lerpInt(final int a, final int b, final double t) {
  return a + (b - a) * t;
}

// -------------------------------------------------------------------
// Clamping & Math Helpers
// -------------------------------------------------------------------

/// Returns [x] clamped to be between [min] and [max].
///
/// The arguments [min] and [max] must be finite.
///
/// If [x] is `NaN`, then [max] is returned.
/// CREDIT: Flutter Foundation
double clampDouble(
  final double x, {
  required final double min,
  required final double max,
}) {
  assert(min <= max && !max.isNaN && !min.isNaN);
  if (x < min) {
    return min;
  }
  if (x > max) {
    return max;
  }
  if (x.isNaN) {
    return max;
  }
  return x;
}

/// Same as [num.clamp] but optimized for a non-null [double].
/// CREDIT: Dart.ui Color Class
/// This is faster because it avoids polymorphism, boxing, and special cases for
/// floating point numbers.
//
// See also: //dev/benchmarks/microbenchmarks/lib/foundation/clamp.dart
double clampDoubleDart(final double x, final double min, final double max) {
  assert(min <= max && !max.isNaN && !min.isNaN);
  if (x < min) {
    return min;
  }
  if (x > max) {
    return max;
  }
  if (x.isNaN) {
    return max;
  }
  return x;
}

/// Clamps an integer between two integers.
///
/// Returns input when min <= input <= max, and either min or max
/// otherwise.
/// CREDIT: MaterialColorUtilities
int clampInt(
  final int input, {
  required final int min,
  required final int max,
}) {
  if (input < min) {
    return min;
  } else if (input > max) {
    return max;
  }

  return input;
}

/// Clamps an integer [value] between 0 and 255.
///
/// This is a shorthand for `clampInt(value, min: 0, max: 255)`.
/// Returns the clamped value as an [int], which is useful for ensuring
/// a color component is within the valid 8-bit range.
int clamp0to255(final int value) => clampInt(value, min: 0, max: 255);

/// Clamps a [value] between 0.0 and 1.0.
///
/// This is a shorthand for `value.clamp(0.0, 1.0)`.
/// Returns the clamped value as a [double].
double clamp01(final double value) => clampDouble(value, min: 0.0, max: 1.0);

/// Cube root function.
double cbrt(final double val) {
  if (val.isNegative) {
    return -pow(-val, 1.0 / 3.0).toDouble();
  } else {
    return pow(val, 1.0 / 3.0).toDouble();
  }
}

// -------------------------------------------------------------------
// Color Conversion from Components
// -------------------------------------------------------------------

/// CREDIT: Dart.ui library
double getHue(
  final double red,
  final double green,
  final double blue,
  final double max,
  final double delta,
) {
  late double hue;
  if (max == 0.0) {
    hue = 0.0;
  } else if (max == red) {
    hue = 60.0 * (((green - blue) / delta) % 6);
  } else if (max == green) {
    hue = 60.0 * (((blue - red) / delta) + 2);
  } else if (max == blue) {
    hue = 60.0 * (((red - green) / delta) + 4);
  }

  /// Set hue to 0.0 when red == green == blue.
  hue = hue.isNaN ? 0.0 : hue;
  return hue;
}

/// CREDIT: Dart.ui library
ColorIQ colorFromHue(
  final double alpha,
  final double hue,
  final double chroma,
  final double secondary,
  final double match,
) {
  final (double red, double green, double blue) = switch (hue) {
    < 60.0 => (chroma, secondary, 0.0),
    < 120.0 => (secondary, chroma, 0.0),
    < 180.0 => (0.0, chroma, secondary),
    < 240.0 => (0.0, secondary, chroma),
    < 300.0 => (secondary, 0.0, chroma),
    _ => (chroma, 0.0, secondary),
  };
  return ColorIQ.fromArgbInts(
    (alpha * 0xFF).round(),
    ((red + match) * 0xFF).round(),
    ((green + match) * 0xFF).round(),
    ((blue + match) * 0xFF).round(),
  );
}

/// CIE 1931 2° Standard Observer, D65 illuminant.
///
/// X, Y, Z tristimulus values of the white point.
const List<double> kWhitePointD65 = <double>[95.047, 100.0, 108.883];

/// Multiplies a 1x3 row vector with a 3x3 matrix.
List<double> matrixMultiply(
    final List<double> row, final List<List<double>> matrix) {
  final double a =
      row[0] * matrix[0][0] + row[1] * matrix[0][1] + row[2] * matrix[0][2];
  final double b =
      row[0] * matrix[1][0] + row[1] * matrix[1][1] + row[2] * matrix[1][2];
  final double c =
      row[0] * matrix[2][0] + row[1] * matrix[2][1] + row[2] * matrix[2][2];
  return <double>[a, b, c];
}

// CREDIT: Material Color Utilities
// CREDIT: https://github.com/bernaferrari/hsluv-dart/blob/main/lib/hsluv.dart
const List<List<double>> srgbToXyzMatrix = <List<double>>[
  <double>[0.41233895, 0.35762064, 0.18051042],
  <double>[0.2126, 0.7152, 0.0722],
  <double>[0.01932141, 0.11916382, 0.95034478],
];

// CREDIT: Material Color Utilities
const List<List<double>> xyzToSrgbMatrix = <List<double>>[
  <double>[3.2413774792388685, -1.5376652402851851, -0.49885366846268053],
  <double>[-0.9691452513005321, 1.8758853451067872, 0.04156585616912061],
  <double>[0.05562093689691305, -0.20395524564742123, 1.0571799111220335],
];

/// CREDIT: https://github.com/bernaferrari/hsluv-dart/blob/main/lib/hsluv.dart
/// CREDIT: Material Color Utilities, aka 'm
const List<List<double>> xyzToSrgbMatrix2 = <List<double>>[
  <double>[3.240969941904521, -1.537383177570093, -0.498610760293],
  <double>[-0.96924363628087, 1.87596750150772, 0.041555057407175],
  <double>[0.055630079696993, -0.20397695888897, 1.056971514242878]
];

/// CREDIT: https://github.com/bernaferrari/hsluv-dart/blob/main/lib/hsluv.dart
/// CREDIT: Material Color Utilities, aka 'm', aka minV
const List<List<double>> srgbToXyzMatrix2 = <List<double>>[
  <double>[0.41239079926595, 0.35758433938387, 0.18048078840183],
  <double>[0.21263900587151, 0.71516867876775, 0.072192315360733],
  <double>[0.019330818715591, 0.11919477979462, 0.95053215224966]
];

/// Converts a color from ARGB to XYZ;
/// Generates a 32-bit hexId from the given x, y, and z values.
/// CREDIT: Material Color Utilities
int argbFromXyz(final double x, final double y, final double z) {
  const List<List<double>> matrix = xyzToSrgbMatrix;
  final double linearR = matrix[0][0] * x + matrix[0][1] * y + matrix[0][2] * z;
  final double linearG = matrix[1][0] * x + matrix[1][1] * y + matrix[1][2] * z;
  final double linearB = matrix[2][0] * x + matrix[2][1] * y + matrix[2][2] * z;
  final int r = delinearized100Based(linearR);
  final int g = delinearized100Based(linearG);
  final int b = delinearized100Based(linearB);
  return argbFromRgb(r, g, b);
}

/// Converts a color from XYZ to ARGB.
/// CREDIT: Material Color Utilities
List<double> xyzFromArgb(final int argb) {
  final double r = linearized(redFromArgb(argb));
  final double g = linearized(greenFromArgb(argb));
  final double b = linearized(blueFromArgb(argb));
  return matrixMultiply(<double>[r, g, b], srgbToXyzMatrix);
}

/// Converts a color represented in Lab color space into an ARGB
/// integer.
XYZ labToXYZ(final double l, final double a, final double b) {
  final double fy = (l + 16.0) / 116.0;
  final double fx = a / 500.0 + fy;
  final double fz = fy - b / 200.0;
  final double xNormalized = labInvf(fx);
  final double yNormalized = labInvf(fy);
  final double zNormalized = labInvf(fz);
  final double x = xNormalized * kWhitePointD65[0];
  final double y = yNormalized * kWhitePointD65[1];
  final double z = zNormalized * kWhitePointD65[2];
  return XYZ(x, y, z);
}

/// Converts a color from ARGB to XYZ.
RgbInts xyzToRgb(final double x, final double y, final double z) {
  const List<List<double>> matrix = xyzToSrgbMatrix;
  final double linearR = matrix[0][0] * x + matrix[0][1] * y + matrix[0][2] * z;
  final double linearG = matrix[1][0] * x + matrix[1][1] * y + matrix[1][2] * z;
  final double linearB = matrix[2][0] * x + matrix[2][1] * y + matrix[2][2] * z;
  final int r = delinearized100Based(linearR);
  final int g = delinearized100Based(linearG);
  final int b = delinearized100Based(linearB);
  return (red: r, green: g, blue: b);
}

/// Converts a color represented in Lab color space into an ARGB
/// integer.
/// CREDIT: Material Color Utilities
int argbFromLab(final double l, final double a, final double b) {
  final double fy = (l + 16.0) / 116.0;
  final double fx = a / 500.0 + fy;
  final double fz = fy - b / 200.0;
  final double xNormalized = labInvf(fx);
  final double yNormalized = labInvf(fy);
  final double zNormalized = labInvf(fz);
  final double x = xNormalized * kWhitePointD65[0];
  final double y = yNormalized * kWhitePointD65[1];
  final double z = zNormalized * kWhitePointD65[2];
  return argbFromXyz(x, y, z);
}

/// Converts a color from ARGB representation to L*a*b*
/// representation.
///
/// [argb] the ARGB representation of a color
/// Returns a Lab object representing the color
/// CREDIT: Material Color Utilities
List<double> labFromArgb(final int argb) {
  final double linearR = linearized(redFromArgb(argb));
  final double linearG = linearized(greenFromArgb(argb));
  final double linearB = linearized(blueFromArgb(argb));
  final double x = srgbToXyzMatrix[0][0] * linearR +
      srgbToXyzMatrix[0][1] * linearG +
      srgbToXyzMatrix[0][2] * linearB;
  final double y = srgbToXyzMatrix[1][0] * linearR +
      srgbToXyzMatrix[1][1] * linearG +
      srgbToXyzMatrix[1][2] * linearB;
  final double z = srgbToXyzMatrix[2][0] * linearR +
      srgbToXyzMatrix[2][1] * linearG +
      srgbToXyzMatrix[2][2] * linearB;
  final double xNormalized = x / kWhitePointD65[0];
  final double yNormalized = y / kWhitePointD65[1];
  final double zNormalized = z / kWhitePointD65[2];
  final double fx = labF(xNormalized);
  final double fy = labF(yNormalized);
  final double fz = labF(zNormalized);
  final double l = 116.0 * fy - 16;
  final double a = 500.0 * (fx - fy);
  final double b = 200.0 * (fy - fz);
  return <double>[l, a, b];
}

/// CREDIT: Material Color Utilities
List<double> labFromXYZ(final double x, final double y, final double z) {
  final double xNormalized = x / kWhitePointD65[0];
  final double yNormalized = y / kWhitePointD65[1];
  final double zNormalized = z / kWhitePointD65[2];
  final double fx = labF(xNormalized);
  final double fy = labF(yNormalized);
  final double fz = labF(zNormalized);
  final double l = 116.0 * fy - 16;
  final double a = 500.0 * (fx - fy);
  final double b = 200.0 * (fy - fz);
  return <double>[l, a, b];
}

/// A helper function for converting from CIELAB to CIEXYZ.
/// This is part of the CIELAB color space definition, used to transform
/// normalized tristimulus values (X/Xn, Y/Yn, Z/Zn) before calculating
/// L*, a*, and b* values.
///
/// [t] is a normalized tristimulus value (e.g., Y/Yn).
///
/// Returns the transformed value.
/// CREDIT: Material Color Utilities
/// See also:
///  * [labInvf], the inverse of this function.
double labF(final double t) {
  if (t > kEpsilon) {
    // if t > ε, returns t^(1/3)
    return pow(t, 1.0 / 3.0).toDouble();
  } else {
    // if t <= ε, returns (κ * t + 16) / 116
    return (kKappa * t + 16) / 116;
  }
}

/// The inverse of the [labF] function. Used for converting CIELAB
/// back to CIEXYZ.
///
/// [ft] is the transformed value from the [labF] function.
///
/// Returns the original normalized tristimulus value.
/// CREDIT: Material Color Utilities
/// See also:
///  * [labF], the function this inverts.
double labInvf(final double ft) {
  final double ft3 = ft * ft * ft;
  if (ft3 > kEpsilon) {
    // if ft^3 > ε, the inverse is simply ft^3
    return ft3;
  } else {
    // if ft^3 <= ε, the inverse is (116 * ft - 16) / κ
    return (116 * ft - 16) / kKappa;
  }
}

/// Represents the non-linearly compressed LMS values (L', M', S').
class LmsPrime {
  final double lPrime, mPrime, sPrime;
  LmsPrime(this.lPrime, this.mPrime, this.sPrime);
}

/// Converts linear (gamma-corrected) sRGB components [0.0 - 1.0]
/// into the non-linear L'M'S' space for Oklab calculation.
///
/// @param lr Linear Red component.
/// @param lg Linear Green component.
/// @param lb Linear Blue component.
LmsPrime linearRgbToLmsPrime(
    final LinRGB lr, final LinRGB lg, final LinRGB lb) {
  // --- Stage 1: Linear sRGB to LMS (Long, Medium, Short) ---
  // This matrix transforms light intensities into values related to the
  // human eye's cone responses (photoreceptors).
  final double L = (0.4121656120 * lr.value) +
      (0.5362752080 * lg.value) +
      (0.0514570080 * lb.value);
  final double M = (0.2118591070 * lr.value) +
      (0.6807189584 * lg.value) +
      (0.1074061555 * lb.value);
  final double S = (0.0883097947 * lr.value) +
      (0.2818474174 * lg.value) +
      (0.6300096956 * lb.value);

  // --- Stage 2: Non-linear Compression (Cube Root) ---
  // This compression step is crucial for achieving perceptual uniformity.
  // It stabilizes the color space, making steps in L', M', S' correspond
  // more closely to steps in human perception.
  final double lPrime = math.pow(L, 1.0 / 3.0).toDouble();
  final double mPrime = math.pow(M, 1.0 / 3.0).toDouble();
  final double sPrime = math.pow(S, 1.0 / 3.0).toDouble();

  return LmsPrime(lPrime, mPrime, sPrime);
}

/// Converts L*a*b* components [0.0 - 1.0] into the non-linear LMS space.
///
/// @param l L* component.
/// @param aLab a* component.
/// @param bLab b* component.
///
/// Returns the LMS space representation of the color.
LmsPrime labToLmsPrime(final double l, final double aLab, final double bLab) {
  final double l_ = l + 0.3963377774 * aLab + 0.2158037573 * bLab;
  final double m_ = l - 0.1055613458 * aLab - 0.0638541728 * bLab;
  final double s_ = l - 0.0894841775 * aLab - 1.2914855480 * bLab;

  final double l3 = l_ * l_ * l_;
  final double m3 = m_ * m_ * m_;
  final double s3 = s_ * s_ * s_;

  return LmsPrime(l3, m3, s3);
}

/// aka IsShortHex, aka is 8Bit, is8Bit isTwoDigitHex
/// determines if a number is an 8-bit or 1-byte value (which are equivalent).
/// Involves checking if it falls within the range of 0 to 255
bool is8BitUnsigned(final int hexInt) {
  // check
  if (hexInt < 0 || hexInt > 255 || hexInt.bitLength > 8) {
    return false;
  }
  // i.e. IF it an 8-bit number, than it will accept the 0xFF mask correctly and
  // return the same number.
  if ((hexInt & 0xFF == hexInt) && (hexInt >= 0 && hexInt <= 255)) {
    return true; // Check if number is within 0-255
  }

  /// last-resort check here
  final bool b = (hexInt <= 0xFF && hexInt.toRadixString(16).length <= 2);
  return b;
}

/// Determines whether the input number is 32-bit unsigned
bool is32BitUnsigned(final int hexInt) {
  // check
  if (hexInt.bitLength > 32 ||
      hexInt.isNegative ||
      hexInt.isNaN ||
      hexInt.isInfinite ||
      hexInt > maxUInt32) {
    return false;
  }

  /// Handle the case where alpha is zero
  if (hexInt.toRadixString(16).length >= 8) {
    return true;
  }

  if (hexInt.alpha.toInt() > 0 &&
      (hexInt.blue.toInt() > 0 ||
          hexInt.red.toInt() > 0 ||
          hexInt.green.toInt() > 0)) {
    return true;
  }

  /// Handle the case where alpha is zero
  if (is8BitUnsigned(hexInt)) {
    return false;
  }
  return false;
}
