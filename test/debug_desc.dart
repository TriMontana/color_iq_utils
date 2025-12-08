import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  const HSL red = HSL(0, 0.3, 0.8);
  print('Red (HSL 0, 0.3, 0.8):');
  print('  HCT: ${red.toHctColor()}');
  print('  Slice: ${red.closestColorSlice().name}');
  print('  Desc: ${ColorDescriptor.describe(red)}');

  const HSL yellow = HSL(60, 1.0, 0.5);
  print('Yellow (HSL 60, 1.0, 0.5):');
  print('  HCT: ${yellow.toHctColor()}');
  print('  Slice: ${yellow.closestColorSlice().name}');
  print('  Desc: ${ColorDescriptor.describe(yellow)}');

  final ColorIQ lightGray = ColorIQ(0xFFD3D3D3);
  print('LightGray (D3D3D3):');
  print('  HSL: ${lightGray.hsl}');
  print('  Desc: ${ColorDescriptor.describe(lightGray)}');
}
