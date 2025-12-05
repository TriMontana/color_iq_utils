import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;

import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/string_helpers.dart';
import 'package:color_iq_utils/src/foundation/enums.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:color_iq_utils/src/utils/error_handling.dart';

/// Extension for doubles
extension DoubleHelpersNullableIQ on double? {
  double? assertRange0to100Nullable([final String? msg]) {
    if (this == null) {
      return null;
    }
    if (this! < 0.0 || this! > 100.0) {
      throw RangeError(
        'Range Error: Value must be between 0 and 100 -- ' //
        '${msg ?? 'assertRange0to100Nullable'}',
      );
    }
    return this;
  }

  String get orEmpty => this?.toString() ?? kEmptyStr;
  double orThrow([final String? msg]) =>
      this ?? (throw Exception(msg ?? 'null double at line 26'));
}

/// Extension for doubles
extension DoubleHelpersIQ on double {
  double get clampHue => clampDouble(this, min: kMinHue, max: kMaxHue);
  double get clampChromaHct =>
      clampDouble(this, min: kMinChroma, max: kMaxChroma);
  double get clampToneHct => clampDouble(this, min: kMinTone, max: kMaxTone);
  double get clamp0to1 => clampDouble(this, min: 0.0, max: 1.0);
  double assertRangeHue([final String? msg]) {
    if (this < kMinHue || this > kMaxHue) {
      throw RangeError(
        'Range Error: Value must be between $kMinHue and ' //
        '$kMaxHue -- ${msg ?? 'assertRangeHue0'}',
      );
    }
    return this;
  }

  double assertRangeChroma([final String? msg]) {
    if (this < kMinChroma || this > kMaxChroma) {
      throw RangeError(
        'Range Error: Value must be between $kMinChroma ' //
        'and $kMaxChroma -- ${msg ?? 'assertRangeChroma'}',
      );
    }
    return this;
  }

  double assertRange0to100([final String? msg]) {
    if (this < 0.0 || this > 100.0) {
      throw RangeError(
        'Range Error: Value must be between 0 and 100 -- ' //
        '${msg ?? 'assertRange0to100'}',
      );
    }
    return this;
  }

  double assertRange0to1([final String? msg]) {
    if (isNaN || (this < 0.0 || this > 1.0)) {
      throw RangeError(
        'Range Error: Value must be between 0 and 1.0 -- ' //
        '${msg ?? 'assertRange0to1.0'}',
      );
    }
    return this;
  }

  int roundAndClamp0to255int([final String? msg]) {
    if (this < 0.0 || this > 255.0) {
      throw RangeError(
        'Range Error: Value must be between 0 and 255 -- ' //
        '${msg ?? 'roundAndClamp0to255int'}',
      );
    }
    return round().clamp(0, 255);
  }

  /// Convert a normalized double (0.0-1.0) to an int (0-255), aka factored float to int
  int normalizedTo255int([final String? msg]) {
    if (this < 0.0 || this > 1.0) {
      throw RangeError(
        'Range Error: Value must be between 0 and 1.0 -- ' //
        '${msg ?? 'normalizedTo255int'}',
      );
    }
    return (this * 255).round();
  }

// sRGB Linear to sRGB (Gamma encoded), aka gamma correction, delinearization
  // Gamma correction (Transfer function) for Display P3 is sRGB curve.
  double get gammaCorrect {
    assertRange0to1('gammaCorrect-$this');
    return linearToSrgb(this);
  }

  /// To String without training zeros.
  String toStrTrimZeros([
    final int decimals = 6,
    final int decimalsToRetain = 1,
  ]) =>
      toStringAsFixed(decimals).removeTrailingZeroes(decimalsToRetain);

  String toStringDegrees({
    final int decimals = 6,
    final int decimalsToRetain = 1,
  }) =>
      (toStringAsFixed(decimals).removeTrailingZeroes(decimalsToRetain) +
          kDegreeSign);

  /// Assert that this [double] is in the range of 0.0 to 1.0, i.e. a factored
  /// float (aka RGB percent or ARGB normalized)
  /// If not throw an error
  double assertPercentage({
    final double? tolerance, //  = 0.000027,
    final String? msg,
  }) {
    if (this >= 0.0 && this <= 1.0) {
      //    0.0 <= this && this <= 1.0, // the 99% case here
      return this;
    }
    if (tolerance != null) {
      if (this > (0 - tolerance) && this < (1.0 + tolerance)) {
        return clamp0to1;
      }
    }
    final StackTrace st = StackTrace.current;
    final String er = 'assertPercentage error-UseTolerance: ' //
        '${msg.orEmpty}--${st.toString()}';
    stderr.writeln(er);
    developer.log(er);
    throw Exception(er);
  }

