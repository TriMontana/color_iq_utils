import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';

/// A color in the HSL (Hue, Saturation, Lightness) color space.
///
/// HSL is a cylindrical-coordinate representation of points in an RGB color model.
///
/// - **Hue**: The type of color (e.g., red, green, blue). It is represented as an
///   angle from 0 to 360 degrees.
/// - **Saturation**: The "purity" of the color. 0% means a shade of gray and
///   100% is the full color. It is represented as a double from 0.0 to 1.0.
/// - **Lightness**: The "brightness" of the color. 0% is black, 100% is white,
///   and 50% is the "normal" color. It is represented as a double from 0.0 to 1.0.
class HslColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The hue value, ranging from 0.0 to 360.0.
  final double h;

  /// The saturation value, ranging from 0.0 to 1.0.
  final double s;

  /// The lightness value, ranging from 0.0 to 1.0.
  final double l;

  /// The alpha value (opacity) of the color.
  Percent get alpha => super.a;

  /// Creates an HSL color.
  ///
  /// All values are clamped to their respective ranges.
  /// Requires a `hexId` to be passed for the underlying [ColorSpacesIQ] representation.
  const HslColor(this.h, this.s, this.l,
      {final Percent alpha = Percent.max,
      required final int hexId,
      final List<String>? names})
      : assert(
            h >= 0.0 && h <= 360.0, 'Invalid hue, range must be 0 to 360: $h'),
        assert(s >= 0.0 && s <= 1.0,
            'Invalid saturation, range must be 0 to 1: $s'),
        assert(l >= 0.0 && l <= 1.0,
            'Invalid lightness, range must be 0 to 1: $l'),
        super(hexId, a: alpha, names: names ?? const <String>[]);

  /// Creates an HSL color and calculates the `hexId` automatically.
  ///
  /// This is a convenience constructor that calculates the integer hex value
  /// from the provided HSL and alpha values.
  HslColor.alt(this.h, this.s, this.l,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String>? names})
      : super(hexId ?? HslColor.toHexID(h, s, l, alpha: alpha),
            a: alpha, names: names ?? const <String>[]);

  /// Creates an [HslColor] from an RGB [Color].
  ///
  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  factory HslColor.fromInt(final int color) {
    final double red = color.r;
    final double green = color.g;
    final double blue = color.b;

    final double max = math.max(red, math.max(green, blue));
    final double min = math.min(red, math.min(green, blue));
    final double delta = max - min;

    final Percent alpha = Percent(color.a);
    final double hue = getHue(red, green, blue, max, delta);
    final double lightness = (max + min) / 2.0;
    // Saturation can exceed 1.0 with rounding errors, so clamp it.
    final double saturation = min == max
        ? 0.0
        : clampDouble(
            delta / (1.0 - (2.0 * lightness - 1.0).abs()),
            min: 0.0,
            max: 1.0,
          );
    return HslColor.alt(hue, saturation, lightness, alpha: alpha);
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Creates a 32-bit ARGB hex value from HSL values.
  ///
  /// [h] is in the range of 0.0-360.0.
  /// [s] is in the range of 0.0-1.0.
  /// [l] is in the range of 0.0-1.0.
  /// [alpha] is in the range of 0.0-1.0.
  static int toHexID(final double h, final double s, final double l,
      {final Percent alpha = Percent.max}) {
    final double c = (1 - (2 * l - 1).abs()) * s;
    final double x = c * (1 - ((h / 60) % 2 - 1).abs());
    final double m = l - c / 2;

    double r = 0, g = 0, b = 0;
    if (h < 60) {
      r = c;
      g = x;
    } else if (h < 120) {
      r = x;
      g = c;
    } else if (h < 180) {
      g = c;
      b = x;
    } else if (h < 240) {
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      b = c;
    } else {
      r = c;
      b = x;
    }

    return ColorIQ.fromARGB(
      (alpha * 255).round(),
      ((r + m) * 255).round().clamp(0, 255),
      ((g + m) * 255).round().clamp(0, 255),
      ((b + m) * 255).round().clamp(0, 255),
    ).value;
  }

  @override
  HslColor darken([final double amount = 20]) =>
      copyWith(saturation: max(0.0, l - amount / 100));

  @override
  HslColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toHsl();
  }

  @override
  HslColor saturate([final double amount = 25]) {
    return HslColor.alt(h, min(1.0, s + amount / 100), l, alpha: alpha);
  }

  @override
  HslColor desaturate([final double amount = 25]) =>
      copyWith(saturation: max(0.0, s - amount / 100));

  @override
  HslColor intensify([final double amount = 10]) {
    return HslColor.alt(h, min(1.0, s + amount / 100), l, alpha: alpha);
  }

  @override
  HslColor deintensify([final double amount = 10]) =>
      copyWith(saturation: max(0.0, s - amount / 100));

  @override
  HslColor accented([final double amount = 15]) => intensify(amount);

  @override
  HslColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsl();
  }

  @override
  HslColor get inverted => flipHue();

  /// Flip the hue by 180 degrees.
  HslColor flipHue() => HslColor.alt(_wrapHue(h + 180), s, l, alpha: alpha);

  @override
  HslColor get grayscale => HslColor.alt(h, 0.0, l, alpha: alpha);

  @override
  HslColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HslColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HslColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HslColor otherHsl =
        other is HslColor ? other : other.toColor().toHsl();
    if (t == 1.0) return otherHsl;

    return HslColor.alt(
      lerpHue(h, otherHsl.h, t),
      lerpDouble(s, otherHsl.s, t),
      lerpDouble(l, otherHsl.l, t),
      alpha: alpha.lerpTo(otherHsl.alpha, t),
    );
  }

  @override
  HslColor lighten([final double amount = 20]) {
    return HslColor.alt(h, s, min(1.0, l + amount / 100), alpha: alpha);
  }

  @override
  HslColor fromHct(final HctColor hct) => HslColor.fromInt(hct.toInt());

  @override
  HslColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsl();
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
  HslColor copyWith({
    final double? hue,
    final double? saturation,
    final double? lightness,
    final Percent? alpha,
  }) {
    return HslColor.alt(hue ?? h, saturation ?? s, lightness ?? l,
        alpha: alpha ?? this.alpha);
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Native implementation for HSL
    final List<HslColor> results = <HslColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 0.1; // 10%
      final double newL = (l + delta).clamp(0.0, 1.0);
      results.add(HslColor.alt(h, s, newL, alpha: alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<HslColor> results = <HslColor>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = (1.0 - l) / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      final double newL = (l + delta * i).clamp(0.0, 1.0);
      results.add(HslColor.alt(h, s, newL, alpha: alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<HslColor> results = <HslColor>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = l / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      final double newL = (l - delta * i).clamp(0.0, 1.0);
      results.add(HslColor.alt(h, s, newL, alpha: alpha));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsl();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HslColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    final HslColor target = other is HslColor ? other : other.toHslColor();
    final double t = (amount / 100).clamp(0.0, 1.0).toDouble();

    return HslColor.alt(
      lerpHueB(h, target.h, t),
      clamp01(lerpDoubleB(s, target.s, t)),
      clamp01(lerpDoubleB(l, target.l, t)),
      alpha: Percent(clamp01(lerpDoubleB(alpha.val, target.alpha.val, t))),
    );
  }

  @override
  HslColor opaquer([final double amount = 20]) {
    final double factor = (amount / 100).clamp(0.0, 1.0).toDouble();
    return HslColor.alt(h, s, l,
        alpha: Percent(clamp01(alpha.value + (1 - alpha.value) * factor)));
  }

  @override
  HslColor adjustHue([final double amount = 20]) =>
      HslColor.alt(_wrapHue(h + amount), s, l, alpha: alpha);

  @override
  HslColor get complementary =>
      HslColor.alt(_wrapHue(h + 180.0), s, l, alpha: alpha);

  @override
  HslColor warmer([final double amount = 20]) =>
      HslColor.alt(_wrapHue(h - amount), s, l, alpha: alpha);

  @override
  HslColor cooler([final double amount = 20]) =>
      HslColor.alt(_wrapHue(h + amount), s, l, alpha: alpha);

  @override
  List<HslColor> generateBasicPalette() {
    const List<double> saturationOffsets = <double>[-0.2, -0.1, 0.0, 0.1, 0.2];
    const List<double> lightnessOffsets = <double>[-0.2, -0.1, 0.0, 0.1, 0.2];

    return List<HslColor>.generate(saturationOffsets.length, (final int index) {
      return HslColor.alt(
        h,
        clamp01(s + saturationOffsets[index]),
        clamp01(l + lightnessOffsets[index]),
        alpha: alpha,
      );
    });
  }

  @override
  List<HslColor> tonesPalette() {
    const List<double> toneOffsets = <double>[-0.3, -0.15, 0.0, 0.15, 0.3];
    return toneOffsets
        .map(
          (final double delta) =>
              HslColor.alt(h, s, (l + delta).clamp(0.0, 1.0), alpha: alpha),
        )
        .toList();
  }

  @override
  List<HslColor> analogous({final int count = 5, final double offset = 30}) {
    if (count <= 0) {
      return <HslColor>[];
    }
    final List<HslColor> palette = <HslColor>[];
    final double pivot = (count - 1) / 2;
    for (int i = 0; i < count; i++) {
      final double delta = (i - pivot) * offset;
      palette.add(HslColor.alt(_wrapHue(h + delta), s, l, alpha: alpha));
    }
    return palette;
  }

  @override
  List<HslColor> square() => List<HslColor>.generate(
        4,
        (final int index) =>
            HslColor.alt(_wrapHue(h + 90.0 * index), s, l, alpha: alpha),
        growable: false,
      );

  @override
  List<HslColor> tetrad({final double offset = 60}) => <HslColor>[
        HslColor.alt(h, s, l, alpha: alpha),
        HslColor.alt(_wrapHue(h + offset), s, l, alpha: alpha),
        HslColor.alt(_wrapHue(h + 180.0), s, l, alpha: alpha),
        HslColor.alt(_wrapHue(h + 180.0 + offset), s, l, alpha: alpha),
      ];

  double _wrapHue(final double hue) {
    final double mod = hue % 360.0;
    return mod < 0 ? mod + 360.0 : mod;
  }

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    // HSL is always within sRGB gamut by its definition.
    // For other gamuts, a conversion to a colorspace that can check gamut
    // would be necessary, but for sRGB, it's inherently true.
    if (gamut == Gamut.sRGB) {
      return true;
    }

    // For other gamuts, we'd need conversion. For now, we fall back.
    return toColor().isWithinGamut(gamut);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HslColor(h: ${h.toStrTrimZeros(3)}, '
      's: ${s.toStrTrimZeros(3)}, ' //
      'l: ${l.toStrTrimZeros(2)}, '
      'alpha: ${alpha.toStrTrimZeros(2)})';

  @override
  HslColor toHslColor() => this;

  @override
  ColorSlice closestColorSlice() {
    final String name = getColorNameFromHue(h);
    final int index = (h / 6).round() % 60;
    final double startAngle = index * 6.0;
    final double endAngle = (index + 1) * 6.0;
    final double centerAngle = startAngle + 3.0;

    return ColorSlice(
      color: HslColor.alt(centerAngle, 1.0, 0.5),
      startAngle: startAngle,
      endAngle: endAngle,
      name: name,
    );
  }

  @override
  double get luminance {
    final int argb = HslColor.toHexID(h, s, l, alpha: alpha);
    final int r = (argb >> 16) & 0xFF;
    final int g = (argb >> 8) & 0xFF;
    final int b = argb & 0xFF;
    return computeLuminanceViaInts(r, g, b);
  }

  @override
  double contrastWith(final ColorSpacesIQ other) {
    final double l1 = luminance;
    final double l2 = other.toLRV;
    final double lighter = max(l1, l2);
    final double darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }
}
