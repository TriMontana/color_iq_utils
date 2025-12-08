import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsluv.dart';

/// A representation of color in the HSLuv color space.
/// Adapted from hsluv-dart: https://github.com/hsluv/hsluv-dart
/// by Bernardo Ferrari
///
/// HSLuv is a human-friendly alternative to HSL. It is designed to be
/// perceptually uniform, meaning that changes in the H, S, and L values
/// correspond to consistent changes in the perceived color.
///
/// The `HsluvColor` class provides properties for hue, saturation, and lightness,
/// and methods for color manipulation and conversion to other color spaces.
///
/// - **Hue (h):** The color's angle on the color wheel, ranging from 0 to 360.
/// - **Saturation (s):** The color's intensity, from 0 (grayscale) to 100 (fully saturated).
/// - **Lightness (l):** The color's perceived brightness, from 0 (black) to 100 (white).
///  CREDIT: https://github.com/hsluv/hsluv-dart
class HsluvColor extends CommonIQ implements ColorSpacesIQ {
  final double h;
  final double s;
  final double l;

  const HsluvColor(this.h, this.s, this.l,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String> names = kEmptyNames})
      : super(hexId, alpha: alpha, names: names);

  /// Creates a 32-bit ARGB hex value from HSLuv components.
  @override
  int get value => super.colorId ?? HsluvColor.hexIdFromHSLuv(h: h, s: s, l: l);

  static int hexIdFromHSLuv(
      {required final double h,
      required final double s,
      required final double l}) {
    return Hsluv.hsluvToHex(<double>[h, s, l]).toHexInt();
  }

  static int hsluvToHexId(final double h, final double s, final double l) {
    return Hsluv.hsluvToHex(<double>[h, s, l]).toHexInt();
  }

  @override
  HsluvColor darken([final double amount = 20]) {
    return HsluvColor(h, s, max(0.0, l - amount));
  }

  HsluvColor get grayscale => HsluvColor(h, 0, l);

  @override
  HsluvColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HsluvColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HsluvColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final HsluvColor otherHsluv =
        other is HsluvColor ? other : other.toColor().toHsluv();
    if (t == 1.0) {
      return otherHsluv;
    }

    return HsluvColor(
      lerpHue(h, otherHsluv.h, t),
      lerpDouble(s, otherHsluv.s, t),
      lerpDouble(l, otherHsluv.l, t),
    );
  }

  @override
  HsluvColor lighten([final double amount = 20]) {
    return HsluvColor(h, s, min(100.0, l + amount));
  }

  @override
  HsluvColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toHsluv();
  }

  @override
  HsluvColor saturate([final double amount = 25]) {
    return HsluvColor(h, min(100.0, s + amount), l);
  }

  @override
  HsluvColor desaturate([final double amount = 25]) {
    return HsluvColor(h, max(0.0, s - amount), l);
  }

  @override
  HsluvColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toHsluv();
  }

  @override
  HsluvColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toHsluv();
  }

  @override
  HsluvColor accented([final double amount = 15]) {
    return toColor().accented(amount).toHsluv();
  }

  @override
  HsluvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsluv();
  }

  @override
  HctColor toHctColor() => toColor().toHctColor();

  @override
  HsluvColor fromHct(final HctColor hct) => hct.toColor().toHsluv();

  @override
  HsluvColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsluv();
  }

  @override
  double get transparency => toColor().transparency;

  /// Creates a copy of this color with the given fields replaced with the new values.
  HsluvColor copyWith({final double? h, final double? s, final double? l}) {
    return HsluvColor(h ?? this.h, s ?? this.s, l ?? this.l);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsluv())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsluv())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsluv())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsluv();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  HsluvColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHsluv();

  @override
  HsluvColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHsluv();

  @override
  HsluvColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return HsluvColor(newHue, s, l);
  }

  @override
  HsluvColor get complementary => adjustHue(180);

  @override
  HsluvColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHsluv();

  @override
  HsluvColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHsluv();

  @override
  List<HsluvColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHsluv())
      .toList();

  @override
  List<HsluvColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHsluv()).toList();

  @override
  List<HsluvColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHsluv())
          .toList();

  @override
  List<HsluvColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHsluv()).toList();

  @override
  List<HsluvColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHsluv())
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
    return <String, dynamic>{
      'type': 'HsluvColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha':
          1.0, // HsluvColor does not inherently store alpha, assuming opaque
    };
  }

  @override
  String toString() =>
      'HsluvColor(h: ${h.toStrTrimZeros(3)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
