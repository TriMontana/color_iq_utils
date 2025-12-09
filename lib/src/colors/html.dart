import 'package:color_iq_utils/src/color_models_lib.dart';
import 'package:color_iq_utils/src/colors/encycolorpedia.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:material_color_utilities/hct/hct.dart';

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
final ColorIQ cAqua = ColorIQ(hxAqua, names: kAqua);
const int hxAquamarine = 0xFF7FFFD4;
final ColorIQ cAquamarine = ColorIQ(hxAquamarine, names: kAquamarine);
const int hxBeige = 0xFFF5F5DC;
final ColorIQ cBeige = ColorIQ(hxBeige, names: kBeige);
const int hxBisque = 0xFFFFE4C4;
final ColorIQ cBisque = ColorIQ(hxBisque, names: kBisque);
const int hxBlack = 0xFF000000;
final HtmlColor cBlack =
    HtmlColor(hxBlack, names: kBlack, hctColor: Hct.from(0, 0, 0));
const HSL kHslBlack = HSL(0, 0, 0, hexId: hxBlack, names: kBlack);
const LuvColor luvBlack = LuvColor(0, 0, 0, hexId: hxBlack, names: kBlack);
const int hxBlanchedAlmond = 0xFFFFEBCD;
final ColorIQ cBlanchedAlmond =
    ColorIQ(hxBlanchedAlmond, names: kBlanchedAlmond);
const int hxBlue = 0xFF0000FF;
final HtmlColor cBlue =
    HtmlColor(hxBlue, names: kBlue, hctColor: Hct.from(266, 87, 32));
const int hxBlueViolet = 0xFF8A2BE2;
final HtmlColor cBlueViolet = HtmlColor(hxBlueViolet,
    names: kBlueViolet, hctColor: Hct.from(292, 102, 41));
const int hxBrownHtml = 0xFFA52A2A;
final HtmlColor cBrownHtml =
    HtmlColor(hxBrownHtml, names: kBrown, hctColor: Hct.from(28, 46, 38));
const int hxBurlyWood = 0xFFDEB887;
final HtmlColor cBurlyWood =
    HtmlColor(hxBurlyWood, names: kBurlyWood, hctColor: Hct.from(76, 36, 75));
final HtmlColor cBurlywood = cBurlyWood;
const int hxCadetBlue = 0xFF5F9EA0;
final HtmlColor cCadetBlue =
    HtmlColor(hxCadetBlue, names: kCadetBlue, hctColor: Hct.from(223, 21, 61));
const int hxChartreuse = 0xFF7FFF00;
final HtmlColor cChartreuse = HtmlColor(hxChartreuse,
    names: kChartreuse, hctColor: Hct.from(118, 115, 86));
const int hxChocolate = 0xFFD2691E;
final HtmlColor cChocolate =
    HtmlColor(hxChocolate, names: kChocolate, hctColor: Hct.from(46, 74, 54));
const int hxCoral = 0xFFFF7F50;
final HtmlColor cCoral =
    HtmlColor(hxCoral, names: kCoral, hctColor: Hct.from(43, 83, 64));
const int hxCornflowerBlue = 0xFF6495ED;
final HtmlColor cCornflowerBlue = HtmlColor(hxCornflowerBlue,
    names: kCornflowerBlue, hctColor: Hct.from(258, 39, 62));
const int hxCornSilk = 0xFFFFF8DC;
final ColorIQ cCornSilk = ColorIQ(hxCornSilk, names: kCornsilk);
const int hxCrimson = 0xFFDC143C;
final ColorIQ cCrimson = ColorIQ(hxCrimson, names: kCrimson);
const int hxCyan = 0xFF00FFFF;
final HtmlColor cCyan =
    HtmlColor(hxCyan, names: kCyan, hctColor: Hct.from(192, 58, 91));
const int hxDarkBlue = 0xFF00008B;
final HtmlColor cDarkBlue =
    HtmlColor(hxDarkBlue, names: kDarkBlue, hctColor: Hct.from(274, 54, 12));
