import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'coloriq.dart';
import 'hct_color.dart';

class HslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;
  final double alpha;

  const HslColor(this.h, this.s, this.l, [this.alpha = 1.0]);

  @override
  ColorIQ toColor() {
      double c = (1 - (2 * l - 1).abs()) * s;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = l - c / 2;
      
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
      
      return ColorIQ.fromARGB((alpha * 255).round(), ((r + m) * 255).round().clamp(0, 255), ((g + m) * 255).round().clamp(0, 255), ((b + m) * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HslColor darken([double amount = 20]) {
    return HslColor(h, s, max(0.0, l - amount / 100), alpha);
  }

  @override
  HslColor brighten([double amount = 20]) {
    return toColor().brighten(amount).toHsl();
  }

  @override
  HslColor saturate([double amount = 25]) {
    return HslColor(h, min(1.0, s + amount / 100), l, alpha);
  }

  @override
  HslColor desaturate([double amount = 25]) {
    return HslColor(h, max(0.0, s - amount / 100), l, alpha);
  }

  @override
  HslColor intensify([double amount = 10]) {
    return toColor().intensify(amount).toHsl();
  }

  @override
  HslColor deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toHsl();
  }

  @override
  HslColor accented([double amount = 15]) {
    return toColor().accented(amount).toHsl();
  }

  @override
  HslColor simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toHsl();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HslColor get inverted => toColor().inverted.toHsl();

  @override
  HslColor get grayscale => HslColor(h, 0.0, l, alpha);

  @override
  HslColor whiten([double amount = 20]) => toColor().whiten(amount).toHsl();

  @override
  HslColor blacken([double amount = 20]) => toColor().blacken(amount).toHsl();

  @override
  HslColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as ColorIQ).toHsl();

  @override
  HslColor lighten([double amount = 20]) {
    return HslColor(h, s, min(1.0, l + amount / 100), alpha);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HslColor fromHct(HctColor hct) => hct.toColor().toHsl();

  @override
  HslColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsl();
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
  HslColor copyWith({double? h, double? s, double? l, double? alpha}) {
    return HslColor(
      h ?? this.h,
      s ?? this.s,
      l ?? this.l,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Native implementation for HSL
    final results = <HslColor>[];
    for (int i = 0; i < 5; i++) {
        double delta = (i - 2) * 0.1; // 10%
        double newL = (l + delta).clamp(0.0, 1.0);
        results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    final results = <HslColor>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = (1.0 - l) / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      double newL = (l + delta * i).clamp(0.0, 1.0);
      results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    final results = <HslColor>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = l / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      double newL = (l - delta * i).clamp(0.0, 1.0);
      results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsl();

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
  HslColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHsl();

  @override
  HslColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHsl();

  @override
  HslColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHsl();

  @override
  HslColor get complementary => toColor().complementary.toHsl();

  @override
  HslColor warmer([double amount = 20]) => toColor().warmer(amount).toHsl();

  @override
  HslColor cooler([double amount = 20]) => toColor().cooler(amount).toHsl();

  @override
  List<HslColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHsl()).toList();

  @override
  List<HslColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHsl()).toList();

  @override
  List<HslColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHsl()).toList();

  @override
  List<HslColor> square() => toColor().square().map((c) => c.toHsl()).toList();

  @override
  List<HslColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHsl()).toList();

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
      'type': 'HslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
