import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';

/// The YCbCr standard to use for conversion.
///
/// Different standards use different coefficients for the luma/chroma separation.
/// - **bt601:** Standard-definition TV (ITU-R BT.601)
/// - **bt709:** High-definition TV and sRGB (ITU-R BT.709) - DEFAULT
/// - **bt2020:** Ultra-high-definition TV (ITU-R BT.2020)
enum YCbCrStandard {
  /// SD video (ITU-R BT.601) - used in DVD, SD broadcast
  bt601,

  /// HD video and sRGB (ITU-R BT.709) - used in Blu-ray, HD broadcast, web
  bt709,

  /// UHD/4K/8K video (ITU-R BT.2020) - used in HDR content
  bt2020,
}

/// A representation of a color in the YCbCr color space.
///
/// YCbCr separates image luminance (Y) from chrominance (Cb, Cr), making it
/// ideal for video compression and image processing. It's used in:
/// - **JPEG compression**
/// - **MPEG video encoding**
/// - **TV broadcasting (HD, UHD)**
///
/// Components:
/// - **Y (Luma):** The brightness/luminance, ranging 0-1 (full range) or 16-235 (video range)
/// - **Cb (Chroma-Blue):** Blue difference, ranging -0.5 to 0.5
/// - **Cr (Chroma-Red):** Red difference, ranging -0.5 to 0.5
///
/// This implementation uses full-range (0-1) values internally.
class YCbCrColor extends CommonIQ implements ColorSpacesIQ {
  /// The luma (brightness) component, ranging 0.0 to 1.0.
  final double y;

  /// The chroma-blue component, ranging -0.5 to 0.5.
  final double cb;

  /// The chroma-red component, ranging -0.5 to 0.5.
  final double cr;

  /// The YCbCr standard used for this color.
  final YCbCrStandard standard;

