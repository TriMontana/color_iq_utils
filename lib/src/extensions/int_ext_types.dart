import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/foundation/constants.dart';

// Extension type for 8-bit unsigned int that can invoke all members of 'int',
extension type Uint8IQ._(int value) implements int {
  /// Constant constructor.
  const Uint8IQ(final int val, {final String? msg})
      : assert(
          val >= 0 && val <= 255,
          '$errorMsg0to255-"$val"--${msg ?? //
              'Error: 0 to 255'}',
        ),
        value = val;

  Uint8IQ addWithClam(final Uint8IQ other) =>
      Uint8IQ((value + other.value).clamp0to255);

  bool get isEven => true;
  // Method:
  bool isValid() => !isNegative;

  // Wraps the 'int' type's '<' operator:
  bool operator <(final Uint8IQ other) => value < other.value;
  bool operator >(final Uint8IQ other) => value > other.value;

  static const Uint8IQ zero = Uint8IQ(0);
  static const Uint8IQ one = Uint8IQ(1);
  static const Uint8IQ min = Uint8IQ(0);
  static const Uint8IQ max = Uint8IQ(255);
}

// This provides the user-friendly interface for the 32-bit integer.
extension type const ColorId(int value) {
  int get alpha => (value >> 24) & 0xFF;
  int get red => (value >> 16) & 0xFF;
  int get green => (value >> 8) & 0xFF;
  int get blue => (value & 0xFF);
}