  double pow(final double exponent) => math.pow(this, exponent).toDouble();

  double get cubed => math.pow(this, 3).toDouble();

  double get toReciprocal => invertDouble(this);

  double get clampMinus1to1 => clamp(-1.0, 1.0).toDouble();
  double get clamp0to255 => clamp(0.0, 255.0).toDouble();
  double get clamp0to360 => clamp(0.0, 360.0).toDouble();
  double get degreesToRadians => this * (math.pi / 180.0);
  double get radiansToDegrees => this * (180.0 / math.pi);
  double get normalizedDegrees => (this % 360.0 + 360.0) % 360.0;
  double get normalizedRadians =>
      (this % (2 * math.pi) + (2 * math.pi)) % (2 * math.pi);
  double invertDouble(final double val) => val == 0.0 ? 0.0 : 1.0 / val;

  double roundToDecimalPlaces(final int fractionalDigits) {
    final int places = (fractionalDigits < 0) ? 2 : fractionalDigits;
    final double mod = math.pow(10.0, places) as double;
    return (this * mod).round() / mod;
  }

  /// Clamp within tolerance range
  double clamp0to1IfInTolerance([double tolerance = kEpsilon]) {
    tolerance = tolerance.makePositive.toDouble();
    if (this >= (0 - tolerance) && this <= (1.0 + tolerance)) {
      return clamp0to1;
    }
    throw Exception(
      '${toString()} is out of scope to be clamped with tolerance $tolerance',
    );
  }

  /// Get the hue ange as a string
  String hueAngleAsStr({
    final int decimals = 1,
    final bool addDegreeSign = false,
  }) =>
      (addDegreeSign == false) ? str(decimals) : '${str(decimals)}$kDegreeSign';

  /// Rounds this double to [precision] decimal points.
  double roundToPrecision(final int precision) =>
      roundToDecimalPlaces(precision);

  // check if a number is a whole number by using the modulo operator % and
  // by checking if the value is equal to the value after removing the
  // fractional part.
  bool get isWhole =>
      (this is int) || (this % 1) == 0 || (this == roundToDouble());

  /// Assert minimum
  double assertMinimum(final double minAmount, {final String? msg}) {
    if (this < minAmount) {
      throw AssertionError(
        'Invalid amount $this vs. $minAmount assertMinimum-${msg.orEmpty}',
      );
    }
    return this;
  }

  // From Math.Utils
  // from https://github.com/material-foundation/material-color-utilities/blob/main/dart/lib/utils/math_utils.dart
  /// Sanitizes a degree measure as a floating-point number.
  /// Returns a degree measure between 0.0 (inclusive) and 360.0
  /// (exclusive). so -5 becomes 355
  double get sanitizeDegreesDouble {
    double degrees = this % 360.0;
    if (degrees < 0) {
      degrees += 360.0;
    }
    return degrees;
  }

  /// Returns this value squared (this * this)
  double get squared => this * this;

  /// Returns the square root of this value
  double get sqrt => math.sqrt(this);

  /// Returns the absolute value of this double
  double get abs => this < 0 ? -this : this;

  /// Returns the ceiling (smallest integer >= this)
  double get ceil => ceilToDouble();

  /// Returns the floor (largest integer <= this)
  double get floor => floorToDouble();

  /// Returns the natural logarithm (base e) of this value
  double get ln => math.log(this);

  /// Returns the base-10 logarithm of this value
  double get log10 => math.log(this) / math.ln10;

  /// Returns e raised to the power of this value
  double get exp => math.exp(this);

  /// Returns the remainder of this value divided by [divisor]
  double remainder(final double divisor) => this % divisor;

  /// Returns the sign of this value (-1 for negative, 0 for zero, 1 for positive)
  int get sign => this < 0 ? -1 : (this > 0 ? 1 : 0);

  /// Returns the maximum of this value and [other]
  double max(final double other) => math.max(this, other);

  /// Returns the minimum of this value and [other]
  double min(final double other) => math.min(this, other);

  /// Check if this value is approximately equal to [other] within [epsilon] tolerance
  /// Useful for floating-point comparisons
  bool isCloseTo(final double other, {final double epsilon = 1e-9}) {
    return (this - other).abs() < epsilon;
  }

  /// Check if this value is approximately zero within [epsilon] tolerance
  bool isApproximatelyZero({final double epsilon = 1e-9}) =>
      isCloseTo(0.0, epsilon: epsilon);

