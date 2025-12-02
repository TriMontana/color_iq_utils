import 'package:color_iq_utils/src/color_interfaces.dart';
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
  final String name;

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
    (final double hue) => HsvColor(hue, saturation / 100, value / 100),
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
    for (ColorSlice slice in wheel) slice.name: slice,
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
    for (ColorSlice slice in wheel) slice.name: slice,
  };
}

/// Static access to the HCT color wheel slices.
final List<ColorSlice> hctSlices = generateHctWheel();

List<ColorSlice> _generateWheel(
  final ColorSpacesIQ Function(double hue) colorFactory,
  final double param1,
  final double param2, {
  final String Function(int index)? nameProvider,
}) {
  final List<ColorSlice> slices = <ColorSlice>[];
  const double step = 6.0; // 360 / 60
  final String Function(int index) getName = nameProvider ?? _getColorName;

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
String getColorNameFromHue(final double hue) {
  final int index = (hue / 6).round() % 60;
  return _getColorName(index);
}

/// Returns a name for one of the 60 color sections.
String _getColorName(final int index) {
  // ... (existing list)
  const List<String> finalNames = <String>[
    // 0-4 (Red -> Orange)
    "Red", "Red-Orange", "Vermilion", "Scarlet", "Orange-Red",
    // 5-9 (Orange -> Yellow)
    "Orange", "Deep Orange", "Amber", "Chrome Yellow", "Golden Yellow",
    // 10-14 (Yellow -> Green-Yellow)
    "Yellow", "Lemon", "Lime", "Chartreuse", "Lawn Green",
    // 15-19 (Green-Yellow -> Green)
    "Spring Green", "Harlequin", "Lime Green", "Pale Green", "Light Green",
    // 20-24 (Green -> Cyan-Green)
    "Green", "Medium Green", "Forest Green", "Emerald", "Jungle Green",
    // 25-29 (Cyan-Green -> Cyan)
    "Mint", "Teal", "Aqua", "Turquoise", "Sky Blue",
    // 30-34 (Cyan -> Blue-Cyan)
    "Cyan", "Cerulean", "Azure", "Cobalt", "Cornflower",
    // 35-39 (Blue-Cyan -> Blue)
    "Royal Blue", "Dodger Blue", "Deep Sky Blue", "Steel Blue", "Denim",
    // 40-44 (Blue -> Magenta-Blue)
    "Blue", "Medium Blue", "Dark Blue", "Indigo", "Blue-Violet",
    // 45-49 (Magenta-Blue -> Magenta)
    "Violet", "Purple", "Electric Purple", "Deep Purple", "Phlox",
    // 50-54 (Magenta -> Red-Magenta)
    "Magenta", "Fuchsia", "Orchid", "Deep Pink", "Hot Pink",
    // 55-59 (Red-Magenta -> Red)
    "Rose", "Raspberry", "Crimson", "Amaranth", "Ruby",
  ];

  if (index >= 0 && index < finalNames.length) {
    return finalNames[index];
  }
  return "Unknown";
}

/// Returns a name for one of the 60 HCT color sections.
/// HCT Red is around 27 degrees, so we shift the names.
String _getHctColorName(final int index) {
  // Shift by -4 indices (approx 24 degrees) so that HCT 27 (Index 4) maps to "Red" (Index 0).
  // (4 - 4) = 0.
  // We need to handle wrap around.
  int shiftedIndex = (index - 4) % 60;
  if (shiftedIndex < 0) shiftedIndex += 60;
  return _getColorName(shiftedIndex);
}
