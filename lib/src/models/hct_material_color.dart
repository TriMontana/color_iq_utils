import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:material_color_utilities/hct/hct.dart';

/// Enum representing all Material Design color shades.
///
/// This combines both primary shades (50-900) and accent shades (A100-A700)
/// into a single sortable enum. Primary shades sort first, then accents.
///
/// Each shade has an associated [tone] (0-100 lightness in HCT) and
/// [chromaFactor] for generating perceptually consistent color palettes.
enum MaterialShade implements Comparable<MaterialShade> {
  // Primary shades (ordered by ascending tone darkness)
  s50(50, tone: 98, chromaFactor: 0.4),
  s100(100, tone: 95, chromaFactor: 0.5),
  s200(200, tone: 90, chromaFactor: 0.6),
  s300(300, tone: 80, chromaFactor: 0.8),
  s400(400, tone: 70, chromaFactor: 0.9),
  s500(500, tone: 60, chromaFactor: 1.0), // Base/primary color
  s600(600, tone: 50, chromaFactor: 1.0),
  s700(700, tone: 40, chromaFactor: 0.95),
  s800(800, tone: 30, chromaFactor: 0.9),
  s900(900, tone: 20, chromaFactor: 0.85),

  // Accent shades (higher chroma for vibrancy)
  a100(100, tone: 90, chromaFactor: 1.3, isAccent: true),
  a200(200, tone: 80, chromaFactor: 1.5, isAccent: true), // Primary accent
  a400(400, tone: 60, chromaFactor: 1.4, isAccent: true),
  a700(700, tone: 40, chromaFactor: 1.2, isAccent: true);

  /// The Material Design shade value (50, 100, 200, etc.)
  final int value;

  /// The HCT tone (lightness) for this shade, 0-100.
  final double tone;

  /// Factor to multiply base chroma by. Accents typically have higher values.
  final double chromaFactor;

  /// Whether this is an accent shade.
  final bool isAccent;

  const MaterialShade(
    this.value, {
    required this.tone,
    required this.chromaFactor,
    this.isAccent = false,
  });

  /// Returns the sort key for ordering (primary shades first, then accents).
  int get _sortKey => isAccent ? 1000 + value : value;

  @override
  int compareTo(final MaterialShade other) =>
      _sortKey.compareTo(other._sortKey);

  /// Returns the display name, e.g., "500" or "A200".
  String get displayName => isAccent ? 'A$value' : '$value';

  /// All primary (non-accent) shades.
  static List<MaterialShade> get primaryShades =>
      values.where((final MaterialShade s) => !s.isAccent).toList();

  /// All accent shades.
  static List<MaterialShade> get accentShades =>
      values.where((final MaterialShade s) => s.isAccent).toList();
}

/// A Material Design color palette generated using HCT (Hue, Chroma, Tone).
///
/// This class unifies Flutter's [MaterialColor] and [MaterialAccentColor] into
/// a single class, using the perceptually uniform HCT color space to generate
/// consistent, visually pleasing palettes.
///
/// Example:
/// ```dart
/// // Create from a seed color
/// final palette = HctMaterialColor.fromColor(ColorIQ(0xFF2196F3));
///
/// // Access shades
/// final primary = palette[MaterialShade.s500]; // Base color
/// final light = palette[MaterialShade.s200];   // Light variant
/// final accent = palette[MaterialShade.a200];  // Vibrant accent
///
/// // Get sorted map of all shades
/// final allShades = palette.toSortedMap();
/// ```
class HctMaterialColor {
  /// The hue of this color palette (0-360 degrees).
  final double hue;

  /// The base chroma (colorfulness) of this palette.
  final double chroma;

  /// Cached shade colors.
  final Map<MaterialShade, ColorIQ> _shades = <MaterialShade, ColorIQ>{};

  /// Creates an [HctMaterialColor] from hue and chroma values.
  ///
  /// - [hue]: The hue angle in degrees (0-360).
  /// - [chroma]: The base chroma (colorfulness). Typical values are 30-90.
  HctMaterialColor({
    required this.hue,
    required this.chroma,
  });

  /// Creates an [HctMaterialColor] from a seed color.
  ///
  /// Extracts the hue and chroma from the seed color using HCT.
  factory HctMaterialColor.fromColor(final ColorIQ color) {
    final Hct hct = Hct.fromInt(color.value);
    return HctMaterialColor(hue: hct.hue, chroma: hct.chroma);
  }

  /// Creates an [HctMaterialColor] from an ARGB integer.
  factory HctMaterialColor.fromInt(final int argb) {
    final Hct hct = Hct.fromInt(argb);
    return HctMaterialColor(hue: hct.hue, chroma: hct.chroma);
  }

