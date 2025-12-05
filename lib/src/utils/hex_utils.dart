import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/extensions/string_helpers.dart';
import 'package:color_iq_utils/src/utils/error_handling.dart';
import 'package:color_iq_utils/src/utils/regex_utils.dart';

ColorIQ parseHex(String hex) {
  hex = hex.replaceAll('#', '').toUpperCase();
  // hex = hex.substring(1);
  if (hex.length == 3) {
    hex = hex.split('').map((final String c) => '$c$c').join('');
  }

  if (hex.length == 6) {
    hex = 'FF$hex';
    return ColorIQ(int.parse(hex, radix: 16));
  }

  if (hex.length == 8) {
// CSS hex is RRGGBBAA, Dart Color is AARRGGBB
// So we need to move AA to the front.
// Input: RRGGBBAA
// Output: AARRGGBB
    final String r = hex.substring(0, 2);
    final String g = hex.substring(2, 4);
    final String b = hex.substring(4, 6);
    final String a = hex.substring(6, 8);
    hex = '$a$r$g$b';
    return ColorIQ(int.parse(hex, radix: 16));
  }

  throw FormatException('Invalid hex color: #$hex');
}

/// HexUtils class
/// An 8-bit or 1-byte hexadecimal number can contain a maximum value
/// of 255 decimal (FF). A 32-bit (or 4-byte) number maxes out at FFFFFFFF
/// or two words (FFFF FFFF)
/// A 64-bit (or 8-byte) number maxes out at FFFF FFFF FFFF FFFF or four words.
///   See also [findClosestHexSingle]
abstract class HexUtils {
  // Prevent instantiation
  HexUtils._();

  static List<String> hexArray = '0123456789ABCDEF'.split('');
  static const Set<int> validHexLengths = <int>{2, 3, 4, 6, 8};
  static const String hexChars = "0123456789abcdef";
  static const Map<String, int> hexCharsMap = <String, int>{
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'a': 10, // lower case
    'b': 11,
    'c': 12,
    'd': 13,
    'e': 14,
    'f': 15,
    'A': 10, // upper case
    'B': 11, // upper case
    'C': 12,
    'D': 13,
    'E': 14,
    'F': 15,
  };

  // https://www.binaryhexconverter.com/decimal-to-hex-converter
  /// See also [findClosestHexSingle], aka mapToString, mapHexToString
  static const Map<int, String> numToHexConversionTable = <int, String>{
    0: '0',
    1: '1',
    2: '2',
    3: '3',
    4: '4',
    5: '5',
    6: '6',
    7: '7',
    8: '8',
    9: '9',
    10: 'A',
    11: 'B',
    12: 'C',
    13: 'D',
    14: 'E',
    15: 'F',
  };

  static const Map<String, int> mapBinaryToHex = <String, int>{
    '0000': 0x00,
    '0001': 0x01,
    '0010': 0x02,
    '0011': 0x03,
    '0100': 0x04,
    '0101': 0x05,
    '0110': 0x06,
    '0111': 0x07,
    '1000': 0x08,
    '1001': 0x09,
    '1010': 0x0A,
    '1011': 0x0B,
    '1100': 0x0C,
    '1101': 0x0D,
    '1110': 0x0E,
    '1111': 0x0F,
  };

  static const Map<String, int> mapBinaryToInt = <String, int>{
    '0000': 0,
    '0001': 1,
    '0010': 2,
    '0011': 3,
    '0100': 4,
    '0101': 5,
    '0110': 6,
    '0111': 7,
    '1000': 8,
    '1001': 9,
    '1010': 10,
    '1011': 11,
    '1100': 12,
    '1101': 13,
    '1110': 14,
    '1111': 15,
  };

  static const Map<String, String> mapHexStrToBinary = <String, String>{
    '0': '0000',
    '1': '0001',
    '2': '0010',
    '3': '0011',
    '4': '0100',
    '5': '0101',
    '6': '0110',
    '7': '0111',
    '8': '1000',
    '9': '1001',
    'A': '1010',
    'B': '1011',
    'C': '1100',
    'D': '1101',
    'E': '1110',
    'F': '1111',
  };

  static const Map<int, String> mapHex4BitIntToBinary = <int, String>{
    0x0: '0000',
    0x1: '0001',
    0x2: '0010',
    0x3: '0011',
    0x4: '0100',
    0x5: '0101',
    0x6: '0110',
    0x7: '0111',
    0x8: '1000',
    0x9: '1001',
    0xA: '1010',
    0xB: '1011',
    0xC: '1100',
    0xD: '1101',
    0xE: '1110',
    0xF: '1111',
  };

  static const Map<int, int> mapHex4BitIntToInt = <int, int>{
    0x0: 0,
    0x1: 1,
    0x2: 1,
    0x3: 3,
    0x4: 4,
    0x5: 5,
    0x6: 6,
    0x7: 7,
    0x8: 8,
    0x9: 9,
    0xA: 10,
    0xB: 11,
    0xC: 12,
    0xD: 13,
    0xE: 14,
    0xF: 15,
  };

  static final String hexLengthErrorMessage =
      'Invalid hex length must be 2, 3, 4, 6 or 8, ${validHexLengths.toSet()}';

  static String hexToAscii(final String hexString) => List<String>.generate(
        hexString.length ~/ 2,
        (final int i) => String.fromCharCode(
          int.parse(hexString.substring(i * 2, (i * 2) + 2), radix: 16),
        ),
      ).join();

  /// Converts an byte array to a integer.
  static int bytesToInt(final List<int> bytes) {
    int value = 0;

    for (int i = 0, length = bytes.length; i < length; i++) {
      value += bytes[i] * (math.pow(256, i) as int);
    }
    return value;
  }

  // int toUnsigned(int width) => toUnsigned();
  /// Uses bitwise AND operator with the mask 0xffffffff
  /// (or 4294967295 in decimal). This operation effectively extracts
  /// the lower 32 bits of the integer, discarding any higher bits and
  /// ensuring the result is within the range of a 32-bit unsigned
  /// integer (0 to 232 - 1). Prefer to use the method below from BigInt
  static int toUInt32A(final int val) => (val & 0xffffffff);

  /// Same as above [toUInt32Int], tested with DartPad
  static int toUInt32B(final int val) =>
      BigInt.from(val).toUnsigned(32).toInt();

  /// Same as above [toUInt32Int], tested on DartPad. Part of Dart core.
  static int toUInt32C(final int val) => val.toUnsigned(32);

