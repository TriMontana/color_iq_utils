import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// Represents a color in the Munsell color system.
///
/// The Munsell system models colors based on three properties:
/// - **Hue**: The basic color (e.g., Red, Yellow, Green). Represented as a string like "5R".
/// - **Value**: The lightness or darkness of the color, on a scale from 0 (black) to 10 (white).
/// - **Chroma**: The color's purity or saturation, starting from 0 for neutral gray.
///
/// Note: Conversion from Munsell to other color spaces like RGB is complex and
/// often requires lookup tables. This implementation provides an approximation.
/// Many methods ops the `MunsellColor` to a `ColorIQ` object first to perform
/// the operation, and then ops it back. This might lead to precision loss
/// due to the approximate nature of the Munsell to RGB conversion.
class MunsellColor extends CommonIQ implements ColorSpacesIQ {
  /// The Munsell hue, represented as a string (e.g., "5R", "10GY").
  final String hue;

  /// The Munsell value (lightness), ranging from 0 (black) to 10 (white).
  final double munsellValue;

  /// The Munsell chroma (saturation), starting from 0 for neutral gray.
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value =>
      super.colorId ?? MunsellColor.toHexId(hue, munsellValue, chroma);

  /// Creates a 32-bit hex ID from the Munsell properties.
  ///
  /// This method generates a reproducible ARGB integer value based on the
  /// Munsell color's components. It's intended for use as a unique identifier
  /// rather than a visually accurate color representation, as a direct Munsell
  /// to ARGB conversion is complex.
  ///
  /// - **Alpha**: Always 255 (fully opaque).
  /// - **Red**: Derived from the hash code of the `hue` string.
  /// - **Green**: Derived from `munsellValue`.
  /// - **Blue**: Derived from `chroma`.
  static int toHexId(
      final String hue, final double value, final double chroma) {
    const int alpha = 255;
    // Hue hash provides a consistent integer for the string.
    final int red = hue.hashCode % 256;
    // Value (0-10) and Chroma (0-50+) are scaled to fit in 0-255.
    final int green = (value * 25.5).round().clamp(0, 255);
    final int blue = (chroma * 5)
        .round()
        .clamp(0, 255); // Chroma can go high, scale it down.
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }

  @override
  ColorIQ toColor() {
    // Munsell conversion is complex and usually requires lookup tables.
    // For this implementation, we will return a placeholder or approximate if possible.
    // Since we don't have the tables, we'll return Black or throw.
    // Or better, return a neutral gray based on Value.
    // Value 0-10 maps to L* 0-100 roughly.
    final int grayVal = (munsellValue * 25.5).round().clamp(0, 255);
    return ColorIQ.fromArgbInts(
        alpha: 255, red: grayVal, green: grayVal, blue: grayVal);
  }

  @override
  MunsellColor darken([final double amount = 20]) {
    // Decrease Value
    return MunsellColor(
      hue,
      (munsellValue - (amount / 10)).clamp(0.0, 10.0),
      chroma,
    );
  }

  @override
  MunsellColor brighten([final double amount = 20]) {
    // Increase Value
    return MunsellColor(
      hue,
      (munsellValue + (amount / 10)).clamp(0.0, 10.0),
      chroma,
    );
  }

  @override
  MunsellColor saturate([final double amount = 25]) {
    // Increase Chroma
    return MunsellColor(
      hue,
      munsellValue,
      chroma + (amount / 5),
    ); // Arbitrary scale
  }

  @override
  MunsellColor desaturate([final double amount = 25]) {
    // Decrease Chroma
    return MunsellColor(hue, munsellValue, max(0.0, chroma - (amount / 5)));
  }

  MunsellColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  MunsellColor deintensify([final double amount = 10]) {
    return desaturate(amount);
  }