const int hxDarkCyan = 0xFF008B8B;
final ColorIQ cDarkCyan = ColorIQ(hxDarkCyan, names: kDarkCyan);
const int hxDarkGoldenRod = 0xFFB8860B;
final ColorIQ cDarkGoldenRod = ColorIQ(hxDarkGoldenRod, names: kDarkGoldenRod);
const int hxDarkGray = 0xFFA9A9A9;
final ColorIQ cDarkGray = ColorIQ(hxDarkGray, names: kDarkGray);
const int hxDarkGreenHtml = 0xFF006400;
final ColorIQ cDarkGreenHtml = ColorIQ(hxDarkGreenHtml, names: kDarkGreen);
const int hxDarkKhaki = 0xFFBDB76B;
final ColorIQ cDarkKhaki = ColorIQ(hxDarkKhaki, names: kDarkKhaki);
const int hxDarkMagenta = 0xFF8B008B;
final ColorIQ cDarkMagenta = ColorIQ(hxDarkMagenta, names: kDarkMagenta);
const int hxDarkOliveGreen = 0xFF556B2F;
final ColorIQ cDarkOliveGreen =
    ColorIQ(hxDarkOliveGreen, names: kDarkOliveGreen);
const int hxDarkOrange = 0xFFFF8C00;
final ColorIQ cDarkOrange = ColorIQ(hxDarkOrange, names: kDarkOrange);
const int hxDarkOrchid = 0xFF9932CC;
final ColorIQ cDarkOrchid = ColorIQ(hxDarkOrchid, names: kDarkOrchid);
const int hxDarkRed = 0xFF8B0000;
final HtmlColor cDarkRed =
    HtmlColor(hxDarkRed, names: kDarkRed, hctColor: Hct.from(25, 92, 29));
const int hxDarkSalmon = 0xFFE9967A;
final ColorIQ cDarkSalmon = ColorIQ(hxDarkSalmon, names: kDarkSalmon);
const int hxDarkSeaGreen = 0xFF8FBC8F;
final ColorIQ cDarkSeaGreen = ColorIQ(hxDarkSeaGreen, names: kDarkSeaGreen);
const int hxDarkSlateBlue = 0xFF483D8B;
final ColorIQ cDarkSlateBlue = ColorIQ(hxDarkSlateBlue, names: kDarkSlateBlue);
const int hxDarkSlateGray = 0xFF2F4F4F;
final ColorIQ cDarkSlateGray = ColorIQ(hxDarkSlateGray, names: kDarkSlateGray);
const int hxDarkTurquoise = 0xFF00CED1;
final ColorIQ cDarkTurquoise = ColorIQ(hxDarkTurquoise, names: kDarkTurquoise);
const int hxDarkViolet = 0xFF9400D3;
final ColorIQ cDarkViolet = ColorIQ(hxDarkViolet, names: kDarkViolet);
const int hxDarkYellowHtml = 0xFF8B8B00;
final ColorIQ cDarkYellowHtml = ColorIQ(hxDarkYellowHtml, names: kDarkYellow);
const int hxDeepPink = 0xFFFF1493;
final ColorIQ cDeepPink = ColorIQ(hxDeepPink, names: kDeepPink);
const int hxDeepSkyBlue = 0xFF00BFFF;
final ColorIQ cDeepSkyBlue = ColorIQ(hxDeepSkyBlue, names: kDeepSkyBlue);
const int hxDimGray = 0xFF696969;
final ColorIQ cDimGray = ColorIQ(hxDimGray, names: kDimGray);
const int hxDimGrey = 0xFF696969;
final ColorIQ cDimGrey = ColorIQ(hxDimGrey, names: kDimGrey);
const int hxDodgerBlue = 0xFF1E90FF;
final ColorIQ cDodgerBlue = ColorIQ(hxDodgerBlue, names: kDodgerBlue);
const int hxFireBrick = 0xFFB22222;
final ColorIQ cFireBrick = ColorIQ(hxFireBrick, names: kFireBrick);
const int hxFloralWhite = 0xFFFFFAF0;
final ColorIQ cFloralWhite = ColorIQ(hxFloralWhite, names: kFloralWhite);
const int hxForestGreen = 0xFF228B22;
final ColorIQ cForestGreen = ColorIQ(hxForestGreen, names: kForestGreen);
const int hxFuchsia = 0xFFFF00FF;
final ColorIQ cFuchsia = ColorIQ(hxFuchsia, names: kFuchsia);
const int hxGainsboro = 0xFFDCDCDC;
final ColorIQ cGainsboro = ColorIQ(hxGainsboro, names: kGainsboro);
const int hxGhostWhite = 0xFFF8F8FF;
final ColorIQ cGhostWhite = ColorIQ(hxGhostWhite, names: kGhostWhite);
const int hxGoldHtml = 0xFFFFD700;
final ColorIQ cGoldHtml = ColorIQ(hxGoldHtml, names: kGold);
const int hxGoldenRod = 0xFFDAA520;
final ColorIQ cGoldenRod = ColorIQ(hxGoldenRod, names: kGoldenRod);
const int hxGray = 0xFF808080;
final HtmlColor cGray =
    HtmlColor(hxGray, names: kGray, hctColor: Hct.from(209, 0, 54));
