import 'package:color_iq_utils/src/color_models_lib.dart';
import 'package:color_iq_utils/src/colors/encycolorpedia.dart';
import 'package:color_iq_utils/src/naming/names.dart';

/// Color family categories for HTML colors
enum ColorFamilyHTML {
  red(hxRed, kRed),
  orange(hxOrangeHtml, kOrange),
  yellow(hxYellow, kYellow),
  green(hxGreenHtml, kGreen),
  cyan(hxCyan, kCyan),
  blue(hxBlue, kBlue),
  purple(hxPurple, kPurple),
  pink(hxPink, kPink),
  brown(hxBrownHtml, kBrown),
  white(hxWhite, kWhite),
  gray(hxGray, kGray),
  black(hxBlack, kBlack);

  const ColorFamilyHTML(this.argb, this.names);
  final int argb;
  final List<String> names;
}

const int hxAliceBlue = 0xFFF0F8FF;
final ColorIQ cAliceBlue = ColorIQ(hxAliceBlue, names: kAliceBlue);
const int hxAntiqueWhite = 0xFFFAEBD7;
final ColorIQ cAntiqueWhite = ColorIQ(hxAntiqueWhite, names: kAntiqueWhite);
const int hxAqua = 0xFF00FFFF;
final ColorIQ cAqua = ColorIQ(hxAqua);
const int hxAquamarine = 0xFF7FFFD4;
final ColorIQ cAquamarine = ColorIQ(hxAquamarine);
const int hxBeige = 0xFFF5F5DC;
final ColorIQ cBeige = ColorIQ(hxBeige);
const int hxBisque = 0xFFFFE4C4;
final ColorIQ cBisque = ColorIQ(hxBisque);
const int hxBlack = 0xFF000000;
final ColorIQ cBlack = ColorIQ(hxBlack);
const HslColor kHslBlack = HslColor(0, 0, 0, hexId: hxBlack);
const YiqColor yiqBlack = YiqColor(0.0, 0.0, 0.0, val: hxBlack);
const YuvColor yuvBlack = YuvColor(0.0, 0.0, 0.0, val: hxBlack); // Black
const LuvColor luvBlack = LuvColor(0, 0, 0, hexId: hxBlack);
const int hxBlanchedAlmond = 0xFFFFEBCD;
final ColorIQ cBlanchedAlmond = ColorIQ(hxBlanchedAlmond);
const int hxBlue = 0xFF0000FF;
final ColorIQ cBlue = ColorIQ(hxBlue, names: kBlue);
const int hxBlueViolet = 0xFF8A2BE2;
final ColorIQ cBlueViolet = ColorIQ(hxBlueViolet);
const int hxBrownHtml = 0xFFA52A2A;
final ColorIQ cBrownHtml = ColorIQ(hxBrownHtml);
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
const int hxCyan = 0xFF00FFFF;
final ColorIQ cCyan = ColorIQ(hxCyan);
const int hxDarkBlue = 0xFF00008B;
final ColorIQ cDarkBlue = ColorIQ(hxDarkBlue);
const int hxDarkCyan = 0xFF008B8B;
final ColorIQ cDarkCyan = ColorIQ(hxDarkCyan);
const int hxDarkGoldenRod = 0xFFB8860B;
final ColorIQ cDarkGoldenRod = ColorIQ(hxDarkGoldenRod);
const int hxDarkGray = 0xFFA9A9A9;
final ColorIQ cDarkGray = ColorIQ(hxDarkGray);
const int hxDarkGreenHtml = 0xFF006400;
final ColorIQ cDarkGreenHtml = ColorIQ(hxDarkGreenHtml);
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
const int hxDarkSalmon = 0xFFE9967A;
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
const int hxDarkYellowHtml = 0xFF8B8B00;
final ColorIQ cDarkYellowHtml = ColorIQ(hxDarkYellowHtml);
const int hxDeepPink = 0xFFFF1493;
final ColorIQ cDeepPink = ColorIQ(hxDeepPink);
const int hxDeepSkyBlue = 0xFF00BFFF;
final ColorIQ cDeepSkyBlue = ColorIQ(hxDeepSkyBlue);
const int hxDimGray = 0xFF696969;
final ColorIQ cDimGray = ColorIQ(hxDimGray);
const int hxDimGrey = 0xFF696969;
final ColorIQ cDimGrey = ColorIQ(hxDimGrey);
const int hxDodgerBlue = 0xFF1E90FF;
final ColorIQ cDodgerBlue = ColorIQ(hxDodgerBlue);
const int hxFireBrick = 0xFFB22222;
final ColorIQ cFireBrick = ColorIQ(hxFireBrick);
const int hxFloralWhite = 0xFFFFFAF0;
final ColorIQ cFloralWhite = ColorIQ(hxFloralWhite);
const int hxForestGreen = 0xFF228B22;
final ColorIQ cForestGreen = ColorIQ(hxForestGreen);
const int hxFuchsia = 0xFFFF00FF;
final ColorIQ cFuchsia = ColorIQ(hxFuchsia);
const int hxGainsboro = 0xFFDCDCDC;
final ColorIQ cGainsboro = ColorIQ(hxGainsboro);
const int hxGhostWhite = 0xFFF8F8FF;
final ColorIQ cGhostWhite = ColorIQ(hxGhostWhite);
const int hxGoldHtml = 0xFFFFD700;
final ColorIQ cGoldHtml = ColorIQ(hxGoldHtml);
const int hxGoldenRod = 0xFFDAA520;
final ColorIQ cGoldenRod = ColorIQ(hxGoldenRod);
const int hxGray = 0xFF808080;
final ColorIQ cGray = ColorIQ(hxGray);
const int hxGrey = hxGray;
final ColorIQ cGrey = cGray;
const int hxGreenHtml = 0xFF008000;
final ColorIQ cGreenHtml = ColorIQ(hxGreenHtml);
const HsvColor hsvGreen = HsvColor(120, 1.0, 1.0, hexId: hxGreenHtml);
const HslColor hslGreen = HslColor(120, 1.0, 0.5, hexId: hxGreenHtml);
const YiqColor yiqGreen = YiqColor(0.0, 0.0, 0.0, val: hxGreenHtml);
const YuvColor yuvGreen = YuvColor(0.0, 0.0, 0.0, val: hxGreenHtml); // Green
const LuvColor luvGreen = LuvColor(0, 0, 0, hexId: hxGreenHtml);
const CmykColor cmykGreen = CmykColor(0, 0, 0, 0, value: hxGreenHtml); // Green
const HwbColor hwbGreen = HwbColor(120, 0.0, 0.0, hexId: hxGreenHtml);
const int hxGreenYellow = 0xFFADFF2F;
final ColorIQ cGreenYellow = ColorIQ(hxGreenYellow);
const int hxHoneyDew = 0xFFF0FFF0;
const int hxHoneydew = hxHoneyDew;
final ColorIQ cHoneyDew = ColorIQ(hxHoneyDew);
const int hxHotPink = 0xFFFF69B4;
final ColorIQ cHotPink = ColorIQ(hxHotPink);
const int hxIndianRed = 0xFFCD5C5C;
final ColorIQ cIndianRed = ColorIQ(hxIndianRed);
const int hxIndigo = 0xFF4B0082;
final ColorIQ cIndigo = ColorIQ(hxIndigo);
const int hxIvory = 0xFFFFFFF0;
final ColorIQ cIvory = ColorIQ(hxIvory);
const int hxKhaki = 0xFFF0E68C;
const int hxLightKhaki = hxKhaki;
final ColorIQ cKhaki = ColorIQ(hxKhaki);
const int hxLavender = 0xFFE6E6FA;
final ColorIQ cLavender = ColorIQ(hxLavender);
const int hxLavenderBlush = 0xFFFFF0F5;
final ColorIQ cLavenderBlush = ColorIQ(hxLavenderBlush);
const int hxLawnGreen = 0xFF7CFC00;
final ColorIQ cLawnGreen = ColorIQ(hxLawnGreen);
const int hxLemonChiffon = 0xFFFFFACD;
final ColorIQ cLemonChiffon = ColorIQ(hxLemonChiffon);
const int hxLightBlue = 0xFFADD8E6;
final ColorIQ cLightBlue = ColorIQ(hxLightBlue);
const int hxLightCoral = 0xFFF08080;
final ColorIQ cLightCoral = ColorIQ(hxLightCoral);
const int hxLightCyanHtml = 0xE0FFFF;
final ColorIQ cLightCyanHtml = ColorIQ(hxLightCyanHtml, names: kLightCyan);
const int hxLightGoldenRodYellow = 0xFFFAFAD2;
final ColorIQ cLightGoldenRodYellow = ColorIQ(hxLightGoldenRodYellow);
const int hxLightGray = 0xFFD3D3D3;
final ColorIQ cLightGray = ColorIQ(hxLightGray, names: kLightGray);
const int hxLightGreen = 0xFF90EE90;
final ColorIQ cLightGreen = ColorIQ(hxLightGreen);
const int hxLightPink = 0xFFFFB6C1;
final ColorIQ cLightPink = ColorIQ(hxLightPink);
const int hxLightSalmon = 0xFFFFA07A;
final ColorIQ cLightSalmon = ColorIQ(hxLightSalmon);
const int hxLightSeaGreen = 0xFF20B2AA;
final ColorIQ cLightSeaGreen = ColorIQ(hxLightSeaGreen);
const int hxLightSkyBlue = 0xFF87CEFA;
final ColorIQ cLightSkyBlue = ColorIQ(hxLightSkyBlue);
const int hxLightSlateGray = 0xFF778899;
final ColorIQ cLightSlateGray = ColorIQ(hxLightSlateGray);
const int hxLightSlateGrey = 0xFF778899;
final ColorIQ cLightSlateGrey = ColorIQ(hxLightSlateGrey);
const int hxLightSteelBlue = 0xFFB0C4DE;
final ColorIQ cLightSteelBlue = ColorIQ(hxLightSteelBlue);
const int hxLightYellow = 0xFFFFFFE0;
final ColorIQ cLightYellow = ColorIQ(hxLightYellow);

