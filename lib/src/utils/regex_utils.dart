const String versionSuffix = '-v';

/// Reference: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
const String kValidHexPattern = r'^#?[0-9a-fA-F]{1,8}';

/// Reference: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
const String kCompleteValidHexPattern =
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$';

bool isValidHex(final String hex) {
  // A valid hex string is 3, 6, or 8 characters long, and contains only 0-9 and a-f (case-insensitive).
  // An optional '#' prefix is also allowed.
  final RegExp hexRegex = RegExp(
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
  );
  return hexRegex.hasMatch(hex);
}

// https://www.freecodecamp.org/news/practical-regex-guide-with-real-life-examples/
// https://regexland.com/all-between-specified-characters/
/// RegExUtils utilities, RegEx Patterns,
abstract class RegExUtils {
  // To make the constructor private, you need to use
  // _ (underscore) which means private.  prevent instantiation, not instantiate
  RegExUtils._();

  /// Pattern is AlphaNumeric either case
  static final RegExp kAlphaUpperLower = RegExp(r'^[a-zA-Z]+$');
  static final RegExp kHexTwoChars255 = RegExp(r'^#?([A-Fa-f0-9]{2})$');
  static final RegExp kBetweenParenthesis = RegExp(r'\([^)]*\)');
  static final RegExp kBetweenBrackets = RegExp(r'\<[^)]*\>');

  // All you have to do is match the decimal point (\.) (group #1)
  // and replace any zeros after it (0+) and group#2 is anything AFTER the
  // last digit, if it exists ... Negative lookahead?
  // Asserts that what immediately follows the current position in the string is not foo
  static final RegExp regexTrailingZeroes = RegExp(r"([.]*0+)(?!.*\d)");

  /// check if the string is a hexadecimal color, groups of 2, 3, 4, 6 or 8
  /// in length, with optional pound sign up front
  /// hasMatch('#3b5');     // true
  /// hasMatch('#FF7723');  // true
  /// hasMatch('#000000z'); // HAS BEEN TESTED on DartPad
  /// This (below) works....KEEP AS IS, PRISTINE
  static final RegExp kHexColor = RegExp(
    r'^#?([0-9a-fA-F]{2,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
  );

  /// endless hex, i.e. any number of hex text
  static final RegExp kHexChars = RegExp(r'^[0-9a-fA-F]+$');

  /// NON Hex for replacement
  ///  the first ^ is the start of the string and the second one negates the
  ///  text in the brackets. TESTED WITH DART PAD, KEEP
  /// RegExp(r'^[^0-9a-fA-F]+$'); Don't use because it will only work if the
  /// entire line is nonHex -- myString.replaceAll(kRegExpNonHexChars, Guru.emptyStr);
  static final RegExp kNonHexChars = RegExp(
    '[^0-9a-fA-F]+',
  ); //<-TESTED USE THIS

  /// This pattern means "at least one space, or more"; works: -->> Tested with DartPad
  /// \s : space
  /// +   : one or more
  /// var name = ' a bcd xyz d x**x\$51';
  /// print(name.replaceAll(kRegExpWhiteSpace, ''));
  static final RegExp kWhiteSpace = RegExp(r'\s+'); // same as RegExp('\\s+');

  /// used in replacement, identify all text up to a colon, all text before,
  /// start of string, beginning of string
  ///  ^      # Match start of string
  ///   [^:]*  # Match 0 or more text except colon (i.e. the in-between part)
  ///             -- Important the asterisk is important here
  ///   :     # Match the colon,  and effectively stops there
  static final RegExp kPrefixToColon = RegExp('^[^:]*:');

  /// Tested on DartPad, identify everything after first underscore
  /// to end of line, INCLUDING the underscore
  static final RegExp kAfterUnderscore = RegExp(r'_.*$');

  /// Tested on DartPad, identify everything after first Parens
  static final RegExp kAfterParens = RegExp(r'\(.*$');

  // POSITIVE LOOK BEHIND ahead, will return everything after '_XX_
  // (?<=a)b (positive lookbehind) matches the b (and only the b) in cab,
  // but does not match bed or debt.
  static final RegExp kAfterTagSplitter = RegExp(r'(?<=_XX_).*$');