  /// Convert a byte array [bytes] into a hex string.
  ///
  /// Used to get a hex string representation of raw bytes.
  /// Should not be used for UTF-8 encoded data such as message encryption.
  static String bytesToHex(final List<int> bytes) {
    final StringBuffer result = StringBuffer();
    for (final int part in bytes) {
      result.write('${part < 16 ? kZeroStr : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  /// Extract bytes from a hexInt to a list of ints
  static List<int> extractBytesToList(final int hexInt) {
    final int bitLen = hexInt.bitLength;
    if (bitLen < 8) {
      throw Exception('8--Bit length was not >= 8 but was $bitLen');
    }
    // int val = 0;
    final int byte1 = (hexInt >> 0) & 0xff;
    final int byte2 = bitLen >= 8 ? ((hexInt >> 8) & 0xff) : 0;
    final int byte3 = bitLen >= 16 ? ((hexInt >> 16) & 0xff) : 0;
    final int byte4 = bitLen >= 24 ? ((hexInt >> 24) & 0xff) : 0;
    // now add it up
    // final int iByte1 = (byte1 * 1);
    // val += iByte1; // * 16 power of 0 (which is always 1)
    // debugPrint('val (First Byte) is now1: $val');
    // final int iByte2 = (byte2 * 16).toInt();
    // val += iByte2; // 16 to the power of 1
    // final int iByte3 = (byte3 * math.pow(16, 2)).toInt();
    // val += iByte3; // 16 to the power of 2
    // final int iByte4 = (byte4 * math.pow(16, 3)).toInt();
    // val += iByte4;
    // debugPrint(
    //   'extracting bits-$val---Byte1: $byte1, Byte2 = $byte2, Byte3 = $byte3, '
    //   'Byte 4 = $byte4',
    // );
    return <int>[byte1, byte2, byte3, byte4];
  }

  // ======================= PREMIERE METHOD ====================================
  /// String is in the format "aabbcc" or "ffaabbcc"
  /// ALERT--ALERT--ALERT Do NOT use '0x..' in the string,
  /// if you do, then it is a base10 calc so just int.parse(str) WITHOUT RADIX
  /// WORKS Tested on DartPad, hexStrToIntVal1('353535') ==> 4281677109
  /// hexStrToIntVal1('#ffaabbcc') ==> 4289379276, aka StringToHexInt, strToHexInt
  /// aka hexStrToHexInt
  static int hexIdFromHexStr(
    final String hexStr, [
    final String alphaChannel = kDefaultAlphaChannel,
  ]) {
    try {
      if (hexStr.startsWith(kPoundSign)) {
        final int? lRes = int.tryParse('$k0xLower${hexStr.substring(1)}') ??
            int.tryParse('$k0xUpper${hexStr.substring(1)}') ??
            int.tryParse('$n0FF${hexStr.substring(1)}');
        if (lRes != null) {
          return lRes;
        }
      }
      if (hexStr.startsWith(n0FF) ||
          hexStr.startsWith(k0xLower) ||
          hexStr.startsWith(k0xUpper)) {
        final int? lRes = int.tryParse(hexStr.toUpperCase());
        if (lRes != null) {
          return lRes;
        }
      }
      // first cleanse the string, e.g. remove pound sign and '0x' because it is
      // base 16, not 10
      final String lHexColor = HexUtils.resizeHexString(
        hexStr,
        alphaChannel: alphaChannel,
      );
      final int? lRes = int.tryParse(lHexColor, radix: 16);
      if (lRes != null) {
        return lRes;
      }
      return HexUtils.hexStrToHexInt2(lHexColor);
    } catch (e, stacktrace) {
      // debugPrintStack(stackTrace: stacktrace);
      // final String st = getStackTraceAsString(stackTrace: stacktrace, error: e);
      throw Exception('$e\n$stacktrace');
    }
  }

  /// Allows for varying lengths of the hexString, including short hexs
  /// (rgb), (argb) for full 32-bit int. Uses similar logic to [resizeHexString]
  static int hexStrToHexId(final String hexStrInput, [final int base = 16]) {
    String normalized = hexStrInput.removeNonHexChars;
    if (normalized.length < 3 || normalized.length > 8) {
      throw ArgumentError(
        'Invalid Hex String length in hexStrToHexId ${normalized.length} - $hexStrInput-${HexUtils.clName}',
      );
    }
    late final String r;
    late final String g;
    late final String b;
    if (normalized.length == 3) {
      r = '${normalized[0]}${normalized[0]}';
      g = '${normalized[1]}${normalized[1]}';
      b = '${normalized[2]}${normalized[2]}';
      // Example: f00 => ff0000 => Red, 100 % Alpha
      final int val1 = int.tryParse('FF$r$g$b', radix: base) ??
          (throw Exception(
            'Could not parse Hex String $hexStrInput-${HexUtils.clName}',
          ));
      return val1;
    }

    /// Convert from ARGB (not RGBA) format
    if (normalized.length == 4) {
      // Example: f00f => ff0000ff => Blue, ARGB
      final String a = '${normalized[0]}${normalized[0]}';
      r = '${normalized[1]}${normalized[1]}';
      g = '${normalized[2]}${normalized[2]}';
      b = '${normalized[3]}${normalized[3]}';
      final int val2 = int.tryParse('$a$r$g$b', radix: base) ??
          (throw Exception(
            'Could not parse Hex String (ARGB) ' //
            '$hexStrInput at 316-${HexUtils.clName}',
          ));
      return val2;
    }

    if (normalized.length == 6) {
      // Example: ff0000 =>  NO ALPHA
      normalized = 'FF$normalized';
      final int val3 = int.tryParse(normalized, radix: base) ??
          (throw Exception(
            'Could not parse Hex String Length(6) ' //
            '$hexStrInput at 331-${HexUtils.clName}',
          ));
      return val3;
    }

    if (normalized.length == 8) {
      final int val4 = int.tryParse(normalized, radix: 16) ??
          (throw Exception(
            'Could not parse Hex String Length(8) ' //
            '$hexStrInput at 339-${HexUtils.clName}',
          ));
      return val4;
    }
    throw HexColorParseException(
      'Could not parse-$hexStrInput-${normalized.length}',
    );
  }

  // hexToInt, hexToDecimal hexToNumber, e.g. hex '62' -> 98, '6E' -> 110
  // THIS WORKS!!! KEEP, example: Color color= Color(hexStrToInt("FFB74093"));
  static int hexStrToHexInt2(final String hex) {
    int val = 0;
    final int len = hex.length;
    for (int i = 0; i < len; i++) {
      final int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw FormatException('Invalid hexadecimal value $hex');
      }
    }
    return val;
  }

  /// return string list:
  /// 0 - Alpha
  /// 1 - Red
  /// 2 - Green
  /// 3 - Blue
  /// Call [singleNumToHexStr] after this
  static List<String> hexStrToStrList(final String hexStrInput) {
    final String input = hexStrInput.removeNonHexChars;
    final String lHexStr = ArgumentError.checkNotNull(
      HexUtils.validateHexStrOrNull(input),
      'invalid Hex string at 90 $input-${HexUtils.clName}',
    ); // remove pound sign
    if (lHexStr.length == 3) {
      return <String>[
        kDefaultAlphaChannel,
        lHexStr[0].repeat(2),
        lHexStr[1].repeat(2),
        lHexStr[2].repeat(2),
      ];
    } else if (lHexStr.length == 4) {
      // rgba .. NOT argb
      return <String>[
        lHexStr[3].repeat(2),
        lHexStr[0].repeat(2),
        lHexStr[1].repeat(2),
        lHexStr[2].repeat(2),
      ];
    } else if (lHexStr.length == 6) {
      return <String>[
        kDefaultAlphaChannel,
        lHexStr.substring(0, 2),
        lHexStr.substring(2, 4),
        lHexStr.substring(4, 6),
      ];
    }
    if (lHexStr.length == 8) {
      return <String>[
        lHexStr.substring(0, 2),
        lHexStr.substring(2, 4),
        lHexStr.substring(4, 6),
        lHexStr.substring(6, 8),
      ];
    }
    throw Exception(
      'INVALID HEX CONVERSION-hexStrToStrList, ' //
      '"$lHexStr"-${HexUtils.clName}',
    );
  }

  /// Hex String to Uint8List
  static Uint8List hexStrToUint8List(final String hexStringIn) {
    final String hex = hexStringIn.removeNonHexChars;
    if (hex.length % 2 != 0) {
      throw ArgumentError('Invalid hex string length-$hexStringIn');
    }

    final List<int> bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      final String hexPair = hex.substring(i, i + 2);
      final int byteValue = int.parse(hexPair, radix: 16);
      bytes.add(byteValue);
    }

    return Uint8List.fromList(bytes);
  }

  // static List<int> hexStrToUint8List2(String hexString) =>
  //     hex.decode(hexString.removeNonHexChars);

  /// RGB values are ranging in [0;1].
  /// @param hex A `#RRGGBB` representation of a color.
  /// @return An array containing the color's RGB values. .. NOT TESTED
  static List<double> hexToRgbList(String hex) {
    hex = hex.toLowerCase();
    final List<double> ret = <double>[];
    for (int i = 0; i < 3; i += 1) {
      final int digit1 = hexChars.indexOf(hex[i * 2 + 1]);
      final int digit2 = hexChars.indexOf(hex[i * 2 + 2]);
      final int n = digit1 * 16 + digit2;
      ret.add(n / 255.0);
    }
    return ret;
  }

  /// Reference: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
  static ColorIQ? colorFromHex(
    final String inputString, {
    final bool enableAlpha = true,
  }) {
    // Registers validator for exactly 6 or 8 digits long HEX (with optional #).
    final RegExp hexValidator = RegExp(kCompleteValidHexPattern);
    // Validating input, if it does not match — it's not proper HEX.
    if (!hexValidator.hasMatch(inputString)) {
      return null;
    }
    // Remove optional hash if exists and convert HEX to UPPER CASE.
    String hexToParse =
        inputString.replaceAll(kPoundSign, kEmptyStr).toUpperCase();
    // It may allow HEXs with transparency information even if alpha is disabled,
    if (!enableAlpha && hexToParse.length == 8) {
      // but it will replace this info with 100% non-transparent value (FF).
      hexToParse = 'FF${hexToParse.substring(2)}';
    }
    // HEX may be provided in 3-digits format, let's just duplicate each letter.
    if (hexToParse.length == 3) {
      hexToParse = hexToParse
          .split(kEmptyStr)
          .expand((final String i) => <String>[i * 2])
          .join();
    }
    // We will need 8 digits to parse the color, let's add missing digits.
    if (hexToParse.length == 6) {
      hexToParse = 'FF$hexToParse';
    }
    // HEX must be valid now, but as a precaution, it will just "try" to parse it.
    final int? intColorValue = int.tryParse(hexToParse, radix: 16);
    // final Suit st = Suit.getBrandFromGeneric<S>();
    // If for some reason HEX is not valid — abort the operation, return nothing.
    if (intColorValue == null) {
      return ColorIQ(
        HexUtils.hexStrToHexInt2(hexToParse),
      ); // .toCInf<S>(st as S);
    }
    return ColorIQ(intColorValue);
  }

  /// Hex6 to RGB
  static List<int> hex6toRGB(final String hexStr) {
    int? bigInt;
    if (hexStr.startsWith(kPoundSign)) {
      bigInt = int.tryParse(hexStr.substring(1), radix: 16);
    } else if (hexStr.startsWith(k0xLower) || hexStr.startsWith(k0xUpper)) {
      bigInt = int.tryParse(hexStr.substring(2), radix: 16);
    } else {
      bigInt = int.tryParse(hexStr, radix: 16);
    }
    bigInt = ArgumentError.checkNotNull(bigInt, 'BigInt was null at 1088');
    final int a = (bigInt! >> 24) & 0xFF;
    final int r = (bigInt >> 16) & 0xFF;
    final int g = (bigInt >> 8) & 0xFF;
    final int b = bigInt & 0xFF;
    return <int>[a, r, g, b];
  }

  // don't know if this works???
  // NOTE: the hex.decode is from the Convert package
  /// Converts a hex string to a [Uint8List].
  static Uint8List hexToBytes(final String hexString) {
    final List<int> bytes = utf8.encode(hexString);
    final Uint8List uint8List = Uint8List.fromList(bytes);
    //   print(uint8List); // Output: [72, 101, 108, 108, 111, 44, 32, 68, 97, 114, 116, 33]
    return uint8List;
  }

  //     Uint8List.fromList(hex.decode(hexString.removeNonHexChars));
  // alternate approach
  static Uint8List convertStringToUint8List(final String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  /// Decode a BigInt from bytes in big-endian encoding.
  static BigInt _decodeBigInt(final List<int> bytes) {
    BigInt result = BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  // https://suragch.medium.com/working-with-bytes-in-dart-6ece83455721
  /// Byte List to HexInt: ALERT make sure this is in REVERSE order
  // static int byteListToHexInt(List<int> inList) {
  //   // debugPrint('inList was: ${inList.toString()}');
  //   return HexUtils.hexStrToHexId(hex.encode(inList));
  // }

  /// Converts bytes to [BigInt].
  static BigInt bytesToBigInt(final Uint8List bigIntBytes) =>
      _decodeBigInt(bigIntBytes);

  /// Converts a bigint to a byte array.
  static Uint8List bigIntTo16Bytes(final BigInt bigInt) =>
      HexUtils.hexToBytes(bigInt.toRadixString(16).padLeft(32, kZeroStr));

  /// Converts a binary string into a hex string.
  static String binaryToHex(final String binary) =>
      BigInt.parse(binary, radix: 2).toRadixString(16).toUpperCase();

  /// Reverse the bytes.
  static Uint8List reverseBytes(final Uint8List bytes) {
    final Uint8List reversed = Uint8List(bytes.length);
    for (int i = bytes.length; i > 0; i--) {
      reversed[bytes.length - i] = bytes[i - 1];
    }
    return reversed;
  }

  /// Converts byte array to string UTF-8.
  static String bytesToUtf8String(final Uint8List bytes) => utf8.decode(bytes);

  /// Converts a UTF-8 [input] string to an encoded byte array.
  static List<int> stringToBytesUtf8(final String input) => utf8.encode(input);

  /// Converts a UTF-8 [input] string to an encoded byte array.
  static Uint8List utf8StringToBytes(final String input) =>
      Uint8List.fromList(utf8.encode(input));

  /// Concatenates one or more byte arrays.
  static Uint8List concat(final List<Uint8List> bytes) {
    final StringBuffer hex = StringBuffer();

    for (final Uint8List byte in bytes) {
      hex.write(bytesToHex(byte));
    }
    return HexUtils.hexToBytes(hex.toString());
  }

  /// convert int value (1-digit or two-digit number) to hex, shortHex, UInt8
  /// SINGLE Integer to Hex; convert int to Hex val, toHex Str, shortHex
  /// This is for a SINGLE DIGIT, twoChar, oneChar, singleChar, singleDigit
  /// See: https://www.binaryhexconverter.com/decimal-to-hex-converter
  static String singleNumToHexStr<T extends num>(
    final T number, {
    final bool padWithZero = true,
    final bool add0x = true,
  }) {
    try {
      // print('AA: RECEIVED $number from singleNumToHexStr');
      final int gVal = validate0to255(number);
      final String lHexStr =
          gVal.toRadixString(16).padLeft(2, kZeroStr).toUpperCase();
      assertTrue(
        lHexStr.isNotEmpty,
        'invalid hex length - singleNumToHexStr' //
        '--$number',
      );
      // print('2returning "$lHexStr" from singleNum');
      if (lHexStr.length == 2) {
        if (add0x) {
          return k0xLower + lHexStr;
        }
        return lHexStr;
      }
      // notice we're only padding TWO (2) here... PAD 2 pad 2
      final String pz = padWithZero ? lHexStr.padLeft(2, kZeroStr) : lHexStr;
      // print('3returning $pz singleNum');
      return (add0x) ? (k0xLower + pz) : pz;
    } catch (e, stacktrace) {
      final String st = stacktrace.convertToString();
      developer.log(
        'Could not get RGB-$number\n-$st',
        stackTrace: stacktrace,
        error: e,
      );

      throw Exception(st);
    }
  }

  /// aka IsShortHex
  static bool isThreeDigitHex(final int hexInt) {
    return (hexInt <= 0xFFF && hexInt.toRadixString(16).length <= 3);
  }

  /// RGB values are ranging in [0;1].  assumes ONLY six character (no alpha)
  /// @param tuple An array containing the color's RGB values.
  /// @return A string containing a `#RRGGBB` representation of given color.
  static String rgbToHexStr(final List<double> tuple) {
    String h = kPoundSign;
    for (int i = 0; i < 3; i += 1) {
      final double chan = tuple[i];
      final int c = (chan * 255).round();
      final int digit2 = c % 16;
      final int digit1 = ((c - digit2) ~/ 16);
      h += hexChars[digit1] + hexChars[digit2];
    }

    return h;
  }

  // -------------------------------------------------------------------------
  // ======================= PREMIERE METHOD ====================================
  // ======================= PREMIERE METHOD ====================================
  // makeValidHex, including REMOVAL of non-hex text, assertValidHexStr
  /// attempts to fix the hex string, removes pound sign and leading 0x because
  /// of base 16
  static String? validateHexStrOrNull(final String hexString) {
    // print('start string 1424 is $hexString');
    // first remove the non-hex strings (x (in 0x),poundSign, etc.)
    // ....ops occur AFTER the non-hex values
    // have been removed
    final String lHexStr = hexString.removeNonHexChars;
    if (lHexStr.isEmpty ||
        !validHexLengths.contains(lHexStr.length) ||
        !RegExUtils.kHexColor.hasMatch(lHexStr)) {
      developer.log(
        'invalid hex-validateHexStrOrNull: "$hexString" '
        '- $hexLengthErrorMessage$hexString',
      );
      return null;
    }
    return lHexStr;
  }

  static final String clName = (HexUtils).toString();

  /// hexInt list as string
  // AVOID using Iterable.forEach() with a function literal.
  // https://dart.dev/guides/language/effective-dart/usage#collections
  static String hexIntListAsStr(
    final List<int>? list, [
    final String delimiter = kComma,
  ]) {
    if (list == null || list.isEmpty) {
      developer.log('LIST IS EMPTY-hexIntListAsStr-${HexUtils.clName}');
      return getCurrentMethodName();
    }
    final StringBuffer sb = StringBuffer();
    for (final int element in list) {
      sb
        ..write(element.toHexStr)
        ..write(delimiter);
    }
    return sb.toString();
  }

  /// Determines whether or not an [input] string is a hex string.
  // static bool isHex(String hexInput) {
  //   final String input = hexInput.removeNonHexChars;
  //   if (input.isEmpty) {
  //     return false;
  //   }
  //   if (0 != (input.length % 2)) {
  //     return false;
  //   }
  //
  //   return tryGetBytes(input) != null && true;
  // }

  /// Determines whether the [input] string is a valid hex string.
  static bool isHexString(final String hexInput) {
    final String input = hexInput.removeNonHexChars;

    for (int i = 0; i < input.length; i++) {
      if (!HexUtils.hexCharsMap.keys.contains(input[i])) {
        return false;
      }
    }
    return true;
  }

  /// Converts a UTF-8 [input] string to hex string.
  static String utf8ToHex(final String hexInput) {
    if (hexInput.isBlank) {
      return hexInput;
    }
    final String input = hexInput.removeNonHexChars;
    final StringBuffer sb = StringBuffer();
    final String rawString = _rawStringToUtf8(input);
    for (int i = 0; i < rawString.length; i++) {
      sb.write(rawString.codeUnitAt(i).toRadixString(16));
    }
    return sb.toString();
  }

  /// Tries to convert a [hex] string to a UTF-8 string.
  /// When it fails to decode UTF-8, it returns the non UTF-8 string instead.
  static String tryHexToUtf8(final String hexInput) {
    final String input = hexInput.removeNonHexChars;
    final List<int> codeUnits = _getCodeUnits(input);
    try {
      return HexUtils.bytesToUtf8String(codeUnits as Uint8List);
    } on Exception catch (_) {
      return String.fromCharCodes(codeUnits);
    }
  }

  /// Converts a hex string to a binary string.
  static String hexToBinary(final String hexString) =>
      BigInt.parse(hexString.removeNonHexChars, radix: 16).toRadixString(2);

  /// Returns the reversed order of the given [input] hex string.
  ///
  /// Throws an error if [input] could not be processed.
  // static String reverseHexString(String input) {
  //   try {
  //     return getString(
  //       HexUtils.getBytes(input.removeNonHexChars).reversed.toList(),
  //     );
  //   } on Exception catch (e) {
  //     throw ArgumentError('Failed reversing the input. Error: $e');
  //   }
  // }

  // ------------------------------ private / protected functions ------------------------------ //

  /// Converts a hex string into byte array. Also tries to correct malformed hex string.
  // static List<int> _getBytesInternal(String hexString) {
  //   final String paddedHexString = 0 == hexString.length % 2
  //       ? hexString
  //       : '0$hexString';
  //   final List<int> encodedBytes = HexUtils.stringToBytesUtf8(paddedHexString);
  //   return hex.decode(String.fromCharCodes(encodedBytes));
  // }

  /// Converts raw string into a string of single byte characters using UTF-8 encoding.
  static String _rawStringToUtf8(final String input) {
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final int cu = input.codeUnitAt(i);

      if (128 > cu) {
        sb.write(String.fromCharCode(cu));
      } else if ((127 < cu) && (2048 > cu)) {
        sb.write(String.fromCharCode((cu >> 6) | 192));
        sb.write(String.fromCharCode((cu & 63) | 128));
      } else {
        sb.write(String.fromCharCode((cu >> 12) | 224));
        sb.write(String.fromCharCode(((cu >> 6) & 63) | 128));
        sb.write(String.fromCharCode((cu & 63) | 128));
      }
    }

    return sb.toString();
  }

  // from: https://github.com/proximax-storage/dart-xpx-chain-sdk/blob/master/lib/src/utils/hex_utils.dart

  /// Get a list of code unit of a hex string.
  static List<int> _getCodeUnits(final String hex) {
    final List<int> codeUnits = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      codeUnits.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }

    return codeUnits;
  }

  /// Converts [hex] string to a byte array.
  /// Throws an exception upon failing.
  // static List<int> getBytes(String hex) {
  //   try {
  //     return HexUtils._getBytesInternal(hex.removeNonHexChars);
  //   } on Exception catch (e) {
  //     throw ArgumentError(
  //       'Could not convert hex string into a byte array. Error: $e',
  //     );
  //   }
  // }

  /// Tries to convert [hex] string to a byte array.
  ///
  /// The output will be null if the input is malformed.
  // static List<int>? tryGetBytes(String hex) {
  //   try {
  //     return _getBytesInternal(hex.removeNonHexChars);
  //   } on Exception catch (_) {
  //     return null;
  //   }
  // }

  /// Converts byte array to a hex string.
  ///
  /// Used for converting UTF-8 encoded data from and to bytes.
  // static String getString(List<int> bytes) {
  //   final String encodedString = hex.encode(bytes);
  //   return HexUtils.bytesToUtf8String(encodedString.codeUnits as Uint8List);
  // }

  /// Uses bitwise AND operator with the mask 0xffffffff
  /// (or 4294967295 in decimal). This operation effectively extracts
  /// the lower 32 bits of the integer, discarding any higher bits and
  /// ensuring the result is within the range of a 32-bit unsigned
  /// integer (0 to 232 - 1).
  static int toUInt32Int(final int hexInt) => (hexInt & 0xffffffff);

  /// Same as above [toUInt32Int], tested with DartPad
  static int toUnsigned32(final int hexInt) =>
      BigInt.from(hexInt).toUnsigned(32).toInt();

  /// This method converts an integer to its 32-bit unsigned representation.
  /// Same as above [toUInt32Int], tested on DartPad
  static int toUInt32(final int hexInt) => hexInt.toUnsigned(32);

  static String resizeToHex8String(final String hex) {
    // Remove '#' if present
    String hexColor = hex.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 3) {
      final String hr = hexColor.substring(0, 1);
      final String hg = hexColor.substring(1, 2);
      final String hb = hexColor.substring(2, 3);
      hexColor = 'FF$hr$hr$hg$hg$hb$hb';
    }
    if (hexColor.length == 4) {
      // ALERT RGBA here (alpha is at end)
      // return '${hexColor}F'; // rgba, not argb // need to parse out each character and duplicate character
      final String hr = hexColor.substring(0, 1);
      final String hg = hexColor.substring(1, 2);
      final String hb = hexColor.substring(2, 3);
      final String ha = hexColor.substring(3, 4);
      hexColor = '$ha$ha$hr$hr$hg$hg$hb$hb';
    }
    // 12 bit to 24bit
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    if (hexColor.length == 8) {
      return hexColor;
    }

    throw Exception(
      'Invalid hex code: $hex, must be length of 3, 6, or 8, excluding pound sign',
    );
  }

