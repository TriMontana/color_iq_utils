import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

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
/// This class provides methods to ops from and to other color spaces,
/// as well as to manipulate the color.
class YiqColor extends CommonIQ implements ColorSpacesIQ {
  /// The luma component.
  final double y;

  /// The in-phase chrominance component.
  final double i;

  /// The quadrature chrominance component.
  final double q;

  const YiqColor(this.y, this.i, this.q,
      {final int? val,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(val, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? YiqColor.hexIdFromYiq(y, i, q);

  /// Converts a 32-bit ARGB color ID (Flutter Color.value) to YIQ components.
  ///
  /// @param argb32 The 32-bit integer color ID (e.g., 0xFFRRGGBB).
  /// @returns A Yiq object containing Luminance (Y), In-phase (I), and Quadrature (Q).
  YiqColor convertArgbToYiq(final int argb32) {
    // Normalize R, G, B to the range [0.0, 1.0]
    final double r = argb32.r2;
    final double g = argb32.g2;
    final double b = argb32.b2;

    // 2. Apply the NTSC YIQ Conversion Matrix
    // [Y] = [0.299  0.587  0.114] [R]
    // [I] = [0.596 -0.274 -0.322] [G]
    // [Q] = [0.211 -0.523  0.312] [B]

    // Y (Luminance): Perceived brightness (0.0 to 1.0)
    final double y = (0.299 * r) + (0.587 * g) + (0.114 * b);

    // I (In-phase): The orange-cyan axis (approx. -0.596 to +0.596)
    final double i = (0.596 * r) - (0.274 * g) - (0.322 * b);

    // Q (Quadrature): The green-magenta axis (approx. -0.523 to +0.523)
    final double q = (0.211 * r) - (0.523 * g) + (0.312 * b);

    // 3. Return the YIQ object
    return YiqColor(
        y.clamp(0.0, 1.0), i.clamp(-0.596, 0.596), q.clamp(-0.523, 0.523));
  }

  /// Creates a 32-bit hex ARGB value from YIQ components.
  ///
  /// [y] - The luma component (0.0 to 1.0).
  /// [i] - The in-phase chrominance component (-0.5957 to 0.5957).
  /// [q] - The quadrature chrominance component (-0.5226 to 0.5226).
  static int hexIdFromYiq(final double y, final double i, final double q,
      {final Percent alpha = Percent.max}) {
    final double r = y + 0.956 * i + 0.621 * q;
    final double g = y - 0.272 * i - 0.647 * q;
    final double b = y - 1.106 * i + 1.703 * q;

    final int red = (r * 255).round().clamp(0, 255);
    final int green = (g * 255).round().clamp(0, 255);
    final int blue = (b * 255).round().clamp(0, 255);

    return (alpha.toInt0to255 << 24) | (red << 16) | (green << 8) | blue;
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  @override
  YiqColor darken([final double amount = 20]) {
    return copyWith(y: (y - amount / 100).clamp(0.0, 1.0));
  }

  @override
  YiqColor saturate([final double amount = 25]) {
    final double scale = 1.0 + (amount / 100.0);
    return YiqColor(y, i * scale, q * scale);
  }

  @override
  YiqColor desaturate([final double amount = 25]) {
    final double scale = 1.0 - (amount / 100.0);
    return YiqColor(y, i * scale, q * scale);
  }

  YiqColor intensify([final double amount = 10]) {
    return saturate(amount);
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
  YiqColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  YiqColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  YiqColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final YiqColor otherYiq =
        other is YiqColor ? other : other.toColor().toYiq();
    if (t == 1.0) return otherYiq;

    return YiqColor(
      lerpDouble(y, otherYiq.y, t),
      lerpDouble(i, otherYiq.i, t),
      lerpDouble(q, otherYiq.q, t),
    );
  }

  @override
  YiqColor lighten([final double amount = 20]) {
    return copyWith(y: (y + amount / 100).clamp(0.0, 1.0));
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  YiqColor copyWith({
    final double? y,
    final double? i,
    final double? q,
    final Percent? alpha,
  }) {
    return YiqColor(
      y ?? this.y,
      i ?? this.i,
      q ?? this.q,
      alpha: alpha ?? super.a,
    );
  }

  @override
  List<YiqColor> get monochromatic {
    final List<YiqColor> results = <YiqColor>[];
    for (int index = 0; index < 5; index++) {
      final double delta = (index - 2) * 0.1;
      final double newY = (y + delta).clamp(0.0, 1.0);
      results.add(YiqColor(newY, i, q, alpha: alpha));
    }
    return results;
  }

  @override
  List<YiqColor> lighterPalette([final double? step]) {
    final double s = (step ?? 10.0) / 100.0;
    return <YiqColor>[
      copyWith(y: (y + s).clamp(0.0, 1.0)),
      copyWith(y: (y + s * 2).clamp(0.0, 1.0)),
      copyWith(y: (y + s * 3).clamp(0.0, 1.0)),
      copyWith(y: (y + s * 4).clamp(0.0, 1.0)),
      copyWith(y: (y + s * 5).clamp(0.0, 1.0)),
    ];
  }

  @override
  List<YiqColor> darkerPalette([final double? step]) {
    final double s = (step ?? 10.0) / 100.0;
    return <YiqColor>[
      copyWith(y: (y - s).clamp(0.0, 1.0)),
      copyWith(y: (y - s * 2).clamp(0.0, 1.0)),
      copyWith(y: (y - s * 3).clamp(0.0, 1.0)),
      copyWith(y: (y - s * 4).clamp(0.0, 1.0)),
      copyWith(y: (y - s * 5).clamp(0.0, 1.0)),
    ];
  }

  @override
  YiqColor get random {
    final Random rng = Random();
    return YiqColor(
      rng.nextDouble(),
      rng.nextDouble() * 1.1914 - 0.5957,
      rng.nextDouble() * 1.0452 - 0.5226,
      alpha: alpha,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is YiqColor) {
      const double epsilon = 0.001;
      return (y - other.y).abs() < epsilon &&
          (i - other.i).abs() < epsilon &&
          (q - other.q).abs() < epsilon &&
          (alpha.val - other.alpha.val).abs() < epsilon;
    }
    return false;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  YiqColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  YiqColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  YiqColor adjustHue([final double amount = 20]) {
    final double angleRad = amount * pi / 180.0;
    final double cosA = cos(angleRad);
    final double sinA = sin(angleRad);
    final double newI = i * cosA - q * sinA;
    final double newQ = i * sinA + q * cosA;
    return YiqColor(y, newI, newQ, alpha: alpha);
  }

  @override
  YiqColor get complementary => adjustHue(180);

  @override
  YiqColor warmer([final double amount = 20]) {
    final double currentHue = atan2(q, i) * 180.0 / pi;
    const double targetHue = 30.0;
    final double delta = ((targetHue - currentHue + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return adjustHue(shift);
  }

  @override
  YiqColor cooler([final double amount = 20]) {
    final double currentHue = atan2(q, i) * 180.0 / pi;
    const double targetHue = 210.0;
    final double delta = ((targetHue - currentHue + 540) % 360) - 180;
    final double shift = delta * (amount / 100).clamp(0.0, 1.0);
    return adjustHue(shift);
  }

  @override
  List<YiqColor> generateBasicPalette() => <YiqColor>[
        copyWith(y: (y - 0.4).clamp(0.0, 1.0)),
        copyWith(y: (y - 0.2).clamp(0.0, 1.0)),
        this,
        copyWith(y: (y + 0.2).clamp(0.0, 1.0)),
        copyWith(y: (y + 0.4).clamp(0.0, 1.0)),
      ];

  @override
  List<YiqColor> tonesPalette() => List<YiqColor>.generate(
        6,
        (final int index) => copyWith(y: (index / 5).clamp(0.0, 1.0)),
      );

  @override
  List<YiqColor> analogous({final int count = 5, final double offset = 30}) {
    if (count <= 1) {
      return <YiqColor>[this];
    }
    final double center = (count - 1) / 2;
    return List<YiqColor>.generate(
      count,
      (final int index) => adjustHue((index - center) * offset),
    );
  }

  @override
  List<YiqColor> square() => List<YiqColor>.generate(
        4,
        (final int index) => adjustHue(index * 90.0),
      );

  @override
  List<YiqColor> tetrad({final double offset = 60}) => <YiqColor>[
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
    return <String, dynamic>{'type': 'YiqColor', 'y': y, 'i': i, 'q': q};
  }

  @override
  String toString() => 'YiqColor(y: ${y.toStrTrimZeros(2)}, ' //
      'i: ${i.toStringAsFixed(2)}, q: ${q.toStringAsFixed(2)})';
}