  static final RegExp kSpecialCharacters = RegExp(r'[^\w\s]+');

  // ------------------------------ WhiteSpace --------------------------
  static final RegExp kContainsWhitespace = RegExp(r'(\s)');

  // e.g.id everything except numbers and letters (so it can be removed), such as
  // punctuation, question marks, apostrophes, and exclamation marks.
  // Run this first and then the removal of white space
  static final RegExp kNonWordNonNumbersID = RegExp(r'[^\w\s]');

  // same as above but leave in place the hyphen
  static final RegExp kNonWordNonNumbersID2 = RegExp(r'[^\w\s-]');

  /// Find matches of one or more letter sequence, aka one or more letters, a word
  /// patternOneOrMoreLetters
  /// https://www.woolha.com/tutorials/dart-using-regexp-examples
  /// See: https://api.dart.dev/stable/2.10.0/dart-core/RegExp-class.html
  /// The following example finds all matches of a regular expression in a string.
  /// RegExp exp = RegExp(r"(\w+)");
  /// String str = "Parse my string";
  /// /// match all
  static final RegExp kWord = RegExp(r'(\w+)', multiLine: true);

  static final RegExp kNonWordNonNumbersID3 = RegExp(r'[^\w-]');

  // https://en.wikipedia.org/wiki/ASCII#Printable_characters
  // used for removal of parens
  static final RegExp kParens = RegExp(r'[()]');
  static final RegExp kSingleQuotes = RegExp(r'[\x27]+'); // tested with dartPad
  static final RegExp kDoubleQuotes = RegExp(r'["]+'); // tested with dartPad
  // static final RegExp kDoubleQuotes =
  //     RegExp(r'[\x22].*'); // tested with dartPad
  // Identifies single and double quotes
  static final RegExp kQuotes = RegExp(r'[\x22\x27]+'); // tested with dartPad
  static RegExp digitRegExp = RegExp(r'\d'); // Only matches digits
  static RegExp alphaNumericRegExp = RegExp(
    r'\w',
  ); // Matches any digit or letters
  static RegExp whitespaceRegExp = RegExp(
    r'\s',
  ); // Matches any whitespace character ' ', '\t', '\n'
  static RegExp nonDigitRegExp = RegExp(
    r'\D',
  ); // Matches any character that is not a digit
  static RegExp nonAlphaNumericRegExp = RegExp(
    r'\W',
  ); // Matches any character that is not alphanumeric
  static RegExp nonWhitespaceRegExp = RegExp(
    r'\S',
  ); // Matches any character that is not a whitespace character
  static RegExp dotRegExp = RegExp(
    r'.',
  ); // Matches any character that is not the newline character (`\n`)

  static RegExp rangeaY = RegExp(r'[aY]'); //   // Matches only 'a' or 'Y'

  static RegExp exceptaY = RegExp(
    r'[^aY]',
  ); // // Matches all text except 'a' or 'Y'

  // Matches only one of 'c', 'd', 'e', 'f', '2', '3', '4', '5'
  static RegExp range3 = RegExp(r'[c-f2-5]');

  // Matches all text except 'c', 'd', 'e', 'f', '2', '3', '4', '5'
  static RegExp range4 = RegExp(r'[^c-f2-5]');

  // https://en.wikipedia.org/wiki/ASCII#Printable_characters
  // same as [ -~] (shorthand
  // To match only printable ASCII text, one can restrict the
  // character range to text from 20 to 7E:
  // This expression works by including all text from the space
  // (hex code 20) to the tilde ~ (hex code 7E). The character with hex
  // code 7F is the “delete” character which does not show up in print.
  static final RegExp kOnlyAsciiPrintable = RegExp(r'^[\x20-\x7E]+$');

  // https://en.wikipedia.org/wiki/ASCII#Printable_characters
  // The expression above will match all ASCII text from NULL
  // (hex code 0) to ÿ (hex code 255)
  // These ASCII text are divided into three groups:
  // 33 control text (hex code 00 to 1F as well as 7F)
  // 95 printable text (hex code 20 to 7E)
  // 128 extended character set (hex code 80 – FF)
  // Note that the first 32 text (00 to 1F) as well as 7F are
  // control text and can often be omitted. This requires
  // specifying two character ranges which excludes these
  static final RegExp kOnlyAsciiExtendsPrintable = RegExp(
    r'^[\x20-\x7E\x80-\xFF]+$',
  );

