import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/ok_hsl_color.dart';
import 'package:color_iq_utils/src/models/ok_hsv_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';

/// A representation of a color in the Oklab color space.
///
/// The Oklab color space is a perceptually uniform color space designed
/// for tasks like color picking, color gradients, and image processing.
/// It aims to represent colors in a way that aligns more closely with human
/// perception of color differences.
///
/// [l] represents lightness (from 0 to 1, where 0 is black and 1 is white).
/// [aLab] represents the green-red axis.
/// [bLab] represents the blue-yellow axis.
/// [alpha] represents the opacity (from 0.0 for transparent to 1.0 for opaque).
class OkLabColor extends CommonIQ implements ColorSpacesIQ {
  /// The lightness component of the color, ranging from 0.0 (black) to 1.0 (white).
  final double l;

  /// The 'a' component of the color, representing the green-red axis.
  final double aLab;

  /// The 'b' component of the color, representing the blue-yellow axis.
  final double bLab;

  /// Creates an [OkLabColor].
  ///
  /// - [l]: Lightness, must be between 0.0 and 1.0.
  /// - [a]: Green-red component.
  /// - [b]: Blue-yellow component.
  /// - [alpha]: Opacity, defaults to 1.0 (fully opaque).
  const OkLabColor(this.l, this.aLab, this.bLab,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String>? names})
      : assert(l >= 0 && l <= 1, 'L must be between 0 and 1, but was $l'),
        assert(aLab >= -1 && aLab <= 1,
            'A must be between -1 and 1, but was $aLab'),
        assert(bLab >= -1 && bLab <= 1,
            'B must be between -1 and 1, but was $bLab'),
        super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value =>
      super.colorId ?? OkLabColor.hexIdFromOkLAB(l, aLab, bLab, alpha: alpha);

  /// A stand-alone static method to create a 32-bit hexID/ARGB from this
  /// class's properties.
  static int hexIdFromOkLAB(final double l, final double a, final double b,
      {final Percent alpha = Percent.max}) {
    final LmsPrime lmsPrime = labToLmsPrime(l, a, b);

    double r = 4.0767416621 * lmsPrime.lPrime -
        3.3077115913 * lmsPrime.mPrime +
        0.2309699292 * lmsPrime.sPrime;
    double g = -1.2684380046 * lmsPrime.lPrime +
        2.6097574011 * lmsPrime.mPrime -
        0.3413193965 * lmsPrime.sPrime;
    double bVal = -0.0041960863 * lmsPrime.lPrime -
        0.7034186147 * lmsPrime.mPrime +
        1.7076147010 * lmsPrime.sPrime;

    r = r.clamp(0.0, 1.0).delinearize;
    g = g.clamp(0.0, 1.0).delinearize;
    bVal = bVal.clamp(0.0, 1.0);
    bVal = (bVal > 0.0031308)
        ? (1.055 * pow(bVal, 1 / 2.4) - 0.055)
        : (12.92 * bVal);

    final int alphaInt = (alpha.val * 255).round();
    final int redInt = (r * 255).round().clamp(0, 255);
    final int greenInt = (g * 255).round().clamp(0, 255);
    final int blueInt = (bVal * 255).round().clamp(0, 255);

    return (alphaInt << 24) | (redInt << 16) | (greenInt << 8) | (blueInt << 0);
  }

  /// Creates an [OkLabColor] from an ARGB integer.
  ///
  /// - [argb]: An integer representing the color in ARGB format.
  factory OkLabColor.fromInt(final int argb) {
    final Percent alpha = argb.a2;

    // sRGB to Linear sRGB
    final LinRGB lr = argb.redLinearized;
    final LinRGB lg = argb.greenLinearized;
    final LinRGB lb = argb.blueLinearized;

    final LmsPrime lmsPrime = linearRgbToLmsPrime(lr, lg, lb);

    final double labL = 0.2104542553 * lmsPrime.lPrime +
        0.7936177850 * lmsPrime.mPrime -
        0.0040720468 * lmsPrime.sPrime;
    final double labA = 1.9779984951 * lmsPrime.lPrime -
        2.4285922050 * lmsPrime.mPrime +
        0.4505937099 * lmsPrime.sPrime;
    final double labB = 0.0259040371 * lmsPrime.lPrime +
        0.7827717662 * lmsPrime.mPrime -
        0.8086757660 * lmsPrime.sPrime;

    return OkLabColor(labL, labA, labB, alpha: alpha);
  }

  /// Creates an [OkLabColor] from another [ColorSpacesIQ] instance.
  /// This is a convenience factory that converts any color model that implements
  /// [ColorSpacesIQ] into an [OkLabColor].
  factory OkLabColor.from(final ColorSpacesIQ color) =>
      OkLabColor.fromInt(color.value);

  @override
  ColorIQ toColor() {
    final int argb = OkLabColor.hexIdFromOkLAB(l, aLab, bLab, alpha: alpha);
    return ColorIQ(argb);
  }

  @override
  OkLCH toOkLch() {
    final double c = sqrt(aLab * aLab + bLab * bLab);
    double h = atan2(bLab, aLab);
    h = h * 180 / pi;
    if (h < 0) {
      h += 360;
    }
    return OkLCH(Percent(l), c, h, alpha: alpha);
  }

  OkHslColor toOkHsl() {
    final OkLCH lch = toOkLch();
    double s = (lch.l.val == 0 || lch.l.val == 1) ? 0 : lch.c / 0.4;
    if (s > 1) s = 1;
    return OkHslColor(
      lch.h,
      s,
      lch.l,
      alpha: alpha,
    ); // OkHslColor doesn't have alpha in constructor yet? Wait, I fixed it.
    // Wait, OkHslColor constructor is (h, s, l, [alpha]).
    // So I should pass alpha.
  }

  OkHsvColor toOkHsv() {
    final OkLCH lch = toOkLch();
    double v = lch.l.val + lch.c / 0.4;
    if (v > 1) {
      v = 1;
    }
    double s = (v == 0) ? 0 : (lch.c / 0.4) / v;
    if (s > 1) {
      s = 1;
    }
    return OkHsvColor(lch.h, s, v, alpha: alpha);
  }

  @override
  OkLabColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  OkLabColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  OkLabColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final OkLabColor otherLab =
        other is OkLabColor ? other : other.toColor().toOkLab();
    if (t == 1.0) return otherLab;

    return OkLabColor(
      lerpDouble(l, otherLab.l, t),
      lerpDouble(aLab, otherLab.aLab, t),
      lerpDouble(bLab, otherLab.bLab, t),
    );
  }

  @override
  OkLabColor lighten([final double amount = 20]) {
    return copyWith(l: min(1.0, l + amount / 100));
  }

  @override
  OkLabColor darken([final double amount = 20]) {
    return OkLabColor(max(0.0, l - amount / 100), aLab, bLab, alpha: alpha);
  }

  @override
  OkLabColor saturate([final double amount = 25]) {
    return (toOkLch().saturate(amount)).toOkLab();
  }

  @override
  OkLabColor desaturate([final double amount = 25]) {
    return (toOkLch().desaturate(amount)).toOkLab();
  }

  @override
  OkLabColor accented([final double amount = 15]) {
    return toColor().accented(amount).toOkLab();
  }

  @override
  OkLabColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkLab();
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  OkLabColor copyWith({
    final double? l,
    final double? a,
    final double? b,
    final Percent? alpha,
  }) {
    return OkLabColor(
      l ?? this.l,
      a ?? aLab,
      b ?? bLab,
      alpha: alpha ?? super.a,
    );
  }

  @override
  List<OkLabColor> get monochromatic {
    final List<OkLabColor> results = <OkLabColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 0.1;
      final double newL = (l + delta).clamp(0.0, 1.0);
      results.add(OkLabColor(newL, aLab, bLab, alpha: alpha));
    }
    return results;
  }

  @override
  List<OkLabColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <OkLabColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<OkLabColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <OkLabColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  OkLabColor get random {
    final Random rng = Random();
    return OkLabColor(
      rng.nextDouble(),
      rng.nextDouble() * 2 - 1,
      rng.nextDouble() * 2 - 1,
      alpha: alpha,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is OkLabColor) {
      const double epsilon = 0.001;
      return (l - other.l).abs() < epsilon &&
          (aLab - other.aLab).abs() < epsilon &&
          (bLab - other.bLab).abs() < epsilon &&
          (alpha.val - other.alpha.val).abs() < epsilon;
    }
    return false;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  OkLabColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  OkLabColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  OkLabColor adjustHue([final double amount = 20]) {
    return toOkLch().adjustHue(amount).toOkLab();
  }

  @override
  OkLabColor get complementary => adjustHue(180);

  @override
  OkLabColor warmer([final double amount = 20]) {
    return toOkLch().warmer(amount).toOkLab();
  }

  @override
  OkLabColor cooler([final double amount = 20]) {
    return toOkLch().cooler(amount).toOkLab();
  }

  @override
  List<OkLabColor> generateBasicPalette() => <OkLabColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<OkLabColor> tonesPalette() => List<OkLabColor>.generate(
        6,
        (final int index) => copyWith(l: (index / 5).clamp(0.0, 1.0)),
      );

  @override
  List<OkLabColor> analogous({final int count = 5, final double offset = 30}) {
    return toOkLch()
        .analogous(count: count, offset: offset)
        .map((final ColorSpacesIQ c) => (c as OkLCH).toOkLab())
        .toList();
  }

  @override
  List<OkLabColor> square() => toOkLch()
      .square()
      .map((final ColorSpacesIQ c) => (c as OkLCH).toOkLab())
      .toList();

  @override
  List<OkLabColor> tetrad({final double offset = 60}) => toOkLch()
      .tetrad(offset: offset)
      .map((final ColorSpacesIQ c) => (c as OkLCH).toOkLab())
      .toList();

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
      'type': 'OkLabColor',
      'l': l,
      'a': aLab,
      'b': bLab,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkLabColor(l: ${l.toStringAsFixed(2)}, '
      'a: ${aLab.toStringAsFixed(2)}, b: ${bLab.toStringAsFixed(2)}, ' //
      'alpha: ${alpha.toStringAsFixed(2)})';
}
