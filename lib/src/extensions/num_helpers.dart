import 'dart:math' as math;

import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/string_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

extension NumExtensionIQ<T extends num> on num {
  bool isSubtypeOf<Y>() => <T>[] is List<Y>;

  /// Returns the value of `this` cubed.
  num cubed() => this * this * this;
  num get cubed2 => math.pow(this, 3);

  /// Returns the absolute value of this number.
  num get abs => this < 0 ? -this : this;

  /// Returns the sign of this number (-1 for negative, 0 for zero, 1 for positive).
  int get sign => this < 0 ? -1 : (this > 0 ? 1 : 0);

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

  String bracket([
    final String leftSide = kLeftSquareBracket,
    final String rightSide = kRightSquareBracket,
  ]) =>
      toString().bracketed();

  /// get the cubic root of a number, cubeRoot
  double get cubr => math.pow(this, 1 / 3).toDouble();

  double get cbrt => math.pow(this, 1 / 3).toDouble();

  /// Cube root of a number
  num cubeRoot() => nthRoot(3);

  /// Compute the nth root of a number
  num nthRoot(final double nth) => this >= 0
      ? math.pow(this, 1 / nth)
      : (throw Exception('Use positive numbers for nthRoot'));

  // check if a number has a zero fractional part is by using the modulo
  // operator % and by checking if the value is equal to the value
  // after removing the fractional part.
  bool get isWholeNumber =>
      (this is int) || (this % 1) == 0 || (this == roundToDouble());

  /// Checks if the number is even
  bool isEven() => this % 2 == 0;

  /// Checks if the number is odd
  bool isOdd() => this % 2 != 0;

  /// Return *this* as a bracketed string
  String bracketed([
    final String leftSide = kLeftSquareBracket,
    final String rightSide = kRightSquareBracket,
  ]) =>
      toString().bracketed(leftSide, rightSide);

  num clampBetween(final num min, final num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  num get clampDegrees {
    num hue = this % 360;
    if (hue < 0) {
      hue += 360;
    }
    return hue;
  }

  num get clampRadians {
    num hue = this % (math.pi * 2);

    if (hue < 0) {
      hue += math.pi * 2;
    }

    return hue;
  }

  /// Returns this value normalized to the range [0, 360).
  double get sanitizeDegreesNum {
    final double degrees = this % 360.0;
    return degrees >= 0 ? degrees : degrees + 360.0;
  }

  /// Checks if the number is a perfect square
  bool isPerfectSquare() {
    final int x = math.sqrt(this).toInt();
    return x * x == this;
  }

  /// Checks if the number is prime
  bool isPrime() {
    if (this <= 1) return false;
    for (int i = 2; i * i <= this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }

  /// Get the delta or difference between two numbers
  T difference(final T otherNum) =>
      math.max(this, otherNum) - math.min(this, otherNum) as T;

  /// Approximately, i.e. is within absolute difference
  bool approximately(final num otherNumber, {required final num tolerance}) {
    final num difference = (this - otherNumber).abs();
    final bool rslt = difference <= tolerance;
    // if (!rslt) {
    //   debugPrint(
    //     'approximately: actual: $this vs. ' //
    //     '$otherNumber vs. Tolerance $tolerance, Difference is: '
    //     '$difference',
    //   );
    // }
    return rslt;
  }

  /// Returns `true` if the absolute difference between this number
  /// and [val] is less than or equal to [tolerance].
  bool isWithinTolerance(final num val, final num tolerance) =>
      (this - val).abs() <= tolerance;

  /// Calculates the minimal angular distance between this value and [otherVal] on a 0-360 degree circle.
  /// Returns a [Hue] representing the shortest difference in degrees.
  double differenceDegrees(final num otherVal) {
    final double a = sanitizeDegreesDouble(toDouble());
    final double b = sanitizeDegreesDouble(otherVal.toDouble());
    final double diff = (a - b).abs();
    final double shortest = diff > 180.0 ? (360.0 - diff) : diff;
    return shortest;
  }

  /// Returns `true` if [val] is within [tolerance] of this number.
  bool isEqualsWithTolerance(final num val, [final double tolerance = 0.10]) =>
      (this - val).abs() <= tolerance;
}
