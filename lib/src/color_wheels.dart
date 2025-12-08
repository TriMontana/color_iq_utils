import 'package:color_iq_utils/src/colors_lib.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';

/// Represents a slice of a color wheel.
class ColorSlice {
  /// The color of this slice.
  final ColorSpacesIQ color;

  /// The starting angle of this slice in degrees (inclusive).
  final double startAngle;

  /// The ending angle of this slice in degrees (exclusive).
  final double endAngle;

  /// The name of the color range.
  final List<String> name;

  const ColorSlice({
    required this.color,
    required this.startAngle,
    required this.endAngle,
    required this.name,
  });
}

/// Generates a 60-section HSV color wheel.
/// [saturation] and [value] can be customized (default 100).
List<ColorSlice> generateHsvWheel({
  final double saturation = 100,
  final double value = 100,
}) {
  return _generateWheel(
    (final double hue) =>
        HSV(hue, Percent(saturation / 100), Percent(value / 100)),
    saturation,
    value,
  );
}

/// Generates a 60-section HSV color wheel as a Map of names to slices.
/// [saturation] and [value] can be customized (default 100).
Map<String, ColorSlice> getHsvWheelMap({
  final double saturation = 100,
  final double value = 100,
}) {
  final List<ColorSlice> wheel = generateHsvWheel(
    saturation: saturation,
    value: value,
  );
  return <String, ColorSlice>{
    for (ColorSlice slice in wheel) slice.name[0]: slice,
  };
}

/// Generates a 60-section HCT color wheel.
/// [chroma] and [tone] can be customized (default 50).
List<ColorSlice> generateHctWheel({
  final double chroma = 50,
  final double tone = 50,
}) {
  return _generateWheel(
    (final double hue) => HctColor.alt(hue, chroma, tone),
    chroma,
    tone,
    nameProvider: _getHctColorName,
  );
}

/// Generates a 60-section HCT color wheel as a Map of names to slices.
/// [chroma] and [tone] can be customized (default 50).
Map<String, ColorSlice> getHctWheelMap({
  final double chroma = 50,
  final double tone = 50,
}) {
  final List<ColorSlice> wheel = generateHctWheel(chroma: chroma, tone: tone);
  return <String, ColorSlice>{
    for (ColorSlice slice in wheel) slice.name[0]: slice,
  };
}

/// Static access to the HCT color wheel slices.
final List<ColorSlice> hctSlices = generateHctWheel();

List<ColorSlice> _generateWheel(
  final ColorSpacesIQ Function(double hue) colorFactory,
  final double param1,
  final double param2, {
  final List<String> Function(int index)? nameProvider,
}) {
  final List<ColorSlice> slices = <ColorSlice>[];
  const double step = 6.0; // 360 / 60
  final List<String> Function(int index) getName =
      nameProvider ?? _getColorName;

  for (int i = 0; i < 60; i++) {
    final double startAngle = i * step;
    final double endAngle = (i + 1) * step;
    final double centerAngle = startAngle + (step / 2);

    slices.add(
      ColorSlice(
        color: colorFactory(centerAngle),
        startAngle: startAngle,
        endAngle: endAngle,
        name: getName(i),
      ),
    );
  }
  return slices;
}

/// Returns a name for the given hue (0-360).
List<String> getColorNameFromHue(final double hue) {
  final int index = (hue / 6).round() % 60;
  return _getColorName(index);
}

