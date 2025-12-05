import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;

import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/string_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

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
        'and $kMaxTone -- ${msg ?? 'assertRange0to100'}',
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
}