const int hxGrey = hxGray;
final ColorIQ cGrey = cGray;
const int hxGreenHtml = 0xFF008000;
final HtmlColor cGreenHtml =
    HtmlColor(hxGreenHtml, names: kGreen, hctColor: Hct.from(142, 71, 46));
const HSV hsvGreen =
    HSV(120, Percent.max, Percent.max, hexId: hxGreenHtml, names: kGreen);
const HSL hslGreen =
    HSL(120, Percent.max, Percent.mid, hexId: hxGreenHtml, names: kGreen);

const int hxGreenYellow = 0xFFADFF2F;
final ColorIQ cGreenYellow = ColorIQ(hxGreenYellow, names: kGreenYellow);
const int hxHoneyDew = 0xFFF0FFF0;
const int hxHoneydew = hxHoneyDew;
final ColorIQ cHoneyDew = ColorIQ(hxHoneyDew, names: kHoneyDew);
const int hxHotPink = 0xFFFF69B4;
final ColorIQ cHotPink = ColorIQ(hxHotPink, names: kHotPink);
const int hxIndianRed = 0xFFCD5C5C;
final ColorIQ cIndianRed = ColorIQ(hxIndianRed, names: kIndianRed);
const int hxIndigo = 0xFF4B0082;
final ColorIQ cIndigo = ColorIQ(hxIndigo, names: kIndigo);
const int hxIvory = 0xFFFFFFF0;
final HtmlColor cIvory =
    HtmlColor(hxIvory, names: kIvory, hctColor: Hct.from(108, 5, 99));
const int hxKhaki = 0xFFF0E68C;
const int hxLightKhaki = hxKhaki;
final ColorIQ cKhaki = ColorIQ(hxKhaki, names: kKhaki);
const int hxLavender = 0xFFE6E6FA;
final ColorIQ cLavender = ColorIQ(hxLavender, names: kLavender);
const int hxLavenderBlush = 0xFFFFF0F5;
final ColorIQ cLavenderBlush = ColorIQ(hxLavenderBlush, names: kLavenderBlush);
const int hxLawnGreen = 0xFF7CFC00;
final ColorIQ cLawnGreen = ColorIQ(hxLawnGreen, names: kLawnGreen);
const int hxLemonChiffon = 0xFFFFFACD;
final ColorIQ cLemonChiffon = ColorIQ(hxLemonChiffon, names: kLemonChiffon);
const int hxLightBlue = 0xFFADD8E6;
final ColorIQ cLightBlue = ColorIQ(hxLightBlue, names: kLightBlue);
const int hxLightCoral = 0xFFF08080;
final ColorIQ cLightCoral = ColorIQ(hxLightCoral, names: kLightCoral);
const int hxLightCyanHtml = 0xE0FFFF;
final ColorIQ cLightCyanHtml = ColorIQ(hxLightCyanHtml, names: kLightCyan);
const int hxLightGoldenRodYellow = 0xFFFAFAD2;
final ColorIQ cLightGoldenRodYellow =
    ColorIQ(hxLightGoldenRodYellow, names: kLightGoldenRodYellow);
const int hxLightGray = 0xFFD3D3D3;
final ColorIQ cLightGray = ColorIQ(hxLightGray, names: kLightGray);
const int hxLightGreen = 0xFF90EE90;
final ColorIQ cLightGreen = ColorIQ(hxLightGreen, names: kLightGreen);
const int hxLightPink = 0xFFFFB6C1;
final ColorIQ cLightPink = ColorIQ(hxLightPink, names: kLightPink);
const int hxLightSalmon = 0xFFFFA07A;
final ColorIQ cLightSalmon = ColorIQ(hxLightSalmon, names: kLightSalmon);
const int hxLightSeaGreen = 0xFF20B2AA;
final ColorIQ cLightSeaGreen = ColorIQ(hxLightSeaGreen, names: kLightSeaGreen);
const int hxLightSkyBlue = 0xFF87CEFA;
final ColorIQ cLightSkyBlue = ColorIQ(hxLightSkyBlue, names: kLightSkyBlue);
const int hxLightSlateGray = 0xFF778899;
final ColorIQ cLightSlateGray =
    ColorIQ(hxLightSlateGray, names: kLightSlateGray);