const int hxLime = 0xFF00FF00; // same as ElectricLime
final ColorIQ cLime = ColorIQ(hxLime);
const int hxLimeGreen = 0xFF32CD32;
final ColorIQ cLimeGreen = ColorIQ(hxLimeGreen);
const int hxLinen = 0xFFFAF0E6;
final ColorIQ cLinen = ColorIQ(hxLinen);
const int hxMagenta = 0xFFFF00FF;
final ColorIQ cMagenta = ColorIQ(hxMagenta, names: kMagenta);
const int hxMaroon = 0xFF800000;
final ColorIQ cMaroon = ColorIQ(hxMaroon);
const int hxMediumAquaMarine = 0xFF66CDAA;
final ColorIQ cMediumAquaMarine = ColorIQ(hxMediumAquaMarine);
const int hxMediumBlue = 0xFF0000CD;
final ColorIQ cMediumBlue = ColorIQ(hxMediumBlue);
const int hxMediumOrchid = 0xFFBA55D3;
final ColorIQ cMediumOrchid = ColorIQ(hxMediumOrchid);
const int hxMediumPurple = 0xFF9370DB;
final ColorIQ cMediumPurple = ColorIQ(hxMediumPurple);
const int hxMediumSeaGreen = 0xFF3CB371;
final ColorIQ cMediumSeaGreen =
    ColorIQ(hxMediumSeaGreen, names: kMediumSeaGreen);
