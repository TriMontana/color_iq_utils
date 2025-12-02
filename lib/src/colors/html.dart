import 'dart:math';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

/// Color family categories for HTML colors
enum ColorFamily {
  red,
  orange,
  yellow,
  green,
  cyan,
  blue,
  purple,
  pink,
  brown,
  white,
  gray,
  black,
}



/// Standard HTML/CSS color names with their hex values
enum HTML {
  aliceBlue(0xFFF0F8FF, 'Alice Blue', ColorFamily.blue),
  antiqueWhite(0xFFFAEBD7, 'Antique White', ColorFamily.white),
  aqua(0xFF00FFFF, 'Aqua', ColorFamily.cyan),
  aquamarine(0xFF7FFFD4, 'Aquamarine', ColorFamily.cyan),
  azure(0xFFF0FFFF, 'Azure', ColorFamily.cyan),
  beige(0xFFF5F5DC, 'Beige', ColorFamily.white),
  bisque(0xFFFFE4C4, 'Bisque', ColorFamily.orange),
  black(0xFF000000, 'Black', ColorFamily.black),
  blanchedAlmond(0xFFFFEBCD, 'Blanched Almond', ColorFamily.white),
  blue(0xFF0000FF, 'Blue', ColorFamily.blue),
  blueViolet(0xFF8A2BE2, 'Blue Violet', ColorFamily.purple),
  brown(0xFFA52A2A, 'Brown', ColorFamily.brown),
  burlyWood(0xFFDEB887, 'BurlyWood', ColorFamily.brown),
  cadetBlue(0xFF5F9EA0, 'Cadet Blue', ColorFamily.blue),
  chartreuse(0xFF7FFF00, 'Chartreuse', ColorFamily.green),
  chocolate(0xFFD2691E, 'Chocolate', ColorFamily.brown),
  coral(0xFFFF7F50, 'Coral', ColorFamily.orange),
  cornflowerBlue(0xFF6495ED, 'CornflowerBlue', ColorFamily.blue),
  cornsilk(0xFFFFF8DC, 'Cornsilk', ColorFamily.white),
  crimson(0xFFDC143C, 'Crimson', ColorFamily.red),
  cyan(0xFF00FFFF, 'Cyan', ColorFamily.cyan),
  darkBlue(0xFF00008B, 'DarkBlue', ColorFamily.blue),
  darkCyan(0xFF008B8B, 'DarkCyan', ColorFamily.cyan),
  darkGoldenRod(0xFFB8860B, 'DarkGoldenRod', ColorFamily.yellow),
  darkGray(0xFFA9A9A9, 'DarkGray', ColorFamily.gray),
  darkGrey(0xFFA9A9A9, 'DarkGrey', ColorFamily.gray),
  darkGreen(0xFF006400, 'DarkGreen', ColorFamily.green),
  darkKhaki(0xFFBDB76B, 'DarkKhaki', ColorFamily.yellow),
  darkMagenta(0xFF8B008B, 'Dark Magenta', ColorFamily.purple),
  darkOliveGreen(0xFF556B2F, 'Dark OliveGreen', ColorFamily.green),
  darkOrange(0xFFFF8C00, 'DarkOrange', ColorFamily.orange),
  darkOrchid(0xFF9932CC, 'DarkOrchid', ColorFamily.purple),
  darkRed(0xFF8B0000, 'DarkRed', ColorFamily.red),
  darkSalmon(0xFFE9967A, 'DarkSalmon', ColorFamily.orange),
  darkSeaGreen(0xFF8FBC8F, 'DarkSeaGreen', ColorFamily.green),
  darkSlateBlue(0xFF483D8B, 'DarkSlateBlue', ColorFamily.blue),
  darkSlateGray(0xFF2F4F4F, 'Dark SlateGray', ColorFamily.gray),
  darkSlateGrey(0xFF2F4F4F, 'Dark SlateGrey', ColorFamily.gray),
  darkTurquoise(0xFF00CED1, 'Dark Turquoise', ColorFamily.cyan),
  darkViolet(0xFF9400D3, 'DarkViolet', ColorFamily.purple),
  deepPink(0xFFFF1493, 'DeepPink', ColorFamily.pink),
  deepSkyBlue(0xFF00BFFF, 'Deep SkyBlue', ColorFamily.blue),
  dimGray(0xFF696969, 'DimGray', ColorFamily.gray),
  dimGrey(0xFF696969, 'DimGrey', ColorFamily.gray),
  dodgerBlue(0xFF1E90FF, 'DodgerBlue', ColorFamily.blue),
  fireBrick(0xFFB22222, 'FireBrick', ColorFamily.red),
  floralWhite(0xFFFFFAF0, 'Floral White', ColorFamily.white),
  forestGreen(0xFF228B22, 'Forest Green', ColorFamily.green),
  fuchsia(0xFFFF00FF, 'Fuchsia', ColorFamily.purple),
  gainsboro(0xFFDCDCDC, 'Gainsboro', ColorFamily.gray),
  ghostWhite(0xFFF8F8FF, 'Ghost White', ColorFamily.white),
  gold(0xFFFFD700, 'Gold', ColorFamily.yellow),
  goldenRod(0xFFDAA520, 'GoldenRod', ColorFamily.yellow),
  gray(0xFF808080, 'Gray', ColorFamily.gray),
  grey(0xFF808080, 'Grey', ColorFamily.gray),
  green(0xFF008000, 'Green', ColorFamily.green),
  greenYellow(0xFFADFF2F, 'GreenYellow', ColorFamily.green),
  honeyDew(0xFFF0FFF0, 'HoneyDew', ColorFamily.white),
  hotPink(0xFFFF69B4, 'HotPink', ColorFamily.pink),
  indianRed(0xFFCD5C5C, 'IndianRed', ColorFamily.red),
  indigo(0xFF4B0082, 'Indigo', ColorFamily.purple),
  ivory(0xFFFFFFF0, 'Ivory', ColorFamily.white),
  khaki(0xFFF0E68C, 'Khaki', ColorFamily.yellow),
  lavender(0xFFE6E6FA, 'Lavender', ColorFamily.purple),
  lavenderBlush(0xFFFFF0F5, 'LavenderBlush', ColorFamily.pink),
  lawnGreen(0xFF7CFC00, 'Lawn Green', ColorFamily.green),
  lemonChiffon(0xFFFFFACD, 'Lemon Chiffon', ColorFamily.yellow),
  lightBlue(0xFFADD8E6, 'LightBlue', ColorFamily.blue),
  lightCoral(0xFFF08080, 'Light Coral', ColorFamily.orange),
  lightCyan(0xFFE0FFFF, 'Light Cyan', ColorFamily.cyan),
  lightGoldenRodYellow(0xFFFAFAD2, 'Light GoldenRod Yellow', ColorFamily.yellow),
  lightGray(0xFFD3D3D3, 'LightGray', ColorFamily.gray),
  lightGrey(0xFFD3D3D3, 'LightGrey', ColorFamily.gray),
  lightGreen(0xFF90EE90, 'LightGreen', ColorFamily.green),
  lightPink(0xFFFFB6C1, 'LightPink', ColorFamily.pink),
  lightSalmon(0xFFFFA07A, 'LightSalmon', ColorFamily.orange),
  lightSeaGreen(0xFF20B2AA, 'LightSeaGreen', ColorFamily.green),
  lightSkyBlue(0xFF87CEFA, 'LightSkyBlue', ColorFamily.blue),
  lightSlateGray(0xFF778899, 'LightSlateGray', ColorFamily.gray),
  lightSlateGrey(0xFF778899, 'LightSlateGrey', ColorFamily.gray),
  lightSteelBlue(0xFFB0C4DE, 'LightSteelBlue', ColorFamily.blue),
  lightYellow(0xFFFFFFE0, 'LightYellow', ColorFamily.yellow),
  lime(0xFF00FF00, 'Lime', ColorFamily.green),
  limeGreen(0xFF32CD32, 'LimeGreen', ColorFamily.green),
  linen(0xFFFAF0E6, 'Linen', ColorFamily.white),
  magenta(0xFFFF00FF, 'Magenta', ColorFamily.purple),
  maroon(0xFF800000, 'Maroon', ColorFamily.red),
  mediumAquaMarine(0xFF66CDAA, 'MediumAquaMarine', ColorFamily.cyan),
  mediumBlue(0xFF0000CD, 'MediumBlue', ColorFamily.blue),
  mediumOrchid(0xFFBA55D3, 'MediumOrchid', ColorFamily.purple),
  mediumPurple(0xFF9370DB, 'Medium Purple', ColorFamily.purple),
  mediumSeaGreen(0xFF3CB371, 'MediumSeaGreen', ColorFamily.green),
  mediumSlateBlue(0xFF7B68EE, 'MediumSlateBlue', ColorFamily.blue),
  mediumSpringGreen(0xFF00FA9A, 'Medium SpringGreen', ColorFamily.green),
  mediumTurquoise(0xFF48D1CC, 'MediumTurquoise', ColorFamily.cyan),
  mediumVioletRed(0xFFC71585, 'MediumVioletRed', ColorFamily.pink),
  midnightBlue(0xFF191970, 'MidnightBlue', ColorFamily.blue),
  mintCream(0xFFF5FFFA, 'MintCream', ColorFamily.white),
  mistyRose(0xFFFFE4E1, 'MistyRose', ColorFamily.pink),
  moccasin(0xFFFFE4B5, 'Moccasin', ColorFamily.orange),
  navajoWhite(0xFFFFDEAD, 'NavajoWhite', ColorFamily.orange),
  navy(0xFF000080, 'Navy', ColorFamily.blue),
  oldLace(0xFFFDF5E6, 'OldLace', ColorFamily.white),
  olive(0xFF808000, 'Olive', ColorFamily.green),
  oliveDrab(0xFF6B8E23, 'Olive Drab', ColorFamily.green),
  orange(0xFFFFA500, 'Orange', ColorFamily.orange),
  orangeRed(0xFFFF4500, 'OrangeRed', ColorFamily.orange),
  orchid(0xFFDA70D6, 'Orchid', ColorFamily.purple),
  paleGoldenRod(0xFFEEE8AA, 'PaleGoldenRod', ColorFamily.yellow),
  paleGreen(0xFF98FB98, 'PaleGreen', ColorFamily.green),
  paleTurquoise(0xFFAFEEEE, 'PaleTurquoise', ColorFamily.cyan),
  paleVioletRed(0xFFDB7093, 'PaleVioletRed', ColorFamily.pink),
  papayaWhip(0xFFFFEFD5, 'PapayaWhip', ColorFamily.orange),
  peachPuff(0xFFFFDAB9, 'PeachPuff', ColorFamily.orange),
  peru(0xFFCD853F, 'Peru', ColorFamily.orange),
  pink(0xFFFFC0CB, 'Pink', ColorFamily.pink),
  plum(0xFFDDA0DD, 'Plum', ColorFamily.purple),
  powderBlue(0xFFB0E0E6, 'PowderBlue', ColorFamily.blue),
  purple(0xFF800080, 'Purple', ColorFamily.purple),
  rebeccaPurple(0xFF663399, 'RebeccaPurple', ColorFamily.purple),
  red(0xFFFF0000, 'Red', ColorFamily.red),
  rosyBrown(0xFFBC8F8F, 'RosyBrown', ColorFamily.brown),
  royalBlue(0xFF4169E1, 'RoyalBlue', ColorFamily.blue),
  saddleBrown(0xFF8B4513, 'SaddleBrown', ColorFamily.brown),
  salmon(0xFFFA8072, 'Salmon', ColorFamily.orange),
  sandyBrown(0xFFF4A460, 'SandyBrown', ColorFamily.orange),
  seaGreen(0xFF2E8B57, 'SeaGreen', ColorFamily.green),
  seaShell(0xFFFFF5EE, 'SeaShell', ColorFamily.white),
  sienna(0xFFA0522D, 'Sienna', ColorFamily.brown),
  silver(0xFFC0C0C0, 'Silver', ColorFamily.gray),
  skyBlue(0xFF87CEEB, 'SkyBlue', ColorFamily.blue),
  slateBlue(0xFF6A5ACD, 'SlateBlue', ColorFamily.blue),
  slateGray(0xFF708090, 'SlateGray', ColorFamily.gray),
  slateGrey(0xFF708090, 'SlateGrey', ColorFamily.gray),
  snow(0xFFFFFAFA, 'Snow', ColorFamily.white),
  springGreen(0xFF00FF7F, 'SpringGreen', ColorFamily.green),
  steelBlue(0xFF4682B4, 'Steel Blue', ColorFamily.blue),
  tan(0xFFD2B48C, 'Tan', ColorFamily.brown),
  teal(0xFF008080, 'Teal', ColorFamily.cyan),
  thistle(0xFFD8BFD8, 'Thistle', ColorFamily.purple),
  tomato(0xFFFF6347, 'Tomato', ColorFamily.red),
  turquoise(0xFF40E0D0, 'Turquoise', ColorFamily.cyan),
  violet(0xFFEE82EE, 'Violet', ColorFamily.purple),
  wheat(0xFFF5DEB3, 'Wheat', ColorFamily.brown),
  white(0xFFFFFFFF, 'White', ColorFamily.white),
  whiteSmoke(0xFFF5F5F5, 'White Smoke', ColorFamily.white),
  yellow(0xFFFFFF00, 'Yellow', ColorFamily.yellow),
  yellowGreen(0xFF9ACD32, 'Yellow Green', ColorFamily.green);