  @override
  MunsellColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  MunsellColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toMunsell();
  }

  @override
  MunsellColor adjustHue([final double amount = 20]) {
    // Munsell hue circle: R, YR, Y, GY, G, BG, B, PB, P, RP (10 hues)
    // Each hue has 10 steps (e.g., 1R to 10R)
    final List<String> hueLetters = <String>[
      'R',
      'YR',
      'Y',
      'GY',
      'G',
      'BG',
      'B',
      'PB',
      'P',
      'RP'
    ];

    // Parse current hue
    final RegExp huePattern = RegExp(r'(\d+(?:\.\d+)?)([A-Z]+)');
    final Match? match = huePattern.firstMatch(hue);
    if (match == null) return this;

    final double hueNum = double.parse(match.group(1)!);
    final String hueLetter = match.group(2)!;
    final int hueIndex = hueLetters.indexOf(hueLetter);
    if (hueIndex == -1) return this;

    // Convert to continuous hue value (0-100)
    final double continuousHue = hueIndex * 10 + hueNum;

    // Adjust by amount (treating amount as degrees, scale to 0-100 range)
    final double adjustedHue = (continuousHue + (amount * 100 / 360)) % 100;

    // Convert back to Munsell notation
    final int newHueIndex = (adjustedHue / 10).floor() % 10;
    final double newHueNum = (adjustedHue % 10).clamp(0.1, 10.0);
    final String newHue =
        '${newHueNum.toStringAsFixed(1)}${hueLetters[newHueIndex]}';

    return MunsellColor(newHue, munsellValue, chroma);
  }

  @override
  MunsellColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      lerp(other, amount / 100);

  @override
  MunsellColor get complementary => adjustHue(180);

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  MunsellColor opaquer([final double amount = 20]) => this;

  @override
  MunsellColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  MunsellColor blacken([final double amount = 20]) =>
      lerp(cBlack, amount / 100);

  @override
  MunsellColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;

    // Convert other to Munsell or approximate
    MunsellColor otherMunsell;
    if (other is MunsellColor) {
      otherMunsell = other;
    } else if (other.isEqual(cWhite)) {
      otherMunsell = const MunsellColor('N', 10.0, 0.0);
    } else if (other.isEqual(cBlack)) {
      otherMunsell = const MunsellColor('N', 0.0, 0.0);
    } else {
      otherMunsell = other.toColor().toMunsell();
    }

    if (t == 1.0) return otherMunsell;

    return MunsellColor(
      t < 0.5 ? hue : otherMunsell.hue,
      lerpDouble(munsellValue, otherMunsell.munsellValue, t),
      lerpDouble(chroma, otherMunsell.chroma, t),
    );
  }

  @override
  MunsellColor lighten([final double amount = 20]) {
    // Increase Value
    return MunsellColor(
      hue,
      (munsellValue + (amount / 10)).clamp(0.0, 10.0),
      chroma,
    );
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  MunsellColor copyWith({
    final String? hue,
    final double? munsellValue,
    final double? chroma,
  }) {
    return MunsellColor(
      hue ?? this.hue,
      munsellValue ?? this.munsellValue,
      chroma ?? this.chroma,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    final List<MunsellColor> results = <MunsellColor>[];
    // Create variations by changing value while keeping hue and chroma constant
    for (int i = 1; i <= 9; i++) {
      final double newValue = (i * 1.0).clamp(0.0, 10.0);
      results.add(MunsellColor(hue, newValue, chroma));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<MunsellColor> results = <MunsellColor>[];
    final double delta = step ?? 1.0; // Default step in Munsell value units

    for (int i = 1; i <= 5; i++) {
      final double newValue = (munsellValue + delta * i).clamp(0.0, 10.0);
      results.add(MunsellColor(hue, newValue, chroma));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<MunsellColor> results = <MunsellColor>[];
    final double delta = step ?? 1.0; // Default step in Munsell value units

    for (int i = 1; i <= 5; i++) {
      final double newValue = (munsellValue - delta * i).clamp(0.0, 10.0);
      results.add(MunsellColor(hue, newValue, chroma));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random {
    final Random rnd = Random();
    // Generate random Munsell hue string
    final List<String> hueLetters = <String>[
      'R',
      'YR',
      'Y',
      'GY',
      'G',
      'BG',
      'B',
      'PB',
      'P',
      'RP'
    ];
    final int hueNum = rnd.nextInt(10) + 1; // 1-10
    final String randomHue =
        '$hueNum${hueLetters[rnd.nextInt(hueLetters.length)]}';
    final double randomValue = rnd.nextDouble() * 10.0; // 0-10
    final double randomChroma = rnd.nextDouble() * 20.0; // 0-20 typical range
    return MunsellColor(randomHue, randomValue, randomChroma);
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is! MunsellColor) return false;
    const double epsilon = 0.001;
    return hue == other.hue &&
        (munsellValue - other.munsellValue).abs() < epsilon &&
        (chroma - other.chroma).abs() < epsilon;
  }

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  MunsellColor warmer([final double amount = 20]) {
    // In Munsell, warmer hues are around YR (Yellow-Red)
    // Adjust hue toward YR (roughly 30 degrees or index 1)
    return adjustHue(amount);
  }

  @override
  MunsellColor cooler([final double amount = 20]) {
    // In Munsell, cooler hues are around B (Blue)
    // Adjust hue in opposite direction
    return adjustHue(-amount);
  }

  @override
  List<MunsellColor> generateBasicPalette() {
    final List<MunsellColor> results = <MunsellColor>[];
    // Generate palette with variations in value (lightness)
    for (int i = 0; i < 9; i++) {
      final double newValue = (i * 1.25).clamp(0.0, 10.0);
      results.add(MunsellColor(hue, newValue, chroma));
    }
    return results;
  }

  @override
  List<MunsellColor> tonesPalette() {
    final List<MunsellColor> results = <MunsellColor>[];
    // Create tones by varying value around the current value
    final List<double> valueOffsets = <double>[-4, -3, -2, -1, 0, 1, 2, 3, 4];
    for (final double offset in valueOffsets) {
      final double newValue = (munsellValue + offset).clamp(0.0, 10.0);
      results.add(MunsellColor(hue, newValue, chroma));
    }
    return results;
  }

  @override
  List<MunsellColor> analogous({
    final int count = 5,
    final double offset = 30,
  }) {
    final List<MunsellColor> results = <MunsellColor>[this];
    final int side = count ~/ 2;

    for (int i = 1; i <= side; i++) {
      results.add(adjustHue(offset * i));
      results.insert(0, adjustHue(-offset * i));
    }

    return results.take(count).toList();
  }

  @override
  List<MunsellColor> square() {
    return <MunsellColor>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<MunsellColor> tetrad({final double offset = 60}) {
    return <MunsellColor>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'MunsellColor',
      'hue': hue,
      'value':
          munsellValue, // Using munsellValue to avoid conflict with value getter
      'chroma': chroma,
    };
  }

  @override
  String toString() =>
      'MunsellColor(hue: $hue, value: ${munsellValue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)})';

  @override
  Cam16 toCam16() => Cam16.fromInt(value);
}
