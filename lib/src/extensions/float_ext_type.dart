import 'dart:math' as math;

import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/extensions/num_helpers.dart';
import 'package:color_iq_utils/src/extensions/string_helpers.dart';
import 'package:color_iq_utils/src/foundation/constants.dart';
import 'package:color_iq_utils/src/foundation/enums.dart';
import 'package:color_iq_utils/src/foundation/range.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:color_iq_utils/src/utils/error_handling.dart';

/// A base extension type for floating-point values used throughout the library.
///
/// `FltType` wraps a [double] and serves as the foundation for more specific
/// float-based extension types like [Percent], [SRGB], and [LinRGB].
/// It uses Dart's extension type feature to provide compile-time type safety
/// and specific functionality without the runtime overhead of a traditional
/// wrapper class.
///
/// As an `implements double`, it can be used wherever a `double` is expected,
/// but it also defines a set of constructors and operators that are often
/// overridden by its more specialized subtypes to enforce specific constraints
/// (e.g., clamping values to a 0.0-1.0 range).
///
/// This type is not typically instantiated directly by consumers. Instead, one
/// of its subtypes should be used.
extension type const FloatIQ._(double _) implements double {
  /// Constant constructor
  const FloatIQ(final double val) : this._(val);

  const factory FloatIQ.percent(final double value) = Percent;

  const factory FloatIQ.zeroTo1(final double value) = Percent;

  const factory FloatIQ.factored(final double value) = Percent;

  const factory FloatIQ.srgb(final double value) = Percent;

  const factory FloatIQ.fractionalized(final double value) = Percent;

  const factory FloatIQ.linearized(final double value) = LinRGB;
  const factory FloatIQ.linearize(final double value) = LinRGB;

  const factory FloatIQ.lightnessHsl(final double value) = Percent;

  const factory FloatIQ.saturation(final double value) = Percent;

  const factory FloatIQ.valueHsv(final double value) = Percent;

  const factory FloatIQ.lrv(final double value) = Percent;

  const factory FloatIQ.xyzX(final double value) = Xxyz;

  const factory FloatIQ.xyzY(final double value) = Yxyz;

  const factory FloatIQ.xyzZ(final double value) = Zxyz;

  /// Takes a max val and assumes 0 for minimum
  const FloatIQ.fromUnchecked(
    final double vl,
    final double maxVal, {
    final String? msg,
  })  : _ = vl,
        assert(
          vl >= minFloat8 && vl <= maxVal,
          'FxFloat.fromUnchecked: ${msg ?? ''}-"$vl"',
        );

  factory FloatIQ.clampBetween(
    final double val,
    final double minVal,
    final double maxVal,
  ) =>
      FloatIQ(clampDouble(val, min: minVal, max: maxVal));

  factory FloatIQ.clampInRange(final double val, final RangeIQ<double> range) =>
      FloatIQ(
        clampDouble(
          val,
          min: range.lowerLimit,
          max: range.upperLimit ?? range.getMiddlePoint(),
        ),
      );

  factory FloatIQ.assertBetween(
    final double val,
    final double minVal,
    final double maxVal, {
    final String? msg,
    final Object? source,
  }) {
    final double valNum = assertInRange<double>(
      val,
      lowest: minVal,
      highest: maxVal,
      msg: msg,
      source: source,
    );
    return FloatIQ(valNum);
  }

  /// The value for this double
  double get val => _;

  static const double minValFxFloat = 0.0;
  static const FloatIQ zero = FloatIQ(0.0);
  static const FloatIQ minInstance = FloatIQ.zero;

  double get toMinVal => FloatIQ.minInstance._;

  FloatIQ operator +(final FloatIQ otherVal) => FloatIQ(_ + otherVal._);

  /// "Minus" operator. Results are returned in type of [FloatIQ].
  /// These operators are typically overridden by the more-specific subtypes.
  /// This will NOT clamp the value so it best handled by the API client.
  FloatIQ operator -(final FloatIQ otherVal) => FloatIQ(_ - otherVal._);

  /// A general "Multiply" operator. Results are returned in type of [FloatIQ].
  /// These operators are typically overridden by the more-specific subtypes.
  FloatIQ operator *(final FloatIQ otherVal) =>
      FloatIQ((_ * otherVal._).clamp(0.0, fxFloat8bitInfinity));

  /// A general "Division" operator. Results are returned in type of [FloatIQ].
  /// These operators are typically overridden by the more-specific subtypes.
  FloatIQ operator /(final FloatIQ otherVal) =>
      FloatIQ((_ / otherVal._).clamp(0.0, fxFloat8bitInfinity));

  /// A general "Modulus" operator. Results are returned in type of [FloatIQ].
  /// Returns the remainder in [FloatIQ] format when a number is divided
  /// by another number.  (It's essentially the "leftover" after dividing).
  FloatIQ operator %(final FloatIQ otherVal) =>
      FloatIQ((_ % otherVal._).clamp(0.0, 1.0));

  String toStringAsFixed([final int decimals = 5]) =>
      _.toStringAsFixed(decimals);

  static const String name = "FltType";
}

extension MapStringToFloatHelper on Map<String, FloatIQ> {
  String get asStr4Printing {
    return toStrings.join(kSemiColonNL);
  }

  List<String> get toStrings {
    final List<String> strs = List<String>.empty(growable: true);
    final Iterable<MapEntry<String, FloatIQ>> ents = entries;
    for (final MapEntry<String, FloatIQ> e in ents) {
      strs.add('${e.key}: ${e.value.toString()}');
    }
    return strs;
  }
}

