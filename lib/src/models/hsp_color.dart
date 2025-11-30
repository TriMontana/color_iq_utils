import 'dart:math';
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class HspColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double p;
  final double alpha;

  const HspColor(this.h, this.s, this.p, [this.alpha = 1.0]);

  @override
  Color toColor() {
    // http://alienryderflex.com/hsp.html
    double part = 0.0;
    double r = 0.0;
    double g = 0.0;
    double b = 0.0;
    double minOverMax = 1.0 - s;
    
    if (minOverMax > 0.0) {
      double hLocal = h;
      if ( hLocal < 1.0 / 6.0) {
         hLocal = 6.0 * ( hLocal - 0.0 / 6.0); part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
         b = p / sqrt(0.299 / minOverMax / minOverMax + 0.587 * part * part + 0.114);
         r = (b) / minOverMax; g = (b) + hLocal * ((r) - (b));
      } else if ( hLocal < 2.0 / 6.0) {
         hLocal = 6.0 * (-hLocal + 2.0 / 6.0); part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
         b = p / sqrt(0.587 / minOverMax / minOverMax + 0.299 * part * part + 0.114);
         g = (b) / minOverMax; r = (b) + hLocal * ((g) - (b));
      } else if ( hLocal < 3.0 / 6.0) {
         hLocal = 6.0 * ( hLocal - 2.0 / 6.0); part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
         r = p / sqrt(0.587 / minOverMax / minOverMax + 0.114 * part * part + 0.299);
         g = (r) / minOverMax; b = (r) + hLocal * ((g) - (r));
      } else if ( hLocal < 4.0 / 6.0) {
         hLocal = 6.0 * (-hLocal + 4.0 / 6.0); part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
         r = p / sqrt(0.114 / minOverMax / minOverMax + 0.587 * part * part + 0.299);
         b = (r) / minOverMax; g = (r) + hLocal * ((b) - (r));
      } else if ( hLocal < 5.0 / 6.0) {
         hLocal = 6.0 * ( hLocal - 4.0 / 6.0); part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
         g = p / sqrt(0.114 / minOverMax / minOverMax + 0.299 * part * part + 0.587);
         b = (g) / minOverMax; r = (g) + hLocal * ((b) - (g));
      } else {
         hLocal = 6.0 * (-hLocal + 6.0 / 6.0); part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
         g = p / sqrt(0.299 / minOverMax / minOverMax + 0.114 * part * part + 0.587);
         r = (g) / minOverMax; b = (g) + hLocal * ((r) - (g));
      }
    } else {
      double hLocal = h;
      if ( hLocal < 1.0 / 6.0) {
         hLocal = 6.0 * ( hLocal - 0.0 / 6.0); r = sqrt(p * p / (0.299 + 0.587 * hLocal * hLocal + 0.114 * (1.0 - hLocal) * (1.0 - hLocal))); g = sqrt(p * p / (0.299 / hLocal / hLocal + 0.587 + 0.114 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0))); b = 0.0;
      } else if ( hLocal < 2.0 / 6.0) {
         hLocal = 6.0 * (-hLocal + 2.0 / 6.0); g = sqrt(p * p / (0.587 + 0.299 * hLocal * hLocal + 0.114 * (1.0 - hLocal) * (1.0 - hLocal))); r = sqrt(p * p / (0.587 / hLocal / hLocal + 0.299 + 0.114 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0))); b = 0.0;
      } else if ( hLocal < 3.0 / 6.0) {
         hLocal = 6.0 * ( hLocal - 2.0 / 6.0); g = sqrt(p * p / (0.587 + 0.114 * hLocal * hLocal + 0.299 * (1.0 - hLocal) * (1.0 - hLocal))); b = sqrt(p * p / (0.587 / hLocal / hLocal + 0.114 + 0.299 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0))); r = 0.0;
      } else if ( hLocal < 4.0 / 6.0) {
         hLocal = 6.0 * (-hLocal + 4.0 / 6.0); b = sqrt(p * p / (0.114 + 0.587 * hLocal * hLocal + 0.299 * (1.0 - hLocal) * (1.0 - hLocal))); g = sqrt(p * p / (0.114 / hLocal / hLocal + 0.587 + 0.299 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0))); r = 0.0;
      } else if ( hLocal < 5.0 / 6.0) {
         hLocal = 6.0 * ( hLocal - 4.0 / 6.0); b = sqrt(p * p / (0.114 + 0.299 * hLocal * hLocal + 0.587 * (1.0 - hLocal) * (1.0 - hLocal))); r = sqrt(p * p / (0.114 / hLocal / hLocal + 0.299 + 0.587 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0))); g = 0.0;
      } else {
         hLocal = 6.0 * (-hLocal + 6.0 / 6.0); r = sqrt(p * p / (0.299 + 0.114 * hLocal * hLocal + 0.587 * (1.0 - hLocal) * (1.0 - hLocal))); b = sqrt(p * p / (0.299 / hLocal / hLocal + 0.114 + 0.587 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0))); g = 0.0;
      }
    }

    return Color.fromARGB((alpha * 255).round(), (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HspColor darken([double amount = 20]) {
    return toColor().darken(amount).toHsp();
  }

  @override
  HspColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toHsp();
  }

  @override
  HspColor saturate([double amount = 25]) {
    return HspColor(h, min(1.0, s + amount / 100), p, alpha);
  }

  @override
  HspColor desaturate([double amount = 25]) {
    return HspColor(h, max(0.0, s - amount / 100), p, alpha);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HspColor get inverted => toColor().inverted.toHsp();

  @override
  HspColor get grayscale => toColor().grayscale.toHsp();

  @override
  HspColor whiten([double amount = 20]) => toColor().whiten(amount).toHsp();

  @override
  HspColor blacken([double amount = 20]) => toColor().blacken(amount).toHsp();

  @override
  HspColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsp();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HspColor fromHct(HctColor hct) => hct.toColor().toHsp();

  @override
  HspColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsp();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  HspColor copyWith({double? h, double? s, double? p, double? alpha}) {
    return HspColor(
      h ?? this.h,
      s ?? this.s,
      p ?? this.p,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toHsp()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toHsp())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toHsp())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toHsp();

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
  HspColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHsp();

  @override
  HspColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHsp();

  @override
  HspColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHsp();

  @override
  HspColor get complementary => toColor().complementary.toHsp();

  @override
  HspColor warmer([double amount = 20]) => toColor().warmer(amount).toHsp();

  @override
  HspColor cooler([double amount = 20]) => toColor().cooler(amount).toHsp();

  @override
  List<HspColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHsp()).toList();

  @override
  List<HspColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHsp()).toList();

  @override
  List<HspColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHsp()).toList();

  @override
  List<HspColor> square() => toColor().square().map((c) => c.toHsp()).toList();

  @override
  List<HspColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHsp()).toList();

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
      'type': 'HspColor',
      'hue': h,
      'saturation': s,
      'perceivedBrightness': p,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HspColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, p: ${p.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