const int hxLightSlateGrey = 0xFF778899;
final ColorIQ cLightSlateGrey =
    ColorIQ(hxLightSlateGrey, names: kLightSlateGrey);
const int hxLightSteelBlue = 0xFFB0C4DE;
final ColorIQ cLightSteelBlue =
    ColorIQ(hxLightSteelBlue, names: kLightSteelBlue);
const int hxLightYellow = 0xFFFFFFE0;
final ColorIQ cLightYellow = ColorIQ(hxLightYellow, names: kLightYellow);

const int hxLime = 0xFF00FF00; // same as ElectricLime
final ColorIQ cLime = ColorIQ(hxLime, names: kLime);
const int hxLimeGreen = 0xFF32CD32;
final ColorIQ cLimeGreen = ColorIQ(hxLimeGreen, names: kLimeGreen);
const int hxLinen = 0xFFFAF0E6;
final ColorIQ cLinen = ColorIQ(hxLinen, names: kLinen);
const int hxMagenta = 0xFFFF00FF;
final HtmlColor cMagenta =
    HtmlColor(hxMagenta, names: kMagenta, hctColor: Hct.from(326, 127, 60));
const int hxMaroon = 0xFF800000;
final HtmlColor cMaroon =
    HtmlColor(hxMaroon, names: kMaroon, hctColor: Hct.from(23, 52, 26));
const int hxMediumAquaMarine = 0xFF66CDAA;
final ColorIQ cMediumAquaMarine =
    ColorIQ(hxMediumAquaMarine, names: kMediumAquaMarine);
const int hxMediumBlue = 0xFF0000CD;
final ColorIQ cMediumBlue = ColorIQ(hxMediumBlue, names: kMediumBlue);
const int hxMediumOrchid = 0xFFBA55D3;
final ColorIQ cMediumOrchid = ColorIQ(hxMediumOrchid, names: kMediumOrchid);
const int hxMediumPurple = 0xFF9370DB;
final ColorIQ cMediumPurple = ColorIQ(hxMediumPurple, names: kMediumPurple);
const int hxMediumSeaGreen = 0xFF3CB371;
final ColorIQ cMediumSeaGreen =
    ColorIQ(hxMediumSeaGreen, names: kMediumSeaGreen);
const int hxMediumSlateBlue = 0xFF7B68EE;
final ColorIQ cMediumSlateBlue =
    ColorIQ(hxMediumSlateBlue, names: kMediumSlateBlue);
const int hxMediumSpringGreen = 0xFF00FA9A;
final ColorIQ cMediumSpringGreen =
    ColorIQ(hxMediumSpringGreen, names: kMediumSpringGreen);
const int hxMediumTurquoise = 0xFF48D1CC;
final ColorIQ cMediumTurquoise =
    ColorIQ(hxMediumTurquoise, names: kMediumTurquoise);
const int hxMediumVioletRed = 0xFFC71585;
final ColorIQ cMediumVioletRed =
    ColorIQ(hxMediumVioletRed, names: kMediumVioletRed);
const int hxMidnightBlueHtml = 0xFF191970;
final ColorIQ cMidnightBlueHtml =
    ColorIQ(hxMidnightBlueHtml, names: kMidnightBlue);
const int hxMintCream = 0xFFF5FFFA;
final HtmlColor cMintCream =
    HtmlColor(hxMintCream, names: kMintCream, hctColor: Hct.from(155, 5, 98));
const int hxMistyRose = 0xFFFFE4E1;
final HtmlColor cMistyRose =
    HtmlColor(hxMistyRose, names: kMistyRose, hctColor: Hct.from(13, 11, 91));
const int hxMoccasin = 0xFFFFE4B5;
final HtmlColor cMoccasin =
    HtmlColor(hxMoccasin, names: kMoccasin, hctColor: Hct.from(83, 32, 90));
const int hxNavajoWhite = 0xFFFFDEAD;
final ColorIQ cNavajoWhite = ColorIQ(hxNavajoWhite, names: kNavajoWhite);
const int hxNavy = 0xFF000080;
final HtmlColor cNavy =
    HtmlColor(hxNavy, names: kNavy, hctColor: Hct.from(273, 47, 13));
