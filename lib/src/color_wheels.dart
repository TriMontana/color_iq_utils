import 'color_interfaces.dart';
import 'models/hsv_color.dart';
import 'models/hct_color.dart';

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
List<ColorSlice> generateHsvWheel({double saturation = 100, double value = 100}) {
  return _generateWheel(
    (hue) => HsvColor(hue, saturation / 100, value / 100),
    saturation,
    value,
  );
}

/// Generates a 60-section HSV color wheel as a Map of names to slices.
/// [saturation] and [value] can be customized (default 100).
Map<String, ColorSlice> getHsvWheelMap({double saturation = 100, double value = 100}) {
  final wheel = generateHsvWheel(saturation: saturation, value: value);
  return {for (var slice in wheel) slice.name: slice};
}

/// Generates a 60-section HCT color wheel.
/// [chroma] and [tone] can be customized (default 50).
List<ColorSlice> generateHctWheel({double chroma = 50, double tone = 50}) {
  return _generateWheel(
    (hue) => HctColor(hue, chroma, tone),
    chroma,
    tone,
    nameProvider: _getHctColorName,
  );
}

/// Generates a 60-section HCT color wheel as a Map of names to slices.
/// [chroma] and [tone] can be customized (default 50).
Map<String, ColorSlice> getHctWheelMap({double chroma = 50, double tone = 50}) {
  final wheel = generateHctWheel(chroma: chroma, tone: tone);
  return {for (var slice in wheel) slice.name: slice};
}

/// Static access to the HCT color wheel slices.
final List<ColorSlice> hctSlices = generateHctWheel();

List<ColorSlice> _generateWheel(
  ColorSpacesIQ Function(double hue) colorFactory,
  double param1,
  double param2, {
  String Function(int index)? nameProvider,
}) {
  final slices = <ColorSlice>[];
  const step = 6.0; // 360 / 60
  final getName = nameProvider ?? _getColorName;

  for (int i = 0; i < 60; i++) {
    final startAngle = i * step;
    final endAngle = (i + 1) * step;
    final centerAngle = startAngle + (step / 2);
    
    slices.add(ColorSlice(
      color: colorFactory(centerAngle),
      startAngle: startAngle,
      endAngle: endAngle,
      name: getName(i),
    ));
  }
  return slices;
}

