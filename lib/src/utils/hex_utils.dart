import 'package:color_iq_utils/color_iq_utils.dart';

ColorIQ parseHex(String hex) {
  hex = hex.substring(1);
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
