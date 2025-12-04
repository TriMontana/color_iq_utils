import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// A class representing a color in the YIQ color space.
///
/// The YIQ color model is the color space used by the NTSC color TV system.
/// 'Y' represents the luma component (brightness), and 'I' and 'Q' represent
/// the chrominance components (color information).
///
/// `Y` ranges from 0.0 to 1.0.
/// `I` ranges from -0.5957 to 0.5957.
/// `Q` ranges from -0.5226 to 0.5226.
///
/// This class provides methods to convert from and to other color spaces,
/// as well as to manipulate the color.
class YiqColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The luma component.
  final double y;

  /// The in-phase chrominance component.
  final double i;

  /// The quadrature chrominance component.
  final double q;

  /// Creates a new `YiqColor`.
  const YiqColor(this.y, this.i, this.q, {required final int val}) : super(val);
  YiqColor.alt(this.y, this.i, this.q, {final int? val})
      : super(val ?? YiqColor.argbFromYiq(y, i, q));

  /// Creates a 32-bit hex ARGB value from YIQ components.
  ///
  /// [y] - The luma component (0.0 to 1.0).
  /// [i] - The in-phase chrominance component (-0.5957 to 0.5957).
  /// [q] - The quadrature chrominance component (-0.5226 to 0.5226).
  static int argbFromYiq(final double y, final double i, final double q) {
    final double r = y + 0.956 * i + 0.621 * q;
    final double g = y - 0.272 * i - 0.647 * q;
    final double b = y - 1.106 * i + 1.703 * q;

    final int red = (r * 255).round().clamp(0, 255);
    final int green = (g * 255).round().clamp(0, 255);
    final int blue = (b * 255).round().clamp(0, 255);

    return (255 << 24) | (red << 16) | (green << 8) | blue;
  }

  @override
  ColorIQ toColor() {
    final double r = y + 0.956 * i + 0.621 * q;
    final double g = y - 0.272 * i - 0.647 * q;
    final double b = y - 1.106 * i + 1.703 * q;

    return ColorIQ.fromARGB(
      255,
      (r * 255).round().clamp(0, 255),
      (g * 255).round().clamp(0, 255),
      (b * 255).round().clamp(0, 255),
    );
  }

  @override
  int get value => toColor().value;

  @override
  YiqColor darken([final double amount = 20]) {
    return toColor().darken(amount).toYiq();
  }

  @override
  YiqColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toYiq();
  }

  @override
  YiqColor saturate([final double amount = 25]) {
    final double scale = 1.0 + (amount / 100.0);
    return YiqColor.alt(y, i * scale, q * scale);
  }

  @override
  YiqColor desaturate([final double amount = 25]) {
    final double scale = 1.0 - (amount / 100.0);
    return YiqColor.alt(y, i * scale, q * scale);
  }

  @override
  YiqColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
  YiqColor deintensify([final double amount = 10]) {
    return desaturate(amount);
  }

  @override
  YiqColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  YiqColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toYiq();
  }

  @override
  YiqColor get inverted => toColor().inverted.toYiq();

  @override
  YiqColor get grayscale => toColor().grayscale.toYiq();

  @override
  YiqColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  YiqColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  YiqColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final YiqColor otherYiq =
        other is YiqColor ? other : other.toColor().toYiq();
    if (t == 1.0) return otherYiq;

    return YiqColor.alt(
      lerpDouble(y, otherYiq.y, t),
      lerpDouble(i, otherYiq.i, t),
      lerpDouble(q, otherYiq.q, t),
    );
  }

  @override
  YiqColor lighten([final double amount = 20]) {
    return toColor().lighten(amount).toYiq();
  }

  @override
  YiqColor fromHct(final HctColor hct) => hct.toColor().toYiq();

  @override
  YiqColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toYiq();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  YiqColor copyWith({final double? y, final double? i, final double? q}) {
    return YiqColor.alt(y ?? this.y, i ?? this.i, q ?? this.q);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toYiq())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toYiq())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toYiq())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toYiq();

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
  YiqColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toYiq();

  @override
  YiqColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toYiq();

  @override
  YiqColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toYiq();

  @override
  YiqColor get complementary => toColor().complementary.toYiq();

  @override
  YiqColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toYiq();

  @override
  YiqColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toYiq();

  @override
  List<YiqColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toYiq())
      .toList();

  @override
  List<YiqColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toYiq()).toList();

  @override
  List<YiqColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toYiq())
          .toList();

  @override
  List<YiqColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toYiq()).toList();

  @override
  List<YiqColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toYiq())
      .toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'YiqColor', 'y': y, 'i': i, 'q': q};
  }

  @override
  String toString() =>
      'YiqColor(y: ${y.toStrTrimZeros(2)}, i: ${i.toStringAsFixed(2)}, q: ${q.toStringAsFixed(2)})';
}
