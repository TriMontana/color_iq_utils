import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'lab_color.dart';
import 'luv_color.dart';

class XyzColor implements ColorSpacesIQ {
  final double x;
  final double y;
  final double z;

  const XyzColor(this.x, this.y, this.z);

  @override
  Color toColor() {
    double xTemp = x / 100;
    double yTemp = y / 100;
    double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double b = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    b = (b > 0.0031308) ? (1.055 * pow(b, 1 / 2.4) - 0.055) : (12.92 * b);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  LabColor toLab() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    double xTemp = x / refX;
    double yTemp = y / refY;
    double zTemp = z / refZ;

    xTemp = (xTemp > 0.008856) ? pow(xTemp, 1 / 3).toDouble() : (7.787 * xTemp) + (16 / 116);
    yTemp = (yTemp > 0.008856) ? pow(yTemp, 1 / 3).toDouble() : (7.787 * yTemp) + (16 / 116);
    zTemp = (zTemp > 0.008856) ? pow(zTemp, 1 / 3).toDouble() : (7.787 * zTemp) + (16 / 116);

    double l = (116 * yTemp) - 16;
    double a = 500 * (xTemp - yTemp);
    double b = 200 * (yTemp - zTemp);

    return LabColor(l, a, b);
  }

  LuvColor toLuv() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    double u = (4 * x) / (x + (15 * y) + (3 * z));
    double v = (9 * y) / (x + (15 * y) + (3 * z));

    double yTemp = y / 100.0;
    yTemp = (yTemp > 0.008856) ? pow(yTemp, 1 / 3).toDouble() : (7.787 * yTemp) + (16 / 116);

    double l = (116 * yTemp) - 16;
    double uOut = 13 * l * (u - refU);
    double vOut = 13 * l * (v - refV);
    
    if (x + 15 * y + 3 * z == 0) {
      uOut = 0;
      vOut = 0;
    }

    return LuvColor(l, uOut, vOut);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  XyzColor get inverted => toColor().inverted.toXyz();

  @override
  XyzColor get grayscale => toColor().grayscale.toXyz();

  @override
  XyzColor whiten([double amount = 20]) => toColor().whiten(amount).toXyz();

  @override
  XyzColor blacken([double amount = 20]) => toColor().blacken(amount).toXyz();

  @override
  XyzColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toXyz();
  }

  @override
  XyzColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toXyz();
  }

  @override
  XyzColor darken([double amount = 20]) {
    return toColor().darken(amount).toXyz();
  }

  @override
  XyzColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toXyz();
  }

  @override
  XyzColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toXyz();
  }

  @override
  XyzColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toXyz();
  }

  @override
  XyzColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toXyz();
  }

  @override
  XyzColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toXyz();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  XyzColor fromHct(HctColor hct) => hct.toColor().toXyz();

  @override
  XyzColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toXyz();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  XyzColor copyWith({double? x, double? y, double? z}) {
    return XyzColor(
      x ?? this.x,
      y ?? this.y,
      z ?? this.z,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toXyz()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toXyz())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toXyz())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toXyz();

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
  XyzColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toXyz();

  @override
  XyzColor opaquer([double amount = 20]) => toColor().opaquer(amount).toXyz();

  @override
  XyzColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toXyz();

  @override
  XyzColor get complementary => toColor().complementary.toXyz();

  @override
  XyzColor warmer([double amount = 20]) => toColor().warmer(amount).toXyz();

  @override
  XyzColor cooler([double amount = 20]) => toColor().cooler(amount).toXyz();

  @override
  List<XyzColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toXyz()).toList();

  @override
  List<XyzColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toXyz()).toList();

  @override
  List<XyzColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toXyz()).toList();

  @override
  List<XyzColor> square() => toColor().square().map((c) => c.toXyz()).toList();

  @override
  List<XyzColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toXyz()).toList();

  @override
  double distanceTo(ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      // Convert to sRGB linear
      double xTemp = x / 100;
      double yTemp = y / 100;
      double zTemp = z / 100;

      double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
      double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
      double b = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

      // Gamma correction
      r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
      g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
      b = (b > 0.0031308) ? (1.055 * pow(b, 1 / 2.4) - 0.055) : (12.92 * b);

      const epsilon = 0.0001;
      return r >= -epsilon && r <= 1.0 + epsilon &&
             g >= -epsilon && g <= 1.0 + epsilon &&
             b >= -epsilon && b <= 1.0 + epsilon;
    }
    return true;
  }

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'XyzColor',
      'x': x,
      'y': y,
      'z': z,
    };
  }

  @override
  String toString() => 'XyzColor(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';
}
