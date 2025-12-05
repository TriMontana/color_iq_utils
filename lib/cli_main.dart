import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  final ColorIQ c = ColorIQ.fromHexStr('#BED3E5');
  print('Name: ${c.descriptiveName}');
  print('L*: ${c.lab.l}');
}
