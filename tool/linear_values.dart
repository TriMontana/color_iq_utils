import 'package:color_iq_utils/src/extensions/float_ext_type.dart';
import 'package:color_iq_utils/src/utils/hex_utils.dart';

void main(final List<String> args) {
  print('enum Iq255 {');
  // v0(UI8(0), Percent.v0, Percent.v0),
  for (int x = 0; x < 256; x++) {
    final String valX = HexUtils.singleNumToHexStr(x);

     print('v$x(UI8($valX),  norm: ${Percent.fromIntAsString(x)}, '
         'lin: ${LinRGB.fromIntToString(x)}, shortHex: "${HexUtils.singleNumToHexStr(x)}", ),');
  }  // don't forget to manually the semicolon

}