const int hxOldLace = 0xFFFDF5E6;
final ColorIQ cOldLace = ColorIQ(hxOldLace, names: kOldLace);
const int hxOlive = 0xFF808000;
final HtmlColor cOlive =
    HtmlColor(hxOlive, names: kOlive, hctColor: Hct.from(112, 55, 53));
const int hxOliveDrab = 0xFF6B8E23;
final ColorIQ cOliveDrab = ColorIQ(hxOliveDrab, names: kOliveDrab);
const int hxOrangeHtml = 0xFFFFA500;
final HtmlColor cOrangeHtml =
    HtmlColor(hxOrangeHtml, names: kOrange, hctColor: Hct.from(68, 85, 76));
// https://encycolorpedia.com/ff4500
const int hxOrangeRedHtml = 0xFFFF4500;
final HtmlColor cOrangeRedHtml = HtmlColor(hxOrangeRedHtml,
    names: kOrangeRed, hctColor: Hct.from(34, 95, 58));
final HtmlColor cRedOrange = cOrangeRedHtml;
const int hxOrchid = 0xFFDA70D6;
final ColorIQ cOrchid = ColorIQ(hxOrchid, names: kOrchid);
const int hxPaleGoldenRod = 0xFFEEE8AA;
final ColorIQ cPaleGoldenRod = ColorIQ(hxPaleGoldenRod, names: kPaleGoldenRod);
const int hxPaleGreen = 0xFF98FB98;
final ColorIQ cPaleGreen = ColorIQ(hxPaleGreen, names: kPaleGreen);
const int hxPaleTurquoise = 0xFFAFEEEE;
final ColorIQ cPaleTurquoise = ColorIQ(hxPaleTurquoise, names: kPaleTurquoise);
const int hxPaleVioletRed = 0xFFDB7093;
final ColorIQ cPaleVioletRed = ColorIQ(hxPaleVioletRed, names: kPaleVioletRed);
const int hxPapayaWhip = 0xFFFFEFD5;
final ColorIQ cPapayaWhip = ColorIQ(hxPapayaWhip, names: kPapayaWhip);
const int hxPeachPuff = 0xFFFFDAB9;
final HtmlColor cPeachPuff =
    HtmlColor(hxPeachPuff, names: kPeachPuff, hctColor: Hct.from(72, 27, 88));
const int hxPeru = 0xFFCD853F;
final HtmlColor cPeru =
    HtmlColor(hxPeru, names: kPeru, hctColor: Hct.from(55, 57, 62));
const int hxPink = 0xFFFFC0CB;
final HtmlColor cPink =
    HtmlColor(hxPink, names: kPink, hctColor: Hct.from(21, 30, 83));
const int hxPlumHtml = 0xFFDDA0DD;
final HtmlColor cPlumHtml =
    HtmlColor(hxPlumHtml, names: kPlum, hctColor: Hct.from(316, 32, 74));
const int hxPowderBlue = 0xFFB0E0E6;
final HtmlColor cPowderBlue = HtmlColor(hxPowderBlue,
    names: kPowderBlue, hctColor: Hct.from(221, 24, 87));
const int hxPurpleHtml = 0xFF800080;
final HtmlColor cPurpleHtml =
    HtmlColor(hxPurpleHtml, names: kPurple, hctColor: Hct.from(335, 70, 30));
const int hxRebeccaPurple = 0xFF663399;
final ColorIQ cRebeccaPurple = ColorIQ(hxRebeccaPurple, names: kRebeccaPurple);
const int hxRed = 0xFFFF0000;
final HtmlColor cRed =
    HtmlColor(hxRed, names: kRed, hctColor: Hct.from(27, 113, 53));
const HSL kHslRed =
    HSL(0, Percent.max, Percent.mid, hexId: hxRed, names: kRed); // Red
const HSV kHsvRed = HSV(0, Percent.max, Percent.max, hexId: hxRed, names: kRed);
const int hxRosyBrown = 0xFFBC8F8F;
final ColorIQ cRosyBrown = ColorIQ(hxRosyBrown, names: kRosyBrown);
const int hxRoyalBlue = 0xFF4169E1;
final ColorIQ cRoyalBlue = ColorIQ(hxRoyalBlue, names: kRoyalBlue);
const int hxSaddleBrown = 0xFF8B4513;
final ColorIQ cSaddleBrown = ColorIQ(hxSaddleBrown, names: kSaddleBrown);
const int hxSalmon = 0xFFFA8072;
final HtmlColor cSalmon =
    HtmlColor(hxSalmon, names: kSalmon, hctColor: Hct.from(33, 59, 66));