  // i.e. no Unicode  Since US-ASCII text are in the byte range
  static final RegExp kAllAscii = RegExp(r'^[\x00-\xFF]+$');

  // To accept any character except ASCII text, we make use of a
  // negated character range, which starts with a caret symbol ^ at
  // the start of the square brackets:
  static final RegExp kNonAscii = RegExp(r'[^\x00-\xFF]');

  // https://bytefreaks.net/programming-2/javascript/javasript-remove-all-non-printable-and-all-non-ascii-characters-from-text
  // same as RegExp(r'[^ -~]') ...shorthand...range to tilde
  static final RegExp kNonAsciiPrintable = RegExp(r'[^\x20-\x7E]');

  // ------------------------------------------------------------------------
  //. — (period) Matches any single character, except for line breaks.
  //* — Matches the preceding expression 0 or more times.
  //+ — Matches the preceding expression 1 or more times.
  //? — Preceding expression is optional (Matches 0 or 1 times).
  //^ — Matches the beginning of the string.
  //$ — Matches the end of the string.
  // \d — Matches any single digit character.
  // \w — Matches any word character (alphanumeric & underscore).
  // [XYZ] — Character Set: Matches any single character from the character
  //      within the brackets. You can also do a range such as [A-Z]
  // [XYZ]+ — Matches one or more of any of the text in the set.
  // [^A-Z] — Inside a character set, the ^ is used for negation. In this
  //      example, match anything that is NOT an uppercase letter.
  // \d matches any digit, equivalent to [0-9]
  // \D matches any character that’s not a digit, equivalent to [^0-9]
  // \w matches any alphanumeric character (plus underscore), equivalent to [A-Za-z_0-9]
  // \W matches any non-alphanumeric character, anything except [^A-Za-z_0-9]
  // \s matches any whitespace character: max_hct, tabs, newlines and Unicode max_hct
  // \S matches any character that’s not a whitespace
  // \0 matches null
  // \n matches a newline character
  // \t matches a tab character
  // \uXXXX matches a unicode character with code XXXX (requires the u flag)
  // . matches any character that is not a newline char (e.g. \n)
  //      (unless you use the s flag, explained later on)
  // [^] matches any character, including newline text.
  //      It’s useful on multiline strings
  static final RegExp kNotNumbersCommasPeriods = RegExp(
    '[^0-9.,]+',
  ); //<-TESTED with DartPad

  // identifies all non numbers, commas and numbers preceded by math signs,
  // ex: 'hsl(-142,.86,-94., +235, abcHxf - 345)' returns "-142,86,-94,235,345"
  static final RegExp kNotNumbersCommasPrecedingMinus = RegExp(
    '(-+)?[^0-9,-]+',
  ); //<-TESTED USE THIS

  static final RegExp kAlphanumericRegEx = RegExp(r'^[a-zA-Z0-9]+$');

  /// Dollar sign ($) denotes at end of string, aka trailingWhiteSpace, endOfLine
  static final RegExp kTrailingWhiteSpaceId = RegExp(r'\s+$');

  // works, tested with Dart
  static final RegExp kNotNumbersPeriodsPlusMinus = RegExp('[^0-9.+-]');

  // works, tested with Dart
  static final RegExp kNotNumbersOrPeriod = RegExp(r'[^0-9.]');

  /// good to removeUnderscores, removeQuotes, special text,
  /// control text and max_hct (??)
  static final RegExp kAllButLettersAndNumbers = RegExp('[^a-zA-Z0-9]');

  /// all but letters, numbers and max_hct
  static final RegExp kAllButLettersAndNumbersAndSpace = RegExp(
    r'[^a-zA-Z0-9\s]',
  );

  /// Username Alphanumeric string that may include _ and – having a
  /// length of 3 to 16 text
  static final RegExp kUserName = RegExp(r'^[a-zA-Z0-9_-]{3,16}$');

