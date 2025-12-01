import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

import 'lch_color.dart';

class LabColor implements ColorSpacesIQ {
  final double l;
  final double a;
  final double b;

  const LabColor(this.l, this.a, this.b);

  @override
  Color toColor() {
    double y = (l + 16) / 116;
    double x = a / 500 + y;
    double z = y - b / 200;

    double x3 = x * x * x;
    double y3 = y * y * y;
    double z3 = z * z * z;

    double xn = 95.047;
    double yn = 100.0;
    double zn = 108.883;

    double r = xn * ((x3 > 0.008856) ? x3 : ((x - 16 / 116) / 7.787));
    double g = yn * ((y3 > 0.008856) ? y3 : ((y - 16 / 116) / 7.787));
    double bVal = zn * ((z3 > 0.008856) ? z3 : ((z - 16 / 116) / 7.787));

    double rS = r / 100;
    double gS = g / 100;
    double bS = bVal / 100;

    double rL = rS * 3.2406 + gS * -1.5372 + bS * -0.4986;
    double gL = rS * -0.9689 + gS * 1.8758 + bS * 0.0415;
    double bL = rS * 0.0557 + gS * -0.2040 + bS * 1.0570;

    rL = (rL > 0.0031308) ? (1.055 * pow(rL, 1 / 2.4) - 0.055) : (12.92 * rL);
    gL = (gL > 0.0031308) ? (1.055 * pow(gL, 1 / 2.4) - 0.055) : (12.92 * gL);
    bL = (bL > 0.0031308) ? (1.055 * pow(bL, 1 / 2.4) - 0.055) : (12.92 * bL);

    return Color.fromARGB(255, (rL * 255).round().clamp(0, 255), (gL * 255).round().clamp(0, 255), (bL * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  LchColor toLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi;
    if (h < 0) h += 360;
    return LchColor(l, c, h);
  }

  @override
  List<int> get srgb => toColor().srgb;
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  LabColor get inverted => toColor().inverted.toLab();

  @override
  LabColor get grayscale => toColor().grayscale.toLab();

  @override
  LabColor whiten([double amount = 20]) => toColor().whiten(amount).toLab();

  @override
  LabColor blacken([double amount = 20]) => toColor().blacken(amount).toLab();

  @override
  LabColor lighten([double amount = 20]) {
    return LabColor(min(100, l + amount), a, b);
  }

  @override
  LabColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toLab();
  }

  @override
  LabColor darken([double amount = 20]) {
    return LabColor(max(0, l - amount), a, b);
  }

  @override
  LabColor saturate([double amount = 25]) {
    return toLch().saturate(amount).toLab();
  }

  @override
  LabColor desaturate([double amount = 25]) {
    return toLch().desaturate(amount).toLab();
  }

  @override
  LabColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toLab();
  }

  @override
  LabColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toLab();
  }

  @override
  LabColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toLab();
  }

  @override
  LabColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toLab();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  LabColor fromHct(HctColor hct) => hct.toColor().toLab();

  @override
  LabColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toLab();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  LabColor copyWith({double? l, double? a, double? b}) {
    return LabColor(
      l ?? this.l,
      a ?? this.a,
      b ?? this.b,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toLab()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toLab())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toLab())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toLab();

  @override
  bool isEqual(ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  LabColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toLab();

  @override
  LabColor opaquer([double amount = 20]) => toColor().opaquer(amount).toLab();

  @override
  LabColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toLab();

  @override
  LabColor get complementary => toColor().complementary.toLab();

  @override
  LabColor warmer([double amount = 20]) => toColor().warmer(amount).toLab();

  @override
  LabColor cooler([double amount = 20]) => toColor().cooler(amount).toLab();

  @override
  List<LabColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toLab()).toList();

  @override
  List<LabColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toLab()).toList();

  @override
  List<LabColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toLab()).toList();

  @override
  List<LabColor> square() => toColor().square().map((c) => c.toLab()).toList();

  @override
  List<LabColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toLab()).toList();

  @override
  double distanceTo(ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      // Convert to RGB without clamping and check bounds
      // We can use the logic from toColor but return false if out of 0-1 range (before scaling to 255)
      
      double y = (l + 16) / 116;
      double x = a / 500 + y;
      double z = y - b / 200;

      double x3 = x * x * x;
      double y3 = y * y * y;
      double z3 = z * z * z;

      double xn = 95.047;
      double yn = 100.0;
      double zn = 108.883;

      double rX = xn * ((x3 > 0.008856) ? x3 : ((x - 16 / 116) / 7.787));
      double gY = yn * ((y3 > 0.008856) ? y3 : ((y - 16 / 116) / 7.787));
      double bZ = zn * ((z3 > 0.008856) ? z3 : ((z - 16 / 116) / 7.787));

      double rS = rX / 100;
      double gS = gY / 100;
      double bS = bZ / 100;

      double rL = rS * 3.2406 + gS * -1.5372 + bS * -0.4986;
      double gL = rS * -0.9689 + gS * 1.8758 + bS * 0.0415;
      double bL = rS * 0.0557 + gS * -0.2040 + bS * 1.0570;

      // Linear to sRGB gamma correction
      rL = (rL > 0.0031308) ? (1.055 * pow(rL, 1 / 2.4) - 0.055) : (12.92 * rL);
      gL = (gL > 0.0031308) ? (1.055 * pow(gL, 1 / 2.4) - 0.055) : (12.92 * gL);
      bL = (bL > 0.0031308) ? (1.055 * pow(bL, 1 / 2.4) - 0.055) : (12.92 * bL);

      // Check if within 0.0 - 1.0 (with small epsilon)
      const epsilon = 0.0001;
      return rL >= -epsilon && rL <= 1.0 + epsilon &&
             gL >= -epsilon && gL <= 1.0 + epsilon &&
             bL >= -epsilon && bL <= 1.0 + epsilon;
    }
    // For other gamuts, we'd need their conversion matrices.
    // Defaulting to true for now if not sRGB, or delegate to super?
    // Super returns true.
    return true;
  }

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'LabColor',
      'l': l,
      'a': a,
      'b': b,
    };
  }

  @override
  String toString() => 'LabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
