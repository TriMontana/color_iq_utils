import 'package:color_iq_utils/src/color_models_lib.dart';
import 'package:color_iq_utils/src/colors/encycolorpedia.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/maps/registry.dart';

typedef TdHtml = HTML Function();

class HTML extends ColorIQ implements ColorWheelInf {
  HTML(super.argb,
      {required super.names,
      required HctData super.hct,
      super.argbColor,
      super.alphaInt,
      super.red,
      super.green,
      super.blue,
      super.lrv,
      super.brightness,
      super.hsv,
      super.colorSpace});
}

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
final HTML cAliceBlue = HTML(
  hxAliceBlue,
  names: kAliceBlue,
  hct: const HctData(234.34451, 8.7741, 97.17891),
  lrv: const Percent(0.928801),
  brightness: Brightness.light,
);
const int hxAntiqueWhite = 0xFFFAEBD7;
final HTML cAntiqueWhite = HTML(hxAntiqueWhite,
    names: kAntiqueWhite,
    hct: const HctData(81.50196, 8.9519, 93.73077),
    lrv: const Percent(0.84647),
    brightness: Brightness.light,
    alphaInt: Iq255.max,
    red: Iq255.v250,
    green: Iq255.v235,
    blue: Iq255.v215);
const int hxAqua = 0xFF00FFFF;
final HTML cAqua = HTML(
  hxAqua,
  names: kAqua,
  hct: const HctData(196.5449, 58.95441, 91.11652),
  lrv: const Percent(0.7874),
  brightness: Brightness.light,
  red: Iq255.v0,
  green: Iq255.max,
  blue: Iq255.max,
);
const int hxAquamarine = 0xFF7FFFD4;
final HTML cAquamarine = HTML(
  hxAquamarine,
  names: kAquamarine,
  hct: const HctData(171.85628, 50.44456, 92.03615),
  lrv: const Percent(0.807855),
  brightness: Brightness.light,
  alphaInt: Iq255.max,
  red: Iq255.v127,
  green: Iq255.max,
  blue: Iq255.v212,
);
const int hxBeige = 0xFFF5F5DC;
final HTML cBeige = HTML(
  hxBeige,
  names: kBeige,
  hct: const HctData(117.3517, 11.18285, 95.94888),
  lrv: const Percent(0.898846),
  brightness: Brightness.light,
  alphaInt: Iq255.max,
  red: Iq255.v245,
  green: Iq255.v245,
  blue: Iq255.v220,
);
const int hxBisque = 0xFFFFE4C4;
final HTML cBisque = HTML(
  hxBisque,
  names: kBisque,
  hct: const HctData(74.35239, 14.8926, 92.01245),
  lrv: const Percent(0.807323),
  hsv: const HSV.alt(
      h: Hue(32.54237), s: Percent(0.23137), v: Percent.max, a: Percent.max),
  brightness: Brightness.light,
);
const int hxBlack = 0xFF000000;
const HctData hxBlackData = HctData(0, 0, 0);
final HTML cBlack = HTML(hxBlack, names: kBlack, hct: hxBlackData);
const HSL kHslBlack = HSL(0, 0, 0, hexId: hxBlack, names: kBlack);
const CIELuv luvBlack = CIELuv(0, 0, 0, hexId: hxBlack, names: kBlack);
const int hxBlanchedAlmond = 0xFFFFEBCD;
final HTML cBlanchedAlmond = HTML(hxBlanchedAlmond,
    names: kBlanchedAlmond,
    hct: const HctData(82.25908, 13.08627, 93.91949),
    lrv: const Percent(0.850844),
    brightness: Brightness.light,
    alphaInt: Iq255.max,
    blue: Iq255.CD);
const int hxBlue = 0xFF0000FF;
final HTML cBlue = HTML(hxBlue,
    names: kBlue,
    red: Iq255.v0,
    green: Iq255.v0,
    blue: Iq255.v255,
    hct: const HctData(266, 87, 32));
const int hxBlueViolet = 0xFF8A2BE2;
final HTML cBlueViolet = HTML(hxBlueViolet,
    names: kBlueViolet,
    lrv: const Percent(0.126),
    brightness: Brightness.dark,
    hct: const HctData(292, 102, 41));
const int hxBrownHtml = 0xFFA52A2A;
final HTML cBrownHtml =
    HTML(hxBrownHtml, names: kBrown, hct: const HctData(28, 46, 38));
const int hxBurlyWood = 0xFFDEB887;
final HTML cBurlyWood = HTML(
  hxBurlyWood,
  names: kBurlyWood,
  hct: const HctData(74.028, 23.67445, 77.0169),
  lrv: const Percent(0.515598),
);
final HTML cBurlywood = cBurlyWood;
const int hxCadetBlue = 0xFF5F9EA0;
final HTML cCadetBlue =
    HTML(hxCadetBlue, names: kCadetBlue, hct: const HctData(223, 21, 61));
