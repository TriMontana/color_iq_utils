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
    return ColorIQ.fromArgbInts(255, grayVal, grayVal, grayVal);
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
  MunsellColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toMunsell();

  @override
  MunsellColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toMunsell();

  @override
  MunsellColor get complementary => toColor().complementary.toMunsell();

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  MunsellColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toMunsell();

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
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toMunsell())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toMunsell())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toMunsell())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toMunsell();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  @override
  MunsellColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toMunsell();

  @override
  MunsellColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toMunsell();

  @override
  List<MunsellColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toMunsell())
      .toList();

  @override
  List<MunsellColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toMunsell()).toList();

  @override
  List<MunsellColor> analogous({
    final int count = 5,
    final double offset = 30,
  }) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toMunsell())
          .toList();

  @override
  List<MunsellColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toMunsell()).toList();

  @override
  List<MunsellColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toMunsell())
      .toList();

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
