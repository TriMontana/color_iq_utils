import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/lch_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// Represents a color in the CIELAB color space.
///
/// The CIELAB color space (also known as CIE L*a*b* or Lab) is a color space
/// specified by the International Commission on Illumination (CIE). It describes
/// all the colors visible to the human eye and was created to serve as a
/// device-independent model to be used as a reference.
///
/// The three coordinates of CIELAB represent the lightness of the color (L*),
/// its position between red and green (a*), and its position between yellow
/// and blue (b*).
///
/// - `l`: Lightness, from 0 (black) to 100 (white).
/// - `a`: Green to red axis, where negative values indicate green and positive values indicate red.
/// - `b`: Blue to yellow axis, where negative values indicate blue and positive values indicate yellow.
class LabColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The lightness component (0-100).
  final double l;

  /// The green-red component.
  final double aLab;

  /// The blue-yellow component.
  final double bLab;

  const LabColor(this.l, this.aLab, this.bLab, {required final int hexId})
      : assert(l >= 0 && l <= 100, 'L must be between 0 and 100'),
        super(hexId);
  LabColor.alt(this.l, this.aLab, this.bLab, {final int? hexId})
      : assert(l >= 0 && l <= 100, 'L must be between 0 and 100'),
        super(hexId ?? LabColor.toHexId(l, aLab, bLab));

  static LabColor fromInt(final int hexId) {
    final List<double> lab = labFromArgb(hexId);
    return LabColor.alt(lab[0], lab[1], lab[2], hexId: hexId);
  }

  /// Creates a 32-bit ARGB hex value from CIE-LAB components.
  ///
  /// This is a stand-alone static method that performs the conversion from
  /// LAB to sRGB and then packs it into a 32-bit integer.
  ///
  /// - [l]: Lightness, from 0 (black) to 100 (white).
  /// - [aLab]: Green to red axis.
  /// - [bLab]: Blue to yellow axis.
  ///
  /// Returns an integer representing the ARGB color.
  static int toHexId(final double l, final double aLab, final double bLab) {
    return argbFromLab(l, aLab, bLab);
  }

  @override
  ColorIQ toColor() {
    final double y = (l + 16) / 116;
    final double x = aLab / 500 + y;
    final double z = y - bLab / 200;

    final double x3 = x * x * x;
    final double y3 = y * y * y;
    final double z3 = z * z * z;

    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    final double r = xn * ((x3 > 0.008856) ? x3 : ((x - 16 / 116) / 7.787));
    final double g = yn * ((y3 > 0.008856) ? y3 : ((y - 16 / 116) / 7.787));
    final double bVal = zn * ((z3 > 0.008856) ? z3 : ((z - 16 / 116) / 7.787));

    final double rS = r / 100;
    final double gS = g / 100;
    final double bS = bVal / 100;

    double rL = rS * 3.2406 + gS * -1.5372 + bS * -0.4986;
    double gL = rS * -0.9689 + gS * 1.8758 + bS * 0.0415;
    double bL = rS * 0.0557 + gS * -0.2040 + bS * 1.0570;

    rL = (rL > 0.0031308) ? (1.055 * pow(rL, 1 / 2.4) - 0.055) : (12.92 * rL);
    gL = (gL > 0.0031308) ? (1.055 * pow(gL, 1 / 2.4) - 0.055) : (12.92 * gL);
    bL = (bL > 0.0031308) ? (1.055 * pow(bL, 1 / 2.4) - 0.055) : (12.92 * bL);

    return ColorIQ.fromARGB(
      255,
      (rL * 255).round().clamp(0, 255),
      (gL * 255).round().clamp(0, 255),
      (bL * 255).round().clamp(0, 255),
    );
  }

  @override
  int get value => toColor().value;

  LchColor toLch() {
    final double c = sqrt(aLab * aLab + bLab * bLab);
    double h = atan2(bLab, aLab);
    h = h * 180 / pi;
    if (h < 0) {
      h += 360;
    }
    return LchColor.alt(l, c, h);
  }

  @override
  LabColor get inverted => toColor().inverted.toLab();

  @override
  LabColor get grayscale => toColor().grayscale.toLab();

  @override
  LabColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  LabColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  LabColor lighten([final double amount = 20]) {
    return LabColor.alt(min(100, l + amount), aLab, bLab);
  }

  @override
  LabColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toLab();
  }

  @override
  LabColor darken([final double amount = 20]) {
    return LabColor.alt(max(0, l - amount), aLab, bLab);
  }

  @override
  LabColor saturate([final double amount = 25]) {
    return toLch().saturate(amount).toLab();
  }

  @override
  LabColor desaturate([final double amount = 25]) {
    return toLch().desaturate(amount).toLab();
  }

  @override
  LabColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toLab();
  }

  @override
  LabColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toLab();
  }

  @override
  LabColor accented([final double amount = 15]) {
    return toColor().accented(amount).toLab();
  }

  @override
  LabColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toLab();
  }

  @override
  LabColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final LabColor otherLab =
        other is LabColor ? other : other.toColor().toLab();
    if (t == 1.0) {
      return otherLab;
    }

    return LabColor.alt(
      lerpDouble(l, otherLab.l, t),
      lerpDouble(aLab, otherLab.aLab, t),
      lerpDouble(bLab, otherLab.bLab, t),
    );
  }

  @override
  HctColor toHctColor() => toColor().toHctColor();

  @override
  LabColor fromHct(final HctColor hct) => hct.toColor().toLab();

  @override
  LabColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toLab();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LabColor copyWith({final double? l, final double? a, final double? b}) {
    return LabColor.alt(l ?? this.l, a ?? aLab, b ?? bLab);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toLab())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toLab())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toLab())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toLab();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  LabColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toLab();

  @override
  LabColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toLab();

  @override
  LabColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toLab();

  @override
  LabColor get complementary => toColor().complementary.toLab();

  @override
  LabColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toLab();

  @override
  LabColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toLab();

  @override
  List<LabColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toLab())
      .toList();

  @override
  List<LabColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toLab()).toList();

  @override
  List<LabColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toLab())
          .toList();

  @override
  List<LabColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toLab()).toList();

  @override
  List<LabColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toLab())
      .toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      // Convert to RGB without clamping and check bounds
      // We can use the logic from toColor but return false if out of 0-1 range (before scaling to 255)

      final double y = (l + 16) / 116;
      final double x = aLab / 500 + y;
      final double z = y - bLab / 200;

      final double x3 = x * x * x;
      final double y3 = y * y * y;
      final double z3 = z * z * z;

      const double xn = 95.047;
      const double yn = 100.0;
      const double zn = 108.883;

      final double rX = xn * ((x3 > 0.008856) ? x3 : ((x - 16 / 116) / 7.787));
      final double gY = yn * ((y3 > 0.008856) ? y3 : ((y - 16 / 116) / 7.787));
      final double bZ = zn * ((z3 > 0.008856) ? z3 : ((z - 16 / 116) / 7.787));

      final double rS = rX / 100;
      final double gS = gY / 100;
      final double bS = bZ / 100;

      double rL = rS * 3.2406 + gS * -1.5372 + bS * -0.4986;
      double gL = rS * -0.9689 + gS * 1.8758 + bS * 0.0415;
      double bL = rS * 0.0557 + gS * -0.2040 + bS * 1.0570;

      // Linear to sRGB gamma correction
      rL = (rL > 0.0031308) ? (1.055 * pow(rL, 1 / 2.4) - 0.055) : (12.92 * rL);
      gL = (gL > 0.0031308) ? (1.055 * pow(gL, 1 / 2.4) - 0.055) : (12.92 * gL);
      bL = (bL > 0.0031308) ? (1.055 * pow(bL, 1 / 2.4) - 0.055) : (12.92 * bL);

      // Check if within 0.0 - 1.0 (with small epsilon)
      const double epsilon = 0.0001;
      return rL >= -epsilon &&
          rL <= 1.0 + epsilon &&
          gL >= -epsilon &&
          gL <= 1.0 + epsilon &&
          bL >= -epsilon &&
          bL <= 1.0 + epsilon;
    }
    // For other gamuts, we'd need their conversion matrices.
    // Defaulting to true for now if not sRGB, or delegate to super?
    // Super returns true.
    return true;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'LabColor', 'l': l, 'a': aLab, 'b': bLab};
  }

  @override
  String toString() =>
      'LabColor(l: ${l.toStrTrimZeros(3)}, a: ${aLab.toStringAsFixed(2)}, ' //
      'b: ${bLab.toStrTrimZeros(3)})';
}
