import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
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

  /// Creates a [HsluvColor] from a 32-bit ARGB integer value.
  factory HsluvColor.fromInt(final int argb) {
    return ColorIQ(argb).toHsluv();
  }

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
  HsluvColor saturate([final double amount = 25]) {
    return HsluvColor(h, min(100.0, s + amount), l);
  }

  @override
  HsluvColor desaturate([final double amount = 25]) {
    return HsluvColor(h, max(0.0, s - amount), l);
  }

  @override
  HsluvColor accented([final double amount = 15]) {
    return toColor().accented(amount).toHsluv();
  }

  @override
  HsluvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsluv();
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  HsluvColor copyWith({
    final double? h,
    final double? s,
    final double? l,
    final Percent? alpha,
  }) {
    return HsluvColor(
      h ?? this.h,
      s ?? this.s,
      l ?? this.l,
      alpha: alpha ?? super.a,
    );
  }

  @override
  List<HsluvColor> get monochromatic {
    final List<HsluvColor> results = <HsluvColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 10.0;
      final double newL = (l + delta).clamp(0.0, 100.0);
      results.add(HsluvColor(h, s, newL, alpha: alpha));
    }
    return results;
  }

  @override
  List<HsluvColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <HsluvColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<HsluvColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <HsluvColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  HsluvColor get random {
    final Random rng = Random();
    return HsluvColor(
      rng.nextDouble() * 360.0,
      rng.nextDouble() * 100.0,
      rng.nextDouble() * 100.0,
      alpha: alpha,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is HsluvColor) {
      const double epsilon = 0.001;
      return (h - other.h).abs() < epsilon &&
          (s - other.s).abs() < epsilon &&
          (l - other.l).abs() < epsilon &&
          (alpha.val - other.alpha.val).abs() < epsilon;
    }
    return false;
  }

  @override
  HsluvColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HsluvColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  HsluvColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return HsluvColor(newHue, s, l);
  }

  @override
  HsluvColor get complementary => adjustHue(180);

  @override
  HsluvColor warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    final double delta = ((targetHue - h + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return adjustHue(shift);
  }

  @override
  HsluvColor cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    final double delta = ((targetHue - h + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return adjustHue(shift);
  }

  @override
  List<HsluvColor> generateBasicPalette() => <HsluvColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<HsluvColor> tonesPalette() => List<HsluvColor>.generate(
        6,
        (final int index) => copyWith(l: (index / 5 * 100).clamp(0.0, 100.0)),
      );

  @override
  List<HsluvColor> analogous({final int count = 5, final double offset = 30}) {
    if (count <= 1) {
      return <HsluvColor>[this];
    }
    final double center = (count - 1) / 2;
    return List<HsluvColor>.generate(
      count,
      (final int index) => adjustHue((index - center) * offset),
    );
  }

  @override
  List<HsluvColor> square() => List<HsluvColor>.generate(
        4,
        (final int index) => adjustHue(index * 90.0),
      );

  @override
  List<HsluvColor> tetrad({final double offset = 60}) => <HsluvColor>[
        this,
        adjustHue(offset),
        adjustHue(180),
        adjustHue(180 + offset),
      ];

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

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