  final int value;
  final String name;
  final ColorFamily family;
  const HTML(this.value, this.name, this.family);
}

/// Extension to find the closest color family for any color value
extension ColorFamilyFinder on int {
  /// Determines the closest [ColorFamily] for this color value.
  /// 
  /// Compares the color against representative colors from each family
  /// using Euclidean distance in RGB color space.
  /// 
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// ColorFamily family = myColor.closestColorFamily(); // ColorFamily.red
  /// ```
  ColorFamily closestColorFamily() {
    // Extract RGB components from this color
    final int r = (this >> 16) & 0xFF;
    final int g = (this >> 8) & 0xFF;
    final int b = this & 0xFF;
    
    // Representative colors for each family (using pure/typical colors)
    final Map<ColorFamily, (int, int, int)> familyColors = <ColorFamily, (int, int, int)>{
      ColorFamily.red: (255, 0, 0),
      ColorFamily.orange: (255, 165, 0),
      ColorFamily.yellow: (255, 255, 0),
      ColorFamily.green: (0, 128, 0),
      ColorFamily.cyan: (0, 255, 255),
      ColorFamily.blue: (0, 0, 255),
      ColorFamily.purple: (128, 0, 128),
      ColorFamily.pink: (255, 192, 203),
      ColorFamily.brown: (165, 42, 42),
      ColorFamily.white: (255, 255, 255),
      ColorFamily.gray: (128, 128, 128),
      ColorFamily.black: (0, 0, 0),
    };
    
    // Find the family with minimum distance
    ColorFamily? closestFamily;
    double minDistance = double.infinity;
    
    for (final MapEntry<ColorFamily, (int, int, int)> entry in familyColors.entries) {
      final (int fr, int fg, int fb) = entry.value;
      // Calculate Euclidean distance in RGB space
      final double distance = ((r - fr) * (r - fr) + 
                       (g - fg) * (g - fg) + 
                       (b - fb) * (b - fb)).toDouble();
      
      if (distance < minDistance) {
        minDistance = distance;
        closestFamily = entry.key;
      }
    }
    
    return closestFamily!;
  }
  