  /// Make Hex  String shortHex to hex8, hex3 to hex8; 12bit to 32bit, etc.
  /// 24bit to 12Bit
  static String resizeHexString(
    final String inputHexStr, {
    final int targetLength = 8,
    final String alphaChannel = kDefaultAlphaChannel,
  }) {
    try {
      String hexStr = HexUtils.assertValidHex(inputHexStr);
      if (hexStr.length == targetLength) {
        return hexStr;
      }
      // lower case
      hexStr =
          (hexStr.startsWith(k0xLower) ? hexStr.keepAfter(k0xLower) : hexStr);
      // upper case
      hexStr =
          (hexStr.startsWith(k0xUpper) ? hexStr.keepAfter(k0xUpper) : hexStr);
      // Target Length of three---------------------------------
      if (hexStr.length == 3) {
        if (targetLength == 3) {
          return hexStr;
        } else if (targetLength == 4) {
          return '${hexStr}F'; // rgba, not argb
          // 12 bit to 24bit
        } else if (targetLength == 6) {
          return hexStr[0].repeat(2) +
              hexStr[1].repeat(2) +
              hexStr[2].repeat(2);
          // 12bit to 32bit
        } else if (targetLength == 8) {
          return alphaChannel +
              hexStr[0].repeat(2) +
              hexStr[1].repeat(2) +
              hexStr[2].repeat(2);
        }
        throw Exception('${hexLengthErrorMessage}Resize Hex String 1429');
      } else if (hexStr.length == 4) {
        if (targetLength == 3) {
          return hexStr.substring(0, 3);
        } else if (targetLength == 4) {
          return hexStr; // rgba not argb
        } else if (targetLength == 6) {
          return hexStr.substring(0, 3).repeat(2); // strips off alpha from rgba
        } else if (targetLength == 8) {
          return hexStr.repeat(2);
        }
        throw Exception('${hexLengthErrorMessage}ResizeHexString1444');
      } else if (hexStr.length == 6) {
        // 24bit to 12bit
        if (targetLength == 3) {
          return hexStr[0] + hexStr[2] + hexStr[4]; // best guess here
          // return hexStr.substring(0, 3);
        } else if (targetLength == 4) {
          return '${hexStr.substring(0, 3)}F'; // rgba
        } else if (targetLength == 6) {
          return hexStr;
        } else if (targetLength == 8) {
          return alphaChannel + hexStr;
        }
        throw Exception(
            'Resize Hex String 1485-$targetLength-$hexLengthErrorMessage');
      } else if (hexStr.length == 8) {
        if (targetLength == 3) {
          // return hexStr.substring(2, 5);  // best guess here
          return hexStr[2] + hexStr[4] + hexStr[6]; // best guess here
        } else if (targetLength == 4) {
          // return hexStr.substring(2, 5) + 'F'; // rgba
          return hexStr[0] +
              hexStr[2] +
              hexStr[4] +
              hexStr[6]; // best guess here
        } else if (targetLength == 6) {
          return hexStr.substring(2);
        } else if (targetLength == 8) {
          return hexStr;
        }
        throw Exception(
          'Resize Hex String 1485-$targetLength-$hexLengthErrorMessage',
        );
      }
      throw Exception(
        'Resize Hex String 1485-$targetLength-$hexLengthErrorMessage',
      );
    } catch (e, stacktrace) {
      final String st = '${stacktrace.convertToString()}\n-' //
          '${e.toString()}\n';
      developer.log('resizeHexString $st \n', stackTrace: stacktrace, error: e);
      stderr.write(st);

      throw Exception(st);
    }
  }

