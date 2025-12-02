import 'package:color_iq_utils/src/constants.dart';

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
    if (this < 0.0 || this > 1.0) {
      throw RangeError(
        'Range Error: Value must be between 0 and 1.0 -- ' //
        '${msg ?? 'assertRange0to1.0'}',
      );
    }
    return this;
  }
}