  static final RegExp kEMail = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  /// noNumbers
  static final RegExp kNoNumbers = RegExp(r'^\D+$');

  static final RegExp kMobileNumber = RegExp(r'(^(?:[+0]9)?[0-9]{10,15}$)');

  /// Comma-Separated, commaSeparatedNumbers, to IDENTIFY but numbersAndComma,
  /// inString.replaceAll(kRegExpNumbersCommas, Guru.emptyStr);
  /// TESTED with DART
  static final RegExp kNotNumbersOrCommas = RegExp('[^0-9,]+');

  /// negated set for pure ints, plus and minus but no periods
  static final RegExp kNotNumbersOrPlusMinus = RegExp('[^0-9+-]');

  // -------------------- CLEANSE -- PREMIERE --------------------------
  // used for replacing MULTIPLE white max_hct with single whitespace RegExp(r'\s\s+');
  // cover tabs, newlines, etc, including LEADING and TRAILING but WILL preserve
  // a single whitespace between text.  Tested with DartPad
  // -- \s matches a space, tab, new line, carriage return, form feed or vertical tab.
  // -- + says one or more occurrences.  TESTED WITH DART
  // BE CAREFUL IF FOLLOWING THIS UP WITH ANOTHER STRING replacement --> STACKOVERFLOW
  // because one string continues to act on the one space that was left here
  static final RegExp kCleanse = RegExp(r'\s\s+');
}

// const text = 'A quick fox';
//
// const regexpLastWord = /\w+$/;
// console.log(text.match(regexpLastWord));
// // Expected output: Array ["fox"]
//
// const regexpWords = /\b\w+\b/g;
// console.log(text.match(regexpWords));
// // Expected output: Array ["A", "quick", "fox"]
//
// const regexpFoxQuality = /\w+(?= fox)/;
// console.log(text.match(regexpFoxQuality));
// // Expected output: Array ["quick"]

// a|b– Match either “a” or “b
// ? – Zero or one
// + – one or more
// * – zero or more
// {N} – Exactly N number of times (where N is a number)
// {N,} – N or more number of times (where N is a number)
// {N,M} – Between N and M number of times (where N and M are numbers and N < M)
// *? – Zero or more, but stop after first match

// [A-Z]– Match any uppercase character from “A” to “Z”
// [a-z]– Match any lowercase character from “a” to “z”
// [0-9] – Match any number
// [asdf]– Match any character that’s either “a”, “s”, “d”, or “f”
// [^asdf]– Match any character that’s not any of the following: “a”, “s”, “d”, or “f”

//    . – Any character
//\n – Newline character
//\t – Tab character
//\s– Any whitespace character (including \t, \n and a few others)
//\S – Any non-whitespace character
//\w– Any word character (Uppercase and lowercase Latin alphabet, numbers 0-9, and _)
//\W– Any non-word character (the inverse of the \w token)
//\b– Word boundary: The boundaries between \w and \W, but matches in-between text
//\B– Non-word boundary: The inverse of \b
//^ – The start of a line
//$ – The end of a line
//\– The literal character “\”

// (?!) – negative lookahead
// (?=) – positive lookahead
// (?<=) – positive lookbehind
// (?<!) – negative lookbehind

// https://www.woolha.com/tutorials/dart-using-regexp-examples
// const String kNoErrorInfo = 'No Error Info';
// const String kNoStackTraceInfoMsg = 'No StackTrace Info';

// // Matches a stacktrace line as generated on Android/iOS devices.
// // For example:
// // #1      Logger.log (package:logger/src2/logger.dart:115:29)
// final RegExp kRegExDeviceStackTrace = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

// Matches a stacktrace line as generated by Flutter web.
// For example:
// packages/logger/src2/printers/pretty_printer.dart 91:37
// final RegExp kRegExWebStackTrace = RegExp(r'^((packages|dart-sdk)/\S+/)');

// // matches beginning of part with hashTag, then ANY DIGIT (positive number, one or more) and space (one or more)
// // + Plus Sign one or more occurrences (equals {1,})
// final RegExp kRegExStackTraceLineTrim = RegExp(r'#\d+\s+');