  // The red channel of this color in an 8 bit value.
  static int hexIntToRedInt<T extends num>(final T hexVal) =>
      (0x00ff0000 & hexVal.toInt()) >> 16;

  // ints to str
  static String hexIntToRedStr<T extends num>(final T hexVal) =>
      HexUtils.singleNumToHexStr(hexIntToRedInt(hexVal));

  static int hexIntToGreenInt<T extends num>(final T hexVal) =>
      (0x0000ff00 & hexVal.toInt()) >> 8;

  static String hexIntToGreenStr<T extends num>(final T hexVal) =>
      HexUtils.singleNumToHexStr(HexUtils.hexIntToGreenInt(hexVal));

  static int hexIntToBlueInt<T extends num>(final T hexVal) =>
      (0x000000ff & hexVal.toInt()) >> 0;

  static String hexIntToBlueStr<T extends num>(final T hexVal) =>
      HexUtils.singleNumToHexStr(HexUtils.hexIntToBlueInt(hexVal));

  // color_instances to str, shortHex
  static String colorToHexRedStr(final ColorIQ color) =>
      HexUtils.singleNumToHexStr(color.red);

  static String colorToHexGreenStr(final ColorIQ color) =>
      HexUtils.singleNumToHexStr(color.green);

  static String colorToHexBlueStr(final ColorIQ color) =>
      HexUtils.singleNumToHexStr(color.blue);

