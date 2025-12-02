import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  // Create a ColorIQ object from RGB
  final ColorIQ color = ColorIQ.fromARGB(255, 255, 0, 0); // Red
  print('Original Color (RGB): $color');

  // Convert to various color spaces
  final HspColor hsp = color.toHsp();
  print('HSP: $hsp');

  final YiqColor yiq = color.toYiq();
  print('YIQ: $yiq');

  final OkLabColor oklab = color.toOkLab();
  print('OkLab: $oklab');

  final OkLchColor oklch = color.toOkLch();
  print('OkLch: $oklch');
  
  final HunterLabColor hunter = color.toHunterLab();
  print('Hunter Lab: $hunter');
 

  // Demonstrate CSS string conversion
  final String cssString = color.toCssString();
  print('CSS String: $cssString');

  // Parse a CSS string back to ColorIQ
  final ColorSpacesIQ parsedColor = CssColor.fromCssString(cssString);
  print('Parsed Color from CSS String: $parsedColor');
}