import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  final red = HslColor(0, 0.3, 0.8);
  print('Red (HSL 0, 0.3, 0.8):');
  print('  HCT: ${red.toHct()}');
  print('  Slice: ${red.closestColorSlice().name}');
  print('  Desc: ${ColorDescriptor.describe(red)}');

  final yellow = HslColor(60, 1.0, 0.5);
  print('Yellow (HSL 60, 1.0, 0.5):');
  print('  HCT: ${yellow.toHct()}');
  print('  Slice: ${yellow.closestColorSlice().name}');
  print('  Desc: ${ColorDescriptor.describe(yellow)}');
  
  final lightGray = ColorIQ(0xFFD3D3D3);
  print('LightGray (D3D3D3):');
  print('  HSL: ${lightGray.toHsl()}');
  print('  Desc: ${ColorDescriptor.describe(lightGray)}');
}