  // Use bit shifting together with logical AND to mask out all but last
  // 8 bits, essentially the 'blue' part AS a HEX value, chops off all but blue
  // Used for GRAY calculations, not webSafe
  static int singleChannelHexFromHexInt(final int inVal) {
    final int lByte1Blue = inVal & 0xFF;
    // final _byte2Green = (inVal >> 8) & 0xff;
    return lByte1Blue;
  }

  /// Usage: grayColorInt(0x7E), SINGLEDigitGray, grayHexInt for SHORT INT
  /// aka shortByte to full hex, Converts as SINGLE 8Bit int (e.g. 0xFA) to
  /// a full hex val: 0xfa => 0xFFfafafa (repeats red), used for GRAYs, not
  /// webSafe. REPEATS the input value
  static int shortHex8BitToFullHexInt(final int hexInt) {
    try {
      // leave as var and not as int due to casting problems!
      final int lHexVal = (((0xFF & 0xff) << 24) |
              ((hexInt & 0xff) << 16) |
              ((hexInt & 0xff) << 8) |
              ((hexInt & 0xff) << 0)) &
          0xFFFFFFFF;
      return lHexVal;
    } catch (e, stacktrace) {
      throw Exception(
        'error at 692 -- hexStrToHexInt $hexInt ${stacktrace.toString()}',
      );
    }
  }

