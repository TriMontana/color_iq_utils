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
// Define outside the class, at the top of your file

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
// ---------------------------------------- Symbols ----------------------------------------
const String unicodePrefix = '\\u';
const String kAmpersand = '\u{0026}'; // '&'; Dec 38, Hex 26
const String kAsterisk = '\u{002A}'; //  *
const String kEmptyStr = '';
// const String kEmptyString = emptyStr;
const String equalsSign = '\u{003D}'; // equality sign =
const String notEqualsSign = '\u{2260}'; // not equals to  ≠
const String plusSign = '\u{002B}'; // +  // aka Addition Operator
const String newLine = '\u{000D}\u{000A}'; // same as \r\n
const String kNL = newLine; // Unicode, NewLine
// '.'; // dot, period, (U+002E),  FullStop, Decimal
const String dot = '\u{002E}';
const String period = dot;
const String minusSign = '\u{2212}'; //  '−', aka hyphen
const String leftTriplePrime = '\u{2037}'; //  ‷
const String rightTriplePrime = '\u{2034}'; //  ‴
const String slash = '\u{002F}'; //   / also called Solidus
const String solidus = slash;
const String kReverseSolidus = '\u{005C}'; // \
const String kDegreeSign = '\u{00B0}'; //  ° aka DegreeSymbol
const String degreeCelsius = '\u{2103}'; // U+2103 ℃ DEGREE CELSIUS
const String degreeFahrenheit = '\u{2109}'; // U+2109 ℉ DEGREE
const String kDollarSign = '\u{0024}'; // $
// ---------------------------------------- Names ----------------------------------------
const String kMagenta = 'Magenta';
const String kRed = 'Red';
const String kYellow = 'Yellow';