  /// Check if this value is between [min] and [max] (inclusive)
  bool isBetween(final double min, final double max) =>
      this >= min && this <= max;

  /// Check if this value is between [min] and [max] (exclusive)
  bool isStrictlyBetween(final double min, final double max) =>
      this > min && this < max;

  /// Returns the fractional part of this value (e.g., 3.14 -> 0.14)
  double get fractionalPart => this - floor;

  /// Returns the integer part of this value (e.g., 3.14 -> 3)
  int get integerPart => toInt();

  /// Returns the nearest integer to this value (rounding half away from zero)
  int get nearestInteger => round();

  /// Convert to int using floor rounding
  int get toIntFloor => floor.toInt();

  /// Convert to int using ceil rounding
  int get toIntCeil => ceil.toInt();

  /// Convert to int using round (nearest integer)
  int get toIntRound => round();

  /// Convert to int using truncate (towards zero)
  int get toIntTruncate => truncate();

  /// Convert this percentage (0-1) to percent value (0-100)
  double get toPercent => this * 100.0;

  /// Convert this percent value (0-100) to percentage (0-1)
  double get fromPercent => this / 100.0;

  /// Base toString used to shorten the use of 'toStringAsFixed
  String str(final int decimals) {
    final String myStr = toStringAsFixed(decimals);
    if (!myStr.endsWith(kZeroStr)) {
      return myStr;
    }
    String tempStr = myStr;
    int len;
    int idx;
    do {
      len = tempStr.length - 1;
      idx = tempStr.indexOf('.');
      if (idx >= len - 1 || !tempStr.endsWith('0')) {
        break;
      }
      tempStr = tempStr.substring(0, len);
    } while (myStr.endsWith(kZeroStr) || idx < len - 2);
    return tempStr;
  }

  String get str2 => toStringAsFixed(2);

  String get str3 => toStrTrimZeros(3);

  String get str4 => toStrTrimZeros(4);

  String get str5 => toStrTrimZeros(5);

  String bracket([
    final String leftSide = kLeftSquareBracket,
    final String rightSide = kRightSquareBracket,
  ]) =>
      toString().bracketed();

  /// `true` if the number is positive; otherwise, `false`.
  bool get isPositive => !isNegative;

  num get makePositive => isPositive ? this : (this * -1);

  String toCosineAsStr([final int decimals = 3]) =>
      math.cos(this).toStringAsFixed(decimals);

  // ** Warning ** use this only for standard math operations, not hue/360
  /// Get difference in a LINEAR (pure double) format, *NOT* clockwise not
  /// using 0 to 360. Use [differenceDegrees]
  double differenceDbl(final double otherVal) => (this == otherVal)
      ? 0.0
      : math.max(this, otherVal) - math.min(this, otherVal);

  double getHalfDistance(final double other) {
    final double totalDist = (math.max(this, other) - math.min(this, other));
    return totalDist / 2;
  }

  double getMidPoint(final double other) {
    final double halfDist = getHalfDistance(other);
    return (this + halfDist);
  }

  // https://github.com/material-foundation/material-color-utilities/blob/main/dart/lib/blend/blend.dart
  /// Distance of two points on a circle, represented using degrees.
  /// handles overflow around 180 and 0
  /// so 355 and 5
  /// would be (355 - 5) = 350 - 180 = 170 and 180 - 170 =  10
  /// and 40 and 220 would be
  /// 40 - 210 or - 170, then abs would be +170 and  180 - 170 = 10
  /// Also [getHueDistanceToOther], [computeHueDistance],  [differenceDegrees]
  double differenceDegrees(final double otherVal) {
    final double pt1 = sanitizeDegreesDouble;
    final double pt2 = otherVal.sanitizeDegreesDouble;
    return 180.0 - ((pt1 - pt2).abs() - 180.0).abs();
  }

  /// rotate hue on a 0 to 360 colorWheel, same as above
  double spinHueDegrees(
    final double deg, {
    final RotationDirection direction = RotationDirection.clockwise,
  }) {
    return (direction == RotationDirection.clockwise)
        ? (this + deg).sanitizeDegreesDouble
        : (this - deg).sanitizeDegreesDouble;
  }

  // WORKS...conforms to https://www.color-hex.com/color/6f4e36
  /// aka RotateHue by [amount]
  double spinHue(final double amount) {
    assertTrue(
      amount >= -359.0 && amount < 360.0,
      'Invalid amount "$amount"--current is: ${toStringAsFixed(3)}',
      method: 'SpinHue-Double',
    );
    final double nuHue = (this + amount).sanitizeDegreesDouble;

    return nuHue;
  }

  double get flip => spinHue(180.0);
}