  /// HexInt to ShortHexInt (3 numbers)....WORKS, tested on DartPad
  static int hexIntToShortHexInt(final int hexInt) {
    try {
      final int lRed = (hexInt >> 16) & 0xF;
      final int lGreen = (hexInt >> 8) & 0xF;
      final int lBlue = hexInt & 0xF;
      final int hexVal =
          (((0xF & 0xf) << 12) | (lRed << 8) | (lGreen << 4) | (lBlue << 0)) &
              0xFFF;
      return hexVal;
    } catch (e, stacktrace) {
      throw Exception(
        'error at 692 -- hexStrToHexInt $hexInt ${stacktrace.toString()}',
      );
    }
  }

  /// A value of 0 means this color is fully transparent. A value of 255 means
  /// this color is fully opaque.
  // static int alphaIntFromHex8Int(int hexInt) => (0xff000000 & hexInt) >> 24;

  /// check if the string is a hexadecimal color, groups of 2, 3, 6 or 8
  /// NOTE THAT a pound sign IS acceptable here
  /// hasMatch('#3b5');     // true
  /// hasMatch('#FF7723');  // true
  /// hasMatch('#000000z'); // HAS BEEN TESTED on DartPad
  static bool isValidHexStr(final String hexStr) {
    if (hexStr.isEmpty) {
      return false;
    }
    return HexUtils.validateHexStrOrNull(hexStr) == null ? false : true;
    // return (hexStr.length < 2 || hexStr.length > 9)
    //     ? false
    //     : RegExSK.kHexColor.hasMatch(hexStr);
  }

  // for NON-hex numbers,
  /// See also [findClosestHexSingle]
  /// validates a hexString,  for NON-hex numbers, aka validateHex
  static String assertValidHex(final String hexStr, {final String? msg}) =>
      HexUtils.isValidHexStr(hexStr)
          ? hexStr
          : throw Exception(
              'Invalid HexStr "$hexStr"-- '
              'msg->> ${msg ?? HexUtils.hexLengthErrorMessage}',
            );

  /// assert two chars, two-digit, single number shortHex
  static String assertValidShortHexStr(final String hexStr) =>
      (hexStr.isEmpty || RegExUtils.kHexTwoChars255.hasMatch(hexStr) == false)
          ? throw Exception(
              'INVALID HEX STRING $hexStr',
            )
          : hexStr;

  // function which converts decimal (base10) value to hexadecimal value
  // essentially builds an hexadecimal string
  // https://math.tools/calculator/base/10-16
  // https://jarednielsen.com/convert-decimal-hexadecimal/
  // https://www.rapidtables.com/convert/number/decimal-to-hex.html?x=30
  // WORKS...TESTED ON DART PAD
  /// See also See also [findClosestHexSingle]
  static String decimalToHexadecimalStr(final int initialVal) {
    String hexadecimal = kEmptyStr;
    int lVal = initialVal;
    while (lVal > 0) {
      final int remainder = lVal % 16; // 2048 % 16 = 15 (15 is the remainder)
      // add the remainder to the hexString
      hexadecimal = numToHexConversionTable[remainder]! + hexadecimal;
      lVal = (lVal / 16).floor(); // 2048 / 16 = 127
      // 127 % 16 = 15
      // Our remainder is again 15, so we add F to our hexadecimal string,
      // FF at this point
      // We then divide 127 / 16. Our quotient is 7, so we calculate the remainder
      // and and divide 7 by 16:
      // decimal = decimal;  python floor division operator is // double slash
    }
    return hexadecimal;
  }

  static int decimalToHexNumber(final int val) {
    final String hexadecimal = HexUtils.decimalToHexadecimalStr(val);
    return ArgumentError.checkNotNull(
      int.tryParse(hexadecimal, radix: 16),
      'Could not parse hexString to Base16--$val',
    );
  }

  /// Decimal to Hex, see also [hexIntToDecimal]
  static int decimalToHex(final int d) {
    final String myVal = d.toRadixString(16);

    return int.parse(myVal, radix: 16);
  }

  /// More manual, granular approach here.  Tested on Scratch pad
  static int decimalToHex2(final int decimal) {
    final List<String> hexChars = List<String>.empty(growable: true);
    int currentVal = decimal;
    int quotient = kDefaultInt;
    int remainder = kDefaultInt;
    while (quotient != 0) {
      quotient = currentVal ~/ 16;
      // the remainder for the hex digit
      remainder = currentVal % 16;
      final String hexChar = HexUtils.numToHexConversionTable[remainder]!;
      hexChars.insert(0, hexChar);
      currentVal = quotient;
    }
    final String str = hexChars.join();
    final int myRslt = int.tryParse(str, radix: 16) ??
        (throw Exception('Could not parse $str'));
    return myRslt;
  }

