import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/extensions/float_ext_type.dart';
import 'package:color_iq_utils/src/extensions/num_helpers.dart';
import 'package:color_iq_utils/src/extensions/string_helpers.dart';
import 'package:color_iq_utils/src/foundation/constants.dart';
import 'package:color_iq_utils/src/foundation/enums.dart';

enum RangeType {
  standard, // i.e. linear standard number, math
  degrees, // e.g. wheel
  radians,
  chroma, // has infinite upper bounds
}

/// Manages values within a specified range
class RangeIQ<T extends num> implements Comparable<RangeIQ<T>> {
  /// The lower bound of the range.
  /// Can be null if the range has no lower bound.
  final T lowerLimit;

  /// The upper bound of the range.
  /// Can be null if the range has no upper bound.
  final T? upperLimit;

  /// The middle point along the Range, optional, used for calculations
  /// for closeness to the reference value
  final T? centerPoint;

  /// The type of range, such as Degrees, Radians, or standard math
  final RangeType rangeType;

  /// Optional name of this [RangeIQ]
  final String? name;

  /// Creates a new Range with lower bound and optional upper bound.
  /// [lowerLimit] - The lower bound of the range
  /// [upperLimit] - The upper bound of the range
  /// [rangeType] -- The type of range, such as degrees, radians, or standard
  /// [centerPoint] -- The middle point along the span or range
  /// [name] -- The optional name of this [RangeIQ]
  const RangeIQ(
    this.lowerLimit,
    this.upperLimit, {
    this.rangeType = RangeType.standard,
    this.centerPoint,
    this.name,
  });

  const RangeIQ.hue(
    this.lowerLimit,
    T this.upperLimit, {
    this.rangeType = RangeType.degrees,
    this.centerPoint,
    this.name,
  })  : assert(
          lowerLimit >= 0.0 && lowerLimit <= 359.0,
          'Invalid Lower Limit-HUE-$lowerLimit',
        ),
        assert(
          upperLimit >= lowerLimit && upperLimit <= 360.0,
          'Invalid Upper Limit-HUE- $upperLimit',
        );

  const RangeIQ.chroma(
    this.lowerLimit,
    T this.upperLimit, {
    this.rangeType = RangeType.chroma,
    this.centerPoint,
    this.name,
  })  : assert(
          lowerLimit >= 0.0 && lowerLimit <= kMaxChroma,
          'Invalid Lower Limit-CHROMA-$lowerLimit',
        ),
        assert(
          upperLimit >= lowerLimit && upperLimit <= kMaxChroma,
          'Invalid Upper Limit-CHROMA- $upperLimit',
        );

  const RangeIQ.tone(
    this.lowerLimit,
    T this.upperLimit, {
    this.rangeType = RangeType.standard,
    this.centerPoint,
    this.name,
  })  : assert(
          lowerLimit >= 0.0 && lowerLimit <= kMaxTone,
          'Invalid Lower Limit-TONE-$lowerLimit',
        ),
        assert(
          upperLimit >= lowerLimit && upperLimit <= kMaxTone,
          'Invalid Upper Limit-TONE- $upperLimit',
        );

