import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/utils/error_handling.dart';

/// [Hue] is an extension type specifically for
/// radians and degrees in a color wheel, with values being
/// restricted from 0 to 360 (positive). This extension type aims to provide
/// for:
/// -- inclusive self-validation and code reduction (no need for pre- and
///    post-validation code; validation occurs during creation),
/// -- greater flexibility during filtering and sorting by
///    providing easily identifiable typed subsets amongst the full range
///    of available primitives,
/// -- and compile-time phasing by use of 'const' (constants)
///    and provision of numerous ready-made const values (to reduce code
///    and number of objects in memory).
///    See also  [LinRGB], [XYZ], [UI8],
extension type const Hue._(double _) implements double {
  // const Degrees360(double val) : this._(val);
  const Hue(final double vl)
      : _ = vl,
        assert(
          vl >= Hue.minVal && vl <= Hue.maxVal,
          'Invalid Degrees-"$vl"--$errorMsg0to360-',
        );

  /// Constructor with validation, this is used in the Property legend
  const Hue.fromUnchecked(final double vl, {final String? msg})
      : _ = vl,
        assert(
          vl >= Hue.minVal && vl <= Hue.maxVal,
          'Invalid Hue360-"$vl"--$errorMsg0to360-${msg ?? 'No Message'}',
        );

  /// Factory constructor that checks if the given [vl] is within the valid range for [Hue].
  ///
  /// Throws an [ArgumentError] if [vl] is less than [Hue.minVal] or greater than [Hue.maxVal].
  /// An optional [msg] can be provided to append additional information to the error message.
  ///
  /// Returns a [Hue] instance if the value is valid.
  factory Hue.checkOrThrow(final num vl, {final String? msg}) {
    final double db = vl.toDouble();
    if (db < Hue.minVal || db > Hue.maxVal) {
      throw ArgumentError.value(
        db,
        'Hue.checkOrThrow',
        'Invalid value "$db". Must be between ${Hue.minVal} ' //
            'and ${Hue.maxVal}. ${msg ?? errorMsg0to360}',
      );
    }
    return Hue(db);
  }

  /// Clamped factory constructor, with validation, same as normalized
  factory Hue.normalized(final double vl) => Hue(sanitizeDegreesDouble(vl));

  /// Clamped factory constructor, with validation, same as normalized
  factory Hue.clamped(final double vl) =>
      Hue(sanitizeDegreesDouble(vl.clamp(Hue.minVal, Hue.maxVal)));

  double get toVal => _;
  double get val => _;

  /// To string for extension type
  String toStrET({final int decimals = 4, final bool addDegreesSign = true}) =>
      '${_.toStrTrimZeros(decimals)}' //
      '${addDegreesSign ? kDegreeSign : ''}';

  String toStrDegrees([final int decimals = 4]) {
    return _.toStringAsFixed(decimals).removeTrailingZeroes() + kDegreeSign;
  }

  /// The maximum value that this type can represent, as a plain [double].
  static const double minVal = 0.0;
  static const double midVal = 180.0;
  static const double maxVal = 360.0;

  static const Hue deg0 = Hue.fromUnchecked(Hue.minVal);
  static const Hue zero = Hue.deg0;
  static const Hue deg360 = Hue(360.0);
  static const Hue deg180 = Hue(180.0);

  /// The minimum instance that this type can represent.
  static const Hue minInst = Hue.deg0;

  /// The median instance that this type can represent.
  static const Hue midInst = Hue.deg180;

  /// The maximum instance that this type can represent.
  static const Hue maxInst = Hue.deg360;

  /// Always `1`.
  static const Hue deg1 = Hue.fromUnchecked(1);

  /// Shorthand constants for Degrees
  static const Hue deg5 = Hue(0.5);
  static const Hue deg10 = Hue(10.0);
  static const Hue deg15 = Hue(15.0);
  static const Hue deg20 = Hue(20.0);
  static const Hue deg25 = Hue(25.0);
  static const Hue deg30 = Hue(30.0);
  static const Hue deg40 = Hue(40.0);
  static const Hue deg45 = Hue(45.0);
  static const Hue v60 = Hue(60.0);
  static const Hue v90 = Hue(90.0);
  static const Hue deg95 = Hue(95.0);
  static const Hue deg100 = Hue(100.0);
  static const Hue v120 = Hue(120);

  static const Hue v210 = Hue(210.0);
  static const Hue v240 = Hue(240.0);
  static const Hue v270 = Hue(270.0);
  static const Hue deg300 = Hue(300.0);
  static const Hue deg310 = Hue(310.0);
  static const Hue deg330 = Hue(330.0);

  /// 'Add' operator, with return type in [Hue]
  Hue operator +(final Hue otherDegrees) =>
      Hue((_ + otherDegrees._).sanitizeDegreesDouble);

  /// Subtract operator
  /// assert(2 - 3 == -1);
  Hue operator -(final Hue otherDegrees) =>
      Hue((_ - otherDegrees._).sanitizeDegreesDouble);

  /// Multiply operator
  /// assert(2 * 3 == 6);
  Hue operator *(final Hue otherDegrees) =>
      Hue((_ * otherDegrees._).sanitizeDegreesDouble);

