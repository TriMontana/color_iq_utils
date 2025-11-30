import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class Rec2020Color implements ColorSpacesIQ {
  final double r;
  final double g;
  final double b;

  const Rec2020Color(this.r, this.g, this.b);

  @override
  Color toColor() {
      // Rec. 2020 decoding (Gamma to Linear)
      double transferInv(double v) {
          if (v < 0.018 * 4.5) return v / 4.5;
          return pow((v + 0.099) / 1.099, 1 / 0.45).toDouble();
      }
      
      double rLin = transferInv(r);
      double gLin = transferInv(g);
      double bLin = transferInv(b);
      
      // Rec. 2020 Linear to XYZ (D65)
      double x = rLin * 0.6369580 + gLin * 0.1446169 + bLin * 0.1688810;
      double y = rLin * 0.2627002 + gLin * 0.6779981 + bLin * 0.0593017;
      double z = rLin * 0.0000000 + gLin * 0.0280727 + bLin * 1.0609851;
      
      // XYZ (D65) to sRGB Linear
      double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
      double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
      double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;
      
      // sRGB Linear to sRGB (Gamma encoded)
      rS = (rS > 0.0031308) ? (1.055 * pow(rS, 1 / 2.4) - 0.055) : (12.92 * rS);
      gS = (gS > 0.0031308) ? (1.055 * pow(gS, 1 / 2.4) - 0.055) : (12.92 * gS);
      bS = (bS > 0.0031308) ? (1.055 * pow(bS, 1 / 2.4) - 0.055) : (12.92 * bS);
      
      return Color.fromARGB(255, (rS * 255).round().clamp(0, 255), (gS * 255).round().clamp(0, 255), (bS * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  Rec2020Color darken([double amount = 20]) {
    return toColor().darken(amount).toRec2020();
  }

  @override
  Rec2020Color saturate([double amount = 25]) {
    return toColor().saturate(amount).toRec2020();
  }

  @override
  Rec2020Color desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toRec2020();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  Rec2020Color get inverted => toColor().inverted.toRec2020();

  @override
  Rec2020Color get grayscale => toColor().grayscale.toRec2020();

  @override
  Rec2020Color whiten([double amount = 20]) => toColor().whiten(amount).toRec2020();

  @override
  Rec2020Color blacken([double amount = 20]) => toColor().blacken(amount).toRec2020();

  @override
  Rec2020Color lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toRec2020();

  @override
  Rec2020Color lighten([double amount = 20]) {
    return toColor().lighten(amount).toRec2020();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  Rec2020Color fromHct(HctColor hct) => hct.toColor().toRec2020();

  @override
  Rec2020Color adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toRec2020();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  Rec2020Color copyWith({double? r, double? g, double? b}) {
    return Rec2020Color(
      r ?? this.r,
      g ?? this.g,
      b ?? this.b,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toRec2020()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toRec2020())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toRec2020())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toRec2020();

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
  Rec2020Color blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toRec2020();

  @override
  Rec2020Color opaquer([double amount = 20]) => toColor().opaquer(amount).toRec2020();

  @override
  Rec2020Color adjustHue([double amount = 20]) => toColor().adjustHue(amount).toRec2020();

  @override
  Rec2020Color get complementary => toColor().complementary.toRec2020();

  @override
  Rec2020Color warmer([double amount = 20]) => toColor().warmer(amount).toRec2020();

  @override
  Rec2020Color cooler([double amount = 20]) => toColor().cooler(amount).toRec2020();

  @override
  List<Rec2020Color> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> tonesPalette() => toColor().tonesPalette().map((c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> square() => toColor().square().map((c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toRec2020()).toList();

  @override
  String toString() => 'Rec2020Color(r: ${r.toStringAsFixed(2)}, g: ${g.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
