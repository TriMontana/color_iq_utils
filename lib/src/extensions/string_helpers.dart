import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/utils/error_handling.dart';
import 'package:color_iq_utils/src/utils/hex_utils.dart';
import 'package:color_iq_utils/src/utils/regex_utils.dart';

const Map<String, String> kCharacterPairs = <String, String>{
  "(": ")",
  ")": "(",
  "[": "]",
  "]": "[",
  "{": "}",
  "}": "{",
  "<": ">",
  ">": "<",
  "\\": "/",
  "/": "\\",
  "¿": "?",
  "?": "¿",
  "!": "¡",
  "¡": "!",
  "\"": "'",
  "'": "\"",
  "«": "»",
  "»": "«",
  "‹": "›",
  "›": "‹",
};

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

  /// Fill a string to a certain length
  /// DO not use empty string because it will be trimmed
  String fillToLength(
    final int maxLength, {
    final String fillChar = kMiddleDot,
  }) {
    if (length == maxLength) {
      return this;
    }
    if (length > maxLength) {
      return sliceWithEllipsis(maxLength);
    }

    // this should be named pad UNTIL a position is reached.
    // DO not use empty string because it will be trimmed
    return padRight(maxLength, fillChar);
  }

  /// Truncates the string to [maxLength], appending an ellipsis if truncated.
  /// If [maxLength] is less than or equal to the length of the ellipsis, returns a substring up to [maxLength].
  String sliceWithEllipsis(final int maxLength) {
    if (length <= maxLength) {
      return this;
    }
    const int ellipsisLength = 1; // horizontalEllipsis is a single character
    if (maxLength <= ellipsisLength) {
      // Not enough space for ellipsis, just cut the string
      return substring(0, maxLength);
    }
    final int trimmedLength = maxLength - ellipsisLength;
    return '${substring(0, trimmedLength)}$kHorizontalEllipsis';
  }

  /// Returns the hex-escaped literal (e.g. \x41 for 'A') for a single-character string.
  /// Throws [StateError] if the string is not exactly one character.
  String getHexLiteral() {
    if (runes.length != 1) {
      throw StateError(
        'getHexLiteral() requires a single-character string, got "$this"',
      );
    }
    final int rune = runes.first;
    if (rune <= 0xFF) {
      // Use \xHH for ASCII/Latin-1
      return r'\x' + rune.toRadixString(16).toUpperCase().padLeft(2, '0');
    } else if (rune <= 0xFFFF) {
      // Use \uHHHH for BMP
      return r'\u' + rune.toRadixString(16).toUpperCase().padLeft(4, '0');
    } else {
      // Use \u{HHHHHH} for supplementary planes
      // ignore: prefer_interpolation_to_compose_strings
      return r'\u{' + rune.toRadixString(16).toUpperCase() + '}';
    }
  }

  // https://how.dev/answers/how-to-reverse-a-string-in-dart
  // https://medium.com/@sachinsortur/reverse-a-string-dart-902f2ef2322f
  /// Reverses the string
  String reverseStr2() {
    if (isEmpty) return '';
    final StringBuffer buffer = StringBuffer();
    for (int i = length - 1; i >= 0; i--) {
      buffer.writeCharCode(codeUnitAt(i));
    }
    return buffer.toString();
  }

  // https://medium.com/nextfunc/dart-how-to-reverse-a-string-96613a70c3d0
  String get reverseStringWithRunes {
    final List<int> chars = runes.toList();
    return String.fromCharCodes(chars.reversed);
  }

  /// Checks if the string is a palindrome, i.e. a word, phrase, or sequence
  /// that reads the same backward as forward, e.g., madam or nurses run.
  /// This method ignores case and non-alphanumeric characters.
  bool isPalindrome() {
    final String cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join();
  }

  /// Returns the concatenation of [other] and [this].  Example:
  /// ```dart
  /// 'word'.prepend('key'); // 'keyword'
  /// ```
  String prepend(final String other) => other + this;

  /// Return *this* as a bracketed string
  String bracketed([
    final String leftSide = kLeftSquareBracket,
    final String rightSide = kRightSquareBracket,
  ]) =>
      "$leftSide$this$rightSide";

  String get bracketWithParens => bracketed(kLeftParens, kRightParens);

  String get bracketWithDoubleParens =>
      bracketed(kLeftDoubleParens, kRightDoubleParens);

  String get bracketWithDoubleQuotes =>
      bracketed(kLeftDoubleQuotationMark, kRightDoubleQuotationMark);

  String get bracketWithLenticulars =>
      bracketed(kLeftLenticularBracket, kRightLenticularBracket);

  String get bracketWithSquiggles =>
      bracketed(kRightwardsSquiggleArrow, kLeftwardsSquiggleArrow);

  /// Bracket with  ⫸ ⫷
  String get bracketWithSucceedsPrecedes =>
      bracketed(kTripleNestedGreaterThan, kTripleNestedLessThan);

  /// Bracket with curley brackets
  String get bracketWithCurlies =>
      bracketed(kLeftCurlyBracket, kRightCurlyBracket);

  /// Return *this* as a quoted string
  String get quote => '"$this"';

  /// Return *this* as a quoted string
  String get quoteSingle => '\'$this\'';

  /// Returns a new string by repeating this string [numTimes] times.
  /// Throws [ArgumentError] if [numTimes] is less than 1.
  String repeat(final int numTimes) {
    if (numTimes < 1) {
      throw ArgumentError.value(numTimes, 'numTimes', 'Must be at least 1');
    }
    // String * n is supported in Dart 2.13+, but for compatibility:
    return List<String>.filled(numTimes, this).join();
  }

  /// check if the string is a hexadecimal number
  bool get isHexadecimal => RegExUtils.kHexChars.hasMatch(this);

  /// check if the string is a hexadecimal color
  bool get isHexColor => RegExUtils.kHexColor.hasMatch(this);

  /// contains ignore case, case insensitive
  bool containsIgnoreCase(final String txt) =>
      toLowerCase().contains(txt.toLowerCase());

  /// Compares the given strings [_a] (aka 'this' and [b].
  /// part of [StringHelper], case insensitive, ignore case
  bool equalsIgnoreCase(final String b) =>
      (this == b) ? true : toLowerCase() == b.toLowerCase();

  /// Returns the substring after the first occurrence of ':'
  String get keepAfterColon => keepAfter(kColon);

  /// Returns the substring after the first occurrence of any pattern in [patterns].
  /// If none of the patterns are found, returns the original string.
  /// Trims leading whitespace from the result.
  String keepAfterMulti(final Iterable<String> patterns) {
    if (isBlank || patterns.isEmpty) {
      return this;
    }
    int? minIndex;
    String? foundPattern;
    for (final String pattern in patterns) {
      final int idx = indexOf(pattern);
      if (idx >= 0 && (minIndex == null || idx < minIndex)) {
        minIndex = idx;
        foundPattern = pattern;
      }
    }
    if (minIndex != null && foundPattern != null) {
      return substring(minIndex + foundPattern.length).trimLeft();
    }
    return this;
  }

  /// Returns the substring after the first occurrence of [pattern].
  /// If [pattern] is not found or is empty, returns the original string.
  /// Trims leading whitespace from the result.
  String keepAfter(final String pattern) {
    if (isBlank || pattern.isEmpty) {
      return this;
    }
    final int idx = indexOf(pattern);
    if (idx < 0) {
      return this;
    }
    return substring(idx + pattern.length).trimLeft();
  }

  /// Removes punctuation from the string.
  /// By default, removes all characters except letters and numbers.
  /// Optionally, provide a custom [pattern] to define what to remove.
  String removePunctuation({final RegExp? pattern}) {
    final RegExp regExp = pattern ?? RegExUtils.kAllButLettersAndNumbers;
    return replaceAll(regExp, '');
  }

  /// Removes parentheses from the string.
  String get removeParens => replaceAll(RegExUtils.kParens, kEmptyStr);

  /// Removes quotes from the string.
  String get removeQuotes => replaceAll(RegExUtils.kQuotes, kEmptyStr);

  String get removeQuotes2 => replaceAll(RegExUtils.kDoubleQuotes, kSemiColon);

  // remove between < and >
  String get removeBetweenBrackets =>
      replaceAll(RegExUtils.kBetweenBrackets, kEmptyStr);

  /// removeUnderscores
  String removeUnderscores([final String replacementText = kSpace]) =>
      replaceAll(kUnderscore, replacementText);

  String get removeAfterParens =>
      replaceAll(RegExUtils.kAfterParens, kEmptyStr);

  String get skipLastChar => substring(0, math.max(0, length - 1));

  /// Returns the `String` to snake_case.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'SNAKE CASE';
  /// String fooSNake = foo.toSnakeCase; // returns 'snake_case'
  /// ```
  String get toSnakeCase {
    if (isBlank) {
      return this;
    }

    final List<String> words = toLowerCase().trim().split(RegExp(r'(\s+)'));
    String snakeWord = kEmptyStr;

    if (length == 1) {
      return this;
    }
    for (int i = 0; i <= words.length - 1; i++) {
      if (i == words.length - 1) {
        snakeWord += words[i];
      } else {
        snakeWord += '${words[i]}_';
      }
    }
    return snakeWord;
  }

  /// Returns the `String` in camelcase.
  /// ### Example
  /// ```dart
  /// String foo = 'Find max of array';
  /// String camelCase = foo.toCamelCase; // returns 'findMaxOfArray'
  /// ```
  String get toCamelCase {
    if (isBlank) {
      return this;
    }

    final List<String> words = trim().split(RegExp(r'(\s+)'));
    String result = words[0].toLowerCase();
    for (int i = 1; i < words.length; i++) {
      result += words[i].substring(0, 1).toUpperCase() +
          words[i].substring(1).toLowerCase();
    }
    return result;
  }

  /// Returns the `String` title cased.
  ///
  /// ```dart
  /// String foo = 'Hello dear friend how you doing ?';
  /// Sting titleCased = foo.toTitleCase; // returns 'Hello Dear Friend How You Doing'.
  /// ```
  String get toTitleCase {
    if (isBlank) {
      return this;
    }

    final List<String> words = trim().toLowerCase().split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }

    return words.join(' ');
  }

  /// Converts a string to Title Case.
  String get toTitleCase2 {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (final String word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  /// Removes all non-hexadecimal characters from the string,
  /// and strips common hex prefixes like '0x', '0X', and '#'.
  /// Returns the cleaned, uppercase hex string.
  String get removeNonHexChars {
    String result = trim().toUpperCase();
    // Remove common hex prefixes
    if (result.startsWith(k0xUpper)) {
      result = result.substring(2);
    } else if (result.startsWith(k0xLower)) {
      result = result.substring(2);
    } else if (result.startsWith(kPoundSign)) {
      result = result.substring(1);
    }
    // Remove any remaining non-hex characters
    return result.replaceAll(RegExUtils.kNonHexChars, kEmptyStr);
  }

  /// Remove new lines
  String get removeNewLines => replaceAll("\n", kSpace);

  /// Remove new lines
  String get stripNewLines => replaceAll("\n", kSpace);

  String replaceNewLines([final String substitute = kSpace]) =>
      replaceAll("\n", substitute);

  String get stripHyphens => replaceAll("-", kEmptyStr).trim();

  String get stripHyphensAndUnderscores =>
      replaceAll("-", kEmptyStr).replaceAll("_", kEmptyStr).trim();

  /// Returns `true` if [this] is empty or consists solely of whitespace
  /// text as defined by [String.trim].
  /// same as (s == null || s.isEmpty) ? true : false;
  bool get isBlank => trim().isEmpty;

  /// Checks if the `String` is not blank (null, empty or only white spaces).
  bool get isNotBlank => isBlank == false;

  // https://www.kindacode.com/article/flutter-dart-convert-a-string-integer-to-hex/
  /// Converts the string's runes (Unicode code points) to a hexadecimal string.
  /// Optionally, a [delimiter] can be provided to separate hex values.
  ///
  /// Example:
  ///   'abc'.convertRunesToHex()        // '616263'
  ///   'abc'.convertRunesToHex('-')     // '61-62-63'
  String convertRunesToHex([final String delimiter = kEmptyStr]) {
    return runes
        .map((final int code) => code.toRadixString(16).padLeft(2, '0'))
        .join(delimiter);
  }

  /// also [upperCaseFirstLetter]
  /// Returns this string with the first character in lowercase, leaving the rest unchanged.
  ///
  /// If the string is empty or only whitespace, returns as-is.
  /// Example:
  ///   'Hello' -> 'hello'
  ///   'HELLO' -> 'hELLO'
  ///   ''      -> ''
  String get lowerCaseFirstLetter {
    if (isBlank) return this;
    if (length == 1) return toLowerCase();
    final String first = this[0].toLowerCase();
    final String rest = substring(1);
    return '$first$rest';
  }

  /// Returns this string with the first character capitalized, leaving the rest unchanged.
  /// If the string is empty, returns an empty string.
  String capitalizeFirstLetter() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    return this[0].toUpperCase() + substring(1);
  }

  String trimZero() {
    String tmp = this;
    if (!tmp.contains('.')) {
      return tmp;
    }
    while (tmp.endsWith('0')) {
      tmp = tmp.substring(0, tmp.length - 1);
    }
    if (tmp.endsWith('.')) {
      tmp = tmp.substring(0, tmp.length - 1);
    }
    return tmp;
  }

  String get splitAtDash => replaceAll('-', '-\n');

  String get splitAtSlash => replaceAll('/', '-\n');

  String get splitAtParens => replaceAll('(', '\n(');

  int countVowels() => replaceAll(RegExp(r'[^aeiou]'), '').length;

  String formatAsSquigglyBracketed() {
    return '{$this}'; // Example: wraps with squiggly brackets
  }

  /// Truncate a string to a certain length
  String sliceToLength(final int maxLength) {
    if (length < maxLength) {
      return this;
    }
    return substring(0, maxLength);
  }

  /// Same as above but also adds stripping after underscore
  /// WORKS!! tested
  bool equalsIgnoreCaseSuper(final String b) {
    if (this == b || toLowerCase() == b.toLowerCase()) {
      return true;
    }
    final String tStr1 = removeAfterUnderscore;
    final String tStr2 = b.removeAfterUnderscore;
    // dbg('checking in super \"$_str1\" and \"$_str2\"');
    return tStr1.toLowerCase() == tStr2.toLowerCase();
  }

  /// i.e. everythingBefore, textUpTo, getTextBefore
  String removeAfter(final String pattern) {
    if (!contains(pattern)) {
      // debugPrint('does not contain that pattern $pattern');
      return this;
    }
    return split(pattern)[0]; // return first part
  }

  String get stripVersionSep {
    if (!contains(versionSep)) {
      // debugPrint('does not contain that pattern $pattern');
      return this;
    }
    return split(versionSep)[0]; // return first part
  }

  /// Removes everything before the first occurrence of [pattern], including [pattern] itself.
  /// If [pattern] is not found, returns the original string.
  /// If [pattern] is at the end, returns an empty string.
  String removeBefore(final String pattern) {
    if (isBlank || !contains(pattern)) {
      return this;
    }
    final int idx = indexOf(pattern);
    if (idx + pattern.length >= length) {
      // Pattern is at the end, nothing after it
      return '';
    }
    return substring(idx + pattern.length);
  }

  /// Replaces all non-printable characters in [this] with [replaceWith].
  /// By default, replaces with a space.
  String replaceNonPrintable({final String replaceWith = kSpace}) {
    if (isEmpty) return this;
    final StringBuffer buffer = StringBuffer();
    for (final int codeUnit in codeUnits) {
      if (isPrintable(codeUnit)) {
        buffer.writeCharCode(codeUnit);
      } else if (replaceWith.isNotEmpty) {
        buffer.write(replaceWith);
      }
      // else: skip the character
    }
    return buffer.toString();
  }

  /// Removes everything before the first occurrence of '_'
  String get getBeforeUnderscore =>
      replaceAll(RegExUtils.kAfterUnderscore, kEmptyStr);

  /// Removes all whitespace characters from the string.
  String get removeWhiteSpace =>
      isEmpty ? this : replaceAll(RegExUtils.kWhiteSpace, kEmptyStr);

  /// remove everything from the underscore to end of string or end of line
  /// aka fromUnderscore, toUnderscore
  String get removeAfterUnderscore =>
      replaceAll(RegExUtils.kAfterUnderscore, kEmptyStr);

  /// convert the input to an integer, or NAN if the input is not an integer
  /// REMEMBER THIS IS BASE 10....nonHex
  /// String to Int parse, must set radix to 16 if using HEX
  /// If no [radix] is given then it defaults to 10.   DEFAULTS to base 10
  int toInt({final bool cleanseStr = true, final int? radix}) {
    try {
      final String str1 = assertNotBlank(
        this,
        msg: 'NotBlank failure-$this',
      );
      final String lStrFinal = str1.trim().replaceAll(
            RegExUtils.kNotNumbersOrPlusMinus,
            kEmptyStr,
          );
      final int? tInt = int.tryParse(lStrFinal, radix: radix);
      if (tInt != null) {
        return tInt;
      }
      final double? lDouble = double.tryParse(lStrFinal); // defaults to base 10
      if (lDouble != null) {
        return lDouble.toInt();
      }
      return ArgumentError.checkNotNull(
        num.tryParse(lStrFinal),
        'could not parse "$lStrFinal" $this',
      ).toInt();
    } catch (ex, stackTrace) {
      developer.log('Parsing FAILURE-${ex.toString()}');
      developer.log(stackTrace.toString());
      rethrow;
    }
  }

  double get toDouble =>
      double.tryParse(this) ??
      (throw Exception('unexpected at 465-${toString()}'));

  // FltType get toLRV {
  //   final double d = toDouble;
  //   return FltType.lrv(d);
  // }

  /// String to Int parse, does not use radix, defaults to BASE10 (non hex)
  int get toIntBase10 => toInt(radix: 10);

  num parseToNum([final String errMsg = 'No Error Message Parse to Num']) {
    final num? rslt = num.tryParse(this);
    if (rslt != null) return rslt;
    throw FormatException(errMsg);
  }

  /// Validate that it's not a hexString
  void validateNotHexString({final int? hexInt, final String? msg}) {
    if (startsWith('0xFF') || startsWith('FF')) {
      throw ArgumentError(
        'Cannot validate that this is NOT a hex string $this--${msg.orEmpty}',
      );
    }
  }

  Set<String> toSet() => <String>{this};

  /// Determines if a string is valid, i.e. is NOT null or blank and has
  /// some content, at least one character
  bool get isValidString => isEmpty == false && trim().isEmpty == false;

  String concatOrNull(final String? other) =>
      ((other == null) ? this : this + other);

  /// Converts a hex string to a [Color] object.
  ColorIQ hexToColor() =>
      ColorIQ(int.parse(substring(0, 6), radix: 16) + 0xFF000000);

  /// to [Color]
  /// Converts a hex string to a [Color] object.
  /// Accepts formats like "aabbcc", "ffaabbcc", "#aabbcc", "#ffaabbcc", "0xffaabbcc".
  /// Throws [Exception] if the string cannot be parsed as a color.
  ColorIQ toColor() {
    String hexColor = removeNonHexChars;
    // If only RGB is provided, prepend alpha 'FF'
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    // Now expecting 8 hex digits (AARRGGBB)
    if (hexColor.length == 8) {
      return ColorIQ(int.parse('$k0xLower$hexColor'));
    }
    // Handle #RRGGBB
    if (startsWith(kPoundSign) && length == 7) {
      return ColorIQ(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
    }
    // Handle 0xAARRGGBB
    if (startsWith(n0FF) && length == 10) {
      return ColorIQ(int.parse(this));
    }
    throw ArgumentError.value(this, 'Unknown color string format: "$this"');
  }

  /// Checks if the string matches the given pattern.
  bool hasMatch(final String? value, final String pattern) =>
      (value == null) ? false : RegExp(pattern).hasMatch(value);

  // Check if the string has any number in it, not accepting double, so don't
  // use "."
  bool isNumericOnly(final String s) => hasMatch(s, r'^\d+$');

  /// Checks if string consist only Alphabet. (No Whitespace)
  bool isAlphabetOnly(final String s) => hasMatch(s, r'^[a-zA-Z]+$');

  /// Return a bool if the string is null or empty
  bool get isEmptyOrNull => isEmpty;

  // Checks if string contains at least one Capital Letter
  // final helloWorldCap = 'hello world'.capitalizeFirstOfEach; // 'Hello World'
  // camel case, camelCase, capitalizeEachWord, uppercaseEachWord
  /// Capitalizes the first letter of each word in the string.
  /// Optionally, specify a [connector] to join the words (default is space).
  /// Non-printable characters are replaced with spaces before splitting.
  String capitalizeEachWord({final String connector = kSpace}) {
    return replaceAll(RegExUtils.kNonAsciiPrintable, kSpace)
        .split(RegExp(r'\s+'))
        .where((final String str) => str.isNotEmpty)
        .map((final String str) => str.upperCaseFirstLetter)
        .join(connector);
  }

  /// Convert first letter of string to upper case and append the rest of the
  /// string
  /// Usage: print('someString'.firstLetterToUpperCase);
  /// aka CapitalizeFirstLetter, camel on firstLetter
  /// See also [capitalize] [lowerCaseFirstLetter]
  String get upperCaseFirstLetter {
    if (isBlank) {
      return this;
    }
    return (length == 1) ? toUpperCase() : this[0].toUpperCase() + substring(1);
  }

  /// Splits this string assuming it is in 'camelCase' or 'PascalCase'.
  ///
  /// Each element in the returned iterable will be a word.
  ///
  /// If this string is empty, the returned iterable will be empty.
  ///
  /// ## Example
  ///
  /// ```dart
  /// print('helloWorld'.splitCamelCase()); // ('hello', 'World')
  /// print('XMLHttpRequest'.splitCamelCase()); // ('XML', 'Http', 'Request')
  /// print(''.splitCamelCase()); // ()
  /// ```
  Iterable<String> splitCamelCase() {
    if (isEmpty) return const Iterable<String>.empty();

    // This regex splits before each uppercase letter that follows a lowercase letter or another uppercase letter (for acronyms).
    final RegExp exp = RegExp(
      r'([A-Z]+(?=[A-Z][a-z])|[A-Z]?[a-z]+|[A-Z]+|\d+)',
    );
    return exp
        .allMatches(this)
        .map((final RegExpMatch match) => match.group(0)!)
        .where((final String s) => s.isNotEmpty);
  }

  // Matches a word in a camel case string.
  // static final RegExp _camelCase = RegExp('[A-Z]?[a-z]+');

  String get firstLetterOnlyInCaps {
    if (isBlank) {
      return this;
    }
    return this[0].toUpperCase();
  }

  /// Capitalize the first letter in a string.

  /// Returns this string with the first character capitalized.
  ///
  /// If this string is empty, it will be returned as-is.
  ///
  /// ## Example
  ///
  /// ```dart
  /// print('hello'.capitalize()); // 'Hello'
  /// print(''.capitalize()); // ''
  /// ```
  String get capitalize =>
      (length > 1) ? this[0].toUpperCase() + substring(1) : toUpperCase();

  /// Capitalizes the first letter of each word, splitting on hyphens and spaces,
  /// and joins the result with spaces.
  /// Example: 'foo-bar baz' -> 'Foo Bar Baz'
  String get capitalize2 {
    return replaceAll('-', ' ')
        .split(RegExp(r'\s+'))
        .where((final String word) => word.isNotEmpty)
        .map(
          (final String word) => word.length > 1
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : word.toUpperCase(),
        )
        .join(' ');
  }

  /// Capitalizes the first character and lowercases the rest.
  /// Returns the original string if empty or length < 2.
  String get capitalize3 {
    if (isEmpty) return this;
    if (length < 2) return toUpperCase();
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String toPascalCase() => capitalize;

  /// Return the string remaining in a string after the last "." in a String,
  /// if there is no "." the string itself is returned.
  ///
  /// This function can be used to e.g. return the enum tail value from an
  /// enum's standard toString method.
  String get dotTail => split('.').last;

  /// check if the string is a hexadecimal color
  /// hasMatch('#3b5');     // true
  /// hasMatch('#FF7723');  // true
  /// hasMatch('#000000z'); // false
  bool get isValidHexStr4Color => HexUtils.isValidHexStr(this);

  /// format for Hyphen Variations pattern, e.g. '-v' for Granite Gray-v65
  String get removeAfterHyphen4Vars {
    if (isBlank || !contains(versionSuffix)) {
      return this;
    }
    return split(versionSuffix)[0]; // return first part
  }

  // ======================= PREMIERE METHOD ==================================
  // ======================= PREMIERE METHOD ==================================
  // String is in the format "aabbcc" or "ffaabbcc"
  // ALERT--ALERT--ALERT Do NOT use '0x..' in the string,
  // if you do, then it is a base10 calc so just int.parse(str) WITHOUT RADIX
  // WORKS Tested on DartPad, hexStrToIntVal1('353535') ==> 4281677109
  // hexStrToIntVal1('#ffaabbcc') ==> 4289379276
  /// Converts this string (representing a hex color) to a [Uint32] integer.
  ///
  /// The string should represent a hex color in formats like "aabbcc", "ffaabbcc", "#aabbcc", "#ffaabbcc", or "0xffaabbcc".
  /// Optionally, you can specify an [alphaChannel] (default is [kDefaultAlphaChannel]) to use if the input does not include alpha.
  ///
  /// Throws [Exception] if the string is not a valid hex color.
  ///
  /// Example:
  /// ```dart
  /// 'FFAABB'.toHexInt(); // Uint32(0xFFAABB)
  /// '#FFAABBCC'.toHexInt(); // Uint32(0xFFAABBCC)
  /// ```
  int toHexInt([final String alphaChannel = kDefaultAlphaChannel]) {
    try {
      // Remove any suffix after an underscore (e.g., "FFAABB_foo" -> "FFAABB")
      final String hexCandidate = getBeforeUnderscore;

      // Ensure the string is at least 6 characters (RRGGBB)
      assertTrue(
        hexCandidate.length >= 6,
        'Invalid Hex String at toHexInt: "$this"',
        goToExit: true,
      );

      // Cleanse and resize the hex string, adding alpha if needed
      final String normalizedHex = HexUtils.resizeHexString(
        hexCandidate,
        alphaChannel: alphaChannel,
      );

      // Try parsing as a hex integer
      final int? hexValue = int.tryParse(normalizedHex, radix: 16);

      // Fallback to custom parser if needed
      final int result = hexValue ?? HexUtils.hexStrToHexInt2(normalizedHex);

      return result;
    } catch (e, stacktrace) {
      throw Exception(
          'Failed to parse hex string "$this": ${stacktrace.toString()}');
    }
  }

  /// See also [parseIntOrZero]
  int parseInt() {
    return int.parse(this);
  }

  /// Returns the integer value of the string, or 0 if the string is not a valid integer.
  int get parseIntOrZero => int.tryParse(this) ?? 0;

  int parseIntOrElse({final int optionalReturnInt = 0}) =>
      int.tryParse(this) ?? optionalReturnInt;

  // /// Parse double using the Result pattern
  // Result<double> parseDouble() {
  //   final double? rslt = double.tryParse(this);
  //   return (rslt == null)
  //       ? Result<double>.error(
  //           Exception('Unable to parse string to double $this'),
  //         )
  //       : Result<double>.ok(rslt);
  // }

  num parseNumOrElse({final num optionalReturnNum = 0.0}) =>
      num.tryParse(this) ?? optionalReturnNum;

  /// String to Int parse, USES RADIX for HEX, asserts non-null
  int get toIntRadix16 => toInt(radix: 16);

  /// Converts to JSON with [json.decoder].
  dynamic get jsonDecoded {
    return json.decoder.convert(this);
  }

  /// Decodes a URI-encoded string using [Uri.decodeFull].
  /// Returns the decoded string.
  String get uriDecoded => Uri.decodeFull(this);

  /// Converts with [Uri.encodeFull].
  String get uriEncoded => Uri.encodeFull(this);

  /// Converts with [decodeComponent].
  String get uriComponentDecoded {
    return Uri.decodeComponent(this);
  }

  /// Converts with [Uri.encodeComponent].
  String get uriComponentEncoded => Uri.encodeComponent(this);

  /// Converts with [Uri.decodeQueryComponent].
  String get uriQueryComponentDecoded => Uri.decodeQueryComponent(this);

  /// Converts with [Uri.encodeQueryComponent].
  String get uriQueryComponentEncoded => Uri.encodeQueryComponent(this);

  /// Checks whether the `String` has any whitespace characters.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool hasWhitespace = foo.hasWhitespace; // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'HelloWorld';
  /// bool hasWhitespace = foo.hasWhitespace; // returns false;
  /// ```
  /// Returns true if the string contains any whitespace character.
  /// Returns false for blank (empty or whitespace-only) strings.
  bool get hasWhitespace => isNotBlank && contains(RegExp(r'\s'));

  /// Inserts a `String` at the specified index.
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'hello world';
  /// String newText = text.insertAt(5, '!');
  /// print(newText); // prints 'hello! world'
  /// ```
  String insertAt(final int i, final String value) {
    if (i < 0 || i > length) {
      throw RangeError('Index out of range');
    }
    final String start = substring(0, i);
    final String end = substring(i);
    return start + value + end;
  }

  /// Splits the `String` into a `List` of lines ('\r\n' or '\n').
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'hello\nworld';
  /// List<String> lines = text.splitLines();
  /// print(lines); // prints ['hello', 'world']
  /// ```
  List<String> splitLines() {
    return split(RegExp(r'\r?\n'));
  }

  /// Returns a new `String` with the first occurrence of the given
  /// pattern replaced with the replacement `String`.
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".replaceFirst("s", "S"); // returns "eSentis";
  /// ```
  String replaceFirst(final String pattern, final String replacement) {
    final int index = indexOf(pattern);
    if (index == -1) {
      return this;
    }
    return replaceRange(index, index + pattern.length, replacement);
  }

  /// Returns a new `String` with the last occurrence of the given
  /// pattern replaced with the replacement `String`.
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".replaceLast("s", "S"); // returns "esentiS";
  /// ```
  String replaceLast(final String pattern, final String replacement) {
    final int index = lastIndexOf(pattern);
    if (index == -1) {
      return this;
    }
    return replaceRange(index, index + pattern.length, replacement);
  }

  /// Checks if this string ends with any of the provided patterns.
  ///
  /// Returns true if the string ends with at least one of the patterns,
  /// false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final text = "hello.jpg";
  /// print(text.endsWithAny(['.jpg', '.png', '.gif'])); // true
  /// print(text.endsWithAny(['.mp4', '.avi'])); // false
  /// ```
  bool endsWithAny(final List<String> patterns) {
    if (patterns.isEmpty) return false;

    for (final String pattern in patterns) {
      if (endsWith(pattern)) {
        return true;
      }
    }

    return false;
  }

  /// Checks whether the `String` is consisted of both upper and lower case letters.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool isMixedCase = foo.isMixedCase; // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'hello world';
  /// bool isMixedCase = foo.isMixedCase; // returns false;
  ///
  bool isMixedCase() {
    if (isBlank) {
      return false;
    }
    return toUpperCase() != this && toLowerCase() != this;
  }

  /// convert the input to a Double Pass-Fail.  Pass = 1, fail = 0
  /// aka parseBool()
  bool get isAffirmative {
    final String testStr = toUpperCase();
    final int? tInt = int.tryParse(this);
    if (testStr == 'FALSE' ||
        testStr == 'F' ||
        testStr == 'F.' ||
        testStr == 'FAIL' ||
        testStr == 'FAILED' ||
        testStr == '-1' ||
        testStr == 'NO' ||
        testStr == 'N' ||
        testStr == 'N.' ||
        testStr == 'NEGATIVE' ||
        testStr == 'INCOMPLETE' ||
        testStr == 'CANCEL' ||
        testStr == 'DISMISS' ||
        testStr == '-1.0' ||
        testStr == kEmptyStr ||
        (tInt != null && tInt < 0)) {
      return false;
    }
    if (testStr == 'TRUE' ||
        testStr == 'T' ||
        testStr == 'T.' ||
        testStr == 'PASS' ||
        testStr == 'PASSED' ||
        testStr == '1' ||
        testStr == 'YES' ||
        testStr == 'COMPLETE' ||
        testStr == 'AFFIRMATIVE' ||
        testStr == 'Y' ||
        testStr == 'Y.' ||
        testStr == 'ACCEPT' ||
        testStr == 'CONFIRM' ||
        testStr == 'OK' ||
        testStr == '1.0' ||
        (tInt != null && tInt >= 0)) {
      return true;
    }
    throw Exception(
      'Unknown option for affirm-negative string "$testStr"',
    );
  }

  // 31. Case Conversion Helpers

  /// Convert string to sentence case (first letter capitalized, rest lowercase)
  String get toSentenceCase {
    if (isBlank || length == 0) return this;
    if (length == 1) return toUpperCase();
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Convert to kebab-case (words separated by hyphens)
  String get toKebabCase {
    if (isBlank) return this;
    return toLowerCase()
        .replaceAll(RegExp(r'[_\s]+'), '-')
        .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1-$2')
        .toLowerCase()
        .trim();
  }

  // 32. Character & Word Operations

  /// Count occurrences of [substring] in this string
  int countOccurrences(final String substring) {
    if (substring.isEmpty || isEmpty) return 0;
    int count = 0;
    int index = 0;
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    return count;
  }

  /// Count words in the string (split by whitespace)
  int get wordCount {
    if (isBlank) return 0;
    return trim()
        .split(RegExp(r'\s+'))
        .where((final String s) => s.isNotEmpty)
        .length;
  }

  /// Count consonants in the string
  int countConsonants() => replaceAll(
        RegExp(r'[^a-z]', caseSensitive: false),
        '',
      ).replaceAll(RegExp(r'[aeiou]', caseSensitive: false), '').length;

  /// Get character at [index] (handles negative indices, -1 = last char)
  String? charAt(final int index) {
    if (isEmpty) return null;
    final int actualIndex = index < 0 ? length + index : index;
    if (actualIndex < 0 || actualIndex >= length) return null;
    return this[actualIndex];
  }

  /// Get first [n] characters
  String firstChars(final int n) {
    if (n <= 0) return '';
    if (n >= length) return this;
    return substring(0, n);
  }

  /// Get last [n] characters
  String lastChars(final int n) {
    if (n <= 0) return '';
    if (n >= length) return this;
    return substring(length - n);
  }

  // 33. Validation & Type Checking

  /// Check if string is a valid email address (basic check)
  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  /// Check if string is a valid URL
  bool get isUrl {
    try {
      final Uri? uri = Uri.tryParse(this);
      return uri != null &&
          (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
    } catch (_) {
      return false;
    }
  }

  /// Check if string is a valid integer
  bool get isInt {
    final int? parsed = int.tryParse(this);
    return parsed != null;
  }

  /// Check if string is a valid double/float
  bool get isDouble {
    final double? parsed = double.tryParse(this);
    return parsed != null;
  }

  /// Check if string is a valid number (int or double)
  bool get isNumeric => isInt || isDouble;

  /// Check if string contains only digits
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  /// Check if string contains only letters
  bool get isLettersOnly =>
      RegExp(r'^[a-zA-Z]+$', unicode: true).hasMatch(this);

  /// Check if string is alphanumeric
  bool get isAlphanumeric =>
      RegExp(r'^[a-zA-Z0-9]+$', unicode: true).hasMatch(this);

  // 34. Extraction & Parsing Helpers

  /// Extract numbers from string and return as list
  List<int> extractIntegers() {
    return RegExp(r'-?\d+')
        .allMatches(this)
        .map((final RegExpMatch m) => int.parse(m.group(0)!))
        .toList();
  }

  /// Extract doubles/floats from string and return as list
  List<double> extractDoubles() {
    return RegExp(r'-?\d+\.?\d*')
        .allMatches(this)
        .map((final RegExpMatch m) {
          final String match = m.group(0)!;
          return double.tryParse(match) ?? (match == '0' ? 0.0 : double.nan);
        })
        .where((final double d) => !d.isNaN)
        .toList();
  }

  /// Extract words from string (alphanumeric sequences)
  List<String> extractWords() {
    return RegExp(
      r'\b\w+\b',
      unicode: true,
    ).allMatches(this).map((final RegExpMatch m) => m.group(0)!).toList();
  }

  /// Try to parse as int, returns null if parsing fails
  int? toIntOrNull() => int.tryParse(this);

  /// Try to parse as double, returns null if parsing fails
  double? toDoubleOrNull() => double.tryParse(this);

  /// Try to parse as bool (handles "true", "false", "1", "0", etc.)
  bool? toBoolOrNull() {
    final String lower = toLowerCase().trim();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
    return null;
  }

  // 35. String Manipulation

  /// Replace multiple patterns at once
  String replaceMultiple(final Map<String, String> replacements) {
    String result = this;
    for (final MapEntry<String, String> entry in replacements.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  /// Insert [insertion] at [index] (alternative implementation)
  String insertStringAt(final int index, final String insertion) {
    if (index < 0 || index > length) {
      throw RangeError(
        'Index $index out of range for string of length $length',
      );
    }
    return substring(0, index) + insertion + substring(index);
  }

  /// Remove characters at [start] to [end] (exclusive)
  String removeRange(final int start, final int end) {
    if (start < 0 || end > length || start > end) {
      throw RangeError('Invalid range: start=$start, end=$end, length=$length');
    }
    return substring(0, start) + substring(end);
  }

  /// Truncate to [maxLength] and add [suffix] if truncated
  String truncateWithSuffix(
    final int maxLength, {
    final String suffix = '...',
  }) {
    if (length <= maxLength) return this;
    final int actualMax = maxLength - suffix.length;
    if (actualMax <= 0) return suffix.substring(0, maxLength);
    return substring(0, actualMax) + suffix;
  }

  /// Wrap text to [width] characters, breaking at word boundaries when possible
  String wrapText(final int width) {
    if (width <= 0) return this;
    if (length <= width) return this;

    final List<String> words = split(' ');
    final List<String> lines = <String>[];
    StringBuffer currentLine = StringBuffer();

    for (final String word in words) {
      if (currentLine.isEmpty) {
        currentLine.write(word);
      } else if ((currentLine.length + 1 + word.length) <= width) {
        currentLine.write(' $word');
      } else {
        lines.add(currentLine.toString());
        currentLine = StringBuffer(word);
      }
    }
    if (currentLine.isNotEmpty) {
      lines.add(currentLine.toString());
    }
    return lines.join('\n');
  }

  // 36. Padding & Alignment

  /// Center the string with [fill] character to [width]
  String centerText(final int width, {final String fill = ' '}) {
    if (length >= width) return this;
    final int padding = width - length;
    final int left = padding ~/ 2;
    final int right = padding - left;
    return fill * left + this + fill * right;
  }

  /// Pad string on both sides equally to [width]
  String padCenter(final int width, {final String fill = ' '}) =>
      centerText(width, fill: fill);

  // 37. Comparison & Matching

  /// Check if string starts with any of the provided [prefixes]
  bool startsWithAny(final Iterable<String> prefixes) {
    for (final String prefix in prefixes) {
      if (startsWith(prefix)) return true;
    }
    return false;
  }

  /// Check if string ends with any of the provided [suffixes] (iterable version)
  bool endsWithAnyOf(final Iterable<String> suffixes) {
    for (final String suffix in suffixes) {
      if (endsWith(suffix)) return true;
    }
    return false;
  }

  /// Check if string contains any of the provided [substrings]
  bool containsAny(final Iterable<String> substrings) {
    for (final String substring in substrings) {
      if (contains(substring)) return true;
    }
    return false;
  }

  /// Calculate Levenshtein distance to [other] string
  int levenshteinDistance(final String other) {
    if (isEmpty) return other.length;
    if (other.isEmpty) return length;

    final List<List<int>> matrix = List<List<int>>.generate(
      length + 1,
      (final int i) => List<int>.filled(other.length + 1, 0),
    );

    for (int i = 0; i <= length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= other.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= length; i++) {
      for (int j = 1; j <= other.length; j++) {
        final int cost = this[i - 1] == other[j - 1] ? 0 : 1;
        matrix[i][j] = <int>[
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((final int a, final int b) => a < b ? a : b);
      }
    }

    return matrix[length][other.length];
  }

  /// Calculate similarity percentage with [other] string (0.0 to 1.0)
  double similarityTo(final String other) {
    if (isEmpty && other.isEmpty) return 1.0;
    if (isEmpty || other.isEmpty) return 0.0;
    final int maxLen = length > other.length ? length : other.length;
    final int distance = levenshteinDistance(other);
    return 1.0 - (distance / maxLen);
  }

  // 38. Line & Paragraph Operations

  /// Remove empty lines from string
  String get removeEmptyLines => split(
        '\n',
      ).where((final String line) => line.trim().isNotEmpty).join('\n');

  /// Get lines as a list
  List<String> get lines => split('\n');

  /// Get line at [index] (0-based), returns null if out of range
  String? lineAt(final int index) {
    final List<String> linesList = lines;
    if (index < 0 || index >= linesList.length) return null;
    return linesList[index];
  }

  /// Indent each line by [indent] characters (default 2 spaces)
  String indentLines({final int indent = 2, final String indentChar = ' '}) {
    final String indentStr = indentChar * indent;
    return lines.map((final String line) => '$indentStr$line').join('\n');
  }

  // 39. String Properties

  /// Get the middle character(s) of the string
  String get middleChar {
    if (isEmpty) return '';
    if (length == 1) return this;
    final int mid = length ~/ 2;
    return length.isOdd ? this[mid] : substring(mid - 1, mid + 1);
  }

  /// Check if string is symmetric (palindrome)
  bool get isSymmetric => isPalindrome();

  /// Get unique characters in the string
  Set<String> get uniqueChars => split('').toSet();

  /// Get character frequency map
  Map<String, int> get charFrequency {
    final Map<String, int> freq = <String, int>{};
    for (final String char in split('')) {
      freq[char] = (freq[char] ?? 0) + 1;
    }
    return freq;
  }

  // 40. Utility Methods

  /// Apply transformation if string is not blank
  T? ifNotBlank<T>(final T Function(String) transformer) {
    return isBlank ? null : transformer(this);
  }

  /// Return this string if not blank, otherwise return [fallback]
  String ifBlank(final String fallback) => isBlank ? fallback : this;

  /// Return this string if not empty, otherwise return [fallback]
  String ifEmpty(final String fallback) => isEmpty ? fallback : this;

  /// Chunk string into parts of [size]
  List<String> chunk(final int size) {
    if (size <= 0) throw ArgumentError('Size must be positive');
    final List<String> chunks = <String>[];
    for (int i = 0; i < length; i += size) {
      final int end = (i + size < length) ? i + size : length;
      chunks.add(substring(i, end));
    }
    return chunks;
  }

  /// Remove duplicate consecutive characters
  String removeConsecutiveDuplicates() {
    if (length <= 1) return this;
    final StringBuffer result = StringBuffer();
    String? lastChar;
    for (final String char in split('')) {
      if (char != lastChar) {
        result.write(char);
        lastChar = char;
      }
    }
    return result.toString();
  }

  /// Swap case of all characters
  String get swapCase {
    return split('').map((final String char) {
      if (char == char.toUpperCase()) {
        return char.toLowerCase();
      } else {
        return char.toUpperCase();
      }
    }).join();
  }
}