  /// factory constructor to create a [RangeIQ] with validation
  factory RangeIQ.fromNum(
    final T startVal,
    final T endVal, {
    required final RangeType rangeType,
    T? centerPoint,
  }) {
    if (startVal == endVal && centerPoint == null) {
      centerPoint = startVal;
    }
    if (centerPoint == null) {
      centerPoint =
          math.max(startVal, endVal) - math.min(startVal, endVal) as T;
      if (rangeType == RangeType.degrees || rangeType == RangeType.radians) {
        centerPoint = centerPoint.toDouble().sanitizeDegreesNum as T;
      }
    }
    return RangeIQ<T>(
      startVal,
      endVal,
      centerPoint: centerPoint,
      rangeType: rangeType,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'min': min, 'max': max};

  factory RangeIQ.fromJson(final Map<String, dynamic> json) =>
      // ignore: always_specify_types
      RangeIQ(json['min'], json['max']);

  //

  /// Create a [RangeIQ] where there is only one value for both
  /// minimum and maximum
  const RangeIQ.staticValue(
    final T value, {
    this.centerPoint,
    this.rangeType = RangeType.standard,
    this.name,
  })  : lowerLimit = value,
        upperLimit = value;

  /// Create a [RangeIQ] with values set to zero
  const RangeIQ.zero({
    this.centerPoint,
    this.rangeType = RangeType.standard,
    this.name,
  })  : lowerLimit = 0 as T,
        upperLimit = 0 as T;

  /// Checks whether the input [val] is valid, in range
  T assertValid(final num val, {final String? msg}) {
    if (val.isNaN ||
        val.isInfinite ||
        (val.runtimeType != T && !val.isSubtypeOf<T>())) {
      throw ArgumentError.value(
        val,
        'assertValid',
        'Invalid type in assertValid-#1 ${val.runtimeType.toString()} and ' //
            'T is ${T.toString()}--${msg.orEmpty}',
      );
    }
    if (val.runtimeType == T || val.isSubtypeOf<T>()) {
      assertMinimum(val as T, msg: msg);
      if (upperLimit != null) {
        assertMaximum(val, msg: msg);
      }
      return val;
    }
    throw Exception(
      'Invalid type in assertValid-#2 ${val.runtimeType.toString()} and ' //
      'T is ${T.toString()}--${msg.orEmpty} ',
    );
  }

  /// Checks whether a value is within range
  bool isValidWithOptionalUpper(final num val) {
    if (val < lowerLimit) return false;
    if (upperLimit == null) {
      return true;
    }
    return (val <= upperLimit!);
  }

  /// Checks whether a value is within range
  bool isValidNonNull(final num val) {
    if (val < lowerLimit) return false;
    if (upperLimit == null) {
      return false;
    }
    return (val <= upperLimit!);
  }

  /// Assert that the value is equal to or greater than the lower limit
  T assertMinimum(final T val, {final String? msg}) => (val >= lowerLimit)
      ? val
      : throw ArgumentError(
          'Invalid minimum -- Lower limit is ' //
          '$lowerLimit -- but value was $val' //
          '${msg ?? toString()}',
        );

  /// Assert that the value is less than or equal to the maximum limit
  T assertMaximum(final T val, {final String? msg}) {
    if (upperLimit == null) {
      throw Exception(
        'Upper limit has not been set, is ' //
        'null-${msg ?? toString()}',
      );
    }
    return (val <= upperLimit!)
        ? val
        : throw ArgumentError(
            'Invalid Maximum -- upperLimit limit is ' //
            '${upperLimit!} -- but VALUE was $val ' //
            '${msg ?? toString()}',
          );
  }

  /// Determines whether the value is within the specified range
  bool contains(final num inValue) {
    final double lVal = inValue.toDouble();
    // handle unique case for RED, crossing 360, such as 350 to 5
    if ((upperLimit == null || lowerLimit > upperLimit!) && lowerLimit > 330) {
      if (upperLimit == null) {
        return lVal >= lowerLimit;
      }
      return lVal >= lowerLimit ||
          lVal <= upperLimit!; // this is an OR ...important *OR*
    }
    if (upperLimit == null) {
      return lVal >= lowerLimit;
    }
    return lVal >= lowerLimit && lVal <= upperLimit!;
  }

  bool contains2(final T value) => value >= lowerLimit && value <= toUpperLimit;

  /// Get the span or distance between
  /// See also [getMiddlePoint]
  double getDistance() =>
      upperLimit == null ? 0 : lowerLimit.differenceDegrees(upperLimit!);

  /// Retrieve the middle point in range, with a traditional getter method
  /// so other parameters and safeguards can be added in the future
  T getMiddlePoint() {
    if (centerPoint != null) {
      return centerPoint!;
    }
    if (upperLimit == null) {
      return lowerLimit + 1.0 as T;
    }
    final double dist = lowerLimit.differenceDegrees(upperLimit!);

    // double midVal = (start > end) ? ((start - end) / 2) : ((_end - _start) / 2);
    return (lowerLimit + (dist / 2)).sanitizeDegreesDouble as T;
  }

  T get toUpperLimit => upperLimit ?? lowerLimit + 1.0 as T;

  /// Another version of mid point, but as a standard Dart getter
  T get middlePoint {
    if (upperLimit == null) {
      return lowerLimit;
    }
    return (lowerLimit > upperLimit!)
        ? ((lowerLimit - upperLimit!) / 2) as T
        : ((upperLimit! - lowerLimit) / 2) as T;
  }

  /// Linearly interpolate to the middle point
  T lerpToMiddle(final T val, final LinRGB factor) {
    final num delta = val.difference(middlePoint);
    final double adjustment = (delta * factor.val);
    if (val > middlePoint) {
      return (val - adjustment) as T;
    }
    return (val + adjustment) as T;
  }

  /// Clamps a value within range from within the instance, not externally.
  T clampToRange(final T val) {
    if (val < lowerLimit) {
      return lowerLimit;
    }
    if (upperLimit == null) {
      return val;
    }
    if (val > upperLimit!) {
      return upperLimit!;
    }
    return val;
  }

  T clamp(final T value) => value < lowerLimit
      ? lowerLimit
      : (value > toUpperLimit ? toUpperLimit : value);

  double normalize(final T value) =>
      ((value - lowerLimit) / (toUpperLimit - lowerLimit)).clamp(0.0, 1.0);

  /// Clamp but allow unbounded upper limit (returns input when upper is null).
  T clampUnbounded(final T value) {
    if (value < lowerLimit) {
      return lowerLimit;
    }
    if (upperLimit == null) {
      return value;
    }
    if (value > upperLimit!) {
      return upperLimit!;
    }
    return value;
  }

  T get min => lowerLimit;

  T get max => upperLimit?.toDouble() as T? ?? double.infinity as T;

  // // Example usage:
  // final Range<double> chromaUnbounded = Range<double>(0.0, null, rangeType: RangeType.standard);
  // final bool ok = chromaUnbounded.containsUnbounded(150.0); // true (unbounded upper)
  // final double clamped = chromaUnbounded.clampUnbounded(999.0); // 999.0 (unchanged because unbounded)
  /// True when an upper limit exists.
  bool get hasUpperBound => upperLimit != null;

  /// Returns the upper limit as double, or `double.infinity` when unbounded.
  double get maxOrInfinity => upperLimit?.toDouble() ?? double.infinity;

  /// Returns span or `double.infinity` when unbounded.
  double get spanOrInfinity => hasUpperBound
      ? upperLimit!.toDouble() - lowerLimit.toDouble()
      : double.infinity;

  // Creates a random value within the specified [Range]
  T randomWithinRange([Random? random]) {
    random ??= Random();
    // WHEN upper limit is not set
    if (upperLimit == null) {
      while (true) {
        if (T is int) {
          final T rst = (lowerLimit + random.nextInt(kDefaultInt.floor())) as T;
          if (rst > lowerLimit) {
            return clampToRange(rst);
          }
        }
        if (T is num || T is double) {
          final T rst = (lowerLimit + (random.nextDouble() * 256)) as T;
          if (rst > lowerLimit) {
            return clampToRange(rst);
          }
        }
      }
    }
    if (T is int) {
      final T ret = (lowerLimit +
          random.nextInt(upperLimit! as int) * (upperLimit! - lowerLimit)) as T;
      return clampToRange(ret);
    }
    // must be a double or num
    final T r2 =
        (lowerLimit + random.nextDouble() * (upperLimit! - lowerLimit)) as T;
    return clampToRange(r2);
  }

  /// Get a random item between min and max,
  /// from MIN(inclusive), to MAX(exclusive).
  static T randomBetween<T extends num>(
    final T min,
    final T max, [
    Random? random,
  ]) {
    random ??= Random();
    if (T is int) {
      final int minVal = min as int;
      final int maxVal = max as int;
      final T r1 = minVal + random.nextInt(maxVal - minVal) as T;
      return r1.clamp(min, max) as T;
    }
    // must be num or double
    final double dMinVal = min as double;
    final double dMaxVal = max as double;
    final T r2 = dMinVal + (random.nextDouble() * (dMaxVal - dMinVal)) as T;
    return r2.clamp(dMinVal, max) as T;
  }

  // from MIN(inclusive), to MAX(exclusive).
  static T randomBetweenInclusive<T extends num>(
    final T min,
    final T max, [
    Random? random,
  ]) {
    random ??= Random();
    if (T is int) {
      final int minVal = min as int;
      final int maxVal = max as int;
      final T r1 = minVal + random.nextInt((maxVal + 1) - minVal) as T;
      return r1.clamp(min, max) as T;
    }
    // must be num or double
    final double dMinVal = min as double;
    final double dMaxVal = max as double;
    final T r2 =
        dMinVal + (random.nextDouble() * ((dMaxVal + 0.01) - dMinVal)) as T;
    return r2.clamp(dMinVal, max) as T;
  }

  // from MIN(inclusive), to MAX(exclusive).
  static T randomBetweenExclusive<T extends num>(
    final T min,
    final T max, [
    Random? random,
  ]) {
    random ??= Random();
    if (T is int) {
      final int minVal = min as int;
      final int maxVal = max as int;
      final T r1 = (minVal + 1) + random.nextInt(maxVal - (minVal + 1)) as T;
      return r1.clamp(min, max) as T;
    }
    // must be num or double
    final double dMinVal = min as double;
    final double dMaxVal = max as double;
    final T r2 = (dMinVal + 0.01) +
        (random.nextDouble() * (dMaxVal - (dMinVal + 0.01))) as T;
    return r2.clamp(dMinVal, max) as T;
  }

  /// Plus operator (addition operator)
  RangeIQ<T> operator +(final RangeIQ<T> otherRange) => RangeIQ<T>(
        ((lowerLimit + otherRange.lowerLimit) / 2) as T,
        upperLimit,
        rangeType: rangeType,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is RangeIQ &&
          runtimeType == other.runtimeType &&
          lowerLimit == other.lowerLimit &&
          upperLimit == other.upperLimit;

  @override
  int compareTo(final Object other) {
    return (other is RangeIQ &&
            runtimeType == other.runtimeType &&
            lowerLimit == other.lowerLimit &&
            upperLimit == other.upperLimit)
        ? 0
        : -1;
  }

  @override
  int get hashCode => lowerLimit.hashCode ^ upperLimit.hashCode;

  String toString2() =>
      '[${min != double.infinity ? min : "-∞"}, ${max != double.infinity ? max : "∞"}]';
  String toString3() => '[$min, $max]';

  @override
  String toString() {
    final StringBuffer sb = StringBuffer(name == null ? '' : '$name--');
    sb.write(
      'min (lower limit): ' //
      '${lowerLimit.toStringAsFixed(3).bracketWithDoubleParens}, ',
    );
    if (upperLimit != null) {
      sb.write(
        'max (upper limit): ' //
        '${upperLimit!.toStringAsFixed(3).bracketWithDoubleParens}',
      );
    }
    return sb.toString();
  }
}

/// Range for RGBLinear percents, (factored, normalized), etc.
const RangeIQ<LinRGB> rangeLinearRGB = RangeIQ<LinRGB>(
  LinRGB.minInst,
  LinRGB.maxInst,
  centerPoint: LinRGB.midInst,
  rangeType: RangeType.standard,
);

/// Range for RGBLinear percents, (factored, normalized), etc.
const RangeIQ<Percent> rangePercents = RangeIQ<Percent>(
  Percent.min,
  Percent.max,
  centerPoint: Percent.mid,
  rangeType: RangeType.standard,
);

/// Range for RGBLinear percents, (factored, normalized), etc.
const RangeIQ<SRGB> rangeSRGB = RangeIQ<SRGB>(
  SRGB.minInst,
  SRGB.maxInst,
  centerPoint: SRGB.midInst,
  rangeType: RangeType.standard,
);

// https://github.com/material-foundation/material-color-utilities/blob/main/dart/lib/utils/math_utils.dart
// https://www.trysmudford.com/blog/linear-interpolation-functions/
// float lerp(float v0, float v1, float t) { This is for 0.to 1.0 ONLY
// Precise method, which guarantees v = v1 when t = 1. This method is
// monotonic only when v0 * v1 < 0.
/// The linear interpolation function.
///
/// Returns start if amount = 0 and stop if amount = 1
///    return (1.0 - amount) * start + amount * stop;
/// See also [interpolate]
N lerpTo<N extends num>(
  final N start,
  final N end,
  final double amount, {
  required final N? maxValue,
  final ChannelAdjustMode lerpMode = ChannelAdjustMode.byPercentOfCurrentValue,
}) {
  assert(
    start.isFinite,
    'Cannot interpolate between finite and non-finite values',
  );
  assert(
    end.isFinite,
    'Cannot interpolate between finite and non-finite values',
  );
  assert(amount.isFinite, 't must be finite when interpolating between values');
  if (end == start || amount <= LinRGB.minInst.val || end.isNaN) {
    return start;
  }
  if (start.isNaN || amount >= LinRGB.maxInst.val) {
    return end;
  }
  if (maxValue != null && amount >= maxValue) {
    // debugPrint(
    //   "returning early at 64...$maxValue and " //
    //   "$amount--$end-${lerpMode.name}",
    // );
    return end;
  }
  num delta = (end - start).abs();
  if (start > end && delta > 0) {
    delta *= -1; // negate the return value if going to minimum
  }
  // debugPrint(
  //   '82: inside LERPing...start: "$start" and end: "$end" ' //
  //   'amount: "$amount", delta is: "$delta"; ' //
  //   'Mode is: "${lerpMode.name}"',
  // );
  final double result = switch (lerpMode) {
    ChannelAdjustMode.interpolate => (start + (delta * amount)),
    ChannelAdjustMode.lerp => ((1 - amount) * start) + (amount * end),
    ChannelAdjustMode.byPercentOfCurrentValue =>
      (end > start) ? (start + (start * amount)) : (start - (start * amount)),
    ChannelAdjustMode.byPercentOfWhole => (end > start)
        ? (start + (amount * (maxValue ?? end)))
        : (start - (amount * (maxValue ?? end))),
  };
  // debugPrint(
  //   '108: returning result of LERP...."$result" based on '
  //   'start: "$start" and end: "$end" and ' //
  //   'difference "$delta" amount: "$amount", ' //
  //   'mode is: ${lerpMode.name.bracketWithSucceedsPrecedes}',
  // );

  // will return a signed value (plus or minus here)
  if (N == int || N.runtimeType == int) {
    // debugPrint("N IS INT...do a round()");
    return result.round() as N;
  }
  return result as N;
}

/// Lerp Higher, unbounded
N lerpHigher<N extends num>(final N src, final LinRGB percent) =>
    (src + (src * percent.val)) as N;

/// LERP lower, unbounded
N lerpLower<N extends num>(final N src, final LinRGB percent) =>
    (src - (src * percent.val)) as N;