  /// HexIntToBase10
  static int hexIntToDecimal(final int hexInt) {
    final int bitLen = hexInt.bitLength;
    if (bitLen < 8) {
      throw Exception('8--Bit length was not >= 8 but was $bitLen');
    }

    int val2 = 0;
    final int byte1 = (hexInt >> 0) & 15;
    final int byte2 = (hexInt >> 4) & 15;
    final int byte3 = bitLen >= 8 ? ((hexInt >> 8) & 15) : 0;
    final int byte4 = bitLen >= 12 ? ((hexInt >> 12) & 15) : 0;
    final int byte5 = bitLen >= 16 ? ((hexInt >> 16) & 15) : 0;
    final int byte6 = bitLen >= 20 ? ((hexInt >> 20) & 15) : 0;
    final int byte7 = bitLen >= 24 ? ((hexInt >> 24) & 15) : 0;
    final int byte8 = bitLen >= 28 ? ((hexInt >> 28) & 15) : 0;
    final int rs1 = (byte1 * 1);
    val2 += rs1; // 16 to the power of 0 is always 1
    // debugPrint('RS1 = $rs1 - $val2');
    final int rs2 = (byte2 * 16);
    val2 += rs2; // 16 to the power of 1
    // debugPrint('RS2 = $rs2 - $val2');
    final int rs3 = byte3 != 0 ? (byte3 * (math.pow(16, 2))).toInt() : 0;
    val2 += rs3; // 16 to the power of 2
    // debugPrint('RS3 = $rs3 - $val2');
    final int rs4 = byte4 != 0 ? (byte4 * (math.pow(16, 3))).toInt() : 0;
    val2 += rs4; // 16 to the power of 3
    // debugPrint('RS4 = $rs4 - $val2');
    final int rs5 = byte5 != 0 ? (byte5 * (math.pow(16, 4))).toInt() : 0;
    val2 += rs5; // 16 to the power of 4
    // debugPrint('RS5 = $rs5 - $val2');
    final int rs6 = byte6 != 0 ? (byte6 * (math.pow(16, 5))).toInt() : 0;
    val2 += rs6; // 16 to the power of 5
    // debugPrint('RS6 = $rs6 - $val2');
    final int rs7 = byte7 != 0 ? (byte7 * (math.pow(16, 6))).toInt() : 0;
    val2 += rs7; // 16 to the power of 6
    // debugPrint('RS7 = $rs7 - $val2');
    final int rs8 = byte8 != 0 ? (byte8 * (math.pow(16, 7))).toInt() : 0;
    val2 += rs8; // 16 to the power of 7
    // debugPrint('RS8 = $rs8 - $val2');

    // debugPrint(
    //   'VAL2: extracting bits-$val2---Byte1: $byte1, ' //
    //   'Byte2 = $byte2, Byte3 = $byte3, '
    //   'Byte 4 = $byte4, Byte 5 = $byte5, byte 6 = $byte6',
    // );
    return val2;
  }

  // Explanation:
  // number >> i: Right-shifts the number by i positions. This moves the
  // bit at position i to the rightmost (least significant) position.
  // & 1: Performs a bitwise AND with 1. This isolates the rightmost bit (which is the bit we shifted to that position).
  // The loop iterates through each bit position (0 to 31 for a 32-bit integer), extracting each bit and storing it in the bits array.
  static List<int> extractBits(final int hexInt) {
    final List<int> bits = List<int>.empty(growable: true);
    for (int i = 0; i < 32; i++) {
      // // Assuming 32-bit integers
      bits.add((hexInt >> i) & 1);
    }
    return bits;
  }
} // ------------------ end of class ---------------------------------

class HexColorParseException extends ArgumentError {
  HexColorParseException(String super.msg);
}

// THIS works...tested, aka HexInt to Decimal 0xFF to 255
// This is a rare find, as all other suggestions have you convert the
// number to a string and THEN parse it with parseInt.  This use bit ops.
int hexIntToBase10(final int hexIntTwoDigits) => (0xff & hexIntTwoDigits) >> 0;

/// Convert 12-bit to full hexInt, three bytes (3 bytes) to 32-bit
/// e.g. 0xAFC =>> FFaaffcc;
/// tested on DART-PAD, three-digit hex to fullHex
/// note that each part is 0xF, NOT 0xFF, i.e. 4bit not 8 bit
int shortHex12BitToFullHexInt(final int hexInt) {
  try {
    // note that this is 0xF, NOT 0xFF, 4bit not 8 bit
    final int lRed = (hexInt >> 8) & 0xF;
    final int lGreen = (hexInt >> 4) & 0xF;
    final int lBlue = hexInt & 0xF;
    final int lHexVal = (((0xFF & 0xff) << 24) |
            (lRed << 20) |
            (lRed << 16) |
            (lGreen << 12) |
            (lGreen << 8) |
            (lBlue << 4) |
            (lBlue << 0)) &
        0xFFFFFFFF;
    return lHexVal;
  } catch (e, stacktrace) {
    throw Exception(
      'error -- shortHex12BitToFullHexInt ${hexInt.toHexStr} $stacktrace',
    );
  }
}

// ----------------------- Premiere Method ----------------------------
// ----------------------- Premiere Method ----------------------------
// ----------------------- Premiere Method ----------------------------

/// Returns RGB as percentages
// List<num> hexIntToRGBPercentsList(var dynVal) =>
//     dynamicToRGBList(dynVal).toFactoredListDoubles;

// Hex Conversion Table: https://www.ibm.com/support/knowledgecenter/en/ssw_aix_72/network/conversion_table.html
// So, the number 255 is the decimal equivalent of hexadecimal number FF (Answer).
// https://www.engineeringtoolbox.com/binary-octal-hexadecimal-numbers-d_1802.html
// http://online.sfsu.edu/chrism/hexval.html
// Dec Hex Oct Bin
// 16	10	20	10000
// 17	11	21	10001
// 18	12	22	10010
// 19	13	23	10011
// 221  DD  335   11011101
// 238  EE  356   11101110
// 255  FF  377   11111111