const int hxMediumSlateBlue = 0xFF7B68EE;
final ColorIQ cMediumSlateBlue =
    ColorIQ(hxMediumSlateBlue, names: kMediumSlateBlue);
const int hxMediumSpringGreen = 0xFF00FA9A;
final ColorIQ cMediumSpringGreen = ColorIQ(hxMediumSpringGreen);
const int hxMediumTurquoise = 0xFF48D1CC;
final ColorIQ cMediumTurquoise = ColorIQ(hxMediumTurquoise);
const int hxMediumVioletRed = 0xFFC71585;
final ColorIQ cMediumVioletRed = ColorIQ(hxMediumVioletRed);
const int hxMidnightBlueHtml = 0xFF191970;
final ColorIQ cMidnightBlueHtml = ColorIQ(hxMidnightBlueHtml);
const int hxMintCream = 0xFFF5FFFA;
final ColorIQ cMintCream = ColorIQ(hxMintCream);
const int hxMistyRose = 0xFFFFE4E1;
final ColorIQ cMistyRose = ColorIQ(hxMistyRose);
const int hxMoccasin = 0xFFFFE4B5;
final ColorIQ cMoccasin = ColorIQ(hxMoccasin);
const int hxNavajoWhite = 0xFFFFDEAD;
final ColorIQ cNavajoWhite = ColorIQ(hxNavajoWhite);
const int hxNavy = 0xFF000080;
final ColorIQ cNavy = ColorIQ(hxNavy);
const int hxOldLace = 0xFFFDF5E6;
final ColorIQ cOldLace = ColorIQ(hxOldLace);
const int hxOlive = 0xFF808000;
final ColorIQ cOlive = ColorIQ(hxOlive);
const int hxOliveDrab = 0xFF6B8E23;
final ColorIQ cOliveDrab = ColorIQ(hxOliveDrab);
const int hxOrangeHtml = 0xFFFFA500;
final ColorIQ cOrangeHtml = ColorIQ(hxOrangeHtml, names: kOrange);
const int hxOrangeRedHtml = 0xFFFF4500;
final ColorIQ cOrangeRedHtml = ColorIQ(hxOrangeRedHtml, names: kOrangeRed);
const int hxOrchid = 0xFFDA70D6;
final ColorIQ cOrchid = ColorIQ(hxOrchid);
const int hxPaleGoldenRod = 0xFFEEE8AA;
final ColorIQ cPaleGoldenRod = ColorIQ(hxPaleGoldenRod);
const int hxPaleGreen = 0xFF98FB98;
final ColorIQ cPaleGreen = ColorIQ(hxPaleGreen);
const int hxPaleTurquoise = 0xFFAFEEEE;
final ColorIQ cPaleTurquoise = ColorIQ(hxPaleTurquoise);
const int hxPaleVioletRed = 0xFFDB7093;
final ColorIQ cPaleVioletRed = ColorIQ(hxPaleVioletRed);
const int hxPapayaWhip = 0xFFFFEFD5;
final ColorIQ cPapayaWhip = ColorIQ(hxPapayaWhip);
const int hxPeachPuff = 0xFFFFDAB9;
final ColorIQ cPeachPuff = ColorIQ(hxPeachPuff);
const int hxPeru = 0xFFCD853F;
final ColorIQ cPeru = ColorIQ(hxPeru);
const int hxPink = 0xFFFFC0CB;
final ColorIQ cPink = ColorIQ(hxPink);
const int hxPlumHtml = 0xFFDDA0DD;
final ColorIQ cPlumHtml = ColorIQ(hxPlumHtml, names: kPlum);
const int hxPowderBlue = 0xFFB0E0E6;
final ColorIQ cPowderBlue = ColorIQ(hxPowderBlue, names: kPowderBlue);
const int hxPurpleHtml = 0xFF800080;
final ColorIQ cPurpleHtml = ColorIQ(hxPurple, names: kPurple);
const int hxRebeccaPurple = 0xFF663399;
final ColorIQ cRebeccaPurple = ColorIQ(hxRebeccaPurple);
const int hxRed = 0xFFFF0000;
final ColorIQ cRed = ColorIQ(hxRed);
const HslColor kHslRed =
    HslColor(0, 1.0, 0.5, hexId: hxRed, names: kRed); // Red