const int hxSandyBrown = 0xFFF4A460;
final ColorIQ cSandyBrown = ColorIQ(hxSandyBrown, names: kSandyBrown);
const int hxSeaGreen = 0xFF2E8B57;
final ColorIQ cSeaGreen = ColorIQ(hxSeaGreen, names: kSeaGreen);
const int hxSeaShell = 0xFFFFF5EE;
final ColorIQ cSeaShell = ColorIQ(hxSeaShell, names: kSeaShell);
const int hxSienna = 0xFFA0522D;
final ColorIQ cSienna = ColorIQ(hxSienna, names: kSienna);
const int hxSilver = 0xFFC0C0C0;
final HtmlColor cSilver =
    HtmlColor(hxSilver, names: kSilver, hctColor: Hct.from(209, 0, 78));
const int hxSkyBlue = 0xFF87CEEB;
final ColorIQ cSkyBlue = ColorIQ(hxSkyBlue, names: kSkyBlue);
const int hxSlateBlue = 0xFF6A5ACD;
final ColorIQ cSlateBlue = ColorIQ(hxSlateBlue, names: kSlateBlue);
const int hxSlateGray = 0xFF708090;
final ColorIQ cSlateGray = ColorIQ(hxSlateGray, names: kSlateGray);
const int hxSlateGrey = 0xFF708090;
final ColorIQ cSlateGrey = ColorIQ(hxSlateGrey, names: kSlateGrey);
const int hxSnowHtml = 0xFFFAFAFA;
final ColorIQ cSnowHtml = ColorIQ(hxSnowHtml, names: kSnow);
const int hxSpringGreen = 0xFF00FF7F;
final ColorIQ cSpringGreen = ColorIQ(hxSpringGreen, names: kSpringGreen);
const int hxSteelBlue = 0xFF4682B4;
final ColorIQ cSteelBlue = ColorIQ(hxSteelBlue, names: kSteelBlue);
const int hxTan = 0xFFD2B48C;
final ColorIQ cTan = ColorIQ(hxTan, names: kTan);
const int hxTeal = 0xFF008080;
final HtmlColor cTeal =
    HtmlColor(hxTeal, names: kTeal, hctColor: Hct.from(194, 30, 48));
const int hxThistle = 0xFFD8BFD8;
final ColorIQ cThistle = ColorIQ(hxThistle, names: kThistle);
const int hxTomato = 0xFFFF6347;
final ColorIQ cTomato = ColorIQ(hxTomato, names: kTomato);
const int hxTurquoise = 0xFF40E0D0;
final ColorIQ cTurquoise = ColorIQ(hxTurquoise, names: kTurquoise);
const int hxViolet = 0xFFEE82EE;
final ColorIQ cViolet = ColorIQ(hxViolet, names: kViolet);
const int hxWheat = 0xFFF5DEB3;
final ColorIQ cWheat = ColorIQ(hxWheat, names: kWheat);
const int hxWhite = 0xFFFFFFFF;
final HtmlColor cWhite =
    HtmlColor(hxWhite, names: kWhite, hctColor: Hct.from(209, 0, 100));
const HSL kHslWhite =
    HSL(0, Percent.zero, Percent.max, hexId: hxWhite, lrv: Percent.max);
const CMYK cmykWhite = CMYK(0, 0, 0, 0, value: hxWhite); // White

const int hxWhiteSmoke = 0xFFF5F5F5;
final ColorIQ cWhiteSmoke = ColorIQ(hxWhiteSmoke, names: kWhiteSmoke);
// https://encycolorpedia.com/ffff00
const int hxYellow = 0xFFFFFF00;
final HtmlColor cYellow =
    HtmlColor(hxYellow, names: kYellow, hctColor: Hct.from(100, 97, 98));
const int hxYellowGreen = 0xFF9ACD32;
final ColorIQ cYellowGreen = ColorIQ(hxYellowGreen, names: kYellowGreen);

/// Standard HTML/CSS color names with their hex values
enum HtmlEN {
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
  const HtmlEN(this.value, this.names, this.family);
  int get hexId => value;
  String get hexString =>
      '0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')})';
}
