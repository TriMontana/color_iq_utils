import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/utils/regex_utils.dart';

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  String orDefault(final String defaultValue) {
    return this ?? defaultValue;
  }

  /// Returns an empty string if `this` is `null`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// print(null.orEmpty); // ''
  /// print('hello'.orEmpty); // 'hello'
  /// ```
  String get orEmpty => this ?? kEmptyStr;
}

extension StringHelpers on String {
  String get stripUnderscores => replaceAll("_", kEmptyStr).trim();

  /// See also [removeAfterUnderscore]
  String get removePrefixWithColon =>
      replaceAll(RegExUtils.kPrefixToColon, kEmptyStr);

  /// Removes the given [prefix] from the start of this string, if present.
  /// If the string does not start with [prefix], returns this string unchanged.
  String removePrefix(final String prefix) {
    if (prefix.isEmpty) return this;
    return startsWith(prefix) ? substring(prefix.length) : this;
  }

  /// Removes trailing zeroes after the decimal point, retaining at least [decimalsToRetain] digits.
  /// If there is no decimal point or no trailing zeroes, returns the original string.
  /// Example:
  ///   '12.34000'.removeTrailingZeroes(2) => '12.34'
  String removeTrailingZeroes([final int decimalsToRetain = 1]) {
    if (!contains(dot)) return this;
    final int dotIndex = indexOf(dot);
    final int minLength = dotIndex + 1 + decimalsToRetain;
    int end = length;

    // Find the position to trim trailing zeroes, but keep at least [decimalsToRetain] decimals
    while (end > minLength && this[end - 1] == '0') {
      end--;
    }

    // If the last character is a dot after trimming, remove it
    if (this[end - 1] == dot) {
      end--;
    }

    return substring(0, end);
  }

  String trimZeros([final int decimals = 7]) {
    if (!contains(dot)) {
      return this;
    }
    int idx = indexOf('.');
    int delta = (length - (idx + 1));
    String trimmed = this;
    if (trimmed.length > (idx + decimals)) {
      trimmed = trimmed.substring(0, (idx + decimals));
    }
    // other approach is to use split pattern
    while (trimmed.contains('.') && trimmed.endsWith('0') && delta >= 2) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
      idx = indexOf('.');
      delta = (trimmed.length - (idx + 1));
      // debugPrint('idx is $idx, length is ${trimmed.length} "$trimmed" $delta');
      if (delta <= 1) {
        return trimmed;
      }
    }

    return trimmed;
  }

  /// Returns true if [codeUnit] is a printable ASCII character (code 32 to 126 inclusive).
  bool isPrintable(final int codeUnit) => codeUnit >= 32 && codeUnit <= 126;
}
