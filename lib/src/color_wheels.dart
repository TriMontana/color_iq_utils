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

/// Generates a 60-section HCT color wheel.
/// [chroma] and [tone] can be customized (default 50).
List<ColorSlice> generateHctWheel({double chroma = 50, double tone = 50}) {
  return _generateWheel(
    (hue) => HctColor(hue, chroma, tone),
    chroma,
    tone,
  );
}

List<ColorSlice> _generateWheel(
  ColorSpacesIQ Function(double hue) colorFactory,
  double param1,
  double param2,
) {
  final slices = <ColorSlice>[];
  const step = 6.0; // 360 / 60

  for (int i = 0; i < 60; i++) {
    final startAngle = i * step;
    final endAngle = (i + 1) * step;
    final centerAngle = startAngle + (step / 2);
    
    slices.add(ColorSlice(
      color: colorFactory(centerAngle),
      startAngle: startAngle,
      endAngle: endAngle,
      name: _getColorName(i),
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
  
  // Better approach: Interpolate names or use a fixed 60-item list.
  // I will provide a generated list of 60 names.
  const fullNames = [
    "Red", "Red-Vermilion", "Vermilion", "Deep Orange", "Orange-Red",
    "Orange", "Dark Orange", "Amber", "Golden Yellow", "Gold",
    "Yellow", "Lemon Yellow", "Lime Yellow", "Yellow-Green", "Chartreuse",
    "Lime", "Light Green", "Harlequin", "Green", "Medium Green",
    "Forest Green", "Emerald", "Jungle Green", "Mint", "Teal",
    "Aqua", "Cyan", "Turquoise", "Sky Blue", "Cerulean",
    "Azure", "Cobalt", "Blue", "Medium Blue", "Dark Blue",
    "Indigo", "Blue-Violet", "Violet", "Purple", "Electric Purple",
    "Deep Purple", "Phlox", "Magenta", "Fuchsia", "Orchid",
    "Deep Pink", "Hot Pink", "Rose", "Raspberry", "Crimson",
    "Amaranth", "Ruby", "Cardinal", "Carmine", "Burgundy",
    "Maroon", "Brown", "Sienna", "Rust", "Scarlet" 
  ];
  
  if (index >= 0 && index < fullNames.length) {
      return fullNames[index];
  }
  return "Unknown";
}