  /// Divide operator
  /// assert(5 / 2 == 2.5); // Result is a double
  Hue operator /(final Hue otherDegrees) =>
      Hue((_ / otherDegrees._).sanitizeDegreesDouble);

  Hue operator %(final Hue otherDegrees) =>
      Hue((_ % otherDegrees._).sanitizeDegreesDouble);

  /// Greater than operator
  bool operator >(final Hue otherDegrees) => _ > otherDegrees._;

  /// 'Less than' operator
  bool operator <(final Hue otherDegrees) => _ < otherDegrees._;

  /// 'Greater than or equal' to operator
  bool operator >=(final Hue otherDegrees) => _ >= otherDegrees._;

  /// 'Less than or equal to' operator
  bool operator <=(final Hue otherDegrees) => _ <= otherDegrees._;

  // https://github.com/material-foundation/material-color-utilities/blob/main/dart/lib/blend/blend.dart
  /// Distance of two points on a circle, represented using degrees.
  /// handles overflow around 180 and 0
  /// so 355 and 5
  /// would be (355 - 5) = 350 - 180 = 170 and 180 - 170 =  10
  /// and 40 and 220 would be
  /// 40 - 210 or - 170, then abs would be +170 and  180 - 170 = 10
  /// Also [getHueDistanceToOther],    [differenceDegrees]
  Hue differenceDegrees(final num otherVal) {
    final double pt2 = otherVal.toDouble().sanitizeDegreesDouble;
    return (pt2 == toVal)
        ? this
        : Hue(Hue.deg180.val - ((toVal - pt2).abs() - Hue.deg180.val).abs());
  }

  // Taken from Material Color Utilities
  /// Distance of two points on a circle, represented using degrees.
  Hue calculateDifferenceDegrees(final Hue b) => (b.val == toVal)
      ? this
      : (180.0 - ((val - b.val).abs() - 180.0).abs()).clampToHue;

  /// To Radians
  Radians get toRadians => ColorMathIQ.degreesToRadians(_);

  /// Linearly interpolate to another [Hue]
  Hue lerpTo(final Hue otherHue, [final double percent = 0.20]) {
    final double factor = percent.assertPercentage();
    final Hue dist2 = differenceDegrees(otherHue);
    final double step = dist2.val * factor;
    // debugPrint(
    //   'DUAL: Distance between is $dist2--Factor is: $factor, step ' //
    //       'is: "$step"--value is: ${_.toStringAsFixed(3)}--$name',
    // ); // just testing here
    if (percent.isNegative) {
      return rotateHue(step, direction: RotationDirection.counterclockwise);
    }
    return rotateHue(step, direction: RotationDirection.clockwise);
  }

  /// aka LERPbyAmount, rotate hue on a 0-to-360-degree colorWheel,
  Hue rotateHue(final double amount, {final RotationDirection? direction}) {
    // debugPrint(
    //   'inside ROTATE hue: amount passing is "$amount"--'
    //   'current value is ${_.toStringAsFixed(5)}-',
    // );
    if (amount.isPositive) {
      return increaseHue(amount);
    }
    return decreaseHue(amount);
  }

  /// Sanitize degrees
  Hue get sanitizeDegrees {
    final Hue degrees = Hue(_ % 360.0);
    return (degrees.val < 0) ? degrees + Hue.deg360 : degrees;
  }

  // /// Sanitize degrees from a floating-point number to an integer
  // int get sanitizeDegreesToInt => sanitizeDegreesDouble.toInt();

  /// Flip the hue 180 degrees
  Hue get flip {
    final Hue degrees = Hue((_ + Hue.deg180.val) % Hue.deg360.val);
    return (degrees.val < 0.0) ? degrees + Hue.deg360 : degrees;
  }

  /// Increase hue
  Hue increaseHue(final double amount) {
    final Hue degrees = Hue((_ + amount) % Hue.deg360.val);
    return (degrees.val < 0.0) ? (degrees + Hue.deg360) : degrees;
  }

  Hue decreaseHue(final double amount) {
    // _pr('increaseHue hue amount -- $amount ${this.hue.toStringAsFixed(2)}');
    assertTrue(
      amount >= -359.0 && amount < 360.0,
      '1248: Invalid amount $amount',
      method: 'SpinHue-Double',
    );
    return Hue(sanitizeDegreesDouble(_ - amount));
  }

  /// rotateHue on a 0 to 360 circle; invertHue by 180, same as complement
  /// if hue >= 180, hue = hue - 180
  /// else
  /// if hue <= 180, hue = hue + 180;
  /// Also [toSquareHarmonyHues]
  Hue get toComplementaryHue360 => Hue(sanitizeDegreesDouble(_ + 180.0));

