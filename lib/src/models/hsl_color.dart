import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/models/argb_color.dart';
import 'package:material_color_utilities/hct/cam16.dart';

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
class HSL extends CommonIQ implements ColorSpacesIQ, ColorWheelInf {
  /// The hue value, ranging from 0.0 to 360.0.
  final double h;

  /// The saturation value, ranging from 0.0 to 1.0.
  final double s;

  /// The lightness value, ranging from 0.0 to 1.0.
  final double l;

  /// The luminance of this color, LRV rating, 0.0 to 1.0
  final Percent? lrv;

  final int? colorIdHsl;

  /// Creates an HSL color and calculates the `hexId` automatically.
  ///
  /// This is a convenience constructor that calculates the integer hex value
  /// from the provided HSL and alpha values.
  const HSL(this.h, this.s, this.l,
      {final Percent alpha = Percent.max,
      final int? hexId,
      this.lrv,
      final List<String>? names})
      : colorIdHsl = hexId,
        super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? HSL.hexIdFromHSL(h, s, l, alpha: alpha);

  /// Creates an [HSL] from an RGB [Color].
  ///
  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  factory HSL.fromInt(final int color) {
    return HSL.fromRgbValues(
        r: color.r, g: color.g, b: color.b, alpha: color.a2);
  }

  @override
  int get hexId => colorIdHsl ?? HSL.hexIdFromHSL(h, s, l, alpha: alpha);

  /// Creates an [HSL] from an RGB [Color].
  ///
  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating point imprecision.
  static HSL fromRgbValues({
    required final double r,
    required final double g,
    required final double b,
    final Percent alpha = Percent.max,
  }) {
    final double max = math.max(r, math.max(g, b));
    final double min = math.min(r, math.min(g, b));
    final double delta = max - min;

    final double hue = getHue(r, g, b, max, delta);
    final double lightness = (max + min) / 2.0;
    // Saturation can exceed 1.0 with rounding errors, so clamp it.
    final double saturation = min == max
        ? 0.0
        : clampDouble(
            delta / (1.0 - (2.0 * lightness - 1.0).abs()),
            min: 0.0,
            max: 1.0,
          );
    return HSL(hue, saturation, lightness, alpha: alpha);
  }

  /// Creates a 32-bit ARGB hex value from HSL values.
  ///
  /// [h] is in the range of 0.0-360.0.
  /// [s] is in the range of 0.0-1.0.
  /// [l] is in the range of 0.0-1.0.
  /// [alpha] is in the range of 0.0-1.0.
  static int hexIdFromHSL(
    final double h,
    final double s,
    final double l, {
    final Percent alpha = Percent.max,
  }) {
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

    return ColorIQ.fromArgbInts(
      (alpha * 255).round(),
      ((r + m) * 255).round().clamp(0, 255),
      ((g + m) * 255).round().clamp(0, 255),
      ((b + m) * 255).round().clamp(0, 255),
    ).value;
  }

  /// Converts ARGB to HSL.
  static HSL fromARGB(final AppColor color) {
    return HSL.fromRgbValues(
        r: color.r, g: color.g, b: color.b, alpha: color.a);
  }

  static HSL fromColor(final ColorIQ color) {
    final AppColor argb = color.argb;
    return HSL.fromARGB(argb);
  }

  @override
  HSL darken([final double amount = 20]) =>
      copyWith(saturation: max(0.0, l - amount / 100));

  @override
  HSL brighten([final double amount = 20]) =>
      copyWith(lightness: Percent(min(1.0, l + amount / 100)));

  @override
  HSL saturate([final double amount = 25]) =>
      copyWith(saturation: min(1.0, s + amount / 100));

  /// Increases the transparency of a color by moving the Alpha channel closer to 0.
  /// Maximum Transparency (fully invisible) = Alpha 0x00 (0)
  /// Minimum Transparency (fully opaque) = Alpha 0xFF (255)
  @override
  HSL increaseTransparency([final Percent amount = Percent.v20]) =>
      copyWith(alpha: a.decreaseBy(amount));

  @override
  HSL desaturate([final double amount = 25]) =>
      copyWith(saturation: max(0.0, s - amount / 100));

  HSL intensify([final double amount = 10]) =>
      copyWith(saturation: min(1.0, s + amount / 100));

  HSL deintensify([final double amount = 10]) =>
      copyWith(saturation: max(0.0, s - amount / 100));

  @override
  HSL accented([final double amount = 15]) => intensify(amount);