const HsvColor kHsvRed = HsvColor(0, 1.0, 1.0, hexId: hxRed, names: kRed);
const int hxRosyBrown = 0xFFBC8F8F;
final ColorIQ cRosyBrown = ColorIQ(hxRosyBrown);
const int hxRoyalBlue = 0xFF4169E1;
final ColorIQ cRoyalBlue = ColorIQ(hxRoyalBlue);
const int hxSaddleBrown = 0xFF8B4513;
final ColorIQ cSaddleBrown = ColorIQ(hxSaddleBrown);
const int hxSalmon = 0xFFFA8072;
final ColorIQ cSalmon = ColorIQ(hxSalmon);
const int hxSandyBrown = 0xFFF4A460;
final ColorIQ cSandyBrown = ColorIQ(hxSandyBrown);
const int hxSeaGreen = 0xFF2E8B57;
final ColorIQ cSeaGreen = ColorIQ(hxSeaGreen);
const int hxSeaShell = 0xFFFFF5EE;
final ColorIQ cSeaShell = ColorIQ(hxSeaShell);
const int hxSienna = 0xFFA0522D;
final ColorIQ cSienna = ColorIQ(hxSienna);
const int hxSilver = 0xFFC0C0C0;
final ColorIQ cSilver = ColorIQ(hxSilver);
const int hxSkyBlue = 0xFF87CEEB;
final ColorIQ cSkyBlue = ColorIQ(hxSkyBlue);
const int hxSlateBlue = 0xFF6A5ACD;
final ColorIQ cSlateBlue = ColorIQ(hxSlateBlue);
const int hxSlateGray = 0xFF708090;
final ColorIQ cSlateGray = ColorIQ(hxSlateGray, names: kSlateGray);
const int hxSlateGrey = 0xFF708090;
final ColorIQ cSlateGrey = ColorIQ(hxSlateGrey);
const int hxSnowHtml = 0xFFFAFAFA;
final ColorIQ cSnowHtml = ColorIQ(hxSnowHtml, names: kSnow);
const int hxSpringGreen = 0xFF00FF7F;
final ColorIQ cSpringGreen = ColorIQ(hxSpringGreen);
const int hxSteelBlue = 0xFF4682B4;
final ColorIQ cSteelBlue = ColorIQ(hxSteelBlue);
const int hxTan = 0xFFD2B48C;
final ColorIQ cTan = ColorIQ(hxTan);
const int hxTeal = 0xFF008080;
final ColorIQ cTeal = ColorIQ(hxTeal);
const int hxThistle = 0xFFD8BFD8;
final ColorIQ cThistle = ColorIQ(hxThistle, names: kThistle);
const int hxTomato = 0xFFFF6347;
final ColorIQ cTomato = ColorIQ(hxTomato);
const int hxTurquoise = 0xFF40E0D0;
final ColorIQ cTurquoise = ColorIQ(hxTurquoise, names: kTurquoise);
const int hxViolet = 0xFFEE82EE;
final ColorIQ cViolet = ColorIQ(hxViolet, names: kViolet);
const int hxWheat = 0xFFF5DEB3;
final ColorIQ cWheat = ColorIQ(hxWheat, names: kWheat);
const int hxWhite = 0xFFFFFFFF;
final ColorIQ cWhite = ColorIQ(hxWhite);
const HslColor kHslWhite = HslColor(0, 0, 1.0, hexId: hxWhite);
const CmykColor cmykWhite = CmykColor(0, 0, 0, 0, value: hxWhite); // White
const YiqColor yiqWhite = YiqColor(1.0, 1.0, 1.0, val: hxWhite);
const YuvColor yuvWhite = YuvColor(1.0, 1.0, 1.0, val: hxWhite); // White
const LuvColor luvWhite = LuvColor(100, 0, 0, hexId: hxWhite);
const int hxWhiteSmoke = 0xFFF5F5F5;
final ColorIQ cWhiteSmoke = ColorIQ(hxWhiteSmoke);
const int hxYellow = 0xFFFFFF00;
final ColorIQ cYellow = ColorIQ(hxYellow, names: kYellow);
const int hxYellowGreen = 0xFF9ACD32;
final ColorIQ cYellowGreen = ColorIQ(hxYellowGreen);