/// Returns a name for one of the 60 color sections.
String _getColorName(int index) {
  // 60 sections, 6 degrees each.
  // 0: 0-6 (Red)
  // 10: 60-66 (Yellow)
  // 20: 120-126 (Green)
  // 30: 180-186 (Cyan)
  // 40: 240-246 (Blue)
  // 50: 300-306 (Magenta)
  
  const fullNames = [
    "Red", "Red-Vermilion", "Vermilion", "Scarlet", "Orange-Red", // 0-24
    "Orange", "Deep Orange", "Amber", "Chrome Yellow", "Golden Yellow", // 30-54
    "Yellow", "Lemon Yellow", "Lime Yellow", "Chartreuse", "Yellow-Green", // 60-84
    "Lime", "Spring Green", "Harlequin", "Green", "Medium Green", // 90-114
    "Forest Green", "Emerald", "Jungle Green", "Mint", "Teal", // 120-144
    "Aqua", "Cyan", "Turquoise", "Sky Blue", "Cerulean", // 150-174
    "Azure", "Cobalt", "Blue", "Medium Blue", "Dark Blue", // 180-204
    "Indigo", "Blue-Violet", "Violet", "Purple", "Electric Purple", // 210-234
    "Deep Purple", "Phlox", "Magenta", "Fuchsia", "Orchid", // 240-264
    "Deep Pink", "Hot Pink", "Rose", "Raspberry", "Crimson", // 270-294
    "Amaranth", "Ruby", "Cardinal", "Carmine", "Burgundy", // 300-324
    "Maroon", "Brown", "Sienna", "Rust", "Garnet" // 330-354
  ];
  
  // Corrected list to better align with HSV:
  // 0: Red
  // 10: Yellow
  // 20: Green
  // 30: Cyan
  // 40: Blue
  // 50: Magenta
  
  const alignedNames = [
    "Red", "Red-Orange", "Vermilion", "Scarlet", "Orange-Red", // 0-24
    "Orange", "Deep Orange", "Amber", "Chrome Yellow", "Golden Yellow", // 30-54
    "Yellow", "Lemon", "Lime", "Chartreuse", "Lawn Green", // 60-84
    "Spring Green", "Harlequin", "Green", "Medium Green", "Forest Green", // 90-114
    "Emerald", "Jungle Green", "Mint", "Teal", "Aqua", // 120-144
    "Cyan", "Turquoise", "Sky Blue", "Cerulean", "Azure", // 150-174
    "Cobalt", "Blue", "Medium Blue", "Dark Blue", "Indigo", // 180-204
    "Blue-Violet", "Violet", "Purple", "Electric Purple", "Deep Purple", // 210-234
    "Phlox", "Magenta", "Fuchsia", "Orchid", "Deep Pink", // 240-264
    "Hot Pink", "Rose", "Raspberry", "Crimson", "Amaranth", // 270-294
    "Ruby", "Cardinal", "Carmine", "Burgundy", "Maroon", // 300-324
    "Brown", "Sienna", "Rust", "Garnet", "Dark Red" // 330-354
  ];
  
  // Wait, I need to be careful with indices.
  // 0: Red
  // 10: Yellow (60 deg).
  // 20: Green (120 deg).
  // 30: Cyan (180 deg).
  // 40: Blue (240 deg).
  // 50: Magenta (300 deg).
  
  const hsvNames = [
    "Red", "Red-Orange", "Vermilion", "Scarlet", "Orange-Red", // 0-24
    "Orange", "Deep Orange", "Amber", "Chrome Yellow", "Golden Yellow", // 30-54
    "Yellow", "Lemon", "Lime", "Chartreuse", "Lawn Green", // 60-84
    "Spring Green", "Harlequin", "Green", "Medium Green", "Forest Green", // 90-114
    "Emerald", "Jungle Green", "Mint", "Teal", "Aqua", // 120-144
    "Turquoise", "Sky Blue", "Cerulean", "Azure", "Cyan", // 150-174 (Cyan at 29? No, 174-180 is 29. 180 starts at 30)
    // Wait, 180 is Index 30. So Cyan should be at 30.
    // Let's shift "Cyan" to 30.
    // 25-29 needs to be Green-Cyan to Cyan.
    // 30 needs to be Cyan.
  ];
  
  // Let's try again with strict anchors.
  const alignedHsvNames = [
    // 0-9 (Red to Yellow)
    "Red", "Red-Orange", "Vermilion", "Scarlet", "Orange-Red", // 0, 6, 12, 18, 24
    "Orange", "Deep Orange", "Amber", "Chrome Yellow", "Golden Yellow", // 30, 36, 42, 48, 54
    
    // 10-19 (Yellow to Green)
    "Yellow", "Lemon", "Lime", "Chartreuse", "Lawn Green", // 60, 66, 72, 78, 84
    "Spring Green", "Harlequin", "Green-Yellow", "Lime Green", "Pale Green", // 90, 96, 102, 108, 114
    
    // 20-29 (Green to Cyan)
    "Green", "Medium Green", "Forest Green", "Emerald", "Jungle Green", // 120, 126, 132, 138, 144
    "Mint", "Teal", "Aqua", "Turquoise", "Sky Blue", // 150, 156, 162, 168, 174
    
    // 30-39 (Cyan to Blue)
    "Cyan", "Cerulean", "Azure", "Cobalt", "Cornflower", // 180, 186, 192, 198, 204
    "Blue", "Medium Blue", "Dark Blue", "Royal Blue", "Indigo", // 210, 216, 222, 228, 234 (Blue is 240, so Blue should be at 40)
    
    // Wait, Blue is 240. Index 40.
    // My list above has Blue at 35 (210). That's wrong.
    // 210 is Azure/Blue-Cyan.
    // 240 is Blue.
    
    // Let's restart the list carefully.
  ];

  const finalNames = [
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
    "Rose", "Raspberry", "Crimson", "Amaranth", "Ruby"
  ];

  if (index >= 0 && index < finalNames.length) {
      return finalNames[index];
  }
  return "Unknown";
}

/// Returns a name for one of the 60 HCT color sections.
/// HCT Red is around 27 degrees, so we shift the names.
String _getHctColorName(int index) {
  // Shift by -4 indices (approx 24 degrees) so that HCT 27 (Index 4) maps to "Red" (Index 0).
  // (4 - 4) = 0.
  // We need to handle wrap around.
  int shiftedIndex = (index - 4) % 60;
  if (shiftedIndex < 0) shiftedIndex += 60;
  return _getColorName(shiftedIndex);
}