// SEE https://www.engineeringtoolbox.com/binary-octal-hexadecimal-numbers-d_1802.html
// https://www.engineeringtoolbox.com/binary-octal-hexadecimal-numbers-d_1802.html
// http://online.sfsu.edu/chrism/hexval.html
// HexConversion, hex conversion, hex symbol
// DEC HX
// 000 00
// 001 01
// 002 02
// 003 03
// 004 04
// 005 05
// 006 06
// 007 07
// 008 08
// 009 09
// 010 0A
// 011 0B
// 012 0C
// 013 0D
// 014 0E
// 015 0F
// DEC HX -----------------------------
// 016 10
// 017 11
// 018 12
// 019 13
// 020 14
// 021 15
// 022 16
// 023 17
// 024 18
// 025 19
// 026 1A
// 027 1B
// 028 1C
// 029 1D
// 030 1E
// 031 1F
// DEC HX -----------------------------
// 032 20
// 033 21
// 034 22
// 035 23
// 036 24
// 037 25
// 038 26
// 039 27
// 040 28
// 041 29
// 042 2A
// 043 2B
// 044 2C
// 045 2D
// 046 2E
// 047 2F
// DEC HX -----------------------------
// 048 30
// 049 31
// 050 32
// 051 33
// 052 34
// 053 35
// 054 36
// 055 37
// 056 38
// 057 39
// 058 3A
// 059 3B
// 060 3C
// 061 3D
// 062 3E
// 063 3F
// DEC HX -----------------------------
// 064 40
// 065 41
// 066 42
// 067 43
// 068 44
// 069 45
// 070 46
// 071 47
// 072 48
// 073 49
// 074 4A
// 075 4B
// 076 4C
// 077 4D
// 078 4E
// 079 4F
// DEC HX -----------------------------
// 080 50
// 081 51
// 082 52
// 083 53
// 084 54
// 085 55
// 086 56
// 087 57
// 088 58
// 089 59
// 090 5A
// 091 5B
// 092 5C
// 093 5D
// 094 5E
// 095 5F
// DEC HX -----------------------------
// 096 60
// 097 61
// 098 62
// 099 63
// 100 64
// 101 65
// 102 66
// 103 67
// 104 68
// 105 69
// 106 6A
// 107 6B
// 108 6C
// 109 6D
// 110 6E
// 111 6F
// DEC HX -----------------------------
// 112 70
// 113 71
// 114 72
// 115 73
// 116 74
// 117 75
// 118 76
// 119 77
// 120 78
// 121 79
// 122 7A
// 123 7B
// 124 7C
// 125 7D
// 126 7E
// 127 7F
// DEC HX ---------------------
// 128 80
// 129 81
// 130 82
// 131 83
// 132 84
// 133 85
// 134 86
// 135 87
// 136 88
// 137 89
// 138 8A
// 139 8B
// 140 8C
// 141 8D
// 142 8E
// 143 8F
// DEC HX ----------------------------------
// 144 90
// 145 91
// 146 92
// 147 93
// 148 94
// 149 95
// 150 96
// 151 97
// 152 98
// 153 99
// 154 9A
// 155 9B
// 156 9C
// 157 9D
// 158 9E
// 159 9F
// DEC HX ---------------------------------
// 160 A0
// 161 A1
// 162 A2
// 163 A3
// 164 A4
// 165 A5
// 166 A6
// 167 A7
// 168 A8
// 169 A9
// 170 AA
// 171 AB
// 172 AC
// 173 AD
// 174 AE
// 175 AF
// DEC HX -------------------------------
// 176 B0
// 177 B1
// 178 B2
// 179 B3
// 180 B4
// 181 B5
// 182 B6
// 183 B7
// 184 B8
// 185 B9
// 186 BA
// 187 BB
// 188 BC
// 189 BD
// 190 BE
// 191 BF
// DEC HX
// 192 C0
// 193 C1
// 194 C2
// 195 C3
// 196 C4
// 197 C5
// 198 C6
// 199 C7
// 200 C8
// 201 C9
// 202 CA
// 203 CB
// 204 CC
// 205 CD
// 206 CE
// 207 CF
// DEC HX-----------------------
// 208 D0
// 209 D1
// 210 D2
// 211 D3
// 212 D4
// 213 D5
// 214 D6
// 215 D7
// 216 D8
// 217 D9
// 218 DA
// 219 DB
// 220 DC
// 221 DD
// 222 DE
// 223 DF
// DEC HX ---------------------------
// 224 E0
// 225 E1
// 226 E2
// 227 E3
// 228 E4
// 229 E5
// 230 E6
// 231 E7
// 232 E8
// 233 E9
// 234 EA
// 235 EB
// 236 EC
// 237 ED
// 238 EE
// 239 EF
// DEC HX --------------------------------
// 240 F0
// 241 F1
// 242 F2
// 243 F3
// 244 F4
// 245 F5
// 246 F6
// 247 F7
// 248 F8
// 249 F9
// 250 FA
// 251 FB
// 252 FC
// 253 FD
// 254 FE
// 255 FF

// Hexadecimal Number System

// Given : 15C in base 16
// Conversion to base 10: 12×16{0} + 5×16{1} + 1×16{2}=348 in base 10
// {2} = [power of]
// Anything past the decimal are negative powers. –

// Following are the characteristics of a hexadecimal number system.
//
// Uses 10 digits and 6 letters, 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F.
//
// Letters represents numbers starting from 10. A = 10, B = 11, C = 12, D = 13, E = 14, F = 15.
//
// Also called base 16 number system.
//
// Each position in a hexadecimal number represents a 0 power of the
// base (16). Example − 160
//
// Last position in a hexadecimal number represents an x power of the base (16).
// Example − 16x where x represents the last position - 1.

// 255 (0xFF) --  POWER OF 16
// Step 1: Write down the hexadecimal number:
//
// (FF)16
//
// Step 2: Show each digit place as an increasing power of 16:
//
// Fx16 1 + Fx16 0
//
// Step 3: Convert each hexadecimal digits values to decimal values then perform the math:
//
// 15x16 + 15x1 = (255)10
//
// So, the number 255 is the decimal equivalent of hexadecimal number FF (Answer).
// https://www.engineeringtoolbox.com/binary-octal-hexadecimal-numbers-d_1802.html
// http://online.sfsu.edu/chrism/hexval.html
// Dec Hex Oct Bin
// 16	10	20	10000
// 17	11	21	10001
// 18	12	22	10010
// 19	13	23	10011
// 221  DD  335   11011101
// 238  EE  356   11101110
// 255  FF  377   11111111

// SEE https://www.engineeringtoolbox.com/binary-octal-hexadecimal-numbers-d_1802.html

// Binary  Hex.
// 0	0000	0
// 1	0001	1
// 2	0010	2
// 3	0011	3
// 4	0100	4
// 5	0101	5
// 6	0110	6
// 7	0111	7
// 8	1000	8
// 9	1001	9
// 10	1010	A
// 11	1011	B
// 12	1100	C
// 13	1101	D
// 14	1110	E
// 15	1111	F

// You would use a combination of the << shift operator and the bitwise | operator. If you are trying to build an 8-bit value from two 4-bit inputs, then:
//
// int a = 8;
// int b = 6;
//
// int result = (b << 4) | a;
// If you are trying to build a 32-bit value from two 16-bit inputs, then you would write
//
// result = (b << 16) | a;

// 0xFF & (rgba >> 8)

// int toUTF16(int shortHex, int highByte) {
//   final int bitLength = shortHex.bitLength;
//   /// should be 8 bits here or
//   print('BL: $bitLength');
//
// //   0xffff << 16
// //     int c = (shortHex & 0xFF);
//   int c = ((highByte & 0xFF) << 8) | (shortHex & 0xFF);
// //   int c = (0xFF & (val2 >> 8)) | (shortHex & 0xFF);
//   print('$c 0x${c.toRadixString(16).padLeft(4, '0').toUpperCase()}');
//   final int bitLength2 = c.bitLength;
//   /// should be 8 bits here or
//   print('BL2: $bitLength2');
//   return c;
// }
// For purely historical reasons, computers store bits in groups of 8. Each group of 8 bits is called a byte.