/// Returns a name for one of the 60 color sections.
List<String> _getColorName(final int index) {
  // ... (existing list)
  const List<List<String>> finalNames = <List<String>>[
    // 0-4 (Red -> Orange)
    kRed, kRedOrange, kVermilion, kScarlet, kOrangeRed,
    // 5-9 (Orange -> Yellow)
    kOrange, kDeepOrange, kAmber, kChromeYellow, kGoldenYellow,
    // 10-14 (Yellow -> Green-Yellow)
    kYellow, kLemon, kLime, kChartreuse, kLawnGreen,
    // 15-19 (Green-Yellow -> Green)
    kSpringGreen, kHarlequin, kLimeGreen, kPaleGreen, kLightGreen,
    // 20-24 (Green -> Cyan-Green)
    kGreen, kMediumGreen, kForestGreen, kEmerald, kJungleGreen,
    // 25-29 (Cyan-Green -> Cyan)
    kMint, kTeal, kAqua, kTurquoise, kSkyBlue,
    // 30-34 (Cyan -> Blue-Cyan)
    kCyan, kCerulean, kAzure, kCobalt, kCornflower,
    // 35-39 (Blue-Cyan -> Blue)
    kRoyalBlue, kDodgerBlue, kDeepSkyBlue, kSteelBlue, kDenim,
    // 40-44 (Blue -> Magenta-Blue)
    kBlue, kMediumBlue, kDarkBlue, kIndigo, kBlueViolet,
    // 45-49 (Magenta-Blue -> Magenta)
    kViolet, kPurple, kElectricPurple, kDeepPurple, kPhlox,
    // 50-54 (Magenta -> Red-Magenta)
    kMagenta, kFuchsia, kOrchid, kDeepPink, kHotPink,
    // 55-59 (Red-Magenta -> Red)
    kRose, kRaspberry, kCrimson, kAmaranth, kRuby,
  ];

  if (index >= 0 && index < finalNames.length) {
    return finalNames[index];
  }
  return <String>["Unknown", 'Desconocido'];
}

/// Returns a name for one of the 60 color sections.
ColorIQ getColorBySectionIndex(final int index) {
  // ... (existing list)
  final List<ColorIQ> finalNames = <ColorIQ>[
    // 0-4 (Red -> Orange)
    cRed, cRedOrange, cVermilion, cScarlet, cOrangeRed,
    // 5-9 (Orange -> Yellow)
    cOrange, cDeepOrange, cAmber, cChromeYellow, cGoldenYellow,
    // 10-14 (Yellow -> Green-Yellow)
    cYellow, cLemon, cLime, cChartreuse, cLawnGreen,
    // 15-19 (Green-Yellow -> Green)
    cSpringGreen, cHarlequin, cLimeGreen, cPaleGreen, cLightGreen,
    // 20-24 (Green -> Cyan-Green)
    cGreen, cMediumGreen, cForestGreen, cEmerald, cJungleGreen,
    // 25-29 (Cyan-Green -> Cyan)
    cMint, cTeal, cAqua, cTurquoise, cSkyBlue,
    // 30-34 (Cyan -> Blue-Cyan)
    cCyan, cCerulean, cAzure, cCobalt, cCornflower,
    // 35-39 (Blue-Cyan -> Blue)
    cRoyalBlue, cDodgerBlue, cDeepSkyBlue, cSteelBlue, cDenim,
    // 40-44 (Blue -> Magenta-Blue)
    cBlue, cMediumBlue, cDarkBlue, cIndigo, cBlueViolet,
    // 45-49 (Magenta-Blue -> Magenta)
    cViolet, cPurple, cElectricPurple, cDeepPurple, cPhlox,
    // 50-54 (Magenta -> Red-Magenta)
    cMagenta, cFuchsia, cOrchid, cDeepPink, cHotPink,
    // 55-59 (Red-Magenta -> Red)
    cRose, cRaspberry, cCrimson, cAmaranth, cRuby,
  ];

  if (index >= 0 && index < finalNames.length) {
    return finalNames[index];
  }
  return cBlack;
}

/// Returns a name for one of the 60 HCT color sections.
/// HCT Red is around 27 degrees, so we shift the names.
List<String> _getHctColorName(final int index) {
  // Shift by -4 indices (approx 24 degrees) so that HCT 27 (Index 4) maps to "Red" (Index 0).
  // (4 - 4) = 0.
  // We need to handle wrap around.
  int shiftedIndex = (index - 4) % 60;
  if (shiftedIndex < 0) shiftedIndex += 60;
  return _getColorName(shiftedIndex);
}