/// Standard HTML/CSS color names with their hex values
enum HTML {
  aliceBlue(hxAliceBlue, kAliceBlue, ColorFamilyHTML.blue),
  antiqueWhite(hxAntiqueWhite, kAntiqueWhite, ColorFamilyHTML.white),
  aqua(hxAqua, kAqua, ColorFamilyHTML.cyan),
  aquamarine(hxAquamarine, kAquamarine, ColorFamilyHTML.cyan),
  azure(hxAzure, kAzure, ColorFamilyHTML.cyan),
  beige(hxBeige, kBeige, ColorFamilyHTML.white),
  black(hxBlack, kBlack, ColorFamilyHTML.black),
  blanchedAlmond(hxBlanchedAlmond, kBlanchedAlmond, ColorFamilyHTML.white),
  chartreuse(hxChartreuse, kChartreuse, ColorFamilyHTML.green),
  chocolate(hxChocolate, kChocolate, ColorFamilyHTML.brown),
  coral(hxCoral, kCoral, ColorFamilyHTML.orange),
  cornflowerBlue(hxCornflowerBlue, kCornflowerBlue, ColorFamilyHTML.blue),
  cornsilk(hxCornSilk, kCornsilk, ColorFamilyHTML.white),
  crimson(hxCrimson, kCrimson, ColorFamilyHTML.red),
  cyan(hxCyan, kCyan, ColorFamilyHTML.cyan),
  darkBlue(hxDarkBlue, kDarkBlue, ColorFamilyHTML.blue),
  darkCyan(hxDarkCyan, kDarkCyan, ColorFamilyHTML.cyan),
  darkGoldenRod(hxDarkGoldenRod, kDarkGoldenRod, ColorFamilyHTML.yellow),
  darkGray(hxDarkGray, kDarkGray, ColorFamilyHTML.gray),
  darkGrey(hxDarkGray, kDarkGrey, ColorFamilyHTML.gray),
  darkGreen(hxDarkGreenHtml, kDarkGreen, ColorFamilyHTML.green),
  darkKhaki(hxDarkKhaki, kDarkKhaki, ColorFamilyHTML.yellow),
  darkMagenta(hxDarkMagenta, kDarkMagenta, ColorFamilyHTML.purple),
  darkOliveGreen(hxDarkOliveGreen, kDarkOliveGreen, ColorFamilyHTML.green),
  darkOrange(hxDarkOrange, kDarkOrange, ColorFamilyHTML.orange),
  darkOrchid(hxDarkOrchid, kDarkOrchid, ColorFamilyHTML.purple),
  darkRed(hxDarkRed, kDarkRed, ColorFamilyHTML.red),
  darkSalmon(hxDarkSalmon, kDarkSalmon, ColorFamilyHTML.orange),
  darkSeaGreen(hxDarkSeaGreen, kDarkSeaGreen, ColorFamilyHTML.green),
  darkSlateBlue(hxDarkSlateBlue, kDarkSlateBlue, ColorFamilyHTML.blue),
  darkSlateGray(hxDarkSlateGray, kDarkSlateGray, ColorFamilyHTML.gray),
  darkSlateGrey(hxDarkSlateGray, kDarkSlateGray, ColorFamilyHTML.gray),
  darkTurquoise(hxDarkTurquoise, kDarkTurquoise, ColorFamilyHTML.cyan),
  darkViolet(hxDarkViolet, kDarkViolet, ColorFamilyHTML.purple),
  deepPink(hxDeepPink, kDeepPink, ColorFamilyHTML.pink),
  deepSkyBlue(hxDeepSkyBlue, kDeepSkyBlue, ColorFamilyHTML.blue),
  dimGray(hxDimGray, kDimGray, ColorFamilyHTML.gray),
  dimGrey(hxDimGray, kDimGray, ColorFamilyHTML.gray),
  dodgerBlue(hxDodgerBlue, kDodgerBlue, ColorFamilyHTML.blue),
  fireBrick(hxFireBrick, kFireBrick, ColorFamilyHTML.red),
  floralWhite(hxFloralWhite, kFloralWhite, ColorFamilyHTML.white),
  forestGreen(hxForestGreen, kForestGreen, ColorFamilyHTML.green),
  fuchsia(hxFuchsia, kFuchsia, ColorFamilyHTML.purple),
  gainsboro(hxGainsboro, kGainsboro, ColorFamilyHTML.gray),
  ghostWhite(hxGhostWhite, kGhostWhite, ColorFamilyHTML.white),
  gold(hxGoldHtml, kGold, ColorFamilyHTML.yellow),
  goldenRod(hxGoldenRod, kGoldenRod, ColorFamilyHTML.yellow),
  gray(hxGray, kGray, ColorFamilyHTML.gray),
  grey(hxGray, kGray, ColorFamilyHTML.gray),
  green(hxGreenHtml, kGreen, ColorFamilyHTML.green),
  greenYellow(hxGreenYellow, kGreenYellow, ColorFamilyHTML.green),
  honeyDew(hxHoneyDew, kHoneyDew, ColorFamilyHTML.white),
  hotPink(hxHotPink, kHotPink, ColorFamilyHTML.pink),
  indianRed(hxIndianRed, kIndianRed, ColorFamilyHTML.red),
  indigo(0xFF4B0082, kIndigo, ColorFamilyHTML.purple),
  ivory(hxIvory, kIvory, ColorFamilyHTML.white),
  khaki(hxKhaki, kKhaki, ColorFamilyHTML.yellow),
  lavender(hxLavender, kLavender, ColorFamilyHTML.purple),
  lavenderBlush(hxLavenderBlush, kLavenderBlush, ColorFamilyHTML.pink),
  lawnGreen(hxLawnGreen, kLawnGreen, ColorFamilyHTML.green),
  lemonChiffon(hxLemonChiffon, kLemonChiffon, ColorFamilyHTML.yellow),
  lightBlue(hxLightBlue, kLightBlue, ColorFamilyHTML.blue),
  lightCoral(hxLightCoral, kLightCoral, ColorFamilyHTML.orange),
  lightCyan(hxLightCyanHtml, kLightCyan, ColorFamilyHTML.cyan),
  lightGoldenRodYellow(
      hxLightGoldenRodYellow, kLightGoldenRodYellow, ColorFamilyHTML.yellow),
  lightGray(hxLightGray, kLightGray, ColorFamilyHTML.gray),
  lightGrey(hxLightGray, kLightGray, ColorFamilyHTML.gray),
  lightGreen(hxLightGreen, kLightGreen, ColorFamilyHTML.green),
  lightPink(hxLightPink, kLightPink, ColorFamilyHTML.pink),
  lightSalmon(hxLightSalmon, kLightSalmon, ColorFamilyHTML.orange),
  lightSeaGreen(hxLightSeaGreen, kLightSeaGreen, ColorFamilyHTML.green),
  lightSkyBlue(hxLightSkyBlue, kLightSkyBlue, ColorFamilyHTML.blue),
  lightSlateGray(hxLightSlateGray, kLightSlateGray, ColorFamilyHTML.gray),
  lightSlateGrey(hxLightSlateGray, kLightSlateGray, ColorFamilyHTML.gray),
  lightSteelBlue(hxLightSteelBlue, kLightSteelBlue, ColorFamilyHTML.blue),
  lightYellow(hxLightYellow, kLightYellow, ColorFamilyHTML.yellow),
  lime(hxLime, kLime, ColorFamilyHTML.green),
  limeGreen(hxLimeGreen, kLimeGreen, ColorFamilyHTML.green),
  linen(hxLinen, kLinen, ColorFamilyHTML.white),
  magenta(hxMagenta, kMagenta, ColorFamilyHTML.purple),
  maroon(hxMaroon, kMaroon, ColorFamilyHTML.red),
  mediumAquaMarine(hxMediumAquaMarine, kMediumAquaMarine, ColorFamilyHTML.cyan),
  mediumBlue(hxMediumBlue, kMediumBlue, ColorFamilyHTML.blue),
  mediumOrchid(hxMediumOrchid, kMediumOrchid, ColorFamilyHTML.purple),
  mediumPurple(hxMediumPurple, kMediumPurple, ColorFamilyHTML.purple),
  mediumSeaGreen(hxMediumSeaGreen, kMediumSeaGreen, ColorFamilyHTML.green),
  mediumSlateBlue(hxMediumSlateBlue, kMediumSlateBlue, ColorFamilyHTML.blue),
  mediumSpringGreen(
      hxMediumSpringGreen, kMediumSpringGreen, ColorFamilyHTML.green),
  mediumTurquoise(hxMediumTurquoise, kMediumTurquoise, ColorFamilyHTML.cyan),
  mediumVioletRed(hxMediumVioletRed, kMediumVioletRed, ColorFamilyHTML.pink),
  midnightBlue(hxMidnightBlueHtml, kMidnightBlue, ColorFamilyHTML.blue),
  mintCream(hxMintCream, kMintCream, ColorFamilyHTML.white),
  mistyRose(hxMistyRose, kMistyRose, ColorFamilyHTML.pink),
  moccasin(hxMoccasin, kMoccasin, ColorFamilyHTML.orange),
  navajoWhite(hxNavajoWhite, kNavajoWhite, ColorFamilyHTML.orange),
  navy(hxNavy, kNavy, ColorFamilyHTML.blue),
  oldLace(hxOldLace, kOldLace, ColorFamilyHTML.white),
  olive(hxOlive, kOlive, ColorFamilyHTML.green),
  oliveDrab(hxOliveDrab, kOliveDrab, ColorFamilyHTML.green),
  orange(hxOrangeHtml, kOrange, ColorFamilyHTML.orange),
  orangeRed(hxOrangeRedHtml, kOrangeRed, ColorFamilyHTML.orange),
  orchid(hxOrchid, kOrchid, ColorFamilyHTML.purple),
  paleGoldenRod(hxPaleGoldenRod, kPaleGoldenRod, ColorFamilyHTML.yellow),
  paleGreen(hxPaleGreen, kPaleGreen, ColorFamilyHTML.green),
  paleTurquoise(hxPaleTurquoise, kPaleTurquoise, ColorFamilyHTML.cyan),
  paleVioletRed(hxPaleVioletRed, kPaleVioletRed, ColorFamilyHTML.pink),
  papayaWhip(hxPapayaWhip, kPapayaWhip, ColorFamilyHTML.orange),
  peachPuff(hxPeachPuff, kPeachPuff, ColorFamilyHTML.orange),
  peru(hxPeru, kPeru, ColorFamilyHTML.orange),
  pink(hxPink, kPink, ColorFamilyHTML.pink),
  plum(hxPlumHtml, kPlum, ColorFamilyHTML.purple),
  powderBlue(hxPowderBlue, kPowderBlue, ColorFamilyHTML.blue),
  purple(hxPurple, kPurple, ColorFamilyHTML.purple),
  rebeccaPurple(hxRebeccaPurple, kRebeccaPurple, ColorFamilyHTML.purple),
  red(hxRed, kRed, ColorFamilyHTML.red),
  rosyBrown(hxRosyBrown, kRosyBrown, ColorFamilyHTML.brown),
  royalBlue(hxRoyalBlue, kRoyalBlue, ColorFamilyHTML.blue),
  saddleBrown(hxSaddleBrown, kSaddleBrown, ColorFamilyHTML.brown),
  salmon(hxSalmon, kSalmon, ColorFamilyHTML.orange),
  sandyBrown(hxSandyBrown, kSandyBrown, ColorFamilyHTML.orange),
  seaGreen(hxSeaGreen, kSeaGreen, ColorFamilyHTML.green),
  seaShell(hxSeaShell, kSeaShell, ColorFamilyHTML.white),
  sienna(hxSienna, kSienna, ColorFamilyHTML.brown),
  silver(hxSilver, kSilver, ColorFamilyHTML.gray),
  skyBlue(hxSkyBlue, kSkyBlue, ColorFamilyHTML.blue),
  slateBlue(hxSlateBlue, kSlateBlue, ColorFamilyHTML.blue),
  slateGray(hxSlateGray, kSlateGray, ColorFamilyHTML.gray),
  slateGrey(hxSlateGray, kSlateGray, ColorFamilyHTML.gray),
  snow(hxSnowHtml, kSnow, ColorFamilyHTML.white),
  springGreen(hxSpringGreen, kSpringGreen, ColorFamilyHTML.green),
  steelBlue(hxSteelBlue, kSteelBlue, ColorFamilyHTML.blue),
  tan(hxTan, kTan, ColorFamilyHTML.brown),
  teal(hxTeal, kTeal, ColorFamilyHTML.cyan),
  thistle(hxThistle, kThistle, ColorFamilyHTML.purple),
  tomato(hxTomato, kTomato, ColorFamilyHTML.red),
  turquoise(hxTurquoise, kTurquoise, ColorFamilyHTML.cyan),
  violet(hxViolet, kViolet, ColorFamilyHTML.purple),
  wheat(hxWheat, kWheat, ColorFamilyHTML.brown),
  white(hxWhite, kWhite, ColorFamilyHTML.white),
  whiteSmoke(hxWhiteSmoke, kWhiteSmoke, ColorFamilyHTML.white),
  yellow(hxYellow, kYellow, ColorFamilyHTML.yellow),
  yellowGreen(hxYellowGreen, kYellowGreen, ColorFamilyHTML.green);

  final int value;
  final List<String> names;
  final ColorFamilyHTML family;
  const HTML(this.value, this.names, this.family);
  int get hexId => value;
  String get hexString =>
      '0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')})';
}
