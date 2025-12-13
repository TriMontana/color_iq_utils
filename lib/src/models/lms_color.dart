import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';

/// A representation of a color in the LMS color space.
///
/// LMS describes the response of the three types of cone photoreceptors
/// in the human eye:
/// - **L (Long):** Response to long-wavelength light (~564nm peak, red-sensitive)
/// - **M (Medium):** Response to medium-wavelength light (~534nm peak, green-sensitive)
/// - **S (Short):** Response to short-wavelength light (~420nm peak, blue-sensitive)
///
/// LMS is fundamental to:
/// - Color blindness simulation (cone deficiencies)
/// - Chromatic adaptation (white point adjustments)
/// - Perceptual color models like CAM16 and Oklab
///
/// This implementation uses the Hunt-Pointer-Estevez transformation matrix,
/// which is widely used in color appearance models.
class LmsColor extends CommonIQ implements ColorSpacesIQ {
  /// The long-wavelength cone response (red-sensitive).
  final double l;

  /// The medium-wavelength cone response (green-sensitive).
  final double m;

  /// The short-wavelength cone response (blue-sensitive).
  final double s;

  /// Creates an [LmsColor] from L, M, S cone response values.
  ///
  /// Values are typically in the range [0, 1] for colors within sRGB gamut.
  const LmsColor(
    this.l,
    this.m,
    this.s, {
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? _computeHexId();

  /// Computes ARGB from LMS values using inverse Hunt-Pointer-Estevez matrix.
  int _computeHexId() {
    // LMS to Linear RGB (inverse Hunt-Pointer-Estevez)
    final double rLin = 5.47221206 * l - 4.6419601 * m + 0.16963564 * s;
    final double gLin = -1.1252419 * l + 2.29317094 * m - 0.1678952 * s;
    final double bLin = 0.02980165 * l - 0.19318073 * m + 1.16364789 * s;

    // Linear RGB to sRGB (gamma correction)
    int gammaCorrect(double linear) {
      linear = linear.clamp(0.0, 1.0);
      final double srgb = linear <= 0.0031308
          ? 12.92 * linear
          : 1.055 * pow(linear, 1.0 / 2.4) - 0.055;
      return (srgb.clamp(0.0, 1.0) * 255).round();
    }

    final int r = gammaCorrect(rLin);
    final int g = gammaCorrect(gLin);
    final int b = gammaCorrect(bLin);
    final int a = (alpha.val * 255).round();

    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  /// Creates an [LmsColor] from an ARGB integer.
  ///
  /// Uses the Hunt-Pointer-Estevez transformation matrix for conversion
  /// from linear sRGB to LMS cone response space.
  factory LmsColor.fromInt(final int argb) {
    // Extract and linearize sRGB components
    final double r = ((argb >> 16) & 0xFF) / 255.0;
    final double g = ((argb >> 8) & 0xFF) / 255.0;
    final double b = (argb & 0xFF) / 255.0;

    // sRGB to Linear RGB (inverse gamma)
    double linearize(final double srgb) {
      return srgb <= 0.04045
          ? srgb / 12.92
          : pow((srgb + 0.055) / 1.055, 2.4).toDouble();
    }

    final double rLin = linearize(r);
    final double gLin = linearize(g);
    final double bLin = linearize(b);

    // Linear RGB to LMS (Hunt-Pointer-Estevez matrix)
    // This is the same matrix used in color blindness simulation
    final double lVal = 0.4002 * rLin + 0.7076 * gLin - 0.0808 * bLin;
    final double mVal = -0.2263 * rLin + 1.1653 * gLin + 0.0457 * bLin;
    final double sVal = 0.0 * rLin + 0.0 * gLin + 0.9182 * bLin;

    return LmsColor(
      lVal,
      mVal,
      sVal,
      hexId: argb,
      alpha: Percent(((argb >> 24) & 0xFF) / 255.0),
    );
  }

  /// Creates an [LmsColor] from another [ColorSpacesIQ] instance.
  factory LmsColor.from(final ColorSpacesIQ color) =>
      LmsColor.fromInt(color.value);

  /// Creates an [LmsColor] from XYZ color space.
  ///
  /// Uses the standard XYZ to LMS transformation for D65 illuminant.
  factory LmsColor.fromXyz(final XYZ xyz) {
    // XYZ to LMS matrix (D65 adaptation)
    final double lVal =
        0.8190224379 * xyz.x + 0.3619062600 * xyz.y - 0.1288737815 * xyz.z;
    final double mVal =
        0.0329836539 * xyz.x + 0.9292868615 * xyz.y + 0.0361446663 * xyz.z;
    final double sVal =
        0.0481771893 * xyz.x + 0.2642395317 * xyz.y + 0.6335478284 * xyz.z;

    return LmsColor(lVal / 100, mVal / 100, sVal / 100);
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Converts to XYZ color space.
  XYZ toXyz() {
    // LMS to XYZ matrix (inverse of XYZ to LMS)
    final double x = 1.2268798758 * l - 0.5578149944 * l + 0.2813910456 * s;
    final double y = -0.0405757452 * l + 1.1122868032 * m - 0.0717110580 * s;
    final double z = -0.0763729366 * l - 0.4214933324 * m + 1.5869240198 * s;

    return XYZ(x * 100, y * 100, z * 100);
  }

  @override
  LmsColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  LmsColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  LmsColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final LmsColor otherLms = other is LmsColor ? other : LmsColor.from(other);
    if (t == 1.0) return otherLms;

    return LmsColor(
      lerpDouble(l, otherLms.l, t),
      lerpDouble(m, otherLms.m, t),
      lerpDouble(s, otherLms.s, t),
    );
  }

  @override
  LmsColor lighten([final double amount = 20]) {
    final double factor = 1 + amount / 100;
    return LmsColor(
      (l * factor).clamp(0.0, 1.0),
      (m * factor).clamp(0.0, 1.0),
      (s * factor).clamp(0.0, 1.0),
    );
  }

  @override
  LmsColor darken([final double amount = 20]) {
    final double factor = 1 - amount / 100;
    return LmsColor(
      (l * factor).clamp(0.0, 1.0),
      (m * factor).clamp(0.0, 1.0),
      (s * factor).clamp(0.0, 1.0),
    );
  }

  @override
  LmsColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).lms;
  }

  @override
  LmsColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).lms;
  }

  @override
  LmsColor accented([final double amount = 15]) {
    return toColor().accented(amount).lms;
  }

  @override
  LmsColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).lms;
  }

  /// Creates a copy with the given fields replaced.
  @override
  LmsColor copyWith({
    final double? l,
    final double? m,
    final double? s,
    final Percent? alpha,
  }) {
    return LmsColor(
      l ?? this.l,
      m ?? this.m,
      s ?? this.s,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<LmsColor> get monochromatic => <LmsColor>[
        darken(20),
        darken(10),
        this,
        lighten(10),
        lighten(20),
      ];

  @override
  List<LmsColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <LmsColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<LmsColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <LmsColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  LmsColor get random {
    final Random rng = Random();
    return LmsColor(rng.nextDouble(), rng.nextDouble(), rng.nextDouble());
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is LmsColor) {
      const double epsilon = 0.001;
      return (l - other.l).abs() < epsilon &&
          (m - other.m).abs() < epsilon &&
          (s - other.s).abs() < epsilon;
    }
    return value == other.value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  LmsColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      lerp(other, amount / 100);

  @override
  LmsColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  LmsColor adjustHue([final double amount = 20]) {
    return toColor().adjustHue(amount).lms;
  }

  @override
  LmsColor get complementary => adjustHue(180);

  @override
  LmsColor warmer([final double amount = 20]) {
    return toColor().warmer(amount).lms;
  }

  @override
  LmsColor cooler([final double amount = 20]) {
    return toColor().cooler(amount).lms;
  }

  @override
  List<LmsColor> generateBasicPalette() => <LmsColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<LmsColor> tonesPalette() => List<LmsColor>.generate(
        6,
        (final int i) => copyWith(
          l: l * (1 - i * 0.15),
          m: m * (1 - i * 0.15),
          s: s * (1 - i * 0.15),
        ),
      );

  @override
  List<LmsColor> analogous({final int count = 5, final double offset = 30}) {
    return toColor()
        .hsl
        .analogous(count: count, offset: offset)
        .map((final HSL c) => c.toColor().lms)
        .toList();
  }

  @override
  List<LmsColor> square() {
    return toColor()
        .hsl
        .square()
        .map((final HSL c) => c.toColor().lms)
        .toList();
  }

  @override
  List<LmsColor> tetrad({final double offset = 60}) {
    return toColor()
        .hsl
        .tetrad(offset: offset)
        .map((final ColorSpacesIQ c) => c.toColor().lms)
        .toList();
  }

  @override
  List<LmsColor> split({final double offset = 30}) => <LmsColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<LmsColor> triad({final double offset = 120}) => <LmsColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<LmsColor> twoTone({final double offset = 60}) => <LmsColor>[
        this,
        adjustHue(offset),
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
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': 'LmsColor',
        'l': l,
        'm': m,
        's': s,
        'alpha': alpha.val,
      };

  @override
  String toString() => 'LmsColor(l: ${l.toStringAsFixed(4)}, '
      'm: ${m.toStringAsFixed(4)}, s: ${s.toStringAsFixed(4)})';
}
