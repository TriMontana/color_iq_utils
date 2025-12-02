import 'dart:math';
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

class HspColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double p;
  final double alpha;

  const HspColor(this.h, this.s, this.p, [this.alpha = 1.0]);

  @override
  ColorIQ toColor() {
    // http://alienryderflex.com/hsp.html
    double part = 0.0;
    double r = 0.0;
    double g = 0.0;
    double b = 0.0;
    final double minOverMax = 1.0 - s;
    
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

    return ColorIQ.fromARGB((alpha * 255).round(), (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HspColor darken([final double amount = 20]) {
    return toColor().darken(amount).toHsp();
  }

  @override
  HspColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toHsp();
  }

  @override
  HspColor lighten([final double amount = 20]) {
    return toColor().lighten(amount).toHsp();
  }

  @override
  HspColor saturate([final double amount = 25]) {
    return HspColor(h, min(1.0, s + amount / 100), p, alpha);
  }

  @override
  HspColor desaturate([final double amount = 25]) {
    return HspColor(h, max(0.0, s - amount / 100), p, alpha);
  }

  @override
  HspColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toHsp();
  }

  @override
  HspColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toHsp();
  }

  @override
  HspColor accented([final double amount = 15]) {
    return toColor().accented(amount).toHsp();
  }

  @override
  HspColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsp();
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
  HspColor whiten([final double amount = 20]) => toColor().whiten(amount).toHsp();

  @override
  HspColor blacken([final double amount = 20]) => toColor().blacken(amount).toHsp();

  @override
  HspColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toHsp();

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HspColor fromHct(final HctColor hct) => hct.toColor().toHsp();

  @override
  HspColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsp();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  HspColor copyWith({final double? h, final double? s, final double? p, final double? alpha}) {
    return HspColor(
      h ?? this.h,
      s ?? this.s,
      p ?? this.p,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((final ColorSpacesIQ c) => (c as ColorIQ).toHsp()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsp())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsp())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsp();

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
  HspColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toHsp();

  @override
  HspColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toHsp();

  @override
  HspColor adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toHsp();

  @override
  HspColor get complementary => toColor().complementary.toHsp();

  @override
  HspColor warmer([final double amount = 20]) => toColor().warmer(amount).toHsp();

  @override
  HspColor cooler([final double amount = 20]) => toColor().cooler(amount).toHsp();

  @override
  List<HspColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toHsp()).toList();

  @override
  List<HspColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toHsp()).toList();

  @override
  List<HspColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toHsp()).toList();

  @override
  List<HspColor> square() => toColor().square().map((final ColorIQ c) => c.toHsp()).toList();

  @override
  List<HspColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toHsp()).toList();

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
