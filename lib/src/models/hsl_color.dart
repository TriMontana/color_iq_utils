import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

class HslColor extends ColorSpacesIQ with ColorModelsMixin {
  final double h;
  final double s;
  final double l;
  final double alpha;

  const HslColor(this.h, this.s, this.l,
      {this.alpha = 1.0, required final int hexId})
      : super(hexId);
  //   const HSLColor.fromAHSL(this.alpha, this.hue, this.saturation, this.lightness)
  //     : assert(alpha >= 0.0),
  //       assert(alpha <= 1.0),
  //       assert(hue >= 0.0),
  //       assert(hue <= 360.0),
  //       assert(saturation >= 0.0),
  //       assert(saturation <= 1.0),
  //       assert(lightness >= 0.0),
  //       assert(lightness <= 1.0);

  HslColor.alt(this.h, this.s, this.l, {this.alpha = 1.0, final int? hexId})
      : super(hexId ?? HslColor.toHex(h, s, l, alpha));

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

    final double alpha = color.a;
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
  ColorIQ toColor() {
    final double c = (1 - (2 * l - 1).abs()) * s;
    final double x = c * (1 - ((h / 60) % 2 - 1).abs());
    final double m = l - c / 2;

    double r = 0, g = 0, b = 0;
    if (h < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (h < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }

    return ColorIQ.fromARGB(
      (alpha * 255).round(),
      ((r + m) * 255).round().clamp(0, 255),
      ((g + m) * 255).round().clamp(0, 255),
      ((b + m) * 255).round().clamp(0, 255),
    );
  }

  /// Creates a 32-bit ARGB hex value from HSL values.
  ///
  /// [h] is in the range of 0.0-360.0.
  /// [s] is in the range of 0.0-1.0.
  /// [l] is in the range of 0.0-1.0.
  /// [alpha] is in the range of 0.0-1.0.
  static int toHex(
      final double h, final double s, final double l, final double alpha) {
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
  int get value => toColor().value;

  @override
  HslColor darken([final double amount = 20]) {
    return HslColor(h, s, max(0.0, l - amount / 100), alpha);
  }

  @override
  HslColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toHsl();
  }

  @override
  HslColor saturate([final double amount = 25]) {
    return HslColor(h, min(1.0, s + amount / 100), l, alpha);
  }

  @override
  HslColor desaturate([final double amount = 25]) {
    return HslColor.alt(h, max(0.0, s - amount / 100), l, alpha: alpha);
  }

  @override
  HslColor intensify([final double amount = 10]) {
    return HslColor(h, min(1.0, s + amount / 100), l, alpha);
  }

  @override
  HslColor deintensify([final double amount = 10]) {
    return HslColor.alt(h, max(0.0, s - amount / 100), l, alpha);
  }

  @override
  HslColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  HslColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsl();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

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
      alpha: lerpDouble(alpha, otherHsl.alpha, t),
    );
  }

  @override
  HslColor lighten([final double amount = 20]) {
    return HslColor.alt(h, s, min(1.0, l + amount / 100), alpha: alpha);
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HslColor fromHct(final HctColor hct) => hct.toColor().toHsl();

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
    final double? h,
    final double? s,
    final double? l,
    final double? alpha,
  }) {
    return HslColor(h ?? this.h, s ?? this.s, l ?? this.l, alpha ?? this.alpha);
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Native implementation for HSL
    final List<HslColor> results = <HslColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 0.1; // 10%
      final double newL = (l + delta).clamp(0.0, 1.0);
      results.add(HslColor(h, s, newL, alpha));
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
      results.add(HslColor(h, s, newL, alpha));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsl();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HslColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    final HslColor target = other is HslColor ? other : other.toHslColor();
    final double t = (amount / 100).clamp(0.0, 1.0).toDouble();

    return HslColor(
      lerpHueB(h, target.h, t),
      clamp01(lerpDoubleB(s, target.s, t)),
      clamp01(lerpDoubleB(l, target.l, t)),
      clamp01(lerpDoubleB(alpha, target.alpha, t)),
    );
  }

  @override
  HslColor opaquer([final double amount = 20]) {
    final double factor = (amount / 100).clamp(0.0, 1.0).toDouble();
    return HslColor.alt(h, s, l, alpha: clamp01(alpha + (1 - alpha) * factor));
  }

  @override
  HslColor adjustHue([final double amount = 20]) =>
      HslColor(_wrapHue(h + amount), s, l, alpha);

  @override
  HslColor get complementary => HslColor(_wrapHue(h + 180.0), s, l, alpha);

  @override
  HslColor warmer([final double amount = 20]) =>
      HslColor(_wrapHue(h - amount), s, l, alpha);

  @override
  HslColor cooler([final double amount = 20]) =>
      HslColor(_wrapHue(h + amount), s, l, alpha);

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
              HslColor(h, s, (l + delta).clamp(0.0, 1.0), alpha),
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
      palette.add(HslColor(_wrapHue(h + delta), s, l, alpha));
    }
    return palette;
  }

  @override
  List<HslColor> square() => List<HslColor>.generate(
        4,
        (final int index) => HslColor(_wrapHue(h + 90.0 * index), s, l, alpha),
        growable: false,
      );

  @override
  List<HslColor> tetrad({final double offset = 60}) => <HslColor>[
        HslColor(h, s, l, alpha),
        HslColor.alt(_wrapHue(h + offset), s, l, alpha: alpha),
        HslColor(_wrapHue(h + 180.0), s, l, alpha),
        HslColor(_wrapHue(h + 180.0 + offset), s, l, alpha),
      ];

  double _wrapHue(final double hue) {
    final double mod = hue % 360.0;
    return mod < 0 ? mod + 360.0 : mod;
  }

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
      'type': 'HslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'HslColor(h: ${h.toStrTrimZeros(3)}, '
      's: ${s.toStringAsFixed(2)}, l: ${l.toStrTrimZeros(2)}, '
      'alpha: ${alpha.toStringAsFixed(2)})';

  @override
  HslColor toHslColor() => this;
}
