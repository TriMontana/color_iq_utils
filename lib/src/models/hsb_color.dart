import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';
import 'hsv_color.dart';
import 'dart:math';

class HsbColor implements ColorSpacesIQ {
  final double h;
  final double s;
  final double b;

  const HsbColor(this.h, this.s, this.b);

  @override
  Color toColor() {
      // HSB is the same as HSV, just B instead of V
      return HsvColor(h, s, b).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  HsbColor darken([double amount = 20]) {
    return HsbColor(h, s, max(0.0, b - amount / 100));
  }

  @override
  HsbColor saturate([double amount = 25]) {
    return HsbColor(h, min(1.0, s + amount / 100), b);
  }

  @override
  HsbColor desaturate([double amount = 25]) {
    return HsbColor(h, max(0.0, s - amount / 100), b);
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HsbColor get inverted => toColor().inverted.toHsb();

  @override
  HsbColor get grayscale => toColor().grayscale.toHsb();

  @override
  HsbColor whiten([double amount = 20]) => toColor().whiten(amount).toHsb();

  @override
  HsbColor blacken([double amount = 20]) => toColor().blacken(amount).toHsb();

  @override
  HsbColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toHsb();

  @override
  HsbColor lighten([double amount = 20]) {
    return HsbColor(h, s, min(1.0, b + amount / 100));
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HsbColor fromHct(HctColor hct) => hct.toColor().toHsb();

  @override
  HsbColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsb();
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
  HsbColor copyWith({double? h, double? s, double? b}) {
    return HsbColor(
      h ?? this.h,
      s ?? this.s,
      b ?? this.b,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toHsb()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toHsb())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toHsb())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toHsb();

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
  HsbColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toHsb();

  @override
  HsbColor opaquer([double amount = 20]) => toColor().opaquer(amount).toHsb();

  @override
  HsbColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toHsb();

  @override
  HsbColor get complementary => toColor().complementary.toHsb();

  @override
  HsbColor warmer([double amount = 20]) => toColor().warmer(amount).toHsb();

  @override
  HsbColor cooler([double amount = 20]) => toColor().cooler(amount).toHsb();

  @override
  List<HsbColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toHsb()).toList();

  @override
  List<HsbColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toHsb()).toList();

  @override
  List<HsbColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toHsb()).toList();

  @override
  List<HsbColor> square() => toColor().square().map((c) => c.toHsb()).toList();

  @override
  List<HsbColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toHsb()).toList();

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
      'type': 'HsbColor',
      'hue': h,
      'saturation': s,
      'brightness': b,
      'alpha': 1.0 - transparency, // Assuming alpha is 1 - transparency
    };
  }

  @override
  String toString() => 'HsbColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
