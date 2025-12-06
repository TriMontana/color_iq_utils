import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';

/// A color representation in the Rec. 2020 color space.
///
/// The Rec. 2020 color space, also known as BT.2020, is a wide gamut color
/// space used for ultra-high-definition television (UHDTV). It can represent
/// a much wider range of colors than the standard sRGB color space.
///
/// The [r], [g], and [b] values are typically in the range of 0.0 to 1.0.
class Rec2020Color extends ColorSpacesIQ with ColorModelsMixin {
  @override
  final double r;
  @override
  final double g;
  @override
  final double b;

  const Rec2020Color(this.r, this.g, this.b,
      {required final int hexId,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(hexId, a: alpha, names: names ?? const <String>[]);

  Rec2020Color.alt(this.r, this.g, this.b,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(hexId ?? toHexID(r, g, b),
            a: alpha, names: names ?? const <String>[]);

  /// Creates a 32-bit hex ARGB value from the properties of this class.
  ///
  /// This is a convenience method that converts the Rec. 2020 color
  /// to a [ColorIQ] instance and then returns its integer `value`.
  /// It can be used in contexts where a Rec2020Color object needs to be
  /// represented as a standard 32-bit color value.
  ///
  /// The `alpha` value is always 255 (fully opaque).
  ///
  /// Returns the 32-bit ARGB hex value.
  static int toHexID(final double r, final double g, final double b) {
    // Rec. 2020 decoding (Gamma to Linear)
    double transferInv(final double v) {
      if (v < 0.018 * 4.5) return v / 4.5;
      return pow((v + 0.099) / 1.099, 1 / 0.45).toDouble();
    }

    final double rLin = transferInv(r);
    final double gLin = transferInv(g);
    final double bLin = transferInv(b);

    // Rec. 2020 Linear to XYZ (D65)
    final double x = rLin * 0.6369580 + gLin * 0.1446169 + bLin * 0.1688810;
    final double y = rLin * 0.2627002 + gLin * 0.6779981 + bLin * 0.0593017;
    final double z = rLin * 0.0000000 + gLin * 0.0280727 + bLin * 1.0609851;

    // XYZ (D65) to sRGB Linear
    final double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
    final double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
    final double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;

    // sRGB Linear to sRGB (Gamma encoded)

    return ColorIQ.fromSrgb(
      r: rS.clamp(0.0, 1.0).gammaCorrect,
      g: gS.clamp(0.0, 1.0).gammaCorrect,
      b: bS.clamp(0.0, 1.0).gammaCorrect,
    ).value;
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  @override
  Rec2020Color darken([final double amount = 20]) {
    return toColor().darken(amount).toRec2020();
  }

  @override
  Rec2020Color brighten([final double amount = 20]) {
    return toColor().brighten(amount).toRec2020();
  }

  @override
  Rec2020Color saturate([final double amount = 25]) {
    return toColor().saturate(amount).toRec2020();
  }

  @override
  Rec2020Color desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toRec2020();
  }

  @override
  Rec2020Color intensify([final double amount = 10]) {
    return toColor().intensify(amount).toRec2020();
  }

  @override
  Rec2020Color deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toRec2020();
  }

  @override
  Rec2020Color accented([final double amount = 15]) {
    return toColor().accented(amount).toRec2020();
  }

  @override
  Rec2020Color simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toRec2020();
  }

  @override
  Rec2020Color get inverted => toColor().inverted.toRec2020();

  @override
  Rec2020Color whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  Rec2020Color blacken([final double amount = 20]) =>
      lerp(cBlack, amount / 100);

  @override
  Rec2020Color lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final Rec2020Color otherRec =
        other is Rec2020Color ? other : other.toColor().toRec2020();
    if (t == 1.0) return otherRec;

    return Rec2020Color.alt(
      lerpDouble(r, otherRec.r, t),
      lerpDouble(g, otherRec.g, t),
      lerpDouble(b, otherRec.b, t),
    );
  }

  @override
  Rec2020Color lighten([final double amount = 20]) {
    return toColor().lighten(amount).toRec2020();
  }

  @override
  Rec2020Color fromHct(final HctColor hct) => hct.toColor().toRec2020();

  @override
  Rec2020Color adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toRec2020();
  }

  @override
  double get transparency => toColor().transparency;

  double get opacity => 1.0 - transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  Rec2020Color copyWith({final double? r, final double? g, final double? b}) {
    return Rec2020Color.alt(r ?? this.r, g ?? this.g, b ?? this.b);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toRec2020())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<Rec2020Color> results = <Rec2020Color>[];
    double delta;
    if (step != null) {
      delta = step;
    } else {
      delta = 10.0; // Default step 10%
    }

    for (int i = 1; i <= 5; i++) {
      results.add(whiten(delta * i));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<Rec2020Color> results = <Rec2020Color>[];
    double delta;
    if (step != null) {
      delta = step;
    } else {
      delta = 10.0; // Default step 10%
    }

    for (int i = 1; i <= 5; i++) {
      results.add(blacken(delta * i));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toRec2020();

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
  Rec2020Color blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toRec2020();

  @override
  Rec2020Color opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toRec2020();

  @override
  Rec2020Color adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toRec2020();

  @override
  Rec2020Color get complementary => toColor().complementary.toRec2020();

  @override
  Rec2020Color warmer([final double amount = 20]) =>
      toColor().warmer(amount).toRec2020();

  @override
  Rec2020Color cooler([final double amount = 20]) =>
      toColor().cooler(amount).toRec2020();

  @override
  List<Rec2020Color> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toRec2020())
      .toList();

  @override
  List<Rec2020Color> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> analogous({
    final int count = 5,
    final double offset = 30,
  }) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toRec2020())
          .toList();

  @override
  List<Rec2020Color> square() =>
      toColor().square().map((final ColorIQ c) => c.toRec2020()).toList();

  @override
  List<Rec2020Color> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toRec2020())
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
  List<double> get whitePoint => kWhitePointD65;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'Rec2020Color',
      'r': r,
      'g': g,
      'b': b,
      'opacity': opacity,
    };
  }

  @override
  String toString() => 'Rec2020Color(r: ${r.toStrTrimZeros(4)}, ' //
      'g: ${g.toStringAsFixed(4)}, '
      'b: ${b.toStringAsFixed(4)}, opacity: ${opacity.toStringAsFixed(2)})';
}