  @override
  HSL simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).hsl;
  }

  HSL get fippedHue => flipHue();

  /// Flip the hue by 180 degrees.
  HSL flipHue() => copyWith(hue: _wrapHue(h + 180));

  HSL get grayscale => copyWith(saturation: Percent.zero);

  @override
  HSL whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HSL blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HSL lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HSL otherHsl = other is HSL ? other : other.toColor().hsl;
    if (t == 1.0) {
      return otherHsl;
    }

    return HSL(
      lerpHue(h, otherHsl.h, t),
      lerpDouble(s, otherHsl.s, t),
      lerpDouble(l, otherHsl.l, t),
    );
  }

  @override
  HSL lighten([final double amount = 20]) =>
      copyWith(lightness: Percent(min(1.0, l + amount / 100)));

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
  HSL copyWith({
    final double? hue,
    final double? saturation,
    final Percent? lightness,
    final Percent? alpha,
    final Percent? lrv,
  }) {
    return HSL(hue ?? h, saturation ?? s, lightness ?? l,
        alpha: alpha ?? a, lrv: lrv);
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Native implementation for HSL
    final List<HSL> results = <HSL>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 0.1; // 10%
      final double newL = (l + delta).clamp(0.0, 1.0);
      results.add(copyWith(lightness: Percent(newL)));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<HSL> results = <HSL>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = (1.0 - l) / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      final Percent newL = Percent((l + delta * i).clamp(0.0, 1.0));
      results.add(copyWith(lightness: newL));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<HSL> results = <HSL>[];
    double delta;
    if (step != null) {
      delta = step / 100.0;
    } else {
      delta = l / 6.0;
    }

    for (int i = 1; i <= 5; i++) {
      final Percent newL = Percent((l - delta * i).clamp(0.0, 1.0));
      results.add(copyWith(lightness: newL));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).hsl;

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  HSL blend(final ColorSpacesIQ other, [final double amount = 50]) {
    final HSL target = other is HSL ? other : other.toHslColor();
    final double t = (amount / 100).clamp(0.0, 1.0).toDouble();

    return HSL(
      lerpHueB(h, target.h, t),
      clamp01(lerpDoubleB(s, target.s, t)),
      clamp01(lerpDoubleB(l, target.l, t)),
      alpha: Percent(clamp01(lerpDoubleB(alpha.val, target.alpha.val, t))),
    );
  }

  @override
  HSL opaquer([final double amount = 20]) {
    final double factor = (amount / 100).clamp(0.0, 1.0).toDouble();
    return HSL(h, s, l,
        alpha: Percent(clamp01(alpha.value + (1 - alpha.value) * factor)));
  }

  @override
  HSL adjustHue([final double amount = 20]) =>
      copyWith(hue: _wrapHue(h + amount));

  @override
  HSL get complementary => copyWith(hue: _wrapHue(h + 180.0));

  @override
  HSL warmer([final double amount = 20]) => copyWith(hue: _wrapHue(h - amount));

  @override
  HSL cooler([final double amount = 20]) => copyWith(hue: _wrapHue(h + amount));

  @override
  List<HSL> generateBasicPalette() {
    const List<double> saturationOffsets = <double>[-0.2, -0.1, 0.0, 0.1, 0.2];
    const List<double> lightnessOffsets = <double>[-0.2, -0.1, 0.0, 0.1, 0.2];

    return List<HSL>.generate(saturationOffsets.length, (final int index) {
      return HSL(
        h,
        clamp01(s + saturationOffsets[index]),
        clamp01(l + lightnessOffsets[index]),
        alpha: a,
      );
    });
  }

  @override
  List<HSL> tonesPalette() {
    const List<double> toneOffsets = <double>[-0.3, -0.15, 0.0, 0.15, 0.3];
    return toneOffsets
        .map(
          (final double delta) =>
              copyWith(lightness: Percent((l + delta).clamp(0.0, 1.0))),
        )
        .toList();
  }

  @override
  List<HSL> analogous({final int count = 5, final double offset = 30}) {
    if (count <= 0) {
      return <HSL>[];
    }
    final List<HSL> palette = <HSL>[];
    final double pivot = (count - 1) / 2;
    for (int i = 0; i < count; i++) {
      final double delta = (i - pivot) * offset;
      palette.add(copyWith(hue: _wrapHue(h + delta)));
    }
    return palette;
  }

  @override
  List<HSL> square() => List<HSL>.generate(
        4,
        (final int index) => copyWith(hue: _wrapHue(h + 90.0 * index)),
        growable: false,
      );

  @override
  List<HSL> tetrad({final double offset = 60}) => <HSL>[
        HSL(h, s, l, alpha: alpha),
        copyWith(hue: _wrapHue(h + offset)),
        copyWith(hue: _wrapHue(h + 180.0)),
        HSL(_wrapHue(h + 180.0 + offset), s, l, alpha: alpha),
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
      'alpha': a,
    };
  }

  @override
  String toString() => 'HslColor(h: ${h.toStrTrimZeros(3)}, '
      's: ${s.toStrTrimZeros(3)}, ' //
      'l: ${l.toStrTrimZeros(2)}, '
      'a: ${a.toStrTrimZeros(2)})';

  @override
  HSL toHslColor() => this;

  @override
  ColorSlice closestColorSlice() {
    final List<String> names = getColorNameFromHue(h);
    final int index = (h / 6).round() % 60;
    final double startAngle = index * 6.0;
    final double endAngle = (index + 1) * 6.0;
    final double centerAngle = startAngle + 3.0;

    return ColorSlice(
      color: HSL(centerAngle, 1.0, 0.5),
      startAngle: startAngle,
      endAngle: endAngle,
      name: names,
    );
  }

  @override
  double get luminance {
    final int argb = HSL.hexIdFromHSL(h, s, l, alpha: alpha);
    final int r = (argb >> 16) & 0xFF;
    final int g = (argb >> 8) & 0xFF;
    final int b = argb & 0xFF;
    return computeLuminanceViaInts(r, g, b);
  }

  @override
  double contrastWith(final ColorSpacesIQ other) {
    final double l1 = luminance;
    final double l2 = other.luminance;
    final double lighter = max(l1, l2);
    final double darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  @override
  Cam16 get cam16 => Cam16.fromInt(value);
}
