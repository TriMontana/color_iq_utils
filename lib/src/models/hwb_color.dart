import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'hsv_color.dart';
import 'dart:math';

class HwbColor implements ColorSpacesIQ {
  final double h;
  final double w;
  final double b;
  final double alpha;

  const HwbColor(this.h, this.w, this.b, [this.alpha = 1.0]);

  @override
  Color toColor() {
      double ratio = w + b;
      double wNorm = w;
      double bNorm = b;
      if (ratio > 1) {
          wNorm /= ratio;
          bNorm /= ratio;
      }
      
      double v = 1 - bNorm;
      double s = (v == 0) ? 0 : 1 - wNorm / v;
      
      return HsvColor(h, s, v, alpha).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HwbColor darken([double amount = 20]) {
    return toColor().darken(amount).toHwb();
  }

  @override
  HwbColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toHwb();
  }

  @override
  HwbColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toHwb();
  }

  @override
  HwbColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toHwb();
  }

  @override
  HwbColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toHwb();
  }

  @override
  HwbColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toHwb();
  }

  @override
  HwbColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toHwb();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  HwbColor get inverted => toColor().inverted.toHwb();

  @override
  HwbColor get grayscale => toColor().grayscale.toHwb();

  @override
  HwbColor whiten([double amount = 20]) => toColor().whiten(amount).toHwb();

  @override
  HwbColor blacken([double amount = 20]) => toColor().blacken(amount).toHwb();

  @override
  HwbColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHwb();

  @override
  HwbColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toHwb();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HwbColor fromHct(HctColor hct) => hct.toColor().toHwb();

  @override
  HwbColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHwb();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (h >= 90 && h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HwbColor copyWith({double? h, double? w, double? b, double? alpha}) {
    return HwbColor(
      h ?? this.h,
      w ?? this.w,
      b ?? this.b,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toHwb()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toHwb())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toHwb())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toHwb();

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
  HwbColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHwb();

  @override
  HwbColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHwb();

  @override
  HwbColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHwb();

  @override
  HwbColor get complementary => toColor().complementary.toHwb();

  @override
  HwbColor warmer([double amount = 20]) => toColor().warmer(amount).toHwb();

  @override
  HwbColor cooler([double amount = 20]) => toColor().cooler(amount).toHwb();

  @override
  List<HwbColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHwb()).toList();

  @override
  List<HwbColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHwb()).toList();

  @override
  List<HwbColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHwb()).toList();

  @override
  List<HwbColor> square() => toColor().square().map((c) => c.toHwb()).toList();

  @override
  List<HwbColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHwb()).toList();

  @override
  double distanceTo(ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(ColorSpacesIQ other) => toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) => toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883];

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'HwbColor',
      'hue': h,
      'whiteness': w,
      'blackness': b,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HwbColor(h: ${h.toStringAsFixed(2)}, w: ${w.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
