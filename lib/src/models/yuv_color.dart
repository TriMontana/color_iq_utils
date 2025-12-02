import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

class YuvColor implements ColorSpacesIQ {
  final double y;
  final double u;
  final double v;

  const YuvColor(this.y, this.u, this.v);

  @override
  ColorIQ toColor() {
    final double r = y + 1.13983 * v;
    final double g = y - 0.39465 * u - 0.58060 * v;
    final double b = y + 2.03211 * u;
    return ColorIQ.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  YuvColor darken([final double amount = 20]) {
    return toColor().darken(amount).toYuv();
  }

  @override
  YuvColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toYuv();
  }

  @override
  YuvColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).toYuv();
  }

  @override
  YuvColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toYuv();
  }

  @override
  YuvColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toYuv();
  }

  @override
  YuvColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toYuv();
  }

  @override
  YuvColor accented([final double amount = 15]) {
    return toColor().accented(amount).toYuv();
  }

  @override
  YuvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toYuv();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  YuvColor get inverted => toColor().inverted.toYuv();

  @override
  YuvColor get grayscale => toColor().grayscale.toYuv();

  @override
  YuvColor whiten([final double amount = 20]) => toColor().whiten(amount).toYuv();

  @override
  YuvColor blacken([final double amount = 20]) => toColor().blacken(amount).toYuv();

  @override
  YuvColor lerp(final ColorSpacesIQ other, final double t) => (toColor().lerp(other, t) as ColorIQ).toYuv();

  @override
  YuvColor lighten([final double amount = 20]) {
    return toColor().lighten(amount).toYuv();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  YuvColor fromHct(final HctColor hct) => hct.toColor().toYuv();

  @override
  YuvColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toYuv();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  YuvColor copyWith({final double? y, final double? u, final double? v}) {
    return YuvColor(
      y ?? this.y,
      u ?? this.u,
      v ?? this.v,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((final ColorSpacesIQ c) => (c as ColorIQ).toYuv()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toYuv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toYuv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toYuv();

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
  YuvColor blend(final ColorSpacesIQ other, [final double amount = 50]) => toColor().blend(other, amount).toYuv();

  @override
  YuvColor opaquer([final double amount = 20]) => toColor().opaquer(amount).toYuv();

  @override
  YuvColor adjustHue([final double amount = 20]) => toColor().adjustHue(amount).toYuv();

  @override
  YuvColor get complementary => toColor().complementary.toYuv();

  @override
  YuvColor warmer([final double amount = 20]) => toColor().warmer(amount).toYuv();

  @override
  YuvColor cooler([final double amount = 20]) => toColor().cooler(amount).toYuv();

  @override
  List<YuvColor> generateBasicPalette() => toColor().generateBasicPalette().map((final ColorIQ c) => c.toYuv()).toList();

  @override
  List<YuvColor> tonesPalette() => toColor().tonesPalette().map((final ColorIQ c) => c.toYuv()).toList();

  @override
  List<YuvColor> analogous({final int count = 5, final double offset = 30}) => toColor().analogous(count: count, offset: offset).map((final ColorIQ c) => c.toYuv()).toList();

  @override
  List<YuvColor> square() => toColor().square().map((final ColorIQ c) => c.toYuv()).toList();

  @override
  List<YuvColor> tetrad({final double offset = 60}) => toColor().tetrad(offset: offset).map((final ColorIQ c) => c.toYuv()).toList();

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
      'type': 'YuvColor',
      'y': y,
      'u': u,
      'v': v,
    };
  }

  @override
  String toString() => 'YuvColor(y: ${y.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
