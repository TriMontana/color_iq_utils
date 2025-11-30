import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'color.dart';
import 'hct_color.dart';

class YiqColor implements ColorSpacesIQ {
  final double y;
  final double i;
  final double q;

  const YiqColor(this.y, this.i, this.q);

  @override
  Color toColor() {
    double r = y + 0.956 * i + 0.621 * q;
    double g = y - 0.272 * i - 0.647 * q;
    double b = y - 1.106 * i + 1.703 * q;

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  YiqColor darken([double amount = 20]) {
    return toColor().darken(amount).toYiq();
  }

  @override
  YiqColor saturate([double amount = 25]) {
    return toColor().saturate(amount).toYiq();
  }

  @override
  YiqColor desaturate([double amount = 25]) {
    return toColor().desaturate(amount).toYiq();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  YiqColor get inverted => toColor().inverted.toYiq();

  @override
  YiqColor get grayscale => toColor().grayscale.toYiq();

  @override
  YiqColor whiten([double amount = 20]) => toColor().whiten(amount).toYiq();

  @override
  YiqColor blacken([double amount = 20]) => toColor().blacken(amount).toYiq();

  @override
  YiqColor lerp(ColorSpacesIQ other, double t) => (toColor().lerp(other, t) as Color).toYiq();

  @override
  YiqColor lighten([double amount = 20]) {
    return toColor().lighten(amount).toYiq();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  YiqColor fromHct(HctColor hct) => hct.toColor().toYiq();

  @override
  YiqColor adjustTransparency([double amount = 20]) {
    return toColor().adjustTransparency(amount).toYiq();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  YiqColor copyWith({double? y, double? i, double? q}) {
    return YiqColor(
      y ?? this.y,
      i ?? this.i,
      q ?? this.q,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic.map((c) => (c as Color).toYiq()).toList();

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((c) => (c as Color).toYiq())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((c) => (c as Color).toYiq())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as Color).toYiq();

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
  YiqColor blend(ColorSpacesIQ other, [double amount = 50]) => toColor().blend(other, amount).toYiq();

  @override
  YiqColor opaquer([double amount = 20]) => toColor().opaquer(amount).toYiq();

  @override
  YiqColor adjustHue([double amount = 20]) => toColor().adjustHue(amount).toYiq();

  @override
  YiqColor get complementary => toColor().complementary.toYiq();

  @override
  YiqColor warmer([double amount = 20]) => toColor().warmer(amount).toYiq();

  @override
  YiqColor cooler([double amount = 20]) => toColor().cooler(amount).toYiq();

  @override
  List<YiqColor> generateBasicPalette() => toColor().generateBasicPalette().map((c) => c.toYiq()).toList();

  @override
  List<YiqColor> tonesPalette() => toColor().tonesPalette().map((c) => c.toYiq()).toList();

  @override
  List<YiqColor> analogous({int count = 5, double offset = 30}) => toColor().analogous(count: count, offset: offset).map((c) => c.toYiq()).toList();

  @override
  List<YiqColor> square() => toColor().square().map((c) => c.toYiq()).toList();

  @override
  List<YiqColor> tetrad({double offset = 60}) => toColor().tetrad(offset: offset).map((c) => c.toYiq()).toList();

  @override
  String toString() => 'YiqColor(y: ${y.toStringAsFixed(2)}, i: ${i.toStringAsFixed(2)}, q: ${q.toStringAsFixed(2)})';
}
