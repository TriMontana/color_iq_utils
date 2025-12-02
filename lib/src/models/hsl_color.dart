import 'dart:math';
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

class HslColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;
  final double alpha;

  const HslColor(this.h, this.s, this.l, [this.alpha = 1.0]);

  @override
  ColorIQ toColor() {
      final double c = (1 - (2 * l - 1).abs()) * s;
      final double x = c * (1 - ((h / 60) % 2 - 1).abs());
      final double m = l - c / 2;
      
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
  HslColor darken([final double amount = 20]) {
    return HslColor(h, s, max(0.0, l - amount / 100), alpha);
  }

  @override
  HslColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toHsl();
  }

  @override
  HslColor saturate([final double amount = 25]) {
    return HslColor(h, min(1.0, s + amount / 100), l, alpha);
  }

  @override
  HslColor desaturate([final double amount = 25]) {
    return HslColor(h, max(0.0, s - amount / 100), l, alpha);
  }

  @override
  HslColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toHsl();
  }

  @override
  HslColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toHsl();
  }

  @override
  HslColor accented([final double amount = 15]) {
    return toColor().accented(amount).toHsl();
  }

  @override
  HslColor simulate(final ColorBlindnessType type) {
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
  HslColor whiten([final double amount = 20]) => toColor().whiten(amount).toHsl();

  @override
  HslColor blacken([final double amount = 20]) => toColor().blacken(amount).toHsl();

  @override
  HslColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toHsl();

  @override
  HslColor lighten([final double amount = 20]) {
    return HslColor(h, s, min(1.0, l + amount / 100), alpha);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HslColor fromHct(final HctColor hct) => hct.toColor().toHsl();

  @override
  HslColor adjustTransparency([final double amount = 20]) {
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
  HslColor copyWith({final double? h, final double? s, final double? l, final double? alpha}) {
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
    final List<HslColor> results = <HslColor>[];
    for (int i = 0; i < 5; i++) {
        final double delta = (i - 2) * 0.1; // 10%
        final double newL = (l + delta).clamp(0.0, 1.0);
        results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<HslColor> results = <HslColor>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = (1.0 - l) / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      final double newL = (l + delta * i).clamp(0.0, 1.0);
      results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<HslColor> results = <HslColor>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = l / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      final double newL = (l - delta * i).clamp(0.0, 1.0);
      results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsl();

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
  HslColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toHsl();

  @override
  HslColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toHsl();

  @override
  HslColor adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toHsl();

  @override
  HslColor get complementary => toColor().complementary.toHsl();

  @override
  HslColor warmer([final double amount = 20]) => toColor().warmer(amount).toHsl();

  @override
  HslColor cooler([final double amount = 20]) => toColor().cooler(amount).toHsl();

  @override
  List<HslColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toHsl()).toList();

  @override
  List<HslColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toHsl()).toList();

  @override
  List<HslColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toHsl()).toList();

  @override
  List<HslColor> square() => toColor().square().map((final ColorIQ c) => c.toHsl()).toList();

  @override
  List<HslColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toHsl()).toList();

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
