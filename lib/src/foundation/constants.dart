import 'dart:math' as math;

const int maxUInt32 = 0xFFFFFFFF;
const String versionSep = '-#';
const String deltaDist = 'ΔE';
const double twoPI = 2 * math.pi;
const double piByTwo = math.pi / 2;
const String kDefaultAlphaChannel = 'FF';
const double rgbMidPoint = (255 / 2);
const double maxSRGBChroma = 134.0;
const int kDefaultInt = uInt8bitInfinity; // maxInt32 = 0x7fffffff
const double kDefaultDouble = double.maxFinite; // used for MAX distance
/// That constant `e = 216.0 / 24389.0` is the CIE L*a*b* epsilon threshold, usually called:
/// "epsilon" (ε)**
/// It is the breakpoint used in the CIE 1976 L*a*b* formulas to distinguish
/// between the linear and cubic branches of the transfer function.
const double kEpsilon = 216.0 / 24389.0;
const double kKappa = 24389.0 / 27.0;
const double kDelta = 6.0 / 29.0;
const double kMinTone = 0.0;
const double kMaxTone = 100.0;
const double kMinChroma = 0.0;
const double kMaxChroma = 125.0;
const double kMinHue = 0.0;
const double kMaxHue = 360.0;
const int uInt8bitInfinity = 9007199254740991; //
const double fxFloat8bitInfinity = 9007199254740991.0;
// https://www.npmjs.com/package/color-convert
// https://github.com/material-foundation/material-color-utilities/blob/main/dart/lib/utils/color_utils.dart
/// value for DELINEARIZE, i.e. linearToSRGB, linearToGamma
const double kGammaDelinearize = 0.0031308;
const double chi = 0.040449936; // 0.04045; from MCU
// this is the DART color version of gammaLinearize  0.03928,

/// Values used in converting from sRGB to linear rgb.
/// See transfer function ("gamma") in <https://en.wikipedia.org/wiki/SRGB>
const double kAlphaGammaVal = 0.055;
const double kGammaVal = 2.4;
const double kPhiVal = 12.92;
const double cMaxApprox =
    0.37; // Based on Oklab white point D65 max saturation boundary

