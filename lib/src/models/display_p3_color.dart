import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// A representation of a color in the Display P3 color space.
///
/// The Display P3 color space, developed by Apple Inc., offers a wider gamut
/// than sRGB, particularly in the reds and greens. This makes it suitable for
/// displaying rich, vibrant colors on compatible devices.
///
/// `DisplayP3Color` stores color values as `r`, `g`, and `b` components,
/// each ranging from 0.0 to 1.0.
///
/// This class implements the `ColorSpacesIQ` interface, providing a rich set
/// of methods for color manipulation, conversion, and analysis. It seamlessly
/// integrates with other color models in the library, such as `ColorIQ` (sRGB)
/// and `HctColor`, by converting to and from `ColorIQ` as an intermediary.
///
class DisplayP3Color extends ColorSpacesIQ with ColorModelsMixin {
  @override
  final double r;
  @override
  final double g;
  @override
  final double b;

  const DisplayP3Color(this.r, this.g, this.b, {required final int hexId})
      : super(hexId);

  DisplayP3Color.alt(this.r, this.g, this.b, {final int? hexId})
      : super(hexId ?? DisplayP3Color.toHexId(r, g, b));

  static DisplayP3Color fromInt(final int hexId) {
    final XyzColor xyz = XyzColor.xyzFromRgbLinearized(
        hexId.redLinearized, hexId.greenLinearized, hexId.blueLinearized);

    // XYZ (D65) to Display P3 Linear
    // Matrix from http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
    // or Apple's specs.
    // Using standard P3 D65 matrix.
    double rP3 = xyz.x * 2.4934969 + xyz.y * -0.9313836 + xyz.z * -0.4027107;
    double gP3 = xyz.x * -0.8294889 + xyz.y * 1.7626640 + xyz.z * 0.0236246;
    double bP3 = xyz.x * 0.0358458 + xyz.y * -0.0761723 + xyz.z * 0.9568845;

    // Gamma correction (Transfer function) for Display P3 is sRGB curve.
    rP3 = rP3.gammaCorrect;
    gP3 = gP3.gammaCorrect;
    bP3 = bP3.gammaCorrect;

    return DisplayP3Color.alt(rP3, gP3, bP3);
  }

  /// Creates a 32-bit integer ARGB value from Display P3 components.
  static int toHexId(final double r, final double g, final double b) {
    // Gamma decoding (P3 to Linear), Linearize
    // Gamma decoding (P3 to Linear), Linearize
    final double rLin = srgbToLinear(r.clamp(0.0, 1.0));
    final double gLin = srgbToLinear(g.clamp(0.0, 1.0));
    final double bLin = srgbToLinear(b.clamp(0.0, 1.0));

    // Display P3 Linear to XYZ (D65)
    final double x = rLin * 0.4865709 + gLin * 0.2656677 + bLin * 0.1982173;
    final double y = rLin * 0.2289746 + gLin * 0.6917385 + bLin * 0.0792869;
    final double z = rLin * 0.0000000 + gLin * 0.0451134 + bLin * 1.0439444;

    // XYZ (D65) to sRGB Linear
    double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
    double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
    double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;

    // sRGB Linear to sRGB (Gamma encoded)
    rS = (rS > 0.0031308) ? (1.055 * pow(rS, 1 / 2.4) - 0.055) : (12.92 * rS);
    gS = (gS > 0.0031308) ? (1.055 * pow(gS, 1 / 2.4) - 0.055) : (12.92 * gS);
    bS = (bS > 0.0031308) ? (1.055 * pow(bS, 1 / 2.4) - 0.055) : (12.92 * bS);

    const int a = 0xFF;
    final int r8 = (rS * 255).round().clamp(0, 255);
    final int g8 = (gS * 255).round().clamp(0, 255);
    final int b8 = (bS * 255).round().clamp(0, 255);

    return (a << 24) | (r8 << 16) | (g8 << 8) | b8;
  }

  // Display P3 Linear to XYZ (D65)
  static XyzColor displayP3LinearsToXyz(
      final double rLin, final double gLin, final double bLin) {
    final double x = rLin * 0.4865709 + gLin * 0.2656677 + bLin * 0.1982173;
    final double y = rLin * 0.2289746 + gLin * 0.6917385 + bLin * 0.0792869;
    final double z = rLin * 0.0000000 + gLin * 0.0451134 + bLin * 1.0439444;
    return XyzColor.alt(x, y, z);
  }