  /// Creates a [YCbCrColor] from Y, Cb, Cr components.
  ///
  /// - [y]: Luma (brightness), 0.0 to 1.0
  /// - [cb]: Chroma-blue, -0.5 to 0.5
  /// - [cr]: Chroma-red, -0.5 to 0.5
  /// - [standard]: The YCbCr standard to use (default: BT.709)
  const YCbCrColor(
    this.y,
    this.cb,
    this.cr, {
    this.standard = YCbCrStandard.bt709,
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? _computeHexId();

  /// Gets the conversion coefficients for the specified standard.
  static ({double kr, double kg, double kb}) _getCoefficients(
      final YCbCrStandard std) {
    switch (std) {
      case YCbCrStandard.bt601:
        return (kr: 0.299, kg: 0.587, kb: 0.114);
      case YCbCrStandard.bt709:
        return (kr: 0.2126, kg: 0.7152, kb: 0.0722);
      case YCbCrStandard.bt2020:
        return (kr: 0.2627, kg: 0.6780, kb: 0.0593);
    }
  }

  /// Computes ARGB from YCbCr values.
  int _computeHexId() {
    final ({double kb, double kg, double kr}) coef = _getCoefficients(standard);

    // YCbCr to RGB conversion
    // R = Y + Cr * (2 - 2 * Kr)
    // G = Y - Cb * (Kb / Kg) * (2 - 2 * Kb) - Cr * (Kr / Kg) * (2 - 2 * Kr)
    // B = Y + Cb * (2 - 2 * Kb)
    final double r = y + cr * (2 - 2 * coef.kr);
    final double g = y -
        cb * (coef.kb / coef.kg) * (2 - 2 * coef.kb) -
        cr * (coef.kr / coef.kg) * (2 - 2 * coef.kr);
    final double b = y + cb * (2 - 2 * coef.kb);

    final int rInt = (r.clamp(0.0, 1.0) * 255).round();
    final int gInt = (g.clamp(0.0, 1.0) * 255).round();
    final int bInt = (b.clamp(0.0, 1.0) * 255).round();
    final int aInt = (alpha.val * 255).round();

    return (aInt << 24) | (rInt << 16) | (gInt << 8) | bInt;
  }

  /// Creates a [YCbCrColor] from an ARGB integer.
  ///
  /// Uses the specified [standard] for conversion (default: BT.709).
  factory YCbCrColor.fromInt(
    final int argb, {
    final YCbCrStandard standard = YCbCrStandard.bt709,
  }) {
    final double r = ((argb >> 16) & 0xFF) / 255.0;
    final double g = ((argb >> 8) & 0xFF) / 255.0;
    final double b = (argb & 0xFF) / 255.0;
    final Percent alpha = Percent(((argb >> 24) & 0xFF) / 255.0);

    final ({double kb, double kg, double kr}) coef = _getCoefficients(standard);

    // RGB to YCbCr conversion
    // Y = Kr * R + Kg * G + Kb * B
    // Cb = (B - Y) / (2 - 2 * Kb)
    // Cr = (R - Y) / (2 - 2 * Kr)
    final double yVal = coef.kr * r + coef.kg * g + coef.kb * b;
    final double cbVal = (b - yVal) / (2 - 2 * coef.kb);
    final double crVal = (r - yVal) / (2 - 2 * coef.kr);

    return YCbCrColor(
      yVal,
      cbVal,
      crVal,
      standard: standard,
      hexId: argb,
      alpha: alpha,
    );
  }

  /// Creates a [YCbCrColor] from another [ColorSpacesIQ] instance.
  factory YCbCrColor.from(
    final ColorSpacesIQ color, {
    final YCbCrStandard standard = YCbCrStandard.bt709,
  }) =>
      YCbCrColor.fromInt(color.value, standard: standard);

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Converts this YCbCr color to a different standard.
  YCbCrColor toStandard(final YCbCrStandard newStandard) {
    if (newStandard == standard) return this;
    return YCbCrColor.fromInt(value, standard: newStandard);
  }

  @override
  YCbCrColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  YCbCrColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  YCbCrColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final YCbCrColor otherYCbCr = other is YCbCrColor
        ? other
        : YCbCrColor.from(other, standard: standard);
    if (t == 1.0) return otherYCbCr;

    return YCbCrColor(
      lerpDouble(y, otherYCbCr.y, t),
      lerpDouble(cb, otherYCbCr.cb, t),
      lerpDouble(cr, otherYCbCr.cr, t),
      standard: standard,
    );
  }

  @override
  YCbCrColor lighten([final double amount = 20]) {
    return copyWith(y: (y + amount / 100).clamp(0.0, 1.0));
  }

  @override
  YCbCrColor darken([final double amount = 20]) {
    return copyWith(y: (y - amount / 100).clamp(0.0, 1.0));
  }

  @override
  YCbCrColor saturate([final double amount = 25]) {
    // Increase chroma by scaling Cb and Cr
    final double factor = 1 + amount / 100;
    return copyWith(
      cb: (cb * factor).clamp(-0.5, 0.5),
      cr: (cr * factor).clamp(-0.5, 0.5),
    );
  }

  @override
  YCbCrColor desaturate([final double amount = 25]) {
    // Decrease chroma by scaling Cb and Cr towards zero
    final double factor = 1 - amount / 100;
    return copyWith(
      cb: cb * factor.clamp(0.0, 1.0),
      cr: cr * factor.clamp(0.0, 1.0),
    );
  }

  @override
  YCbCrColor accented([final double amount = 15]) {
    return toColor().accented(amount).ycbcr;
  }

  @override
  YCbCrColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).ycbcr;
  }

  /// Creates a copy with the given fields replaced.
  @override
  YCbCrColor copyWith({
    final double? y,
    final double? cb,
    final double? cr,
    final YCbCrStandard? standard,
    final Percent? alpha,
  }) {
    return YCbCrColor(
      y ?? this.y,
      cb ?? this.cb,
      cr ?? this.cr,
      standard: standard ?? this.standard,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<YCbCrColor> get monochromatic => <YCbCrColor>[
        darken(20),
        darken(10),
        this,
        lighten(10),
        lighten(20),
      ];

  @override
  List<YCbCrColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <YCbCrColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<YCbCrColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <YCbCrColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  YCbCrColor get random {
    final Random rng = Random();
    return YCbCrColor(
      rng.nextDouble(),
      rng.nextDouble() - 0.5,
      rng.nextDouble() - 0.5,
      standard: standard,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is YCbCrColor) {
      const double epsilon = 0.001;
      return (y - other.y).abs() < epsilon &&
          (cb - other.cb).abs() < epsilon &&
          (cr - other.cr).abs() < epsilon &&
          standard == other.standard;
    }
    return value == other.value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  YCbCrColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      lerp(other, amount / 100);

  @override
  YCbCrColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  YCbCrColor adjustHue([final double amount = 20]) {
    return toColor().adjustHue(amount).ycbcr;
  }

  @override
  YCbCrColor get complementary => adjustHue(180);

  @override
  YCbCrColor warmer([final double amount = 20]) {
    return toColor().warmer(amount).ycbcr;
  }

  @override
  YCbCrColor cooler([final double amount = 20]) {
    return toColor().cooler(amount).ycbcr;
  }

  @override
  List<YCbCrColor> generateBasicPalette() => <YCbCrColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<YCbCrColor> tonesPalette() => <YCbCrColor>[
        this,
        desaturate(15),
        desaturate(30),
        desaturate(45),
        desaturate(60),
      ];

  @override
  List<YCbCrColor> analogous({final int count = 5, final double offset = 30}) {
    return toColor()
        .hsl
        .analogous(count: count, offset: offset)
        .map((final HSL c) => c.toColor().ycbcr)
        .toList();
  }

  @override
  List<YCbCrColor> square() {
    return toColor()
        .hsl
        .square()
        .map((final HSL c) => c.toColor().ycbcr)
        .toList();
  }

  @override
  List<YCbCrColor> tetrad({final double offset = 60}) {
    return toColor()
        .hsl
        .tetrad(offset: offset)
        .map((final ColorSpacesIQ c) => c.toColor().ycbcr)
        .toList();
  }

  @override
  List<YCbCrColor> split({final double offset = 30}) => <YCbCrColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<YCbCrColor> triad({final double offset = 120}) => <YCbCrColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<YCbCrColor> twoTone({final double offset = 60}) => <YCbCrColor>[
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
        'type': 'YCbCrColor',
        'y': y,
        'cb': cb,
        'cr': cr,
        'standard': standard.name,
        'alpha': alpha.val,
      };

  @override
  String toString() => 'YCbCrColor(y: ${y.toStringAsFixed(3)}, '
      'cb: ${cb.toStringAsFixed(3)}, cr: ${cr.toStringAsFixed(3)}, '
      'standard: ${standard.name})';
}
