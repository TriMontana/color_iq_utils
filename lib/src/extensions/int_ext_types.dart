import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/foundation/constants.dart';

// Extension type for 8-bit unsigned int that can invoke all members of 'int',
extension type UI8._(int value) implements int {
  /// Constant constructor.
  const UI8(final int val, {final String? msg})
      : assert(
          val >= 0 && val <= 255,
          '$errorMsg0to255-"$val"--${msg ?? //
              'Error: 0 to 255'}',
        ),
        value = val;

  UI8 addWithClam(final UI8 other) => UI8((value + other.value).clamp0to255);

  bool get isEven => true;
  // Method:
  bool isValid() => !isNegative;

  // Wraps the 'int' type's '<' operator:
  bool operator <(final UI8 other) => value < other.value;
  bool operator >(final UI8 other) => value > other.value;

  static const UI8 zero = UI8(0);
  static const UI8 one = UI8(1);
  static const UI8 min = UI8(0);
  static const UI8 max = UI8(255);
  static const UI8 v38 = UI8(38);
  static const UI8 v43 = UI8(43);
  static const UI8 v127 = UI8(127);
  static const UI8 v212 = UI8(212);
  static const UI8 v225 = UI8(225);
  static const UI8 v226 = UI8(226);
  static const UI8 v227 = UI8(227);
  static const UI8 v228 = UI8(228);
  static const UI8 v229 = UI8(229);
  static const UI8 v230 = UI8(230);
  static const UI8 v231 = UI8(231);
  static const UI8 v232 = UI8(232);
  static const UI8 v233 = UI8(233);
  static const UI8 v234 = UI8(234);
  static const UI8 v235 = UI8(235);
  static const UI8 v236 = UI8(236);
  static const UI8 v237 = UI8(237);
}

// This provides the user-friendly interface for the 32-bit integer.
extension type const ColorId(int value) {
  int get alpha => (value >> 24) & 0xFF;
  int get red => (value >> 16) & 0xFF;
  int get green => (value >> 8) & 0xFF;
  int get blue => (value & 0xFF);
}