  @override
  ColorIQ toColor() {
    // Gamma decoding (P3 to Linear)
    // Gamma decoding (P3 to Linear)
    final double rLin = srgbToLinear(r.clamp(0.0, 1.0));
    final double gLin = srgbToLinear(g.clamp(0.0, 1.0));
    final double bLin = srgbToLinear(b.clamp(0.0, 1.0));

    // Display P3 Linear to XYZ (D65)
    final XyzColor xyz = displayP3LinearsToXyz(rLin, gLin, bLin);

    // XYZ (D65) to sRGB Linear
    final double rS =
        xyz.x * 3.2404542 + xyz.y * -1.5371385 + xyz.z * -0.4985314;
    final double gS =
        xyz.x * -0.9692660 + xyz.y * 1.8760108 + xyz.z * 0.0415560;
    final double bS =
        xyz.x * 0.0556434 + xyz.y * -0.2040259 + xyz.z * 1.0572252;

    // sRGB Linear to sRGB (Gamma encoded)
    return ColorIQ.fromSrgb(
      a: 1.0,
      r: rS.gammaCorrect,
      g: gS.gammaCorrect,
      b: bS.gammaCorrect,
    );
  }

  @override
  DisplayP3Color darken([final double amount = 20]) {
    return toColor().darken(amount).toDisplayP3();
  }

  @override
  DisplayP3Color brighten([final double amount = 20]) {
    return toColor().brighten(amount).toDisplayP3();
  }

  @override
  DisplayP3Color saturate([final double amount = 25]) {
    return toColor().saturate(amount).toDisplayP3();
  }

  @override
  DisplayP3Color desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toDisplayP3();
  }

  @override
  DisplayP3Color intensify([final double amount = 10]) {
    return toColor().intensify(amount).toDisplayP3();
  }

  @override
  DisplayP3Color deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toDisplayP3();
  }

  @override
  DisplayP3Color accented([final double amount = 15]) {
    return toColor().accented(amount).toDisplayP3();
  }

  @override
  DisplayP3Color simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toDisplayP3();
  }

  @override
  DisplayP3Color get inverted => toColor().inverted.toDisplayP3();

  @override
  DisplayP3Color get grayscale => toColor().grayscale.toDisplayP3();

  @override
  DisplayP3Color whiten([final double amount = 20]) =>
      lerp(cWhite, amount / 100);

  @override
  DisplayP3Color blacken([final double amount = 20]) =>
      lerp(cBlack, amount / 100);

  @override
  DisplayP3Color lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final DisplayP3Color otherP3 =
        other is DisplayP3Color ? other : other.toColor().toDisplayP3();
    if (t == 1.0) {
      return otherP3;
    }

    return DisplayP3Color.alt(
      lerpDouble(r, otherP3.r, t),
      lerpDouble(g, otherP3.g, t),
      lerpDouble(b, otherP3.b, t),
    );
  }

  @override
  DisplayP3Color lighten([final double amount = 20]) {
    return toColor().lighten(amount).toDisplayP3();
  }

  @override
  DisplayP3Color adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toDisplayP3();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  DisplayP3Color copyWith({final double? r, final double? g, final double? b}) {
    return DisplayP3Color.alt(r ?? this.r, g ?? this.g, b ?? this.b);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toDisplayP3())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<DisplayP3Color> results = <DisplayP3Color>[];
    double delta;
    if (step != null) {
      delta = step;
    } else {
      delta = 10.0; // Default step 10%
    }

    for (int i = 1; i <= 5; i++) {
      results.add(whiten(delta * i));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<DisplayP3Color> results = <DisplayP3Color>[];
    double delta;
    if (step != null) {
      delta = step;
    } else {
      delta = 10.0; // Default step 10%
    }

    for (int i = 1; i <= 5; i++) {
      results.add(blacken(delta * i));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toDisplayP3();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  DisplayP3Color blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toDisplayP3();

  @override
  DisplayP3Color opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toDisplayP3();

  @override
  DisplayP3Color adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toDisplayP3();

  @override
  DisplayP3Color get complementary => toColor().complementary.toDisplayP3();

  @override
  DisplayP3Color warmer([final double amount = 20]) =>
      toColor().warmer(amount).toDisplayP3();

  @override
  DisplayP3Color cooler([final double amount = 20]) =>
      toColor().cooler(amount).toDisplayP3();

  @override
  List<DisplayP3Color> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toDisplayP3())
      .toList();

  @override
  List<DisplayP3Color> tonesPalette() => toColor()
      .tonesPalette()
      .map((final ColorIQ c) => c.toDisplayP3())
      .toList();

  @override
  List<DisplayP3Color> analogous({
    final int count = 5,
    final double offset = 30,
  }) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toDisplayP3())
          .toList();

  @override
  List<DisplayP3Color> square() =>
      toColor().square().map((final ColorIQ c) => c.toDisplayP3()).toList();

  @override
  List<DisplayP3Color> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toDisplayP3())
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
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'DisplayP3Color',
      'r': r,
      'g': g,
      'b': b,
      'opacity': transparency,
    };
  }

  @override
  String toString() => 'DisplayP3Color(r: ${r.toStringAsFixed(4)}, ' //
      'g: ${g.toStrTrimZeros(4)}, ' //
      'b: ${b.toStringAsFixed(4)}, ' //
      'opacity: ${transparency.toStringAsFixed(2)})';

  @override
  ColorSpacesIQ fromHct(final HctColor hct) {
    return DisplayP3Color.fromInt(hct.toInt());
  }
}