/// An extension type representing a percentage value in the range of 0.0 to 1.0.
///
/// `Percent` is a specialized version of [FloatIQ] that ensures its underlying
/// [double] value is always within the [0.0, 1.0] range. It is used as a base
/// type for various color channel components that are expressed as fractions,
/// such as saturation, lightness, and RGB channel values.
///
/// This type provides:
/// - **Compile-time safety**: Guarantees that values are percentages without
///   runtime overhead.
/// - **Validation**: Constructors and factories assert or clamp values to
///   ensure they remain within the valid 0.0 to 1.0 range.
/// - **Utility methods**: Includes methods for interpolation (`lerpTo`),
///   inversion (`inverted`), and convenient formatting (`toPercentString`).
/// - **Predefined constants**: Offers constants for common percentage values
///   like `zero`, `midInst` (0.5), and `max` (1.0) for efficiency and
///   readability.
///
/// It serves as the supertype for more specific fractional types for gamma correction
/// (non-linear, gamma-corrected RGB) and [LinRGB] (linear RGB), inheriting
/// its constraints and base functionality.
extension type const Percent._(double _) implements FloatIQ {
  /// Constant constructor.
  const Percent(final double val, {final String? msg})
      : assert(
          val >= Percent.minVal && val <= Percent.maxVal,
          '$errorMsgFloat0to1-"$val"--${msg ?? //
              'Error: PercentType'}',
        ),
        _ = val;

  /// Clamped factory constructor, with validation
  factory Percent.clamped(
    final double val0to1dot0, {
    final String? msg,
    final double? tolerance,
  }) {
    if (val0to1dot0.isInfinite || val0to1dot0.isNaN) {
      throw Error0to1(val0to1dot0, msg: msg);
    }
    return Percent._legend.clampedWithEncoding(
      val0to1dot0,
      tolerance: tolerance,
      msg: msg,
    );
  }

  /// Constructor to clamp and create [SRGB] from a linear RGB; i.e.
  /// from a NON-gamma-corrected, non-SRGB value. In other words, when
  /// the linear-to-srgb transformation has NOT yet taken place.
  /// [linear0to1Float] 0.0 <= linear0to1Float <= 1.0, represents linearRGB
  ///
  /// This constructor returns the sRGB color space value in range [0.0-1.0]
  /// for [linearVal], assuming [linearVal] is in linear RGB in range [0.0-1.0].
  factory Percent.fromLinRGB(
    final LinRGB linear0to1Float, {
    final String? msg,
    final double? tolerance,
  }) {
    if (linear0to1Float.isInfinite ||
        linear0to1Float.isNaN ||
        linear0to1Float.isNegative) {
      throw Error0to1(linear0to1Float, source: name, msg: msg);
    }
    assertTrue(
      0.0 <= linear0to1Float && linear0to1Float <= 1.0,
      'Invalid Percent at validate0to1$kRightwardsSquiggleArrow' //
      '"$linear0to1Float" -- ' //
      '$errorMsgFloat0to1--${msg.orEmpty}',
    );
    final double correctedVal = applyGamma(linear0to1Float);
    return Percent(
      Percent._legend.clampedWithEncoding(
        correctedVal,
        tolerance: tolerance,
        msg: msg,
      ),
    );
  }

  /// Constructor to clamp and create [SRGB] from a linear RGB; i.e.
  /// from a NON-gamma-corrected, non-SRGB value. In other words, when
  /// the linear-to-srgb transformation has NOT yet taken place.
  /// [linear0to1Float] 0.0 <= linear0to1Float <= 1.0, represents linearRGB
  ///
  /// This constructor returns the sRGB color space value in range [0.0-1.0]
  /// for [linearVal], assuming [linearVal] is in linear RGB in range [0.0-1.0].
  factory Percent.fromLinear(
    final double linear0to1Float, {
    final String? msg,
    final double? tolerance,
  }) {
    if (linear0to1Float.isInfinite ||
        linear0to1Float.isNaN ||
        linear0to1Float.isNegative) {
      throw Error0to1(linear0to1Float, source: name, msg: msg);
    }

    final double correctedVal = applyGamma(linear0to1Float.clamp(0.0, 1.0));
    return Percent(correctedVal);
  }

  /// Clamped factory to accept a standard int and send it back as
  /// a Percent or null
  static Percent? fromIntOrNull(final int? val, {final String? msg}) {
    if (val == null || val.isInfinite || val.isNaN) {
      return null;
    }
    if (val < 0 || val > 255) {
      return null;
    }
    return Percent((val / 255).clamp0to1);
  }

  /// Constant constructor used as a functional pointer by the legend,
  /// which requires a named constructor
  const Percent.fromDouble(final double val, {final String? msg})
      : assert(
          val >= Percent.minVal && val <= Percent.maxVal,
          '$errorMsgFloat0to1-"$val"--${msg ?? //
              'Error: PercentType'}',
        ),
        _ = val;

  /// Delinearize. Constructor to clamp and create [SRGB] from a linear RGB,
  /// aka NON-gamma-corrected, non-SRGB value -- when the linear-to-srgb
  /// transformation has NOT yet taken place.
  /// [linear0to100Float] 0.0 <= linear0to100Float <= 100.0, represents linear
  /// R/G/B channel
  /// This constructor returns the sRGB color space value in range [0.0-1.0]
  /// for [linearVal], assuming [linearVal] is in linear RGB in range [0.0-100.0].
  factory Percent.delinearizeFrom0to100float(
    final double linear0to100Float, {
    final String? msg,
    final double? tolerance,
    final bool applyClamp = false,
  }) {
    final double correctedVal = applyGamma(
      applyClamp
          ? (linear0to100Float / 100.0).clamp(0.0, 1.0)
          : (linear0to100Float / 100.0),
    );
    return Percent(
      Percent._legend.clampedWithEncoding(
        correctedVal,
        tolerance: tolerance,
        msg: msg,
      ),
    );
  }

  double get val => _;
  double get value => _;

  /// Adds another [Percent] value, clamping the result to the `0.0-1.0` range.
  Percent operator +(final Percent otherVal) => Percent(_ + otherVal._);

  /// Multiplies this percentage by a [double].
  ///
  /// Note: The result is a raw [double] and is not clamped or validated
  /// as a [Percent].
  double operator *(final double otherVal) => (_ * otherVal);

  Percent replace(final double val) => Percent(val);
  Percent decreaseBy(final Percent amount) =>
      Percent((_ - amount.value).clamp(0.0, 1.0));

  static Percent? validOrNull(
    final double? val, {
    final String? msg,
    final double? tolerance,
  }) {
    if (val == null || val.isInfinite || val.isNaN) {
      return null;
    }
    if (val >= Percent.minVal && val <= Percent.maxVal) {
      return Percent(val);
    }
    if (tolerance == null) {
      return null;
    }
    return Percent._legend.clampValue(val, msg: msg, tolerance: tolerance);
  }

  /// Converts this percentage to an 8-bit integer (`0` to `255`).
  ///
  /// The percentage (0.0 to 1.0) is scaled by 255, rounded, and clamped
  /// to ensure it falls within the valid 8-bit range.
  int get toInt0to255 => (_ * 255).round().clamp(0, 255);

  /// Creates a new [Percent] instance representing the inverse of the given
  /// `val` (1.0 - val).
  ///
  /// Asserts that the input `val` is within the `0.0-1.0` range.
  static Percent toInvertFactored(final double val, {final String? msg}) =>
      Percent(1 - val.assertRange0to1(msg));

  /// Returns the inverse of this percentage (1.0 - this).
  Percent get inverted => Percent.toInvertFactored(_);

  /// Flips the percentage value around the 50% mark.
  ///
  /// For example, `0.2` becomes `0.8`, and `0.7` becomes `0.3`. This is
  /// equivalent to `inverted`.
  Percent get flipAround50percent => Percent(1 - _);

  /// Returns the name of the type, used for identification and error messages.
  static String get name => 'PercentType';

  /// Converts the percentage to a string representation, trimming trailing zeros.
  ///
  /// [decimals] specifies the maximum number of decimal places.
  String toPercentString([final int decimals = 4]) =>
      _.toStrTrimZeros(decimals);

  /// The legend to use for validation
  static const PercentsLegend _legend = legendPercent;

  /// Gets the [PercentsLegend] descriptor for this type, which contains
  /// metadata like range and validation functions.
  PercentsLegend get toDescriptor => Percent._legend;

  /// Linearly interpolate from this value to the target value.
  Percent lerpTo(
    final double target,
    final double factor, {
    final String? msg,
  }) {
    final double clampedPercent = factor.assertPercentage(msg: msg);
    final double clampedTarget = target.clamp(Percent.minVal, Percent.maxVal);
    if (_ == clampedTarget || clampedPercent == 0.0) {
      return this;
    }
    if (clampedPercent == 1.0) {
      return Percent(clampedTarget);
    }
    final double result = lerpDouble(
      _,
      clampedTarget,
      clampedPercent,
    ).orThrow(msg);
    return Percent(result);
  }

  /// Linearly interpolate to minimum
  Percent lerpToMin(
    final double percent, {
    final String? msg,
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) {
    if (_ == Percent.minVal || this == Percent.min) {
      return this;
    }
    return Percent._legend.lerpToMin(
      this,
      percent.assertPercentage(msg: msg),
      lerpMode: lerpMode,
    );
  }

  /// Linearly interpolate to the maximum amount
  Percent lerpToMax(
    final double percent, {
    final String? msg,
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) {
    if (_ == Percent.maxVal || this == Percent.max) {
      return this;
    }
    return Percent._legend.lerpToMax(
      this,
      percent.assertPercentage(msg: msg),
      lerpMode: lerpMode,
    );
  }

  /// static method to determine if the parameter is valid
  static bool isValid(final double val) => _legend.isValid(val);
  static const double minVal = 0.0;
  static const double midVal = 0.5;
  static const double maxVal = 1.0;

  /// precompiled constant values for efficiency
  static const Percent min = Percent(0.0); // 0% or 0.0
  static const Percent zero = Percent(0.0);
  static const Percent mid = Percent(0.50); // 50% or 0.5
  static const Percent half = Percent.mid;
  static const Percent max = Percent(1.0);
  static const Percent v0 = Percent(0.0);
  static const Percent v05 = Percent(0.05);
  static const Percent v5 = Percent.v05;
  static const Percent v10 = Percent(0.10);
  static const Percent tenth = Percent.v10;
  static const Percent v12 = Percent(0.12);
  static const Percent v15 = Percent(0.15);
  static const Percent v20 = Percent(0.20);
  static const Percent v25 = Percent(0.25);
  static const Percent v30 = Percent(0.30); //
  static const Percent v40 = Percent(0.40);
  static const Percent v50 = Percent(0.50);
  static const Percent v60 = Percent(0.60);
  static const Percent v70 = Percent(0.70);
  static const Percent v75 = Percent(0.75);
  static const Percent v80 = Percent(0.80);
  static const Percent v85 = Percent(0.85);
  static const Percent v87 = Percent(0.87);
}

/// An extension type representing a linear RGB channel value in the range of
/// 0.0 to 1.0.
///
/// `LinRGB` (Linear RGB) values have a linear relationship with light intensity.
/// They are used for accurate color calculations, blending, and transformations.
/// This contrasts with [SRGB] values, which are non-linear ("gamma-corrected")
/// and optimized for display.
///
/// `LinRGB` is also known by other names, such as "linearized", "normalized",
/// "factored", or "RGB percent".
///
/// Key features:
/// - **Validation**: Constructors and factories either clamp a [double] to the
/// 0.0-to-1.0 range or to throw an exception if the value exceeds
/// the bounds.
/// - **Conversion**: The `linearToSrgb` getter provides an easy way to apply
///   gamma correction and ops a linear value to its non-linear [SRGB]
///   equivalent for display.
/// - **Efficiency**: Predefined constants for common values (e.g., `zero`,
///   `midInst`, `maxInst`) improve performance and code readability.
///
/// See also [SRGB]
extension type const LinRGB._(double _) implements Percent {
  /// Constant constructor NOTE: This assumes no gamma-adjustments are needed
  const LinRGB(final double vl, {final String? msg})
      : assert(
          vl >= LinRGB.minVal && vl <= LinRGB.maxVal, //
          '$errorMsgFloat0to1-"$vl"--' //
          '${msg ?? 'Error: Constructor-RgbPercent-Linear sRGB'}',
        ),
        _ = vl;

  /// Clamped factory constructor, with validation
  factory LinRGB.clamped(
    final double linearRgbVal, {
    final String? msg,
    final double? tolerance,
  }) {
    if (linearRgbVal.isInfinite || linearRgbVal.isNaN) {
      throw Error0to1(linearRgbVal, msg: msg);
    }
    return LinRGB._legend.clampedWithEncoding(
      linearRgbVal,
      tolerance: tolerance,
      msg: msg,
    );
  }

  factory LinRGB.checkOrThrow(final num vl, {final String? msg}) =>
      LinRGB._legend.checkOrThrow(vl.toDouble(), msg: msg);

  double get val => _;

  /// The legend to use for validation
  static const LinearRGBLegend _legend = legendLinearRGB;

  LinearRGBLegend get toDescriptor => LinRGB._legend;

  /// Linearly interpolate to minimum
  LinRGB lerpToMin(
    final double percent, {
    final String? msg,
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) =>
      _legend.lerpToMin(
        this,
        percent.assertPercentage(msg: msg),
        lerpMode: lerpMode,
      );

  /// Linearly interpolate to center, mid-point
  LinRGB lerpToMid(
    final double percent, {
    final String? msg,
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) =>
      _legend.lerpToCenter(this, percent.assertPercentage(msg: msg));

  /// Linearly interpolate to the maximum amount
  LinRGB lerpToMax(
    final double percent, {
    final String? msg,
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) =>
      _legend.lerpToMax(
        this,
        percent.assertPercentage(msg: msg),
        lerpMode: lerpMode,
      );

  /// static method to determine if the parameter is valid
  static bool isValid(final double val) => _legend.isValid(val);

  static const double minVal = 0.0;
  static const double midVal = 0.5;
  static const double maxVal = 1.0;

  /// precompiled constant values for efficiency
  static const LinRGB minInst = LinRGB(minVal); // 0% or 0.0
  static const LinRGB maxInst = LinRGB(1.0); // 100% or 1.0
  static const LinRGB midInst = LinRGB(0.5); // 50% or 0.5
  static const LinRGB v0 = LinRGB.minInst; // 0%
  static const LinRGB zero = LinRGB.minInst; // 0%
  static const LinRGB v05 = LinRGB(0.05); // 15%
  static const LinRGB v15 = LinRGB(0.15); // 15%
  static const LinRGB v25 = LinRGB(0.25); // 25%  // v is for value
  static const LinRGB v30 = LinRGB(0.30); //
  static const LinRGB v50 = LinRGB.midInst; // 50%
  static const LinRGB v54 = LinRGB(0.54);
  static const LinRGB v75 = LinRGB(0.75); // 75%
  static const LinRGB v100 = LinRGB.maxInst; // 100%

  // https://pages.hmc.edu/ruye/e161/lectures/ColorProcessing/node2.html
  /// Factory constructor used only by HSI
  factory LinRGB.fromRGB({
    required final int red,
    required final int green,
    required final int blue,
  }) =>
      LinRGB(((red / 0xFF) + (green / 0xFF) + (blue / 0xFF)) / 3.0);

  /// Static method to create [LinRGB] from any [double] with
  /// automatic clamping to range of 0.0 to 1.0. This is less restrictive
  /// that other proxy constructors and defaults to not using the
  /// precompiled values, thus allowing any double value in range.
  static LinRGB fromDouble(
    final double anyDbl, {
    final bool useClamp = true,
    final double? tolerance,
    final String? msg,
  }) {
    if (anyDbl.isInfinite || anyDbl.isNaN || anyDbl.isNegative) {
      throw Error0to1(anyDbl, source: LinRGB.clName, msg: msg);
    }

    if (useClamp) {
      return LinRGB(anyDbl.clamp(0.0, 1.0), msg: msg);
    }
    assertTrue(
      0.0 <= anyDbl && anyDbl <= 1.0,
      'Invalid Percent at validate0to1-$anyDbl -- $errorMsgFloat0to1' //
      '${msg ?? errorMsgFloat0to1}',
    );
    return LinRGB(anyDbl);
  }

  // https://dart.dev/language/extension-types
  /// Multiplies [otherVal] by this number. Clamps values that are
  /// out of range.
  LinRGB operator *(final LinRGB otherVal) => LinRGB.clamped(_ * otherVal._);

  // https://dart.dev/language/extension-types
  /// Division operator.  See also [*] operator
  LinRGB operator /(final LinRGB otherVal) => LinRGB(_ / otherVal._);

  /// "Modulus" operator.  Returns the remainder in [LinRGB] format
  /// when a number is divided
  LinRGB operator %(final num otherVal) => LinRGB(_ % otherVal);

  /// Subtracts [otherVal] from this number. NOTE: the result
  /// will be automatically clamped by the constructor. Thus, it's best
  /// to use the *val getter to control the actual math operations outside
  /// the boundaries.
  /// See also multiplication operator [*], addition operator [+]
  LinRGB operator -(final LinRGB otherVal) => LinRGB.clamped(_ - otherVal._);

  // https://dart.dev/language/extension-types
  /// Addition operator. Adds [otherVal] to this number. NOTE:
  /// Clamps values that are out of range in the constructor. it's best
  /// to use the *val getter to control the actual math operations outside
  /// the boundaries.
  /// See also minus operator [-] assert(2 + 3 == 5);
  LinRGB operator +(final LinRGB otherVal) => LinRGB.clamped(_ + otherVal._);

  /// Class name, used in error-handling and mapping
  static const String clName = 'RgbPercent-sRgbLinear';

  /// Invert a factored float (aka RGB percent or ARGB normalized)
  LinRGB get complement => LinRGB(1 - _);

  // LinRGB get inverted => _.invertFactored();

  /// Get the delinearized (non-linear) value (sRGB)
  Percent get linearToSrgb => Percent(applyGamma(_));

  /// Similar to plus operator but acts on any [num]
  LinRGB plus(final num otherVal) => LinRGB.clamped(_ + otherVal.toDouble());

  /// Similar to minus operator but acts on any [num]
  LinRGB minus(final num otherVal) => LinRGB.clamped(_ - otherVal.toDouble());

  static LinRGB getSumOfList(final List<LinRGB> inList) =>
      inList.reduce((final LinRGB a, final LinRGB b) => a + b);

  String toStringAsFixed([final int decimals = 4]) =>
      _.toStringAsFixed(decimals);

  // String get toShortHexStr => toUint8.toStringHexShort();

  Percent get gammaCorrect => oetf(_);

  String to100PercentStr([final int decimals = 4]) =>
      (_ * 100).toStrTrimZeros(decimals) + kPercentSign;
} // ------------------- End of Extension type ----------------------
/// Linear to sRGB (Encoding): OETF (Opto-Electronic Transfer Function (OETF)
/// Apply gamma transfer function, i.e. ops from LinearRGB to non-linear
/// SRGB. The input value is assumed to a LinearRGB value in the
/// range of 0 to 1.0, i.e. one that is often called 'normalized',
/// as 'RGB Percent,' or 'LinearRGB.
Percent oetf(
  double linearRgbFloat0to1, {
  final String? msg,
  final double tolerance = 0.0003, // epsilon ??
}) {
  linearRgbFloat0to1 = linearRgbFloat0to1.assertPercentage(
    msg: msg,
    tolerance: tolerance,
  );
  // the Gamma threshold - breakpoint
  if (linearRgbFloat0to1 >= kGammaDelinearize) {
    // 0.0031308) {
    return Percent(
        1.055 * math.pow(linearRgbFloat0to1, 1.0 / kGammaVal) - 0.055);
  } else {
    return Percent(12.92 * linearRgbFloat0to1);
  }
}

/// EOTF (Electro-Optical Transfer Function): Converts a non-linear sRGB value
/// back to a linear RGB value.
///
/// This function performs the inverse of the `oetf` operation by removing
/// the gamma correction from an sRGB color channel. The result is a "linear"
/// value in the [0.0, 1.0] range, suitable for mathematical calculations.
///
/// "Linear RGB" is also known by other names, such as 'linearized',
/// 'normalized', or 'gamma-decoded'.
LinRGB eotf(final double srgbNonLinearVal0to1, {final String? msg}) {
  srgbNonLinearVal0to1.assertPercentage(msg: msg);
  if (srgbNonLinearVal0to1 <= chi) {
    // 0.040449936) {
    // 0.04045) {
    return LinRGB(srgbNonLinearVal0to1 / 12.92);
  }
  return LinRGB(
    math.pow((srgbNonLinearVal0to1 + 0.055) / 1.055, kGammaVal) as double,
  );
}

typedef TdCheckCastFN<T extends num> = T Function(T, {String? msg});

/// Descriptor for a single property (channel) in a single ColorModel, such
/// as the hue in HSV or chroma in LCH
sealed class PropertyLegend<T extends num> {
  /// The name or description for this Descriptor
  final String label;

  /// The Range for this descriptor
  final RangeIQ<T> range;

  /// The function pointer to validate an entered value and spawns a new
  /// instance of [T] or throw an exception.
  final TdCheckCastFN<T> _checkAndCastFN;

  /// Creates a new [PropertyLegend] with its Range specifications and
  /// validation functions
  const PropertyLegend({
    required this.label,
    required this.range,
    required final TdCheckCastFN<T> checkAndCastFN,
  }) : _checkAndCastFN = checkAndCastFN;

  /// Linearly interpolate to the lower limit
  T lerpToMin(
    final T val,
    final double percent, {
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) {
    // debugPrint(
    //   '${Fox.circledWhiteStar} 49 (lerpToMin): ' //
    //   'LERP to Min (val) $val --(minVal) $minVal --(maxVal) $maxVal',
    // );
    if (val == minVal) {
      return minVal;
    }
    final T rslt = lerpTo(
      val,
      minVal,
      percent,
      maxValue: maxVal,
      lerpMode: lerpMode,
    );
    // debugPrint(
    //   '${Fox.circledWhiteStar} 52 (RETURNING): ' //
    //   'LERP to Min (val) $val --(minVal) $minVal --(maxVal) $maxVal',
    // );
    return toCheckCastFN(rslt);
  }

  /// Lerp to the Center
  T lerpToCenter(
    final T val,
    final double percent, {
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.lerp,
  }) {
    if (val == midVal) {
      return val;
    }
    return lerpTo(val, midVal, percent, maxValue: maxVal, lerpMode: lerpMode);
  }

  /// LERP to the max. If Upper limit is not set, then simply LERP higher
  T lerpToMax(
    final T val,
    final double percent, {
    final ChannelAdjustMode lerpMode = ChannelAdjustMode.interpolate,
  }) {
    // debugPrint(
    //   '36: Inside LERP to MAX....VAL is: $val and percent is: $percent--TType is ${T.toString()}',
    // );
    if (maxVal == null) {
      // debugPrint(
      //   '38: Inside LERP to MAX maxVAL is NULL....val is: $val and percentIs: $percent ' //
      //   '-- type is ${T.toString()}',
      // );
      final double adjustment = (val * percent);
      // debugPrint(
      //   '40: Inside LERP to MAX maxVAL is NULL....$val and $percent and adjustment: $adjustment',
      // );
      final T rs1 = (val + adjustment) as T; // MUST ADD HERE
      // debugPrint('44: returning....$rs1--${toCheckCastFN(rs1)}');
      return toCheckCastFN(rs1);
    }

    if (val >= maxVal!) {
      return maxVal as T;
    }

    final T rslt = lerpTo(
      val,
      maxVal!,
      percent,
      maxValue: maxVal,
      lerpMode: lerpMode,
    );
    // debugPrint(
    //   '54: returning. based on val: "${val.strB(5)}", maxVal: $maxVal, ' //
    //   'percent: $percent, ...$rslt--${toCheckCastFN(rslt)}',
    // );
    return toCheckCastFN(rslt);
  }

  /// Getter for lower limit (minimum)
  T get minVal => range.lowerLimit;

  T get lowerLimit => minVal;

  /// Getter for upper limit, (maximum). This is nullable, as some
  /// properties do not have fixed upper limits, such as chroma in some models_color.
  T? get maxVal => range.upperLimit;

  T? get upperLimit => range.upperLimit;

  /// Will return LowerLimit if midPoint and UpperPoint are null
  T get midVal => range.getMiddlePoint();

  /// Retrieve the function pointer to check a value and cast it to a new [T]
  TdCheckCastFN<T> get toCheckCastFN => _checkAndCastFN;

  /// Determines whether the value is valid by being within the specified
  /// [RangeIQ]
  bool isValid(final num val) => (range.upperLimit == null)
      ? range.isValidWithOptionalUpper(val)
      : range.isValidNonNull(val);

  /// Clamp a value to within the range, used internally
  T clampValue(final num val, {final String? msg, final num? tolerance}) {
    if (val.isNaN || val.isInfinite) {
      throw ArgumentError.value(
        val,
        'Invalid argument at _clampVal -${msg.orEmpty}',
      );
    }
    // debugPrint('56: inside _clampVal-$val');
    if (range.upperLimit == null) {
      if (val < range.lowerLimit) {
        return range.lowerLimit;
      }
      return math.max(range.lowerLimit, val as T);
    }
    // debugPrint(
    //   '63: inside _clampVal-"$val"-${range.lowerLimit}-${range.upperLimit}',
    // );
    if (tolerance != null) {
      if (val < (range.lowerLimit - tolerance) ||
          val > (range.upperLimit! + tolerance)) {
        throw Exception(
          'Cannot clamp...beyond the ' //
          'tolerance: $val, ${range.lowerLimit} - ${range.upperLimit}--$tolerance',
        );
      }
    }
    final T retVal = val.clamp(range.lowerLimit, range.upperLimit!) as T;
    // debugPrint(
    //   '65: returning clamped-$retVal--${range.lowerLimit}-${range.upperLimit}',
    // );
    return retVal;
  }

  /// Clamped
  T clampedWithEncoding(
    final num val, {
    final String? msg,
    final num? tolerance,
  }) {
    final T c = clampValue(val, msg: msg, tolerance: tolerance);
    // debugPrint('96: received clamped $c -- from $val; tolerance: $tolerance');
    return toCheckCastFN(c, msg: msg);
  }

  /// Clamp a value to within the range at the halfway point
  /// if possible if it is out of range; otherwise, keep the original value
  T _normalizeToMid(final num val) {
    if (val.isNaN || val.isInfinite || range.upperLimit == null) {
      return midVal;
    }
    if (range.isValidNonNull(val)) {
      return val as T;
    }
    return (range.getMiddlePoint());
  }

  /// External method to normalize the value around the middle point
  T normalized(final num val) {
    final T c = _normalizeToMid(val);
    return toCheckCastFN(c);
  }

  /// Get the complement or opposite of the input value
  T complement(final num val, {T? altUpperLimit}) {
    if (range.rangeType == RangeType.degrees ||
        range.rangeType == RangeType.radians) {
      return val.toDouble().flip as T;
    }
    if (val.isNaN || val.isInfinite) {
      return midVal;
    }
    altUpperLimit ??= range.upperLimit;
    if (altUpperLimit == null) {
      return midVal;
    }
    if (val <= range.lowerLimit) {
      return altUpperLimit;
    }
    if (val >= altUpperLimit) {
      return range.lowerLimit;
    }
    final double midPoint = (math.max(altUpperLimit, range.lowerLimit) -
            math.min(range.lowerLimit, altUpperLimit)) /
        2;
    if (val == midPoint) {
      return val as T;
    }
    final double diffFromMidPoint = (val - midPoint).abs();
    if (val > diffFromMidPoint) {
      return midPoint - diffFromMidPoint as T;
    }
    return midPoint + diffFromMidPoint as T;
  }

  /// Asserts that the input value is within range and is a valid entry,
  /// i.e. not NaN or Infinite
  T assertValid(final num val, {final String? msg}) =>
      range.assertValid(val, msg: msg);

  /// Asserts that the value is at least greater than or equal to the
  /// minimum in the specified [RangeIQ]
  T assertMinimumLimit(final T val, {final String? msg}) =>
      range.assertMinimum(val, msg: msg);

  /// Asserts that the value is less than or equal to the upperLimit as
  /// specified [RangeIQ]
  T assertUpperLimit(final T val, {final String? msg}) =>
      range.assertMaximum(val, msg: msg);

  /// Check the input value and return it if valid or throw an exception
  T checkOrThrow(final num val, {final String? msg}) {
    final T c = range.assertValid(val, msg: msg);
    return toCheckCastFN(c);
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is PropertyLegend &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          range == other.range;

  @override
  int get hashCode => Object.hash(label, range);

  @override
  String toString() {
    return 'PropertyLegend: label: "$label", range: ${range.toString()}';
  }
}

// -------------------------- Subclass Definitions --------------------
final class FloatLegend extends PropertyLegend<FloatIQ> {
  const FloatLegend({
    required final String name,
    required super.range,
    required final TdCheckCastFN<FloatIQ> checkAndCast,
  }) : super(label: name, checkAndCastFN: checkAndCast);
}

/// Function pointers to RgbLinear legend
final class PercentsLegend extends PropertyLegend<Percent> {
  const PercentsLegend({
    final String? name,
    final RangeIQ<Percent>? range,
    final TdCheckCastFN<Percent>? checkAndCast,
  }) : super(
          label: name ??
              'Percent 0.0 to 1.0 (aka factored, normalized, fractionalized)',
          range: range ?? rangePercents,
          checkAndCastFN:
              checkAndCast ?? Percent.fromDouble as TdCheckCastFN<Percent>,
        );
}

/// Function pointers to RgbLinear legend
final class LinearRGBLegend extends PropertyLegend<LinRGB> {
  const LinearRGBLegend({
    final String? name,
    final RangeIQ<LinRGB>? range,
    final TdCheckCastFN<LinRGB>? checkAndCast,
  }) : super(
          label: name ?? 'Percent 0.0 to 1.0 (aka factored, normalized)',
          range: range ?? rangeLinearRGB,
          checkAndCastFN:
              checkAndCast ?? LinRGB.fromDouble as TdCheckCastFN<LinRGB>,
        );
}

// /// SRGBLegend class
// final class SRGBLegend extends PropertyLegend<SRGB> {
//   const SRGBLegend({
//     final String? name,
//     final RangeIQ<SRGB>? range,
//     final TdCheckCastFN<SRGB>? checkAndCast,
//   }) : super(
//           label:
//               name ?? 'rangeSRGB Percent 0.0 to 1.0 (aka factored, normalized)',
//           range: range ?? rangeSRGB,
//           checkAndCastFN: checkAndCast ?? SRGB.clamped as TdCheckCastFN<SRGB>,
//         );
// }

/// Constant Instance here
const LinearRGBLegend legendLinearRGB = LinearRGBLegend(
  name: 'LinearRGBLegend-0.0 to 1.0',
);

/// Constant Instance here
const PercentsLegend legendPercent = PercentsLegend(
  name: 'percent legend- 0.0 to 1.0',
);

// /// Constant Instance here
// const SRGBLegend legendSRGB0to1 = SRGBLegend(name: 'SRGB 0.0 to 1.0');

// https://dart.dev/language/extension-types
// https://ildysilva.medium.com/what-are-flutter-and-dart-extension-types-896eda0a3ddf
// https://www.sttmedia.com/colormodel-xyz/colormodels
/// This is 'X' value in an XYZ color model, see also [XYZ]
/// X: Primarily represents the response of the human eye to red and
/// green wavelengths.
/// Ranges from `0` to `95.05` in the normal sRGB spectrum, but colors
/// outside of the sRGB spectrum are upwardly unbounded.
extension type const Xxyz._(double _) implements FloatIQ {
  const Xxyz(final double vl)
      : assert(
          vl >= Xxyz.minXyzX && vl <= Xxyz.maxXyzX,
          'Invalid "X" in XYZ--$vl--$errorMessageX',
        ),
        _ = vl; // named constructor

  const Xxyz.fromUnchecked(final double vl, {final String? msg})
      : assert(
          vl >= Xxyz.minXyzX && vl <= Xxyz.maxXyzX,
          'Invalid "X" in XYZ--$vl--$errorMessageX--${msg ?? ""}',
        ),
        _ = vl; // named constructor

  double get val => _;

  static String get name => capitalLetterX;

  static const FloatLegend xLegend = FloatLegend(
    name: capitalLetterX,
    range: RangeIQ<FloatIQ>(
      Xxyz.minInst as FloatIQ,
      Xxyz.maxInst as FloatIQ,
      rangeType: RangeType.standard,
    ),
    checkAndCast: Xxyz.fromUnchecked as TdCheckCastFN<FloatIQ>,
  );

  // https://www.sttmedia.com/colormodel-xyz/colormodels
  static const double minXyzX = 0.0;
  static const double maxXyzX = 95.05;
  static const Xxyz minInst = Xxyz(minXyzX);
  static const Xxyz maxInst = Xxyz(maxXyzX);
  static const String errorMessageX = 'Invalid "X" in XYZ: Range is ' //
      '$kLeftDoubleParens${Xxyz.minXyzX}$kRightDoubleParens to '
      '${Xxyz.maxXyzX}';
}

// https://www.sttmedia.com/colormodel-xyz/colormodels
/// The Y value in [XYZ].  Y: Represents the luminance or brightness of the
/// color, and is often considered the most important parameter.
/// Ranges from `0` to `108.883` in the normal sRGB spectrum, but colors
/// outside of the sRGB spectrum are upwardly unbounded.
extension type const Yxyz._(double _) implements FloatIQ {
  const Yxyz(final double vl)
      : assert(
          vl >= Yxyz.minXyzY && vl <= Yxyz.maxXyzY,
          'Invalid "Y" in XYZ--"$vl"--${Yxyz.errorMsgY}',
        ),
        _ = vl;

  // https://github.com/color-js/color.js/blob/main/src/spaces/hct.js
  /// Convert L* back to XYZ Y
  factory Yxyz.fromLStar(final double lstar) {
    final num retY =
        lstar > 8 ? math.pow((lstar + 16) / 116, 3) : lstar / kKappa;
    return Yxyz(retY.toDouble());
  }

  static String get name => capitalLetterY;

  static const double minXyzY = 0.0;
  static const double maxXyzY = 100.0;
  static const Yxyz minYval = Yxyz(minXyzY);
  static const Yxyz maxYval = Yxyz(maxXyzY);

  /// Convert XYZ Y to L*
  double get toLstar {
    final double fy = _ > kEpsilon ? _.cubr : (kKappa * _ + 16) / 116;
    return 116.0 * fy - 16.0;
  }

  /// Division operator
  Yxyz operator /(final Yxyz otherVal) => Yxyz.clamped(_ / otherVal._);

  /// Specifically clamped constructor
  factory Yxyz.clamped(final double vl) =>
      Yxyz(vl.clamp(Yxyz.minYval, Yxyz.maxYval));

  /// Error message for [Zxyz]
  static const String errorMsgY =
      'Invalid Y in XYZ; range is (${Yxyz.minXyzY} to ${Yxyz.maxXyzY})';
}

// -----------------------------------------------------------------
// https://www.sttmedia.com/colormodel-xyz/colormodels
/// The Z value in [XYZ].  Z: Primarily represents the human eye's response to
/// blue wavelengths. Ranges from `0` to `108.883` in the normal sRGB spectrum,
/// but colors outside of the sRGB spectrum are upwardly unbounded.
extension type const Zxyz._(double _) implements FloatIQ {
  const Zxyz(final double vl)
      : assert(
          vl >= Zxyz.minZval && vl <= Zxyz.maxZval,
          'Invalid "Z" in XYZ--"$vl"--${Zxyz.errorMsgZ}',
        ),
        _ = vl;

  /// The constructor that is used as a functional pointer in validation
  /// routines
  const Zxyz.fromUnchecked(final double vl, {final String? msg})
      : assert(
          vl >= Zxyz.minZval && vl <= Zxyz.maxZval,
          'Invalid "Z" in XYZ--"$vl"--${Zxyz.errorMsgZ}--${msg ?? ""}',
        ),
        _ = vl;

  factory Zxyz.clamped(final double vl, {final String? msg}) =>
      Zxyz.fromUnchecked(vl.clamp(Zxyz.minZval, Zxyz.maxZval), msg: msg);

  /// Allows to bound upper limit. Colors outside of the sRGB spectrum
  /// are upwardly unbounded.
  factory Zxyz.checkOrThrow(
    final double vl, {
    final String? msg,
    final double tolerance = 0.1,
  }) {
    if (vl > Zxyz.maxZval && vl <= (Zxyz.maxZval + tolerance)) {
      return Zxyz.fromUnchecked(vl.clamp(Zxyz.minZval, Zxyz.maxZval), msg: msg);
    }
    return Zxyz(zLegend.checkOrThrow(vl.toDouble(), msg: msg).val);
  }

  bool isValid(final num val) => zLegend.isValid(val);

  static const double minZval = 0.0;
  static const double maxZval = 108.883; // but some go beyond this
  static const Zxyz minInst = Zxyz(minZval);
  static const Zxyz maxInst = Zxyz(maxZval);

  static const FloatLegend zLegend = FloatLegend(
    name: capitalLetterZ,
    range: RangeIQ<FloatIQ>(
      Zxyz.minInst as FloatIQ,
      Zxyz.maxInst as FloatIQ,
      rangeType: RangeType.standard,
    ),
    checkAndCast: Zxyz.fromUnchecked as TdCheckCastFN<FloatIQ>,
  );

  /// Division operator
  Zxyz operator /(final Zxyz otherVal) => Zxyz.clamped(_ / otherVal._);

  static String get name => capitalLetterZ;

  /// Error message for [Zxyz]
  static const String errorMsgZ =
      'Invalid "Z" in XYZ; range is (${Zxyz.minZval} to ${Zxyz.maxZval})';
}

// ref: https://maxim-gorin.medium.com/generics-in-dart-type-safe-reusable-code-f1e8744c1f9f
// ref: https://dart.dev/language/generics