  /// Creates an [HctMaterialColor] from HCT values directly.
  factory HctMaterialColor.fromHct(final Hct hct) {
    return HctMaterialColor(hue: hct.hue, chroma: hct.chroma);
  }

  /// Gets the color for a specific [MaterialShade].
  ColorIQ operator [](final MaterialShade shade) {
    return _shades.putIfAbsent(shade, () => _generateShade(shade));
  }

  /// Generates a color for the given shade using HCT.
  ColorIQ _generateShade(final MaterialShade shade) {
    final double effectiveChroma = chroma * shade.chromaFactor;
    final Hct hct = Hct.from(hue, effectiveChroma, shade.tone);
    return ColorIQ(hct.toInt());
  }

  /// The primary color (shade 500).
  ColorIQ get primary => this[MaterialShade.s500];

  /// The primary accent color (shade A200).
  ColorIQ get accent => this[MaterialShade.a200];

  /// The lightest primary shade (50).
  ColorIQ get lightest => this[MaterialShade.s50];

  /// The darkest primary shade (900).
  ColorIQ get darkest => this[MaterialShade.s900];

  /// Returns all primary (non-accent) shades as a sorted map.
  Map<MaterialShade, ColorIQ> get primaryShades {
    return Map<MaterialShade, ColorIQ>.fromEntries(
      MaterialShade.primaryShades.map(
        (final MaterialShade s) => MapEntry<MaterialShade, ColorIQ>(s, this[s]),
      ),
    );
  }

  /// Returns all accent shades as a sorted map.
  Map<MaterialShade, ColorIQ> get accentShades {
    return Map<MaterialShade, ColorIQ>.fromEntries(
      MaterialShade.accentShades.map(
        (final MaterialShade s) => MapEntry<MaterialShade, ColorIQ>(s, this[s]),
      ),
    );
  }

  /// Returns all shades (primary + accent) as a sorted map.
  Map<MaterialShade, ColorIQ> toSortedMap() {
    final List<MaterialShade> sorted = MaterialShade.values.toList()..sort();
    return Map<MaterialShade, ColorIQ>.fromEntries(
      sorted.map(
        (final MaterialShade s) => MapEntry<MaterialShade, ColorIQ>(s, this[s]),
      ),
    );
  }

  /// Returns a list of all colors in sort order.
  List<ColorIQ> toList() {
    final List<MaterialShade> sorted = MaterialShade.values.toList()..sort();
    return sorted.map((final MaterialShade s) => this[s]).toList();
  }

  /// Returns the shade whose tone is closest to the given [tone].
  MaterialShade closestShade(
    final double tone, {
    final bool includeAccents = false,
  }) {
    final Iterable<MaterialShade> candidates =
        includeAccents ? MaterialShade.values : MaterialShade.primaryShades;

    return candidates.reduce(
      (final MaterialShade a, final MaterialShade b) =>
          (a.tone - tone).abs() < (b.tone - tone).abs() ? a : b,
    );
  }

  /// Returns a new palette with the same hue but different chroma.
  HctMaterialColor withChroma(final double newChroma) {
    return HctMaterialColor(hue: hue, chroma: newChroma);
  }

  /// Returns a new palette with adjusted hue.
  HctMaterialColor withHue(final double newHue) {
    return HctMaterialColor(hue: newHue, chroma: chroma);
  }

  /// Returns a new palette with hue shifted by [degrees].
  HctMaterialColor adjustHue(final double degrees) {
    return HctMaterialColor(hue: (hue + degrees) % 360, chroma: chroma);
  }

  /// Creates a complementary palette (180° hue shift).
  HctMaterialColor get complementary => adjustHue(180);

  /// Creates an analogous palette shifted by [offset] degrees.
  List<HctMaterialColor> analogous({
    final int count = 3,
    final double offset = 30,
  }) {
    final List<HctMaterialColor> result = <HctMaterialColor>[];
    final int half = count ~/ 2;
    for (int i = -half; i <= half; i++) {
      if (result.length >= count) break;
      result.add(adjustHue(i * offset));
    }
    return result;
  }

  /// Creates a triadic color scheme (3 colors, 120° apart).
  List<HctMaterialColor> get triadic => <HctMaterialColor>[
        this,
        adjustHue(120),
        adjustHue(240),
      ];

  @override
  String toString() =>
      'HctMaterialColor(hue: ${hue.toStringAsFixed(1)}, chroma: ${chroma.toStringAsFixed(1)})';
}