  /// Finds the closest [HTML] color to this color value.
  /// 
  /// Compares the color against all HTML colors using Euclidean distance
  /// in RGB color space.
  /// 
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// HTML closest = myColor.closestHTMLColor(); // HTML.lightCoral
  /// ```
  HTML closestHTMLColor() {
    final int r = (this >> 16) & 0xFF;
    final int g = (this >> 8) & 0xFF;
    final int b = this & 0xFF;
    
    HTML? closestColor;
    double minDistance = double.infinity;
    
    for (final HTML htmlColor in HTML.values) {
      final int hr = (htmlColor.value >> 16) & 0xFF;
      final int hg = (htmlColor.value >> 8) & 0xFF;
      final int hb = htmlColor.value & 0xFF;
      
      final double distance = ((r - hr) * (r - hr) + 
                       (g - hg) * (g - hg) + 
                       (b - hb) * (b - hb)).toDouble();
      
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = htmlColor;
      }
    }
    
    return closestColor!;
  }
  
  /// Determines the closest [ColorFamily] for this color value using CAM16-based distance.
  /// 
  /// Uses perceptually uniform CAM16/HCT color space for more accurate
  /// color family matching based on human perception.
  /// 
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// ColorFamily family = myColor.closestColorFamilyPerceptual(); // ColorFamily.red
  /// ```
  ColorFamily closestColorFamilyPerceptual() {
    final ColorIQ thisColor = ColorIQ(this);
    final HctColor hct1 = thisColor.toHct();
    
    // Representative colors for each family (using pure/typical colors)
    final Map<ColorFamily, ColorIQ> familyColors = <ColorFamily, ColorIQ>{
      ColorFamily.red: const ColorIQ(0xFFFF0000),
      ColorFamily.orange: const ColorIQ(0xFFFFA500),
      ColorFamily.yellow: const ColorIQ(0xFFFFFF00),
      ColorFamily.green: const ColorIQ(0xFF008000),
      ColorFamily.cyan: const ColorIQ(0xFF00FFFF),
      ColorFamily.blue: const ColorIQ(0xFF0000FF),
      ColorFamily.purple: const ColorIQ(0xFF800080),
      ColorFamily.pink: const ColorIQ(0xFFFFC0CB),
      ColorFamily.brown: const ColorIQ(0xFFA52A2A),
      ColorFamily.white: const ColorIQ(0xFFFFFFFF),
      ColorFamily.gray: const ColorIQ(0xFF808080),
      ColorFamily.black: const ColorIQ(0xFF000000),
    };
    
    // Find the family with minimum perceptual distance
    ColorFamily? closestFamily;
    double minDistance = double.infinity;
    
    for (final MapEntry<ColorFamily, ColorIQ> entry in familyColors.entries) {
      final HctColor hct2 = entry.value.toHct();
      
      // Calculate perceptual distance using CAM16/HCT
      // Convert to Cartesian coordinates for distance calculation
      final double h1Rad = hct1.hue * pi / 180;
      final double h2Rad = hct2.hue * pi / 180;
      
      final double a1 = hct1.chroma * cos(h1Rad);
      final double b1 = hct1.chroma * sin(h1Rad);
      final double a2 = hct2.chroma * cos(h2Rad);
      final double b2 = hct2.chroma * sin(h2Rad);
      
      final double dTone = hct1.tone - hct2.tone;
      final double da = a1 - a2;
      final double db = b1 - b2;
      
      final double distance = sqrt(dTone * dTone + da * da + db * db);
      
      if (distance < minDistance) {
        minDistance = distance;
        closestFamily = entry.key;
      }
    }
    
    return closestFamily!;
  }
  
  /// Finds the closest [HTML] color to this color value using CAM16-based distance.
  /// 
  /// Uses perceptually uniform CAM16/HCT color space for more accurate
  /// color matching based on human perception rather than simple RGB distance.
  /// 
  /// Example:
  /// ```dart
  /// int myColor = 0xFFFF6B6B;
  /// HTML closest = myColor.closestHTMLColorPerceptual(); // HTML.lightCoral
  /// ```
  HTML closestHTMLColorPerceptual() {
    final ColorIQ thisColor = ColorIQ(this);
    
    HTML? closestColor;
    double minDistance = double.infinity;
    
    for (final HTML htmlColor in HTML.values) {
      // Use the distanceTo method which uses CAM16/HCT
      final double distance = thisColor.distanceTo(ColorIQ(htmlColor.value));
      
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = htmlColor;
      }
    }
    
    return closestColor!;
  }
}