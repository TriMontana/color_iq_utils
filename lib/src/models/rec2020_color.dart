
import 'dart:math';
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

class Rec2020Color implements ColorSpacesIQ {
  final double r;
  final double g;
  final double b;

  const Rec2020Color(this.r, this.g, this.b);

  @override
  ColorIQ toColor() {
      // Rec. 2020 decoding (Gamma to Linear)
      double transferInv(final double v) {
          if (v < 0.018 * 4.5) return v / 4.5;
          return pow((v + 0.099) / 1.099, 1 / 0.45).toDouble();
      }
      
      final double rLin = transferInv(r);
      final double gLin = transferInv(g);
      final double bLin = transferInv(b);
      
      // Rec. 2020 Linear to XYZ (D65)
      final double x = rLin * 0.6369580 + gLin * 0.1446169 + bLin * 0.1688810;
      final double y = rLin * 0.2627002 + gLin * 0.6779981 + bLin * 0.0593017;
      final double z = rLin * 0.0000000 + gLin * 0.0280727 + bLin * 1.0609851;
      
      // XYZ (D65) to sRGB Linear
      double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
      double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
      double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;
      
      // sRGB Linear to sRGB (Gamma encoded)
      rS = (rS > 0.0031308) ? (1.055 * pow(rS, 1 / 2.4) - 0.055) : (12.92 * rS);
      gS = (gS > 0.0031308) ? (1.055 * pow(gS, 1 / 2.4) - 0.055) : (12.92 * gS);
      bS = (bS > 0.0031308) ? (1.055 * pow(bS, 1 / 2.4) - 0.055) : (12.92 * bS);
      
      return ColorIQ.fromARGB(255, (rS * 255).round().clamp(0, 255), (gS * 255).round().clamp(0, 255), (bS * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  Rec2020Color darken([final double amount = 20]) {
    return toColor().darken(amount).toRec2020();
  }

  @override
  Rec2020Color brighten([final double amount = 20]) {
    return toColor().brighten(amount).toRec2020();
  }

  @override
  Rec2020Color saturate([final double amount = 25]) {
    return toColor().saturate(amount).toRec2020();
  }

  @override
  Rec2020Color desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toRec2020();
  }

  @override
  Rec2020Color intensify([final double amount = 10]) {
    return toColor().intensify(amount).toRec2020();
  }

  @override
  Rec2020Color deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toRec2020();
  }

  @override
  Rec2020Color accented([final double amount = 15]) {
    return toColor().accented(amount).toRec2020();
  }

  @override
  Rec2020Color simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toRec2020();
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
  Rec2020Color whiten([final double amount = 20]) => toColor().whiten(amount).toRec2020();

  @override
  Rec2020Color blacken([final double amount = 20]) => toColor().blacken(amount).toRec2020();

  @override
  Rec2020Color lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toRec2020();

  @override
  Rec2020Color lighten([final double amount = 20]) {
    return toColor().lighten(amount).toRec2020();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  Rec2020Color fromHct(final HctColor hct) => hct.toColor().toRec2020();

  @override
  Rec2020Color adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toRec2020();
  }

  @override
  double get transparency => toColor().transparency;

  double get opacity => 1.0 - transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  Rec2020Color copyWith({final double? r, final double? g, final double? b}) {
    return Rec2020Color(
      r ?? this.r,
      g ?? this.g,
      b ?? this.b,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((final ColorSpacesIQ c) => (c as ColorIQ).toRec2020()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toRec2020())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toRec2020())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toRec2020();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  Rec2020Color blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toRec2020();

  @override
  Rec2020Color opaquer([final double amount = 20]) => toColor().opaquer(amount).toRec2020();

  @override
  Rec2020Color adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toRec2020();

  @override
  Rec2020Color get complementary => toColor().complementary.toRec2020();

  @override
  Rec2020Color warmer([final double amount = 20]) => toColor().warmer(amount).toRec2020();

  @override
  Rec2020Color cooler([final double amount = 20]) => toColor().cooler(amount).toRec2020();

  @override
  List<Rec2020Color> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> square() => toColor().square().map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) => toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'Rec2020Color',
      'r': r,
      'g': g,
      'b': b,
      'opacity': opacity,
    };
  }

  @override
  String toString() => 'Rec2020Color(r: ${r.toStringAsFixed(4)}, g: ${g.toStringAsFixed(4)}, b: ${b.toStringAsFixed(4)}, opacity: ${opacity.toStringAsFixed(2)})';
}
