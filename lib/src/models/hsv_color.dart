import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class HsvColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double v;
  final double alpha;

  const HsvColor(this.h, this.s, this.v, [this.alpha = 1.0]);

  @override
  Color toColor() {
      double c = v * s;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = v - c;
      
      double r = 0, g = 0, b = 0;
      if (h < 60) {
          r = c; g = x; b = 0;
      } else if (h < 120) {
          r = x; g = c; b = 0;
      } else if (h < 180) {
          r = 0; g = c; b = x;
      } else if (h < 240) {
          r = 0; g = x; b = c;
      } else if (h < 300) {
          r = x; g = 0; b = c;
      } else {
          r = c; g = 0; b = x;
      }
      
      return Color.fromARGB((alpha * 255).round(), ((r + m) * 255).round().clamp(0, 255), ((g + m) * 255).round().clamp(0, 255), ((b + m) * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HsvColor darken([double amount = 20]) {
    return HsvColor(h, s, max(0.0, v - amount / 100), alpha);
  }

  @override
  HsvColor saturate([double amount = 25]) {
    return HsvColor(h, min(1.0, s + amount / 100), v, alpha);
  }

  @override
  HsvColor desaturate([double amount = 25]) {
    return HsvColor(h, max(0.0, s - amount / 100), v, alpha);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HsvColor get inverted => toColor().inverted.toHsv();

  @override
  HsvColor get grayscale => toColor().grayscale.toHsv();

  @override
  HsvColor whiten([double amount = 20]) => toColor().whiten(amount).toHsv();

  @override
  HsvColor blacken([double amount = 20]) => toColor().blacken(amount).toHsv();

  @override
  HsvColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsv();

  @override
  HsvColor lighten([double amount = 20]) {
    return HsvColor(h, s, min(1.0, v + amount / 100), alpha);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HsvColor fromHct(HctColor hct) => hct.toColor().toHsv();

  @override
  HsvColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsv();
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
  HsvColor copyWith({double? h, double? s, double? v, double? alpha}) {
    return HsvColor(
      h ?? this.h,
      s ?? this.s,
      v ?? this.v,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toHsv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toHsv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toHsv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toHsv();

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
  HsvColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHsv();

  @override
  HsvColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHsv();

  @override
  HsvColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHsv();

  @override
  HsvColor get complementary => toColor().complementary.toHsv();

  @override
  HsvColor warmer([double amount = 20]) => toColor().warmer(amount).toHsv();

  @override
  HsvColor cooler([double amount = 20]) => toColor().cooler(amount).toHsv();

  @override
  List<HsvColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHsv()).toList();

  @override
  List<HsvColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHsv()).toList();

  @override
  List<HsvColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHsv()).toList();

  @override
  List<HsvColor> square() => toColor().square().map((c) => c.toHsv()).toList();

  @override
  List<HsvColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHsv()).toList();

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
      'type': 'HsvColor',
      'hue': h,
      'saturation': s,
      'value': v,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HsvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)}, a: ${alpha.toStringAsFixed(2)})';
}
