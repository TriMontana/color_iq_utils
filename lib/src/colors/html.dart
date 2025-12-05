import 'package:color_iq_utils/src/color_models.dart';
import 'package:color_iq_utils/src/naming/names.dart';

/// Color family categories for HTML colors
enum ColorFamilyHTML {
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

const int hxYellow = 0xFFFFFF00;
final ColorIQ cYellow = ColorIQ(hxYellow);
const int hxCyan = 0xFF00FFFF;
final ColorIQ cCyan = ColorIQ(hxCyan);
const int hxBlue = 0xFF0000FF;
final ColorIQ cBlue = ColorIQ(hxBlue);
const int hxRed = 0xFFFF0000;
final ColorIQ cRed = ColorIQ(hxRed);
const HslColor kHslRed = HslColor(0, 1.0, 0.5, hexId: hxRed); // Red
const HsvColor kHsvRed = HsvColor(0, 1.0, 1.0, hexId: hxRed);
const int hxOrange = 0xFFFFA500;
final ColorIQ cOrange = ColorIQ(hxOrange);
const int hxGreen = 0xFF00FF00;
final ColorIQ cGreen = ColorIQ(hxGreen);
const int hxElectricLime = 0xFF008000;
final ColorIQ cElectricLime = ColorIQ(hxElectricLime);
const HsvColor hsvGreen = HsvColor(120, 1.0, 1.0, hexId: hxGreen);
const HslColor hslGreen = HslColor(120, 1.0, 0.5, hexId: hxGreen);
const YiqColor yiqGreen = YiqColor(0.0, 0.0, 0.0, val: hxGreen);
const YuvColor yuvGreen = YuvColor(0.0, 0.0, 0.0, val: hxGreen); // Green
const LuvColor luvGreen = LuvColor(0, 0, 0, hexId: hxGreen);
const CmykColor cmykGreen = CmykColor(0, 0, 0, 0, value: hxGreen); // Green
const HwbColor hwbGreen = HwbColor(120, 0.0, 0.0, hexId: hxGreen);
const int hxLime = 0xFF00FF00; // same as ElectricLime
final ColorIQ cLime = ColorIQ(hxLime);
const int hxPurple = 0xFF800080;
final ColorIQ cPurple = ColorIQ(hxPurple);
const int hxPink = 0xFFFFC0CB;
final ColorIQ cPink = ColorIQ(hxPink);
const int hxGray = 0xFF808080;
final ColorIQ cGray = ColorIQ(hxGray);
const int hxBlack = 0xFF000000;
final ColorIQ cBlack = ColorIQ(hxBlack);
const HslColor kHslBlack = HslColor(0, 0, 0, hexId: hxBlack);
const YiqColor yiqBlack = YiqColor(0.0, 0.0, 0.0, val: hxBlack);
const YuvColor yuvBlack = YuvColor(0.0, 0.0, 0.0, val: hxBlack); // Black
const LuvColor luvBlack = LuvColor(0, 0, 0, hexId: hxBlack);
const int hxWhite = 0xFFFFFFFF;
final ColorIQ cWhite = ColorIQ(hxWhite);
const HslColor kHslWhite = HslColor(0, 0, 1.0, hexId: hxWhite);
const CmykColor cmykWhite = CmykColor(0, 0, 0, 0, value: hxWhite); // White
const YiqColor yiqWhite = YiqColor(1.0, 1.0, 1.0, val: hxWhite);
const YuvColor yuvWhite = YuvColor(1.0, 1.0, 1.0, val: hxWhite); // White
const LuvColor luvWhite = LuvColor(100, 0, 0, hexId: hxWhite);
const int hxAliceBlue = 0xFFF0F8FF;
final ColorIQ cAliceBlue = ColorIQ(hxAliceBlue);
const int hxAntiqueWhite = 0xFFFAEBD7;
final ColorIQ cAntiqueWhite = ColorIQ(hxAntiqueWhite);
const int hxAqua = 0xFF00FFFF;
final ColorIQ cAqua = ColorIQ(hxAqua);
const int hxAquamarine = 0xFF7FFFD4;
final ColorIQ cAquamarine = ColorIQ(hxAquamarine);
const int hxAzure = 0xFFF0FFFF;
final ColorIQ cAzure = ColorIQ(hxAzure);
const int hxBeige = 0xFFF5F5DC;
final ColorIQ cBeige = ColorIQ(hxBeige);
const int hxBisque = 0xFFFFE4C4;
final ColorIQ cBisque = ColorIQ(hxBisque);
const int hxBlanchedAlmond = 0xFFFFEBCD;
final ColorIQ cBlanchedAlmond = ColorIQ(hxBlanchedAlmond);
const int hxBlueViolet = 0xFF8A2BE2;
final ColorIQ cBlueViolet = ColorIQ(hxBlueViolet);
const int hxBrown = 0xFFA52A2A;
final ColorIQ cBrown = ColorIQ(hxBrown);
const int hxBurlyWood = 0xFFDEB887;
final ColorIQ cBurlyWood = ColorIQ(hxBurlyWood);
const int hxCadetBlue = 0xFF5F9EA0;
final ColorIQ cCadetBlue = ColorIQ(hxCadetBlue);
const int hxChartreuse = 0xFF7FFF00;
final ColorIQ cChartreuse = ColorIQ(hxChartreuse);
const int hxChocolate = 0xFFD2691E;
final ColorIQ cChocolate = ColorIQ(hxChocolate);
const int hxCoral = 0xFFFF7F50;
final ColorIQ cCoral = ColorIQ(hxCoral);
const int hxCornflowerBlue = 0xFF6495ED;
final ColorIQ cCornflowerBlue = ColorIQ(hxCornflowerBlue);
const int hxCornSilk = 0xFFFFF8DC;
final ColorIQ cCornSilk = ColorIQ(hxCornSilk);
const int hxCrimson = 0xFFDC143C;
final ColorIQ cCrimson = ColorIQ(hxCrimson);
const int hxDarkBlue = 0xFF00008B;
final ColorIQ cDarkBlue = ColorIQ(hxDarkBlue);
const int hxDarkCyan = 0xFF008B8B;
final ColorIQ cDarkCyan = ColorIQ(hxDarkCyan);
const int hxDarkGoldenRod = 0xFFB8860B;
final ColorIQ cDarkGoldenRod = ColorIQ(hxDarkGoldenRod);
const int hxDarkGray = 0xFFA9A9A9;
final ColorIQ cDarkGray = ColorIQ(hxDarkGray);
const int hxDarkGreen = 0xFF006400;
final ColorIQ cDarkGreen = ColorIQ(hxDarkGreen);
const int hxDarkKhaki = 0xFFBDB76B;
final ColorIQ cDarkKhaki = ColorIQ(hxDarkKhaki);
const int hxDarkMagenta = 0xFF8B008B;
final ColorIQ cDarkMagenta = ColorIQ(hxDarkMagenta);
const int hxDarkOliveGreen = 0xFF556B2F;
final ColorIQ cDarkOliveGreen = ColorIQ(hxDarkOliveGreen);
const int hxDarkOrange = 0xFFFF8C00;
final ColorIQ cDarkOrange = ColorIQ(hxDarkOrange);
const int hxDarkOrchid = 0xFF9932CC;
final ColorIQ cDarkOrchid = ColorIQ(hxDarkOrchid);
const int hxDarkRed = 0xFF8B0000;
final ColorIQ cDarkRed = ColorIQ(hxDarkRed);
const int hxDarkSalmon = 0xFF8F0000;
final ColorIQ cDarkSalmon = ColorIQ(hxDarkSalmon);
const int hxDarkSeaGreen = 0xFF8FBC8F;
final ColorIQ cDarkSeaGreen = ColorIQ(hxDarkSeaGreen);
const int hxDarkSlateBlue = 0xFF483D8B;
final ColorIQ cDarkSlateBlue = ColorIQ(hxDarkSlateBlue);
const int hxDarkSlateGray = 0xFF2F4F4F;
final ColorIQ cDarkSlateGray = ColorIQ(hxDarkSlateGray);
const int hxDarkTurquoise = 0xFF00CED1;
final ColorIQ cDarkTurquoise = ColorIQ(hxDarkTurquoise);
const int hxDarkViolet = 0xFF9400D3;
final ColorIQ cDarkViolet = ColorIQ(hxDarkViolet);
const int hxDarkYellow = 0xFF8B8B00;
final ColorIQ cDarkYellow = ColorIQ(hxDarkYellow);

/// Standard HTML/CSS color names with their hex values
enum HTML {
  aliceBlue(hxAliceBlue, 'Alice Blue', ColorFamilyHTML.blue),
  antiqueWhite(hxAntiqueWhite, 'Antique White', ColorFamilyHTML.white),
  aqua(hxAqua, 'Aqua', ColorFamilyHTML.cyan),
  aquamarine(hxAquamarine, 'Aquamarine', ColorFamilyHTML.cyan),
  azure(hxAzure, 'Azure', ColorFamilyHTML.cyan),
  beige(hxBeige, 'Beige', ColorFamilyHTML.white),
  bisque(hxBisque, 'Bisque', ColorFamilyHTML.orange),
  black(hxBlack, 'Black', ColorFamilyHTML.black),
  blanchedAlmond(hxBlanchedAlmond, 'Blanched Almond', ColorFamilyHTML.white),
  blue(hxBlue, 'Blue', ColorFamilyHTML.blue),
  blueViolet(hxBlueViolet, 'Blue Violet', ColorFamilyHTML.purple),
  brown(hxBrown, 'Brown', ColorFamilyHTML.brown),
  burlyWood(hxBurlyWood, 'BurlyWood', ColorFamilyHTML.brown),
  cadetBlue(hxCadetBlue, 'Cadet Blue', ColorFamilyHTML.blue),
  chartreuse(hxChartreuse, 'Chartreuse', ColorFamilyHTML.green),
  chocolate(hxChocolate, 'Chocolate', ColorFamilyHTML.brown),
  coral(hxCoral, 'Coral', ColorFamilyHTML.orange),
  cornflowerBlue(hxCornflowerBlue, 'CornflowerBlue', ColorFamilyHTML.blue),
  cornsilk(hxCornSilk, 'Cornsilk', ColorFamilyHTML.white),
  crimson(hxCrimson, 'Crimson', ColorFamilyHTML.red),
  cyan(hxCyan, 'Cyan', ColorFamilyHTML.cyan),
  darkBlue(hxDarkBlue, 'Dark Blue', ColorFamilyHTML.blue),
  darkCyan(hxDarkCyan, 'Dark Cyan', ColorFamilyHTML.cyan),
  darkGoldenRod(hxDarkGoldenRod, 'DarkGoldenRod', ColorFamilyHTML.yellow),
  darkGray(hxDarkGray, 'Dark Gray', ColorFamilyHTML.gray),
  darkGrey(hxDarkGray, 'DarkGrey', ColorFamilyHTML.gray),
  darkGreen(hxDarkGreen, 'Dark Green', ColorFamilyHTML.green),
  darkKhaki(hxDarkKhaki, 'Dark Khaki', ColorFamilyHTML.yellow),
  darkMagenta(hxDarkMagenta, 'Dark Magenta', ColorFamilyHTML.purple),
  darkOliveGreen(hxDarkOliveGreen, 'Dark OliveGreen', ColorFamilyHTML.green),
  darkOrange(0xFFFF8C00, 'DarkOrange', ColorFamilyHTML.orange),
  darkOrchid(0xFF9932CC, 'DarkOrchid', ColorFamilyHTML.purple),
  darkRed(0xFF8B0000, 'DarkRed', ColorFamilyHTML.red),
  darkSalmon(0xFFE9967A, 'DarkSalmon', ColorFamilyHTML.orange),
  darkSeaGreen(0xFF8FBC8F, 'DarkSeaGreen', ColorFamilyHTML.green),
  darkSlateBlue(0xFF483D8B, 'DarkSlateBlue', ColorFamilyHTML.blue),
  darkSlateGray(0xFF2F4F4F, 'Dark SlateGray', ColorFamilyHTML.gray),
  darkSlateGrey(0xFF2F4F4F, 'Dark SlateGrey', ColorFamilyHTML.gray),
  darkTurquoise(0xFF00CED1, 'Dark Turquoise', ColorFamilyHTML.cyan),
  darkViolet(0xFF9400D3, 'Dark Violet', ColorFamilyHTML.purple),
  deepPink(0xFFFF1493, 'Deep Pink', ColorFamilyHTML.pink),
  deepSkyBlue(0xFF00BFFF, 'Deep SkyBlue', ColorFamilyHTML.blue),
  dimGray(0xFF696969, 'DimGray', ColorFamilyHTML.gray),
  dimGrey(0xFF696969, 'DimGrey', ColorFamilyHTML.gray),
  dodgerBlue(0xFF1E90FF, 'DodgerBlue', ColorFamilyHTML.blue),
  fireBrick(0xFFB22222, 'FireBrick', ColorFamilyHTML.red),
  floralWhite(0xFFFFFAF0, 'Floral White', ColorFamilyHTML.white),
  forestGreen(0xFF228B22, 'Forest Green', ColorFamilyHTML.green),
  fuchsia(0xFFFF00FF, 'Fuchsia', ColorFamilyHTML.purple),
  gainsboro(0xFFDCDCDC, 'Gainsboro', ColorFamilyHTML.gray),
  ghostWhite(0xFFF8F8FF, 'Ghost White', ColorFamilyHTML.white),
  gold(0xFFFFD700, 'Gold', ColorFamilyHTML.yellow),
  goldenRod(0xFFDAA520, 'GoldenRod', ColorFamilyHTML.yellow),
  gray(0xFF808080, 'Gray', ColorFamilyHTML.gray),
  grey(0xFF808080, 'Grey', ColorFamilyHTML.gray),
  green(0xFF008000, 'Green', ColorFamilyHTML.green),
  greenYellow(0xFFADFF2F, 'Green Yellow', ColorFamilyHTML.green),
  honeyDew(0xFFF0FFF0, 'HoneyDew', ColorFamilyHTML.white),
  hotPink(0xFFFF69B4, 'HotPink', ColorFamilyHTML.pink),
  indianRed(0xFFCD5C5C, 'IndianRed', ColorFamilyHTML.red),
  indigo(0xFF4B0082, 'Indigo', ColorFamilyHTML.purple),
  ivory(0xFFFFFFF0, 'Ivory', ColorFamilyHTML.white),
  khaki(0xFFF0E68C, 'Khaki', ColorFamilyHTML.yellow),
  lavender(0xFFE6E6FA, 'Lavender', ColorFamilyHTML.purple),
  lavenderBlush(0xFFFFF0F5, 'LavenderBlush', ColorFamilyHTML.pink),
  lawnGreen(0xFF7CFC00, 'Lawn Green', ColorFamilyHTML.green),
  lemonChiffon(0xFFFFFACD, 'Lemon Chiffon', ColorFamilyHTML.yellow),
  lightBlue(0xFFADD8E6, 'Light Blue', ColorFamilyHTML.blue),
  lightCoral(0xFFF08080, 'Light Coral', ColorFamilyHTML.orange),
  lightCyan(0xFFE0FFFF, 'Light Cyan', ColorFamilyHTML.cyan),
  lightGoldenRodYellow(
    0xFFFAFAD2,
    'Light GoldenRod Yellow',
    ColorFamilyHTML.yellow,
  ),
  lightGray(0xFFD3D3D3, 'Light Gray', ColorFamilyHTML.gray),
  lightGrey(0xFFD3D3D3, 'Light Grey', ColorFamilyHTML.gray),
  lightGreen(0xFF90EE90, 'Light Green', ColorFamilyHTML.green),
  lightPink(0xFFFFB6C1, 'LightPink', ColorFamilyHTML.pink),
  lightSalmon(0xFFFFA07A, 'Light Salmon', ColorFamilyHTML.orange),
  lightSeaGreen(0xFF20B2AA, 'Light SeaGreen', ColorFamilyHTML.green),
  lightSkyBlue(0xFF87CEFA, 'Light SkyBlue', ColorFamilyHTML.blue),
  lightSlateGray(0xFF778899, 'Light SlateGray', ColorFamilyHTML.gray),
  lightSlateGrey(0xFF778899, 'Light SlateGrey', ColorFamilyHTML.gray),
  lightSteelBlue(0xFFB0C4DE, 'Light SteelBlue', ColorFamilyHTML.blue),
  lightYellow(0xFFFFFFE0, 'Light Yellow', ColorFamilyHTML.yellow),
  lime(hxLime, 'Lime', ColorFamilyHTML.green),
  limeGreen(0xFF32CD32, 'Lime Green', ColorFamilyHTML.green),
  linen(0xFFFAF0E6, 'Linen', ColorFamilyHTML.white),
  magenta(0xFFFF00FF, kMagenta, ColorFamilyHTML.purple),
  maroon(0xFF800000, 'Maroon', ColorFamilyHTML.red),
  mediumAquaMarine(0xFF66CDAA, 'Medium AquaMarine', ColorFamilyHTML.cyan),
  mediumBlue(0xFF0000CD, 'Medium Blue', ColorFamilyHTML.blue),
  mediumOrchid(0xFFBA55D3, 'Medium Orchid', ColorFamilyHTML.purple),
  mediumPurple(0xFF9370DB, 'Medium Purple', ColorFamilyHTML.purple),
  mediumSeaGreen(0xFF3CB371, 'MediumSeaGreen', ColorFamilyHTML.green),
  mediumSlateBlue(0xFF7B68EE, 'MediumSlateBlue', ColorFamilyHTML.blue),
  mediumSpringGreen(0xFF00FA9A, 'Medium SpringGreen', ColorFamilyHTML.green),
  mediumTurquoise(0xFF48D1CC, 'MediumTurquoise', ColorFamilyHTML.cyan),
  mediumVioletRed(0xFFC71585, 'MediumVioletRed', ColorFamilyHTML.pink),
  midnightBlue(0xFF191970, 'MidnightBlue', ColorFamilyHTML.blue),
  mintCream(0xFFF5FFFA, 'Mint Cream', ColorFamilyHTML.white),
  mistyRose(0xFFFFE4E1, 'MistyRose', ColorFamilyHTML.pink),
  moccasin(0xFFFFE4B5, 'Moccasin', ColorFamilyHTML.orange),
  navajoWhite(0xFFFFDEAD, 'Navajo White', ColorFamilyHTML.orange),
  navy(0xFF000080, 'Navy', ColorFamilyHTML.blue),
  oldLace(0xFFFDF5E6, 'Old Lace', ColorFamilyHTML.white),
  olive(0xFF808000, 'Olive', ColorFamilyHTML.green),
  oliveDrab(0xFF6B8E23, 'Olive Drab', ColorFamilyHTML.green),
  orange(0xFFFFA500, 'Orange', ColorFamilyHTML.orange),
  orangeRed(0xFFFF4500, 'OrangeRed', ColorFamilyHTML.orange),
  orchid(0xFFDA70D6, 'Orchid', ColorFamilyHTML.purple),
  paleGoldenRod(0xFFEEE8AA, 'Pale GoldenRod', ColorFamilyHTML.yellow),
  paleGreen(0xFF98FB98, 'Pale Green', ColorFamilyHTML.green),
  paleTurquoise(0xFFAFEEEE, 'Pale Turquoise', ColorFamilyHTML.cyan),
  paleVioletRed(0xFFDB7093, 'PaleVioletRed', ColorFamilyHTML.pink),
  papayaWhip(0xFFFFEFD5, 'PapayaWhip', ColorFamilyHTML.orange),
  peachPuff(0xFFFFDAB9, 'PeachPuff', ColorFamilyHTML.orange),
  peru(0xFFCD853F, 'Peru', ColorFamilyHTML.orange),
  pink(0xFFFFC0CB, 'Pink', ColorFamilyHTML.pink),
  plum(0xFFDDA0DD, 'Plum', ColorFamilyHTML.purple),
  powderBlue(0xFFB0E0E6, 'Powder Blue', ColorFamilyHTML.blue),
  purple(0xFF800080, 'Purple', ColorFamilyHTML.purple),
  rebeccaPurple(0xFF663399, 'Rebecca Purple', ColorFamilyHTML.purple),
  red(0xFFFF0000, 'Red', ColorFamilyHTML.red),
  rosyBrown(0xFFBC8F8F, 'Rosy Brown', ColorFamilyHTML.brown),
  royalBlue(0xFF4169E1, 'Royal Blue', ColorFamilyHTML.blue),
  saddleBrown(0xFF8B4513, 'Saddle Brown', ColorFamilyHTML.brown),
  salmon(0xFFFA8072, 'Salmon', ColorFamilyHTML.orange),
  sandyBrown(0xFFF4A460, 'Sandy Brown', ColorFamilyHTML.orange),
  seaGreen(0xFF2E8B57, 'SeaGreen', ColorFamilyHTML.green),
  seaShell(0xFFFFF5EE, 'SeaShell', ColorFamilyHTML.white),
  sienna(0xFFA0522D, 'Sienna', ColorFamilyHTML.brown),
  silver(0xFFC0C0C0, 'Silver', ColorFamilyHTML.gray),
  skyBlue(0xFF87CEEB, 'SkyBlue', ColorFamilyHTML.blue),
  slateBlue(0xFF6A5ACD, 'Slate Blue', ColorFamilyHTML.blue),
  slateGray(0xFF708090, 'Slate Gray', ColorFamilyHTML.gray),
  slateGrey(0xFF708090, 'SlateGrey', ColorFamilyHTML.gray),
  snow(0xFFFFFAFA, 'Snow', ColorFamilyHTML.white),
  springGreen(0xFF00FF7F, 'SpringGreen', ColorFamilyHTML.green),
  steelBlue(0xFF4682B4, 'Steel Blue', ColorFamilyHTML.blue),
  tan(0xFFD2B48C, 'Tan', ColorFamilyHTML.brown),
  teal(0xFF008080, 'Teal', ColorFamilyHTML.cyan),
  thistle(0xFFD8BFD8, 'Thistle', ColorFamilyHTML.purple),
  tomato(0xFFFF6347, 'Tomato', ColorFamilyHTML.red),
  turquoise(0xFF40E0D0, 'Turquoise', ColorFamilyHTML.cyan),
  violet(0xFFEE82EE, 'Violet', ColorFamilyHTML.purple),
  wheat(0xFFF5DEB3, 'Wheat', ColorFamilyHTML.brown),
  white(0xFFFFFFFF, 'White', ColorFamilyHTML.white),
  whiteSmoke(0xFFF5F5F5, 'White Smoke', ColorFamilyHTML.white),
  yellow(hxYellow, kYellow, ColorFamilyHTML.yellow),
  yellowGreen(0xFF9ACD32, 'Yellow Green', ColorFamilyHTML.green);

  final int value;
  final String name;
  final ColorFamilyHTML family;
  const HTML(this.value, this.name, this.family);
  int get hexId => value;
  String get hexString =>
      '0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')})';
}
