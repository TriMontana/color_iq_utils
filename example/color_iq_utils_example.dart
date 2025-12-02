import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  // Create a ColorIQ object from RGB
  final color = ColorIQ.fromARGB(255, 255, 0, 0); // Red
  print('Original Color (RGB): $color');

  // Convert to various color spaces
  final hsp = color.toHsp();
  print('HSP: $hsp');

  final yiq = color.toYiq();
  print('YIQ: $yiq');

  final oklab = color.toOkLab();
  print('OkLab: $oklab');

  final oklch = color.toOkLch();
  print('OkLch: $oklch');
  
  final hunter = color.toHunterLab();
  print('Hunter Lab: $hunter');
 

  // Demonstrate CSS string conversion
  final cssString = color.toCssString();
  print('CSS String: $cssString');

  // Parse a CSS string back to ColorIQ
  final parsedColor = CssColor.fromCssString(cssString);
  print('Parsed Color from CSS String: $parsedColor');
}