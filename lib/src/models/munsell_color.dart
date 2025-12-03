import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
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
/// Many methods convert the `MunsellColor` to a `ColorIQ` object first to perform
/// the operation, and then convert it back. This might lead to precision loss
/// due to the approximate nature of the Munsell to RGB conversion.
class MunsellColor with ColorModelsMixin implements ColorSpacesIQ {
  /// The Munsell hue, represented as a string (e.g., "5R", "10GY").
  final String hue;

  /// The Munsell value (lightness), ranging from 0 (black) to 10 (white).
  final double munsellValue;

  /// The Munsell chroma (saturation), starting from 0 for neutral gray.
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma);

  @override
  ColorIQ toColor() {
    // Munsell conversion is complex and usually requires lookup tables.
    // For this implementation, we will return a placeholder or approximate if possible.
    // Since we don't have the tables, we'll return Black or throw.
    // Or better, return a neutral gray based on Value.
    // Value 0-10 maps to L* 0-100 roughly.
    final int grayVal = (munsellValue * 25.5).round().clamp(0, 255);
    return ColorIQ.fromARGB(255, grayVal, grayVal, grayVal);
  }

  @override
  int get value => toColor().value;

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

  @override
  MunsellColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
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
  List<int> get srgb => toColor().srgb;

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
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  MunsellColor get inverted => toColor().inverted.toMunsell();

  @override
  MunsellColor get grayscale => toColor().grayscale.toMunsell();

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

  @override
  HctColor toHct() => toColor().toHct();

  @override
  MunsellColor fromHct(final HctColor hct) => hct.toColor().toMunsell();

  @override
  MunsellColor adjustTransparency([final double amount = 20]) {
    // Munsell doesn't have alpha, so we ignore or return as is (conceptually)
    // But interface requires returning same type.
    // Since we don't store alpha, we can't really adjust it.
    return this;
  }

  @override
  double get transparency => 0.0;

  @override
  ColorTemperature get temperature => toColor().temperature;

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
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

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
