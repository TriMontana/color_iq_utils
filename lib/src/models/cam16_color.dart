import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'coloriq.dart';
import 'hct_color.dart';

class Cam16Color implements ColorSpacesIQ {
  final double hue;
  final double chroma;
  final double j;
  final double q;
  final double m;
  final double s;
  final double alpha;

  const Cam16Color(this.hue, this.chroma, this.j, this.q, this.m, this.s, [this.alpha = 1.0]);

  @override
  ColorIQ toColor() {
      // This is complex, usually requires viewing conditions.
      // MCU library has Cam16.
      // We can use MCU to convert back to Int.
      // But MCU Cam16 doesn't have direct toInt().
      // It has toXyzInViewingConditions.
      // For simplicity, we might convert to Hct first if possible?
      // Hct is based on Cam16.
      // Hct.from(hue, chroma, tone) -> tone is Lightness (J-like but not exactly J).
      // Let's assume we can use Hct as a bridge if J ~ Tone.
      // Or we can use the Cam16 class from MCU if we can construct it.
      // mcu.Cam16.fromJch(j, c, h);
      final cam16 = mcu.Cam16.fromJch(j, chroma, hue);
      final int argb = cam16.toInt();
      // Restore alpha
      return ColorIQ(argb).copyWith(a: (alpha * 255).round());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  Cam16Color darken([double amount = 20]) {
    return Cam16Color(hue, chroma, max(0, j - amount), q, m, s, alpha);
  }

  @override
  Cam16Color saturate([double amount = 25]) {
    return Cam16Color(hue, chroma + amount, j, q, m, s, alpha);
  }

  @override
  Cam16Color desaturate([double amount = 25]) {
    return Cam16Color(hue, max(0, chroma - amount), j, q, m, s, alpha);
  }

  @override
  Cam16Color intensify([double amount = 10]) {
    return toColor().intensify(amount).toCam16();
  }

  @override
  Cam16Color deintensify([double amount = 10]) {
    return toColor().deintensify(amount).toCam16();
  }

  @override
  Cam16Color accented([double amount = 15]) {
    return toColor().accented(amount).toCam16();
  }

  @override
  Cam16Color simulate(ColorBlindnessType type) {
    return toColor().simulate(type).toCam16();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  Cam16Color get inverted => toColor().inverted.toCam16();

  @override
  Cam16Color get grayscale => toColor().grayscale.toCam16();

  @override
  Cam16Color whiten([double amount = 20]) => toColor().whiten(amount).toCam16();

  @override
  Cam16Color blacken([double amount = 20]) => toColor().blacken(amount).toCam16();

  @override
  Cam16Color lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as ColorIQ).toCam16();

  @override
  Cam16Color lighten([double amount = 20]) {
    return Cam16Color(hue, chroma, min(100, j + amount), q, m, s, alpha);
  }

  @override
  Cam16Color brighten([double amount = 20]) {
    return toColor().brighten(amount).toCam16();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  Cam16Color fromHct(HctColor hct) => hct.toColor().toCam16();

  @override
  Cam16Color adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toCam16();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  Cam16Color copyWith({double? hue, double? chroma, double? j, double? q, double? m, double? s, double? alpha}) {
    return Cam16Color(
      hue ?? this.hue,
      chroma ?? this.chroma,
      j ?? this.j,
      q ?? this.q,
      m ?? this.m,
      s ?? this.s,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as ColorIQ).toCam16()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as ColorIQ).toCam16())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as ColorIQ).toCam16())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toCam16();

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
  Cam16Color blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toCam16();

  @override
  Cam16Color opaquer([double amount = 20]) => toColor().opaquer(amount).toCam16();

  @override
  Cam16Color adjustHue([double amount = 20]) => toColor().adjustHue(amount).toCam16();

  @override
  Cam16Color get complementary => toColor().complementary.toCam16();

  @override
  Cam16Color warmer([double amount = 20]) => toColor().warmer(amount).toCam16();

  @override
  Cam16Color cooler([double amount = 20]) => toColor().cooler(amount).toCam16();

  @override
  List<Cam16Color> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toCam16()).toList();

  @override
  List<Cam16Color> tonesPalette() => toColor().tonesPalette().map((c) => c.toCam16()).toList();

  @override
  List<Cam16Color> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toCam16()).toList();

  @override
  List<Cam16Color> square() => toColor().square().map((c) => c.toCam16()).toList();

  @override
  List<Cam16Color> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toCam16()).toList();

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
      'type': 'Cam16Color',
      'hue': hue,
      'chroma': chroma,
      'j': j,
      'q': q,
      'm': m,
      's': s,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'Cam16Color(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, j: ${j.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