const double kMaxVisibleChromaHct = 100.0;
const double kMax8bit = 255.0; // MAX_BYTE
const int kMinUInt8 = 0;
const int kMaxUInt8 = 255;
const double minFloat8 = 0.0;
const double maxFloat8 = 1.0;
const double midWheel180 = 180.0;
const double maxWheel360 = 360.0;
const int kAlphaMask = 0xFF000000;
const int kAlphaShift = 24;
const int kRedMask = 0x00FF0000;
const int kRedShift = 16;
const int kGreenMask = 0x0000FF00;
const int kGreenShift = 8;
const int kBlueMask = 0x000000FF;
const int kBlueShift = 0;
const List<double> minValuesListFloat = <double>[0.0, 0.0, 0.0, 0.0];
const String kChroma = 'chroma';
const String kValue = 'value';
// ignore: constant_identifier_names
const double kW3C_CONTRAST_TEXT = 4.5;
// ignore: constant_identifier_names
const double kW3C_CONTRAST_LARGE_TEXT = 3.0;
const String hexChars = "0123456789abcdef";
// ---------------------------------------- Symbols ----------------------------------------
const String kUnicodePrefix = '\\u';
const String kAmpersand = '\u{0026}'; // '&'; Dec 38, Hex 26
const String kAsterisk = '\u{002A}'; //  *
const String kEmptyStr = '';
// const String kEmptyString = emptyStr;
const String kEqualsSign = '\u{003D}'; // equality sign =
const String kNotEqualsSign = '\u{2260}'; // not equals to  ≠
const String kPlusSign = '\u{002B}'; // +  // aka Addition Operator
const String kNewLine = '\u{000D}\u{000A}'; // same as \r\n
const String kNL = kNewLine; // Unicode, NewLine
// '.'; // dot, period, (U+002E),  FullStop, Decimal
const String dot = '\u{002E}';
const String period = dot;
const String kMinusSign = '\u{2212}'; //  '−', aka hyphen
const String kLeftTriplePrime = '\u{2037}'; //  ‷
const String kRightTriplePrime = '\u{2034}'; //  ‴
const String kSlash = '\u{002F}'; //   / also called Solidus
const String kSolidus = kSlash;
const String kReverseSolidus = '\u{005C}'; // \
const String kDegreeSign = '\u{00B0}'; //  ° aka DegreeSymbol
const String kDegreeCelsius = '\u{2103}'; // U+2103 ℃ DEGREE CELSIUS
const String kDegreeFahrenheit = '\u{2109}'; // U+2109 ℉ DEGREE
const String kDollarSign = '\u{0024}'; // $
const String kLeftParens = '\u{0028}'; // (
const String kRightParens = '\u{0029}'; // )
const String kSemiColonSpace = '\u{003B}\u{0020}';
const String kSemiColonNL = '\u{003B}\n';
const String kCopyrightSign = '\u{00A9}';
const String kTripleNestedLessThan = '\u{2AF7}'; // ⫷
const String kTripleNestedGreaterThan = '\u{2AF8}'; // ⫸
const String kLeftwardsSquiggleArrow = '\u{21DC}'; // ⇜
const String kRightwardsSquiggleArrow = '\u{21DD}'; // ⇝
const String kHeavyWedgeTailedRightwardArrow = '\u{27BD}'; // ➽
const String kDoubleCurlyLoop = '\u{27BF}'; // ➿
const String kLightBulb = '\u{2600}'; // ☀
const String kMiddleDot = '\u{00B7}'; // · same as centerDot  ·
const String kCombiningDoubleVerticalLineAbove = '\u{030E}'; // ̎
const String kLeftDoubleQuotationMark = '\u{201C}'; //  “
const String kRightDoubleQuotationMark = '\u{201D}'; // ”
const String kLeftLenticularBracket2 = '\u{2E28}'; // 	⸨
const String kRightLenticularBracket2 = '\u{2E29}'; // 	⸩
const String kLeftLenticularBracket = '\u{3010}'; // 	【
const String kRightLenticularBracket = '\u{3011}'; // 	】
const String kEmptySetSymbol = '\u{2205}'; // 	∅
const String kLeftSquareBracket = '\u{005B}'; // 	[
const String kRightSquareBracket = '\u{005D}'; // 	]
const String kLeftDoubleParens = '\u{2E28}'; // 	⸨
const String kRightDoubleParens = '\u{2E29}'; // 	⸩
const String kVerticalLine = '\u{007C}'; // 	|
const String kLeftCurlyBracket = '\u{007B}'; // {
const String kRightCurlyBracket = '\u{007D}'; // }
const String kSamaritan = '\u{214F}'; // 	⅏
const String kCircumflexAccent = '\u{005E}'; // 	^
const String kCapitalLetterI = '\u{0049}';
const String capitalLetterJ = '\u{004A}';
const String capitalLetterK = '\u{004B}';
const String capitalLetterL = '\u{004C}';
const String capitalLetterM = '\u{004D}';
const String capitalLetterN = '\u{004E}';
const String capitalLetterO = '\u{004F}';
const String capitalLetterP = '\u{0050}';
const String capitalLetterQ = '\u{0051}';
const String capitalLetterR = '\u{0052}';
const String capitalLetterS = '\u{0053}';
const String capitalLetterT = '\u{0054}';
const String capitalLetterU = '\u{0055}';
const String capitalLetterV = '\u{0056}'; // 	V
const String capitalLetterW = '\u{0057}'; // 	W
const String capitalLetterX = '\u{0058}'; // 	X
const String capitalLetterY = '\u{0059}'; // 	Y
const String capitalLetterZ = '\u{005A}'; // 	Z
const String kZeroStr = '0';
const String kHorizontalEllipsis = '\u{2026}'; // …
const String kTaurusEmoji = '\u{2649}'; // ♉
const String kWhiteClub = '\u{2667}'; // ♧
const String kDiamondShape = '\u{2666}'; // ♦  black diamond suit
// https://www.compart.com/en/unicode/search?q=heart#characters
const String kHeartSymbol = '\u{2665}'; // ♥
const String kWhiteHeart = '\u{2661}'; // ♡
const String kWhiteDiamond = '\u{2662}'; // ♢
const String kSpade = '\u{2660}'; // ♠
const String kWhiteSpade = '\u{2664}'; // ♤
const String kPercentSign = '\u{0025}'; // '%';
const String kExclamationMark = '\u{0021}';
const String kBlackStar = '\u{2605}'; // ★
const String kCircledWhiteStar = '\u{272A}'; // ✪
const String kBlackFourPointedStar = '\u{2726}'; // ✦
const String kDoubleHorizontal = '\u{2550}'; // ═
const String kDoubleVertical = '\u{2551}'; // ║
// https://www.compart.com/en/unicode/category/So
const String kDoubleUpRight = '\u{255A}'; // ╚
const String kDoubleDownRight = '\u{2554}'; // ╔
const String kSixPointedStar = '\u{2736}'; //  ✶
const String kEightPointedStar = '\u{2737}'; //  ✷
const String warningStars =
    '$kBlackFourPointedStar$kCircledWhiteStar$kBlackFourPointedStar';