  // credit: https://github.com/james-alex/color_models/blob/master/color_models/lib/src/helpers/color_adjustments.dart
  /// Adjusts [hue] towards `270` degrees (cooler/blue) by [percent],
  /// capping the value at `270` if exceeded.
  ///
  /// [percent] is a [Percent] value (0.0 to 1.0) indicating the proportion
  /// of the distance to 270° to move. If [relative] is true (default),
  /// the adjustment is a percentage of the distance to 270°; otherwise,
  /// it is treated as an absolute value.
  ///
  /// Returns a new [Hue] instance, adjusted towards 270°.
  Hue coolerHue(final Percent percent, {final bool relative = true}) {
    final double adjustment =
        relative ? differenceDegrees(270).val * percent.val : percent.val;

    // If hue is between 0° and 90°, move counterclockwise towards 270°
    if (val >= 0 && val <= 90) {
      return Hue.normalized(val - adjustment);
    }
    // If hue is between 270° and 360°, move counterclockwise, but cap at 270°
    else if (val >= 270 && val <= 360) {
      final double newHue = val - adjustment;
      if (newHue < 270) {
        return Hue.v270;
      } else {
        return Hue.normalized(newHue);
      }
    }
    // For hues between 90° and 270°, move clockwise towards 270°
    final double newHue2 = val + adjustment;
    if (newHue2 > 270) {
      return Hue.v270;
    }
    return Hue.normalized(newHue2);
  }

  // taken from https://github.com/james-alex/color_models/blob/master/color_models/lib/src/helpers/color_adjustments.dart
  /// Adjusts [hue] towards `90` degrees by [amount],
  /// capping the value at `90`.
  Hue warmerHue(final Percent percent, {final bool relative = true}) {
    final double adjustment =
        relative ? differenceDegrees(90).val * percent.val : percent.val;
    if (val >= 0 && val <= 90) {
      final double lHue = val + adjustment;
      if (lHue > 90) {
        return Hue.v90;
      } else {
        return Hue.clamped(lHue);
      }
    } else if (val >= 270 && val <= 360) {
      return Hue.normalized((val + adjustment) % 360);
    }
    final double lHue2 = val - adjustment;
    if (lHue2 < 90) {
      return Hue.v90;
    }
    return Hue.normalized(lHue2);
  }

  /// Extension type or data encoding type name as string
  String get name => 'Hue 360';
}

/// An extension type specifically for [Radians] and [Hue]
/// NOTICE that radians have have NEGATIVE values
/// A hue of 180 degrees is equivalent to π radians. (1 radian) A full circle
/// is 360 degrees, which is 2π radians. Therefore, 180 degrees is
/// half a circle, which is π radians. Also [Degrees],
extension type const Radians._(double _) implements Hue {
  const Radians(final double vl)
      : assert(vl >= -360.0 && vl <= 360.0, 'Invalid Radians at 52-$vl'),
        _ = vl; // named constructor

  static final String clName = (Radians).toString();

  String get toClassName => clName;

  double get val => _;
}

extension type const Degrees._(double _) implements Hue {
  const Degrees(final double vl)
      : assert(vl >= -360.0 && vl <= 360.0, 'Invalid Degrees at 52-$vl'),
        _ = vl; // named constructor

  static const String clName = 'Degrees';

  String get toClassName => clName;

  double get val => _;

  static const Degrees zero = Degrees(0.0);

  /// 'Less than' operator
  bool operator <(final Degrees otherDegrees) => _ < otherDegrees._;

  /// 'Add' operator, with return type in [Hue]
  Degrees operator +(final Degrees otherDegrees) =>
      Degrees((_ + otherDegrees._).sanitizeDegreesDouble);

  /// Clamped factory constructor, with validation, same as normalized
  factory Degrees.normalized(final double vl) =>
      Degrees(sanitizeDegreesDouble(vl));

  /// Linearly interpolate to another [Hue]
  Degrees lerpTo(final Hue otherHue, [final double percent = 0.20]) {
    final double factor = percent.assertPercentage();
    final Hue dist2 = Hue(differenceDegrees(val, otherHue.val));
    final double step = dist2.val * factor;
    // debugPrint(
    //   'DUAL: Distance between is $dist2--Factor is: $factor, step ' //
    //   'is: "$step"--value is: ${_.toStringAsFixed(3)}--$name',
    // ); // just testing here
    if (percent.isNegative) {
      return rotateHue(step, direction: RotationDirection.counterclockwise);
    }
    return rotateHue(step, direction: RotationDirection.clockwise);
  }

  /// aka LERPbyAmount, rotate hue on a 0-to-360-degree colorWheel,
  Degrees rotateHue(final double amount, {final RotationDirection? direction}) {
    // debugPrint(
    //   'inside ROTATE hue: amount passing is "$amount"--'
    //   'current value is ${_.toStringAsFixed(5)}-',
    // );
    if (amount.isPositive) {
      return increaseHue(amount);
    }
    return decreaseHue(amount);
  }

  /// Increase hue
  Degrees increaseHue(final double amount) {
    final Degrees degrees = Degrees((_ + amount) % 360.0);
    return Degrees((degrees.val < 0.0) ? (degrees.val + 360.0) : degrees.val);
  }

  Degrees decreaseHue(final double amount) {
    assertTrue(
      amount >= -359.0 && amount < 360.0,
      'decreaseHue: Invalid amount $amount',
      method: 'decreaseHue',
    );
    return Degrees(sanitizeDegreesDouble(_ - amount));
  }
}