const int hxChartreuse = 0xFF7FFF00;
final HTML cChartreuse = HTML(
  hxChartreuse,
  names: kChartreuse,
  hct: const HctData(136.07161, 98.07271, 89.87421),
  lrv: const Percent(0.76032),
  brightness: Brightness.light,
);
const int hxChocolate = 0xFFD2691E;
final HTML cChocolate = HTML(
  hxChocolate,
  names: kChocolate,
  hct: const HctData(48.87847, 57.64034, 55.98605),
  lrv: const Percent(0.238985),
  brightness: Brightness.dark,
);
const int hxCoral = 0xFFFF7F50;
final HTML cCoral = HTML(
  hxCoral,
  names: kCoral,
  hct: const HctData(37.66124, 59.72545, 67.29048),
  lrv: const Percent(0.370179),
  brightness: Brightness.light,
);
const int hxCornflowerBlue = 0xFF6495ED;
final HTML cCornflowerBlue = HTML(
  hxCornflowerBlue,
  names: kCornflowerBlue,
  hct: const HctData(265.03593, 52.41255, 61.92819),
  lrv: const Percent(0.303186),
  brightness: Brightness.dark,
  hsv: const HSV.alt(
      h: Hue(218.54015),
      s: Percent(0.5781),
      v: Percent(0.92941),
      a: Percent.max),
);
const int hxCornSilk = 0xFFFFF8DC;
final HTML cCornSilk = HTML(
  hxCornSilk,
  names: kCornsilk,
  hsv: const HSV.alt(
      h: Hue.v48, s: Percent(0.1373), v: Percent.max, a: Percent.max),
  hct: const HctData(103.64912, 11.66316, 97.45527),
  lrv: const Percent(0.935621),
  brightness: Brightness.light,
);
const int hxCrimson = 0xFFDC143C;
final HTML cCrimson = HTML(
  hxCrimson,
  names: kCrimson,
  hsv: const HSV.alt(
      h: Hue.v348, s: Percent(0.9091), v: Percent(0.86275), a: Percent.max),
  hct: const HctData(17.34394, 93.91811, 47.02981),
  lrv: const Percent(0.160422),
  brightness: Brightness.dark,
);
const int hxCyan = 0xFF00FFFF;
final HTML cCyan = HTML(hxCyan, names: kCyan, hct: const HctData(192, 58, 91));
const int hxDarkBlue = 0xFF00008B;
final HTML cDarkBlue = HTML(
  hxDarkBlue,
  names: kDarkBlue,
  red: Iq255.v0,
  green: Iq255.v0,
  blue: Iq255.v139,
  hsv: const HSV.alt(
    h: Hue.v240,
    s: Percent.max,
    v: Percent(0.5451),
    a: Percent.max,
  ),
  hct: const HctData(282.84947, 59.72758, 14.75716),
  lrv: const Percent(0.018641),
  brightness: Brightness.dark,
);
const int hxDarkCyan = 0xFF008B8B;
final HTML cDarkCyan = HTML(
  hxDarkCyan,
  names: kDarkCyan,
  hsv: const HSV.alt(
      h: Hue.v180, s: Percent.max, v: Percent(0.5451), a: Percent.max),
  hct: const HctData(196.5602, 40.81774, 52.20752),
  lrv: const Percent(0.203293),
  brightness: Brightness.dark,
);
const int hxDarkGoldenRod = 0xFFB8860B;
final HTML cDarkGoldenRod = HTML(
  hxDarkGoldenRod,
  names: kDarkGoldenRod,
  hct: const HctData(82.5057, 48.1271, 59.21854),
  lrv: const Percent(0.272647),
  brightness: Brightness.dark,
);
const int hxDarkGray = 0xFFA9A9A9;
final HTML cDarkGray = HTML(
  hxDarkGray,
  names: kDarkGray,
  hsv: const HSV.alt(
      h: Hue.zero, s: Percent.min, v: Percent(0.66275), a: Percent.max),
  hct: const HctData(209.49322, 2.23928, 69.2378),
  lrv: const Percent(0.396755),
  brightness: Brightness.light,
);
const int hxDarkGreenHtml = 0xFF006400;
final HTML cDarkGreenHtml = HTML(
  hxDarkGreenHtml,
  names: kDarkGreen,
  hct: const HctData(142.2504, 61.32012, 36.20352),
  lrv: const Percent(0.091143),
  brightness: Brightness.dark,
);
const int hxDarkKhaki = 0xFFBDB76B;
final HTML cDarkKhaki = HTML(
  hxDarkKhaki,
  names: kDarkKhaki,
  hct: const HctData(107.25974, 32.85193, 73.38128),
  lrv: const Percent(0.457473),
  brightness: Brightness.light,
);
const int hxDarkMagenta = 0xFF8B008B;
final HTML cDarkMagenta = HTML(
  hxDarkMagenta,
  names: kDarkMagenta,
  hct: const HctData(334.57389, 73.8946, 32.59748),
  lrv: const Percent(0.07353),
  hsv: const HSV.alt(
      h: Hue.v300, s: Percent.max, v: Percent(0.5451), a: Percent.max),
  brightness: Brightness.dark,
);
const int hxDarkOliveGreen = 0xFF556B2F;
final HTML cDarkOliveGreen = HTML(
  hxDarkOliveGreen,
  names: kDarkOliveGreen,
  hct: const HctData(128.62385, 34.96939, 42.23403),
  lrv: const Percent(0.126519),
  brightness: Brightness.dark,
  red: Iq255.v85,
  green: Iq255.v107,
  blue: Iq255.v47,
  hsv: const HSV.alt(
      h: Hue(82.0), s: Percent(0.56075), v: Percent(0.41961), a: Percent.max),
);
const int hxDarkOrange = 0xFFFF8C00;
final HTML cDarkOrange = HTML(
  hxDarkOrange,
  names: kDarkOrange,
  hct: const HctData(58.12211, 65.06335, 69.48104),
  lrv: const Percent(0.400162),
  brightness: Brightness.light,
);
const int hxDarkOrchid = 0xFF9932CC;
final HTML cDarkOrchid = HTML(
  hxDarkOrchid,
  names: kDarkOrchid,
  hct: const HctData(318.63216, 76.1202, 43.37927),
  lrv: const Percent(0.134131),
  red: Iq255.v153,
  green: Iq255.v51,
  blue: Iq255.v204,
  brightness: Brightness.dark,
);
const HctData kHctDarkRed = HctData(27.31941, 77.45539, 28.08473);
const Percent kLrvDarkRed = Percent(0.05489);
const Brightness kBrightnessDarkRed = Brightness.dark;
const int hxDarkRed = 0xFF8B0000;
final HTML cDarkRed = HTML(hxDarkRed,
    names: kDarkRed,
    hct: kHctDarkRed,
    lrv: kLrvDarkRed,
    brightness: kBrightnessDarkRed);
