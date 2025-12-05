import 'package:color_iq_utils/src/foundation/constants.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// Error thrown when a value is outside the range of 0 to 1.0 (inclusive).
///
/// Typically used for validating double-precision floating point values,
/// such as opacity or percentage values.
///
/// - [value]: The offending value that triggered the error.
/// - [source]: Optional source or context where the error occurred (e.g., method name, variable).
/// - [msg]: Optional custom error message for additional context.
///
/// The error message includes the value, a standard description for the 0-1.0 range error,
/// and any provided source or custom message.
final class Error0to1 extends AssertionError {
  /// The source or context where the error occurred (optional).
  final String? source;

  /// An optional custom error message for additional context.
  final String? msg;

  /// Constructs an [Error0to1] with the given [value], [source], and [msg].
  Error0to1(final Object value, {this.source, this.msg})
      : super(
          '${value.toString()}'
          ' -- $errorMsgFloat0to1'
          '${source != null ? ' -- $source' : ''}'
          '${msg != null ? ' -- $msg' : ''}',
        );
}

/// Asserts that [value] is within the inclusive range [lowest] to [highest].
///
/// Throws a [RangeError] if [value] is not in range, or if the range is invalid,
/// or if any value is NaN or infinite.
///
/// Returns [value] if valid.
T assertInRange<T extends num>(
  final T value, {
  required final T lowest,
  required final T highest,
  final Object? source,
  final String? msg,
}) {
  // Validate range bounds
  if (lowest.isNaN || highest.isNaN || value.isNaN) {
    throw RangeError('Values must not be NaN');
  }
  if (!lowest.isFinite || !highest.isFinite || !value.isFinite) {
    throw RangeError('Values must be finite (not infinite)');
  }
  if (lowest > highest) {
    throw RangeError('Invalid range: lowest ($lowest) > highest ($highest)');
  }

  // Check value in range
  if (value < lowest || value > highest) {
    throw RangeError(
      '${msg ?? 'RangeError-$lowest-$highest-$value'} - Not in range [$lowest, $highest]: $value'
      '${source != null ? ' (Source: $source)' : getCurrentMethodName()}',
    );
  }
  return value;
}

/// Assert TRUE KEEP as GLOBAL and static methods
bool assertTrue(
  final bool val,
  final String msg, {
  final int? hexRef,
  final bool goToExit = false,
  final String? method,
}) {
  if (val == true) {
    return val;
  }
  final StackTrace st = StackTrace.current;
  final String erMsg = '\n${st.toString()}';
  throw Exception('$msg ${hexRef?.toHexStr ?? kEmptyStr} - $erMsg');
}

/// Assert Not Blank, global.  ALSO cleanses and returns the string
/// If you do not WANT to use cleansed part, just avoid using return value.
/// aka assertHasData
String assertNotBlank(
  final String? val, {
  final String? msg,
}) {
  if (val == null || val.isEmpty) {
    throw AssertionError(
      'Value was NULL-assertNotBlank-${msg ?? getCurrentMethodName()}',
    );
  }

  return val;
}

String getCurrentMethodName() {
  final List<String> frames = StackTrace.current.toString().split('\n');
  // The second frame usually represents the calling method
  final String? frame = frames.elementAtOrNull(1);

  if (frame != null) {
    // Extract the method name from the frame string
    // This part requires careful string manipulation based on the stack trace format.
    // A common pattern is to find the method name before the parentheses or other delimiters.
    final RegExp regex = RegExp(r'([A-Za-z0-9_.]+)');
    final RegExpMatch? match = regex.firstMatch(
      frame.substring(frame.indexOf(' ')),
    );
    if (match != null) {
      return match.group(0) ?? 'Unknown';
    }
  }
  return 'Unknown';
}

/// Validates whether a number is in the range of 0 to 255, i.e. is an
/// 8-bit unsigned int, see also [ensureUInt8bit]
int validate0to255(
  final num aVal, {
  final bool withClamp = false,
  final Object? source,
  final String? msg,
}) {
  if (aVal.isInfinite || aVal.isNaN) {
    throw Error0to255(aVal, source: source);
  }
  if (aVal is int && is8BitUnsigned(aVal)) {
    // print('returning from is8BitUnsigned');
    return aVal;
  }
  if (aVal is double && (aVal >= 0.0 && aVal <= 1.0)) {
    return ((aVal * 255.0).round() & 0xff);
  }
  final int aNum = aVal.toInt();
  if (aNum >= 0 && aNum <= 255) {
    return aNum;
  }
  return (!withClamp)
      ? (throw Error0to255(aNum, source: source))
      : (aVal.clamp(0.0, 255.0).round() & 0xff); // use original num here
}

extension StackTraceHelper on StackTrace {
  String convertToString({int? methodLineCount}) {
    methodLineCount ??= 3;
    final List<String> lines = toString().split(kNL);
    final List<String> formatted = <String>[];
    int count = 0;
    for (final String line in lines) {
      // if (discardDeviceStacktraceLine(line) || discardWebStacktraceLine(line)) {
      //   continue;
      // }
      formatted.add(
        '#$count   $line',
      );
      if (++count == methodLineCount) {
        break;
      }
    }
    return formatted.join(kNL) + kNL + getCurrentMethodName();
  }
}

// (one or more)
// + Plus Sign one or more occurrences (equals {1,})
final RegExp regExStackTraceLineTrim = RegExp(r'#\d+\s+');

/// Error thrown when a value is outside the range of 0 to 255 (inclusive).
///
/// This is typically used for validating unsigned 8-bit integer values,
/// such as color channels or byte values.
///
/// - [value]: The offending value that triggered the error.
/// - [source]: Optional source or context where the error occurred (e.g., method name, variable).
/// - [errMessage]: Optional custom error message for additional context.
///
/// The error message includes the value, optional custom message, source, and a standard
/// description for the 0-255 range error.
final class Error0to255 extends AssertionError {
  /// The source or context where the error occurred (optional).
  final Object? source;

  /// An optional custom error message for additional context.
  final String? errMessage;

  /// Constructs an [Error0to255] with the given [value], [source], and [errMessage].
  Error0to255(final Object value, {this.source, this.errMessage})
      : super(
          '${value.toString()}'
          '${errMessage != null ? ' -- $errMessage' : ''}'
          ' -- ${source?.toString() ?? 'No Source'} // '
          '$errorMsg0to255',
        );
}
