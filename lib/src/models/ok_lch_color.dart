import 'dart:math';
import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';

class OkLchColor implements ColorSpacesIQ {
  final double l;
  final double c;
  final double h;
  final double alpha;

  const OkLchColor(this.l, this.c, this.h, [this.alpha = 1.0]);

  OkLabColor toOkLab() {
    final double hRad = h * pi / 180;
    return OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha);
  }
  
  @override
  ColorIQ toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  OkLchColor darken([final double amount = 20]) {
    return OkLchColor(max(0.0, l - amount / 100), c, h, alpha);
  }

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  OkLchColor get inverted => toColor().inverted.toOkLch();

  @override
  OkLchColor get grayscale => toColor().grayscale.toOkLch();

  @override
  OkLchColor whiten([final double amount = 20]) => toColor().whiten(amount).toOkLch();

  @override
  OkLchColor blacken([final double amount = 20]) => toColor().blacken(amount).toOkLch();

  @override
  OkLchColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toOkLch();

  @override
  OkLchColor lighten([final double amount = 20]) {
    return OkLchColor(min(1.0, l + amount / 100), c, h, alpha);
  }

  @override
  OkLchColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toOkLch();
  }

  @override
  OkLchColor saturate([final double amount = 25]) {
    return OkLchColor(l, c + amount / 100, h, alpha);
  }

  @override
  OkLchColor desaturate([final double amount = 25]) {
    return OkLchColor(l, max(0.0, c - amount / 100), h, alpha);
  }

  @override
  OkLchColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toOkLch();
  }

  @override
  OkLchColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toOkLch();
  }

  @override
  OkLchColor accented([final double amount = 15]) {
    return toColor().accented(amount).toOkLch();
  }

  @override
  OkLchColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkLch();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  HctColor toHct() => toColor().toHct();

  @override
  OkLchColor fromHct(final HctColor hct) => hct.toColor().toOkLch();

  @override
  OkLchColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkLch();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkLchColor copyWith({final double? l, final double? c, final double? h, final double? alpha}) {
    return OkLchColor(
      l ?? this.l,
      c ?? this.c,
      h ?? this.h,
      alpha ?? this.alpha,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLch()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLch())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkLch())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkLch();

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
  OkLchColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toOkLch();

  @override
  OkLchColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toOkLch();

  @override
  OkLchColor adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toOkLch();

  @override
  OkLchColor get complementary => toColor().complementary.toOkLch();

  @override
  OkLchColor warmer([final double amount = 20]) => toColor().warmer(amount).toOkLch();

  @override
  OkLchColor cooler([final double amount = 20]) => toColor().cooler(amount).toOkLch();

  @override
  List<OkLchColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> square() => toColor().square().map((final ColorIQ c) => c.toOkLch()).toList();

  @override
  List<OkLchColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toOkLch()).toList();

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
      'type': 'OkLchColor',
      'l': l,
      'c': c,
      'h': h,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkLchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