const int hxDarkSalmon = 0xFFE9967A;
final HTML cDarkSalmon = HTML(
  hxDarkSalmon,
  names: kDarkSalmon,
  hct: const HctData(37.08205, 35.90155, 69.85346),
  lrv: const Percent(0.405415),
  brightness: Brightness.light,
);
const int hxDarkSeaGreen = 0xFF8FBC8F;
final HTML cDarkSeaGreen = HTML(
  hxDarkSeaGreen,
  names: kDarkSeaGreen,
  hct: const HctData(149.26201, 31.26704, 72.08741),
  lrv: const Percent(0.437892),
  brightness: Brightness.light,
);
const int hxDarkSlateBlue = 0xFF483D8B;
final HTML cDarkSlateBlue = HTML(
  hxDarkSlateBlue,
  names: kDarkSlateBlue,
  hct: const HctData(292.19372, 45.80113, 30.82929),
  lrv: const Percent(0.065793),
  hsv: const HSV.alt(
      h: Hue(248.46154),
      s: Percent(0.56115),
      v: Percent(0.5451),
      a: Percent.max),
  brightness: Brightness.dark,
);
const int hxDarkSlateGray = 0xFF2F4F4F;
final HTML cDarkSlateGray = HTML(
  hxDarkSlateGray,
  names: kDarkSlateGray,
  hct: const HctData(197.24894, 18.9185, 31.25608),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxDarkTurquoise = 0xFF00CED1;
final HTML cDarkTurquoise = HTML(
  hxDarkTurquoise,
  names: kDarkTurquoise,
  hct: HctData.fromInt(hxDarkTurquoise),
);
const int hxDarkViolet = 0xFF9400D3;
final HTML cDarkViolet = HTML(
  hxDarkViolet,
  names: kDarkViolet,
  hct: const HctData(318.12723, 84.88744, 39.57887),
  lrv: const Percent(0.10999),
  brightness: Brightness.dark,
);
const int hxDarkYellowHtml = 0xFF8B8B00;
final HTML cDarkYellowHtml = HTML(
  hxDarkYellowHtml,
  names: kDarkYellow,
  hct: const HctData(111.04484, 52.09874, 56.04191),
  lrv: const Percent(0.239542),
  brightness: Brightness.dark,
);
const int hxDeepPink = 0xFFFF1493;
final HTML cDeepPink = HTML(
  hxDeepPink,
  names: kDeepPink,
  hct: const HctData(358.18755, 100.3807, 55.95428),
  lrv: const Percent(0.238669),
  brightness: Brightness.dark,
);
const int hxDeepSkyBlue = 0xFF00BFFF;
final HTML cDeepSkyBlue = HTML(
  hxDeepSkyBlue,
  names: kDeepSkyBlue,
  hct: const HctData(234.28577, 57.07304, 72.54923),
  lrv: const Percent(0.444816),
  brightness: Brightness.light,
);
const int hxDimGray = 0xFF696969;
final HTML cDimGray = HTML(
  hxDimGray,
  names: kDimGray,
  hct: const HctData(209.49417, 1.68613, 44.41356),
  lrv: const Percent(0.141263),
  brightness: Brightness.dark,
);
const int hxDimGrey = 0xFF696969;
final HTML cDimGrey = HTML(
  hxDimGrey,
  names: kDimGrey,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxDodgerBlue = 0xFF1E90FF;
final HTML cDodgerBlue = HTML(
  hxDodgerBlue,
  names: kDodgerBlue,
  hct: const HctData(259.32476, 64.95301, 59.38173),
  lrv: const Percent(0.274425),
  brightness: Brightness.dark,
);
const int hxFireBrick = 0xFFB22222;
final HTML cFireBrick = HTML(
  hxFireBrick,
  names: kFireBrick,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxFloralWhite = 0xFFFFFAF0;
final HTML cFloralWhite = HTML(
  hxFloralWhite,
  names: kFloralWhite,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxForestGreen = 0xFF228B22;
final HTML cForestGreen =
    HTML(hxForestGreen, names: kForestGreen, hct: const HctData(120, 71, 46));
const int hxFuchsia = 0xFFFF00FF;
final HTML cFuchsia = HTML(
  hxFuchsia,
  names: kFuchsia,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxGainsboro = 0xFFDCDCDC;
final HTML cGainsboro = HTML(
  hxGainsboro,
  names: kGainsboro,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxGhostWhite = 0xFFF8F8FF;
final HTML cGhostWhite = HTML(
  hxGhostWhite,
  names: kGhostWhite,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxGoldHtml = 0xFFFFD700;
final HTML cGoldHtml = HTML(
  hxGoldHtml,
  names: kGold,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxGoldenRod = 0xFFDAA520;
final HTML cGoldenRod = HTML(
  hxGoldenRod,
  names: kGoldenRod,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxGray = 0xFF808080;
final HTML cGray = HTML(hxGray, names: kGray, hct: const HctData(209, 0, 54));
const int hxGrey = hxGray;
final HTML cGrey = HTML(hxGrey, names: kGrey, hct: const HctData(209, 0, 54));
const int hxGreenHtml = 0xFF008000;
final HTML cGreenHtml =
    HTML(hxGreenHtml, names: kGreen, hct: const HctData(142, 71, 46));
const HSV hsvGreen =
    HSV(Hue.v120, Percent.max, Percent.max, colorId: hxGreenHtml);
const HSL hslGreen =
    HSL(120, Percent.max, Percent.mid, hexId: hxGreenHtml, names: kGreen);
const int hxGreenYellow = 0xFFADFF2F;
final HTML cGreenYellow = HTML(
  hxGreenYellow,
  names: kGreenYellow,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxHoneyDew = 0xFFF0FFF0;
const int hxHoneydew = hxHoneyDew;
final HTML cHoneyDew = HTML(
  hxHoneyDew,
  names: kHoneyDew,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxHotPink = 0xFFFF69B4;
final HTML cHotPink = HTML(
  hxHotPink,
  names: kHotPink,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxIndianRed = 0xFFCD5C5C;
final HTML cIndianRed = HTML(
  hxIndianRed,
  names: kIndianRed,
  hct: const HctData(19.9826, 54.09918, 53.39115),
  lrv: const Percent(0.214061),
  brightness: Brightness.dark,
);
const int hxIndigo = 0xFF4B0082;
final HTML cIndigo = HTML(
  hxIndigo,
  names: kIndigo,
  hct: const HctData(205.5726, 86.6562, 96.5256),
  lrv: const Percent(0.162222),
  brightness: Brightness.dark,
);
const int hxIvory = 0xFFFFFFF0;
final HTML cIvory =
    HTML(hxIvory, names: kIvory, hct: const HctData(108, 5, 99));
const int hxKhaki = 0xFFF0E68C;
const int hxLightKhaki = hxKhaki;
final HTML cKhaki = HTML(
  hxKhaki,
  names: kKhaki,
  hct: const HctData(105.60575, 36.00867, 90.3273),
  lrv: const Percent(0.770123),
  hsv: const HSV.alt(
      h: Hue(54.0), s: Percent(0.41667), v: Percent(0.94118), a: Percent.max),
  brightness: Brightness.light,
);
const int hxLavender = 0xFFE6E6FA;
final HTML cLavender = HTML(
  hxLavender,
  names: kLavender,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxLavenderBlush = 0xFFFFF0F5;
final HTML cLavenderBlush = HTML(
  hxLavenderBlush,
  names: kLavenderBlush,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxLawnGreen = 0xFF7CFC00;
final HTML cLawnGreen = HTML(
  hxLawnGreen,
  names: kLawnGreen,
  hct: const HctData(136.22703, 97.59093, 88.87799),
  lrv: const Percent(0.739059),
  brightness: Brightness.light,
);
const int hxLemonChiffon = 0xFFFFFACD;
final HTML cLemonChiffon = HTML(
  hxLemonChiffon,
  names: kLemonChiffon,
  hct: const HctData(210, 20, 56),
  lrv: const Percent(0.067608),
  brightness: Brightness.dark,
);
const int hxLightBlue = 0xFFADD8E6;
final HTML cLightBlue =
    HTML(hxLightBlue, names: kLightBlue, hct: const HctData(209, 0, 78));
const int hxLightCoral = 0xFFF08080;
final ColorIQ cLightCoral = ColorIQ(hxLightCoral, names: kLightCoral);
const int hxLightCyanHtml = 0xE0FFFF;
final ColorIQ cLightCyanHtml = ColorIQ(hxLightCyanHtml, names: kLightCyan);
const int hxLightGoldenRodYellow = 0xFFFAFAD2;
final HTML cLightGoldenRodYellow = HTML(
  hxLightGoldenRodYellow,
  names: kLightGoldenRodYellow,
  hct: const HctData(114.32888, 17.02054, 97.3688),
  lrv: const Percent(0.933484),
  brightness: Brightness.light,
);
const int hxLightGray = 0xFFD3D3D3;
final HTML cLightGray = HTML(
  hxLightGray,
  names: kLightGray,
  hct: const HctData(209.4926, 2.55959, 84.55612),
  lrv: const Percent(0.651406),
  brightness: Brightness.light,
);
const int hxLightGreen = 0xFF90EE90;
final HTML cLightGreen = HTML(
  hxLightGreen,
  names: kLightGreen,
  hct: const HctData(146.88622, 56.71374, 86.54958),
  lrv: const Percent(0.69092),
  brightness: Brightness.light,
);
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
final HTML cLightYellow = HTML(
  hxLightYellow,
  names: kLightYellow,
  hct: const HctData(115.98355, 13.43042, 99.28484),
  lrv: const Percent(0.981618),
  brightness: Brightness.light,
  red: Iq255.FF,
  green: Iq255.FF,
  blue: Iq255.E0,
);
const int hxLime = 0xFF00FF00; // same as ElectricLime
final HTML cLime = HTML(
  hxLime,
  names: kLime,
  hct: const HctData(142.13989, 108.41006, 87.73703),
  lrv: const Percent(0.7152),
  brightness: Brightness.light,
);
const int hxLimeGreen = 0xFF32CD32;
final HTML cLimeGreen = HTML(
  hxLimeGreen,
  names: kLimeGreen,
  hct: const HctData(143.22013, 85.41983, 72.60854),
  lrv: const Percent(0.44571),
  brightness: Brightness.light,
);
const int hxLinen = 0xFFFAF0E6;
final HTML cLinen = HTML(
  hxLinen,
  names: kLinen,
  hct: const HctData(79.08116, 4.63084, 95.3112),
  lrv: const Percent(0.883573),
  brightness: Brightness.light,
);
const int hxMagenta = 0xFFFF00FF;
final HTML cMagenta =
    HTML(hxMagenta, names: kMagenta, hct: HctData(326, 127, 60));
const int hxMaroon = 0xFF800000;
final HTML cMaroon =
    HTML(hxMaroon, names: kMaroon, hct: const HctData(23, 52, 26));
const int hxMediumAquaMarine = 0xFF66CDAA;
final ColorIQ cMediumAquaMarine =
    ColorIQ(hxMediumAquaMarine, names: kMediumAquaMarine);
const int hxMediumBlue = 0xFF0000CD;
final HTML cMediumBlue =
    HTML(hxMediumBlue, names: kMediumBlue, hct: const HctData(273, 47, 13));
const int hxMediumOrchid = 0xFFBA55D3;
final HTML cMediumOrchid =
    HTML(hxMediumOrchid, names: kMediumOrchid, hct: const HctData(283, 76, 25));
const int hxMediumPurple = 0xFF9370DB;
final ColorIQ cMediumPurple = ColorIQ(hxMediumPurple, names: kMediumPurple);
const int hxMediumSeaGreen = 0xFF3CB371;
final ColorIQ cMediumSeaGreen =
    ColorIQ(hxMediumSeaGreen, names: kMediumSeaGreen);
const int hxMediumSlateBlue = 0xFF7B68EE;
final ColorIQ cMediumSlateBlue =
    ColorIQ(hxMediumSlateBlue, names: kMediumSlateBlue);
const int hxMediumSpringGreen = 0xFF00FA9A;
final HTML cMediumSpringGreen = HTML(
  hxMediumSpringGreen,
  names: kMediumSpringGreen,
  hct: const HctData(158.92056, 74.16895, 87.34115),
  lrv: const Percent(0.707043),
  brightness: Brightness.light,
);
const int hxMediumTurquoise = 0xFF48D1CC;
final ColorIQ cMediumTurquoise =
    ColorIQ(hxMediumTurquoise, names: kMediumTurquoise);
const int hxMediumVioletRed = 0xFFC71585;
final HTML cMediumVioletRed = HTML(hxMediumVioletRed,
    names: kMediumVioletRed, hct: const HctData(352, 85, 45));
const int hxMidnightBlueHtml = 0xFF191970;
final ColorIQ cMidnightBlueHtml =
    ColorIQ(hxMidnightBlueHtml, names: kMidnightBlue);
const int hxMintCream = 0xFFF5FFFA;
final HTML cMintCream =
    HTML(hxMintCream, names: kMintCream, hct: const HctData(155, 5, 98));
const int hxMistyRose = 0xFFFFE4E1;
final HTML cMistyRose =
    HTML(hxMistyRose, names: kMistyRose, hct: const HctData(13, 11, 91));
const int hxMoccasin = 0xFFFFE4B5;
final HTML cMoccasin = HTML(
  hxMoccasin,
  names: kMoccasin,
  hct: const HctData(83.92093, 19.97986, 91.72209),
  hsv: const HSV.alt(
      h: Hue(38.10811), s: Percent(0.2902), v: Percent.max, a: Percent.max),
  brightness: Brightness.light,
);
const int hxNavajoWhite = 0xFFFFDEAD;
final ColorIQ cNavajoWhite = ColorIQ(hxNavajoWhite, names: kNavajoWhite);
const int hxNavy = 0xFF000080;
final HTML cNavy = HTML(hxNavy, names: kNavy, hct: const HctData(273, 47, 13));
const int hxOldLace = 0xFFFDF5E6;
final HTML cOldLace = HTML(
  hxOldLace,
  names: kOldLace,
  hct: const HctData(95.40681, 6.41598, 96.77967),
  lrv: const Percent(0.919006),
  brightness: Brightness.light,
);

HTML fnOldLace() => cOldLace;
const int hxOlive = 0xFF808000;
final HTML cOlive =
    HTML(hxOlive, names: kOlive, hct: const HctData(112, 55, 53));
// https://encycolorpedia.com/6b8e23
const int hxOliveDrab = 0xFF6B8E23;
final HTML cOliveDrab = HTML(hxOliveDrab,
    names: kOliveDrab,
    lrv: const Percent(0.226),
    hct: const HctData(128, 53, 55));
const int hxOrangeHtml = 0xFFFFA500;
final HTML cOrangeHtml =
    HTML(hxOrangeHtml, names: kOrange, hct: const HctData(68, 85, 76));
// https://encycolorpedia.com/ff4500
const int hxOrangeRedHtml = 0xFFFF4500;
final HTML cOrangeRedHtml =
    HTML(hxOrangeRedHtml, names: kOrangeRed, hct: const HctData(34, 95, 58));
final HTML cRedOrange = cOrangeRedHtml;
const int hxOrchid = 0xFFDA70D6;
final ColorIQ cOrchid = ColorIQ(hxOrchid, names: kOrchid);
const int hxPaleGoldenRod = 0xFFEEE8AA;
final HTML cPaleGoldenRod = HTML(hxPaleGoldenRod,
    names: kPaleGoldenRod, hct: const HctData(88, 53, 55));
const int hxPaleGreen = 0xFF98FB98;
final HTML cPaleGreen = HTML(
  hxPaleGreen,
  names: kPaleGreen,
  hct: const HctData(146.87387, 58.65472, 90.75104),
  lrv: const Percent(0.779368),
  brightness: Brightness.light,
);
const int hxPaleTurquoise = 0xFFAFEEEE;
final ColorIQ cPaleTurquoise = ColorIQ(hxPaleTurquoise, names: kPaleTurquoise);
const int hxPaleVioletRed = 0xFFDB7093;
final HTML cPaleVioletRed = HTML(
  hxPaleVioletRed,
  names: kPaleVioletRed,
  hct: const HctData(1.13017, 50.92357, 60.56479),
  lrv: const Percent(0.28755),
  brightness: Brightness.dark,
);
const int hxPapayaWhip = 0xFFFFEFD5;
final HTML cPapayaWhip = HTML(
  hxPapayaWhip,
  names: kPapayaWhip,
  hct: const HctData(85.64513, 11.18099, 95.07544),
  lrv: const Percent(0.877971),
  brightness: Brightness.light,
);
const int hxPeachPuff = 0xFFFFDAB9;
final HTML cPeachPuff =
    HTML(hxPeachPuff, names: kPeachPuff, hct: const HctData(72, 27, 88));
const int hxPear = 0xFFD1E231;
final HTML cPear = HTML(hxPear, names: kPear, hct: const HctData(72, 27, 88));
const int hxPearl = 0xFFE6E8FA;
final HTML cPearl =
    HTML(hxPearl, names: kPearl, hct: const HctData(72, 27, 88));
const int hxPearlAqua = 0xFF88D8E8;
final HTML cPearlAqua =
    HTML(hxPearlAqua, names: kPearlAqua, hct: const HctData(72, 27, 88));
const int hxPearlyPurple = 0xFFb768a2;
final HTML cPearlyPurple =
    HTML(hxPearlyPurple, names: kPearlyPurple, hct: const HctData(72, 27, 88));
const int hxPenguinWhite = 0xFFF5F3EF;
final HTML cPenguinWhite =
    HTML(hxPenguinWhite, names: kPenguinWhite, hct: const HctData(72, 27, 88));
const int hxPeridot = 0xFFE6E200;
final HTML cPeridot =
    HTML(hxPeridot, names: kPeridot, hct: const HctData(72, 27, 88));
const int hxPeriwinkleCrayola = 0xFFC3CDE6;
final HTML cPeriwinkleCrayola = HTML(hxPeriwinkleCrayola,
    names: kPeriwinkleCrayola, hct: const HctData(72, 27, 88));
const int hxPermanentGeraniumLake = 0xFFE12C2C;
final HTML cPermanentGeraniumLake = HTML(hxPermanentGeraniumLake,
    names: kPermanentGeraniumLake, hct: const HctData(72, 27, 88));
const int hxPersianBlue = 0xFF1C39BB;
final HTML cPersianBlue =
    HTML(hxPersianBlue, names: kPersianBlue, hct: const HctData(72, 27, 88));
const int hxPersianGreen = 0xFF00A693;
final HTML cPersianGreen =
    HTML(hxPersianGreen, names: kPersianGreen, hct: const HctData(72, 27, 88));
const int hxPersianIndigo = 0xFF32127A;
final HTML cPersianIndigo = HTML(hxPersianIndigo,
    names: kPersianIndigo, hct: const HctData(72, 27, 88));
const int hxPersianOrange = 0xFFD99058;
final HTML cPersianOrange = HTML(hxPersianOrange,
    names: kPersianOrange, hct: const HctData(72, 27, 88));
const int hxPersianPink = 0xFFF77FBE;
final HTML cPersianPink =
    HTML(hxPersianPink, names: kPersianPink, hct: const HctData(72, 27, 88));
const int hxPersianPlum = 0xFF701C1C;
final HTML cPersianPlum =
    HTML(hxPersianPlum, names: kPersianPlum, hct: const HctData(72, 27, 88));
const int hxPersianRed = 0xFFCC3333;
final HTML cPersianRed =
    HTML(hxPersianRed, names: kPersianRed, hct: const HctData(72, 27, 88));
const int hxPersimmon = 0xFFEC5800;
final HTML cPersimmon =
    HTML(hxPersimmon, names: kPersimmon, hct: const HctData(72, 27, 88));
const int hxPersimmonJuiceColorKakishibuIro = 0xFF934337;
final HTML cPersimmonJuiceColorKakishibuIro = HTML(
    hxPersimmonJuiceColorKakishibuIro,
    names: kPersimmonJuiceColorKakishibuIro,
    hct: const HctData(72, 27, 88));

const int hxPeru = 0xFFCD853F;
final HTML cPeru = HTML(hxPeru, names: kPeru, hct: const HctData(55, 57, 62));
const int hxPink = 0xFFFFC0CB;
final HTML cPink = HTML(hxPink, names: kPink, hct: const HctData(21, 30, 83));
const int hxPlumHtml = 0xFFDDA0DD;
final HTML cPlumHtml =
    HTML(hxPlumHtml, names: kPlum, hct: const HctData(316, 32, 74));
const int hxPowderBlue = 0xFFB0E0E6;
final HTML cPowderBlue =
    HTML(hxPowderBlue, names: kPowderBlue, hct: const HctData(221, 24, 87));
const int hxPurpleHtml = 0xFF800080;
final HTML cPurpleHtml = HTML(
  hxPurpleHtml,
  names: kPurple,
  hct: const HctData(334.56803, 70.27262, 29.7821),
  hsv: const HSV.alt(
      h: Hue.v300, s: Percent.max, v: Percent(0.50196), a: Percent.max),
  lrv: const Percent(0.061477),
  brightness: Brightness.dark,
);

HTML fnPurple() => cPurpleHtml;
const int hxRebeccaPurple = 0xFF663399;
final ColorIQ cRebeccaPurple = ColorIQ(hxRebeccaPurple, names: kRebeccaPurple);
const int hxRed = 0xFFFF0000;
final HTML cRed = HTML(hxRed, names: kRed, hct: const HctData(27, 113, 53));
const HSL kHslRed =
    HSL(0, Percent.max, Percent.mid, hexId: hxRed, names: kRed); // Red
const HSV kHsvRed = HSV(Hue.zero, Percent.max, Percent.max, colorId: hxRed);
const int hxRosyBrown = 0xFFBC8F8F;
final HTML cRosyBrown = HTML(
  hxRosyBrown,
  names: kRosyBrown,
  hct: const HctData(17.25845, 19.07199, 63.60604),
  lrv: const Percent(0.323195),
  brightness: Brightness.dark,
);
const int hxRoyalBlue = 0xFF4169E1;
final HTML cRoyalBlue =
    HTML(hxRoyalBlue, names: kRoyalBlue, hct: const HctData(258, 54, 47));
const int hxSaddleBrown = 0xFF8B4513;
final HTML cSaddleBrown =
    HTML(hxSaddleBrown, names: kSaddleBrown, hct: const HctData(34, 57, 53));
const int hxSalmon = 0xFFFA8072;
final HTML cSalmon =
    HTML(hxSalmon, names: kSalmon, hct: const HctData(33, 59, 66));
const int hxSandyBrown = 0xFFF4A460;
final HTML cSandyBrown =
    HTML(hxSandyBrown, names: kSandyBrown, hct: const HctData(34, 57, 53));
const int hxSeaGreen = 0xFF2E8B57;
final HTML cSeaGreen =
    HTML(hxSeaGreen, names: kSeaGreen, hct: const HctData(150, 57, 53));
const int hxSeaShell = 0xFFFFF5EE;
final HTML cSeaShell =
    HTML(hxSeaShell, names: kSeaShell, hct: const HctData(34, 57, 53));
const int hxSienna = 0xFFA0522D;
final HTML cSienna =
    HTML(hxSienna, names: kSienna, hct: const HctData(34, 57, 53));
const int hxSilver = 0xFFC0C0C0;
final HTML cSilver =
    HTML(hxSilver, names: kSilver, hct: const HctData(209, 0, 78));
const int hxSkyBlue = 0xFF87CEEB;
final HTML cSkyBlue =
    HTML(hxSkyBlue, names: kSkyBlue, hct: const HctData(209, 0, 78));
const int hxSlateBlue = 0xFF6A5ACD;
final ColorIQ cSlateBlue = ColorIQ(hxSlateBlue, names: kSlateBlue);
const int hxSlateGray = 0xFF708090;
final HTML cSlateGray =
    HTML(hxSlateGray, names: kSlateGray, hct: const HctData(210, 20, 56));
const int hxSlateGrey = 0xFF708090;
final ColorIQ cSlateGrey = ColorIQ(hxSlateGrey, names: kSlateGrey);
const int hxSnowHtml = 0xFFFAFAFA;
final ColorIQ cSnowHtml = ColorIQ(hxSnowHtml, names: kSnow);
const int hxSpringGreen = 0xFF00FF7F;
final HTML cSpringGreen =
    HTML(hxSpringGreen, names: kSpringGreen, hct: const HctData(160, 115, 50));
const int hxSteelBlue = 0xFF4682B4;
final HTML cSteelBlue =
    HTML(hxSteelBlue, names: kSteelBlue, hct: HctData.fromInt(hxSteelBlue));
const int hxTan = 0xFFD2B48C;
final ColorIQ cTan = ColorIQ(hxTan, names: kTan);
const int hxTeal = 0xFF008080;
final HTML cTeal = HTML(
  hxTeal,
  names: kTeal,
  hct: const HctData(194, 30, 48),
);

HTML fnTeal() => cTeal;
const int hxThistle = 0xFFD8BFD8;
final ColorIQ cThistle = ColorIQ(hxThistle, names: kThistle);
const int hxTomato = 0xFFFF6347;
final HTML cTomato = HTML(
  hxTomato,
  names: kTomato,
  hct: const HctData(29.54353, 73.93671, 62.20137),
  lrv: const Percent(0.306386),
  brightness: Brightness.dark,
);
const int hxTurquoise = 0xFF40E0D0;
final ColorIQ cTurquoise = ColorIQ(hxTurquoise, names: kTurquoise);
const int hxViolet = 0xFFEE82EE;
final ColorIQ cViolet = ColorIQ(hxViolet, names: kViolet);
const int hxWheat = 0xFFF5DEB3;
final HTML cWheat =
    HTML(hxWheat, names: kWheat, hct: const HctData(88, 53, 55));
const int hxWhite = 0xFFFFFFFF;
final HTML cWhite =
    HTML(hxWhite, names: kWhite, hct: const HctData(209, 0, 100));
const HSL kHslWhite =
    HSL(0, Percent.zero, Percent.max, hexId: hxWhite, lrv: Percent.max);
const CMYK cmykWhite = CMYK(0, 0, 0, 0, value: hxWhite); // White

const int hxWhiteSmoke = 0xFFF5F5F5;
final ColorIQ cWhiteSmoke = ColorIQ(hxWhiteSmoke, names: kWhiteSmoke);
// https://encycolorpedia.com/ffff00
const int hxYellow = 0xFFFFFF00;
final HTML cYellow =
    HTML(hxYellow, names: kYellow, hct: const HctData(100, 97, 98));
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
  darkRed(hxDarkRed, kDarkRed, ColorFamilyHTML.red, hct: kHctDarkRed),
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
  oldLace(hxOldLace, kOldLace, ColorFamilyHTML.white, tdHtml: fnOldLace),
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
  purple(hxPurple, kPurple, ColorFamilyHTML.purple, tdHtml: fnPurple),
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
  teal(hxTeal, kTeal, ColorFamilyHTML.cyan, tdHtml: fnTeal),
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
  final TdHtml? tdHtml;
  final HctData? hct;

  // ignore: unused_element_parameter
  const HtmlEN(this.value, this.names, this.family, {this.tdHtml, this.hct});

  int get hexId => value;

  String get hexString => value.toHexStr;

  HTML get html => tdHtml?.call() ?? colorRegistry[value] as HTML;
}
