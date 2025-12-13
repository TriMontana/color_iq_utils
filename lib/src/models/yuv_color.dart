import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

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
/// [YuvColor] provides methods to ops to and from other color spaces,
/// and to perform various color manipulations.
class YuvColor extends CommonIQ implements ColorSpacesIQ {
  /// The luma component (brightness).
  ///
  /// Ranges from 0.0 to 1.0.
  final double y;

  /// The chrominance U component (blue projection).
  final double u;

  /// The chrominance V component (red projection).
  final double v;

  const YuvColor(this.y, this.u, this.v,
      {final int? val,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(val, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? YuvColor.hexIdFromYUV(y, u, v);

  /// Creates a [YuvColor] instance from a 32-bit ARGB value.
  factory YuvColor.fromInt(final int argb) {
    final int red = (argb >> 16) & 0xFF;
    final int green = (argb >> 8) & 0xFF;
    final int blue = argb & 0xFF;

    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double y = 0.299 * r + 0.587 * g + 0.114 * b;
    return YuvColor(
      y,
      -0.14713 * r - 0.28886 * g + 0.436 * b,
      0.615 * r - 0.51499 * g - 0.10001 * b,
      val: argb,
    );
  }

  /// Creates a [YuvColor] instance from a 32-bit hex value.
  factory YuvColor.fromHexId(final int hex) {
    final int green = (hex >> 8) & 0xFF;
    final int blue = hex & 0xFF;

    final double r = hex.r;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double y = 0.299 * r + 0.587 * g + 0.114 * b;
    return YuvColor(y, -0.14713 * r - 0.28886 * g + 0.436 * b,
        0.615 * r - 0.51499 * g - 0.10001 * b,
        val: hex);
  }

  /// Creates a 32-bit ARGB hex value from [y], [u], and [v] components.
  ///
  /// The alpha value is set to 255 (fully opaque).
  static int hexIdFromYUV(final double y, final double u, final double v) {
    final double r = y + 1.13983 * v;
    final double g = y - 0.39465 * u - 0.58060 * v;
    final double b = y + 2.03211 * u;

    final int red = (r * 255).round().clamp(0, 255);
    final int green = (g * 255).round().clamp(0, 255);
    final int blue = (b * 255).round().clamp(0, 255);

    return (255 << 24) | (red << 16) | (green << 8) | blue;
  }

  @override
  ColorIQ toColor() => ColorIQ(hexIdFromYUV(y, u, v));

  @override
  YuvColor darken([final double amount = 20]) {
    return YuvColor(max(0.0, y - amount / 100), u, v);
  }

  @override
  YuvColor brighten([final double amount = 20]) {
    return YuvColor(min(1.0, y + amount / 100), u, v);
  }

  @override
  YuvColor saturate([final double amount = 25]) {
    final double factor = 1 + (amount / 100);
    return YuvColor(y, u * factor, v * factor);
  }

  @override
  YuvColor desaturate([final double amount = 25]) {
    final double factor = max(0.0, 1 - (amount / 100));
    return YuvColor(y, u * factor, v * factor);
  }

  YuvColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

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
    return YuvColor(min(1.0, y + amount / 100), u, v);
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  YuvColor copyWith({
    final double? y,
    final double? u,
    final double? v,
    final Percent? alpha,
  }) {
    return YuvColor(
      y ?? this.y,
      u ?? this.u,
      v ?? this.v,
      alpha: alpha ?? super.a,
    );
  }

  @override
  List<YuvColor> get monochromatic {
    final List<YuvColor> results = <YuvColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 0.1;
      final double newY = (y + delta).clamp(0.0, 1.0);
      results.add(YuvColor(newY, u, v, alpha: alpha));
    }
    return results;
  }

  @override
  List<YuvColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <YuvColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<YuvColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <YuvColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  YuvColor get random {
    final Random rng = Random();
    return YuvColor(
      rng.nextDouble(),
      rng.nextDouble() * 0.872 - 0.436,
      rng.nextDouble() * 1.230 - 0.615,
      alpha: alpha,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is YuvColor) {
      const double epsilon = 0.001;
      return (y - other.y).abs() < epsilon &&
          (u - other.u).abs() < epsilon &&
          (v - other.v).abs() < epsilon &&
          (alpha.val - other.alpha.val).abs() < epsilon;
    }
    return false;
  }

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  YuvColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  YuvColor opaquer([final double amount = 20]) {
    return this;
  }

  @override
  YuvColor adjustHue([final double amount = 20]) {
    final double angleRad = amount * pi / 180.0;
    final double cosA = cos(angleRad);
    final double sinA = sin(angleRad);
    final double newU = u * cosA - v * sinA;
    final double newV = u * sinA + v * cosA;
    return YuvColor(y, newU, newV, alpha: alpha);
  }

  @override
  YuvColor get complementary => adjustHue(180);

  @override
  YuvColor warmer([final double amount = 20]) {
    final double currentHue = atan2(v, u) * 180.0 / pi;
    const double targetHue = 30.0;
    final double delta = ((targetHue - currentHue + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return adjustHue(shift);
  }

  @override
  YuvColor cooler([final double amount = 20]) {
    final double currentHue = atan2(v, u) * 180.0 / pi;
    const double targetHue = 210.0;
    final double delta = ((targetHue - currentHue + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return adjustHue(shift);
  }

  @override
  List<YuvColor> generateBasicPalette() => <YuvColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<YuvColor> tonesPalette() => List<YuvColor>.generate(
        6,
        (final int index) => copyWith(y: (index / 5).clamp(0.0, 1.0)),
      );

  @override
  List<YuvColor> analogous({final int count = 5, final double offset = 30}) {
    if (count <= 1) {
      return <YuvColor>[this];
    }
    final double center = (count - 1) / 2;
    return List<YuvColor>.generate(
      count,
      (final int index) => adjustHue((index - center) * offset),
    );
  }

  @override
  List<YuvColor> square() => List<YuvColor>.generate(
        4,
        (final int index) => adjustHue(index * 90.0),
      );

  @override
  List<YuvColor> tetrad({final double offset = 60}) => <YuvColor>[
        this,
        adjustHue(offset),
        adjustHue(180),
        adjustHue(180 + offset),
      ];

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
