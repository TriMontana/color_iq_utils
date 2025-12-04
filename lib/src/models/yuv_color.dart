import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

/// A representation of a color in the YUV color space.
///
/// YUV is a color encoding system typically used as part of a color image pipeline.
/// It encodes a color image or video taking human perception into account,
/// allowing reduced bandwidth for chrominance components, thereby typically
/// enabling transmission errors or compression artifacts to be more efficiently
/// masked by human perception than using a "direct" RGB-representation.
///
/// The Y component represents the luma, or brightness, and the U and V components
/// are the chrominance (color) components.
///
/// [YuvColor] provides methods to convert to and from other color spaces,
/// and to perform various color manipulations.
class YuvColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The luma component (brightness).
  ///
  /// Ranges from 0.0 to 1.0.
  final double y;

  /// The chrominance U component (blue projection).
  final double u;

  /// The chrominance V component (red projection).
  final double v;

  const YuvColor(this.y, this.u, this.v, {required final int val}) : super(val);
  YuvColor.alt(this.y, this.u, this.v, {final int? val})
      : super(val ?? YuvColor.toHex(y, u, v));

  /// Creates a 32-bit ARGB hex value from [y], [u], and [v] components.
  ///
  /// The alpha value is set to 255 (fully opaque).
  static int toHex(final double y, final double u, final double v) {
    final double r = y + 1.13983 * v;
    final double g = y - 0.39465 * u - 0.58060 * v;
    final double b = y + 2.03211 * u;

    final int red = (r * 255).round().clamp(0, 255);
    final int green = (g * 255).round().clamp(0, 255);
    final int blue = (b * 255).round().clamp(0, 255);

    return (255 << 24) | (red << 16) | (green << 8) | blue;
  }

  @override
  ColorIQ toColor() {
    final double r = y + 1.13983 * v;
    final double g = y - 0.39465 * u - 0.58060 * v;
    final double b = y + 2.03211 * u;
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
  YuvColor darken([final double amount = 20]) {
    return YuvColor.alt(max(0.0, y - amount / 100), u, v);
  }

  @override
  YuvColor brighten([final double amount = 20]) {
    return YuvColor.alt(min(1.0, y + amount / 100), u, v);
  }

  @override
  YuvColor saturate([final double amount = 25]) {
    final double factor = 1 + (amount / 100);
    return YuvColor.alt(y, u * factor, v * factor);
  }

  @override
  YuvColor desaturate([final double amount = 25]) {
    final double factor = max(0.0, 1 - (amount / 100));
    return YuvColor.alt(y, u * factor, v * factor);
  }

  @override
  YuvColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
  YuvColor deintensify([final double amount = 10]) {
    return desaturate(amount);
  }

  @override
  YuvColor accented([final double amount = 15]) {
    return intensify(amount);
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
  YuvColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  YuvColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  YuvColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final YuvColor otherYuv =
        other is YuvColor ? other : other.toColor().toYuv();
    if (t == 1.0) return otherYuv;

    return YuvColor(
      lerpDouble(y, otherYuv.y, t),
      lerpDouble(u, otherYuv.u, t),
      lerpDouble(v, otherYuv.v, t),
    );
  }

  @override
  YuvColor lighten([final double amount = 20]) {
    return YuvColor.alt(min(1.0, y + amount / 100), u, v);
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
    return YuvColor.alt(y ?? this.y, u ?? this.u, v ?? this.v);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toYuv())
      .toList();

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
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  YuvColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toYuv();

  @override
  YuvColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toYuv();

  @override
  YuvColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toYuv();

  @override
  YuvColor get complementary => toColor().complementary.toYuv();

  @override
  YuvColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toYuv();

  @override
  YuvColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toYuv();

  @override
  List<YuvColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toYuv())
      .toList();

  @override
  List<YuvColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toYuv()).toList();

  @override
  List<YuvColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toYuv())
          .toList();

  @override
  List<YuvColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toYuv()).toList();

  @override
  List<YuvColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toYuv())
      .toList();

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
    return <String, dynamic>{'type': 'YuvColor', 'y': y, 'u': u, 'v': v};
  }

  @override
  String toString() => 'YuvColor(y: ${y.toStrTrimZeros(2)}, ' //
      'u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}