const String kSemiColon = '\u{003B}'; // ';';
const String kFailMark = '\u{274C}'; //'\u{2718}'; // unicode
const String kEraseToLeft = '\u{232B}'; // ⌫
const String kPrime = '\u{2032}'; // unicode, for feet ′
const String kWarningSign = '\u{26A0}'; // ⚠ // alertSymbol
const String kHighVoltageSign = '\u{26A1}'; //  ⚡
const String kRightArrowTwoHeads = '\u{21A0}'; // ↠
const String kRightArrowLong = '\u{27FE}'; // ⟾
const String kBlackRightwardArrowhead = '\u{27A4}'; // ➤
const String kRightArrowCurved = '\u{27A6}'; // ➦
const String kLeftArrowCurved = '\u{2BAF}'; //   ⮪
const String kLeftArrowCurved2 = '\u{2BAA}'; //   ⮪
const String kRightPairedArrow = '\u{21c9}'; // ⇉
const String kLeftPairedArrow = '\u{21c7}'; // ⇇
const String kRightwardsArrow = '\u{2192}'; // →
const String kRomanTenThousand = '\u{2182}'; // ↂ
const String kRomanHundredThousand = '\u{2188}'; // ↈ
const String kPrecedesUnderRelation = '\u{22B0}'; // ⊰
const String kSucceedsUnderRelation = '\u{22B1}'; // ⊱
const String kPrecedesDouble = '\u{2ABB}'; // ⪻
const String kSucceedsDouble = '\u{2ABC}'; // ⪼
const String kDivisionSlash = '\u{2215}'; // ∕
const String kInvertedExclamationMark = '\u{00A1}'; // ¡
const String kLessThanSign = '\u{003C}'; // <
const String kGreaterThanSign = '\u{003E}'; // >
const String kGreaterThanOrEqualTo = '\u{2265}'; // ≥
const String kMultiplicationSign = '\u{00D7}'; // ×
const String kIncrementSign = '\u{2206}'; // ∆
const String kDivisionSign = '\u{00F7}'; // ÷
const String kAlmostEqualTo = '\u{2248}'; // ≈
const String kNotEqualTo = '\u{2260}'; // ≠
const String kApostrophe = '\u{0027}'; //	Apostrophe/Single quote '
const String kUnderscore = '\u{005F}'; // aka low line
const String kQuotationMark = '\u{0022}'; // aka Double quote "
const String kSectionSign = '\u{00A7}'; // §
const String kSolidBox = '\u{220E}'; // U+220E ∎ // aka end of proof
const String kStopButton = '\u{23F9}'; // ⏹
const String kSpace = '\u{0020}'; // ' '; // U+0020
const String kPoundSign = '\u{0023}'; // '#'; // aka numberSign, hashTag, U+0023
const String kApproxEqualTo = '\u{2245}'; // ≅
const String kColon = '\u{003A}'; // colon :
const String kComma = '\u{002C}'; // ','; // U+002C
const String kCommaSpace = ', '; // Runes('\u{002C}\u{0020}'));// U+002C
const String kDash = '\u{2013}'; // - similar to as hyphen, minus
const String kMinus = '\u{002D}';

const String n0FF = '0xFF';
const String k0xLower = '0x';
const String k0xUpper = '0X'; //uppercase on the x
const String delimiter1 = kSemiColonSpace;
const String kTilde = '\u{007E}';
const String kDelimiter2 = ';\n';
const String delimSeparator = '--'; // kDividerDouble?

// ---------------------------------------- Messages ----------------------------------------
/// Error message for floats that must be in the range of 0.0 to 1.0
/// See also [LinRGB]
const String errorMsgFloat0to1 =
    'Invalid Floating-Point Number: Must be non-null double and ' //
    'in the range of 0.0 to 1.0 (double)';

/// Error message for integers and floats that must be in the range of 0
/// to 360, such as hue degrees or radians.  See [Hue]
const String errorMsg0to360 =
    'Invalid Floating-Point Number. Value must be non-null and in '
    'the range of 0.0 to 360.0';

/// Error message for integers that must be in the range of 0 to 255
/// See also [Uint8]
const String errorMsg0to255 =
    'Invalid Integer. Value must be non-null and in the ' //
    'range of 0 (zero) to 255 (0xFF), i.e. unsigned ' //
    'integer 8-bit from 0x00 to 0xFF';
