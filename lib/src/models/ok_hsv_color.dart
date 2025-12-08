import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';

/// A color model that represents color in the Okhsv color space.
///
/// Okhsv is a perceptually uniform color space that is a transformation of the
/// Oklab color space. It is designed to be more intuitive for humans to work
/// with than Oklab, while still retaining the benefits of perceptual uniformity.
///
/// The `OkHsvColor` class has four properties:
///
/// * `hue`: The hue of the color, in degrees (0-360).
/// * `saturation`: The saturation of the color (0-1).
/// * `val`: The value (brightness) of the color (0-1).
/// * `alpha`: The alpha (transparency) of the color (0-1).
class OkHsvColor extends CommonIQ implements ColorSpacesIQ {
  final double hue;
  final double saturation;
  // Renamed from value to val to avoid conflict with ColorSpacesIQ.value
  final double val;

  const OkHsvColor(this.hue, this.saturation, this.val,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String> names = kEmptyNames})
      : super(hexId, names: names, alpha: alpha);
  // super.alt(
  //     hexId ?? OkHsvColor.hexIdFromOkHSV(hue, saturation, val, alpha.val),
  //     a: alpha,
  //     names: names ??
  //         names ??
  //         <String>[
  //           ColorNames.generateDefaultNameFromInt(hexId ??
  //               OkHsvColor.hexIdFromOkHSV(
  //                   hue, saturation, val, alpha.val))
  //         ]);

  @override
  int get value =>
      super.colorId ?? OkHsvColor.hexIdFromOkHSV(hue, saturation, val, alpha);

  /// Generates a 32-bit ARGB hex ID from OkHsv values.
  static int hexIdFromOkHSV(final double hue, final double saturation,
      final double val, final double alpha) {
    // Convert OkHsv to OkLab
    final double c = saturation * val * 0.4;
    final double l = val * (1 - saturation);
    final double hRad = hue * pi / 180;
    final double a = c * cos(hRad);
    final double b = c * sin(hRad);

    // Convert OkLab to linear RGB
    final double l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    final double m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    final double s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    final double l3 = l_ * l_ * l_;
    final double m3 = m_ * m_ * m_;
    final double s3 = s_ * s_ * s_;

    double r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    double g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    double blue = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    // Gamma correction (sRGB)
    // Gamma correction (sRGB)
    r = r.clamp(0.0, 1.0).gammaCorrect;
    g = g.clamp(0.0, 1.0).gammaCorrect;
    blue = blue.clamp(0.0, 1.0).gammaCorrect;

    // Clamp and convert to 0-255
    final int rInt = (r.clamp(0.0, 1.0) * 255).round();
    final int gInt = (g.clamp(0.0, 1.0) * 255).round();
    final int bInt = (blue.clamp(0.0, 1.0) * 255).round();
    final int aInt = (alpha.clamp(0.0, 1.0) * 255).round();

    return (aInt << 24) | (rInt << 16) | (gInt << 8) | bInt;
  }

  /// Converts a 32-bit ARGB color ID to OkHSV components.
  /// Note: OkLab Lightness (L) is used as a proxy for Value (V).
  static OkHsvColor fromInt(final int argb32) {
    final LinRGB lr = argb32.redLinearized;
    final LinRGB lg = argb32.greenLinearized;
    final LinRGB lb = argb32.blueLinearized;

    final LmsPrime lmsPrime = linearRgbToLmsPrime(lr, lg, lb);

    // 3. Convert L'M'S' to Oklab (L, a, b)
    final double oklabL = 0.2104542553 * lmsPrime.lPrime +
        0.7936177850 * lmsPrime.mPrime -
        0.0040720468 * lmsPrime.sPrime;
    final double oklabA = 1.9779984951 * lmsPrime.lPrime -
        2.4285922050 * lmsPrime.mPrime +
        0.4505937102 * lmsPrime.sPrime;
    final double oklabB = 0.0259040371 * lmsPrime.lPrime +
        0.7827717662 * lmsPrime.mPrime -
        0.8086757660 * lmsPrime.sPrime;

    // 4. Calculate Chroma (C) and Hue (H)
    final double c = math.sqrt(oklabA * oklabA + oklabB * oklabB);
    double h = math.atan2(oklabB, oklabA) * 180.0 / math.pi;

    if (h < 0) {
      h += 360.0;
    }

    // 5. Calculate Saturation (S) and Value (V)

    // S: Saturation is Chroma divided by the maximum possible Chroma (C_max)
    final double saturation = (c / cMaxApprox).clamp(0.0, 1.0);

    // V (Value): Oklab Lightness (L) is the perceptually uniform metric [0, 1].
    // We use L as the Value (V) component, as it represents the perceived intensity/lightness.
    final double value = oklabL.clamp(0.0, 1.0);

    // H is Hue [0, 360)
    return OkHsvColor(h, saturation, value);
  }

  @override
  OkLabColor toOkLab() {
    // Reverse of OkLab.toOkHsv
    // v = l + c/0.4
    // s = (c/0.4) / v
    // -> c/0.4 = s * v
    // -> c = s * v * 0.4
    // -> l = v - c/0.4 = v - s*v = v(1-s)
    final double c = saturation * val * 0.4;
    final double l = val * (1 - saturation);
    final double hRad = hue * pi / 180;
    return OkLabColor(l, c * cos(hRad), c * sin(hRad), alpha: alpha);
  }

  @override
  OkHsvColor darken([final double amount = 20]) {
    return OkHsvColor(hue, saturation, max(0.0, val - amount / 100),
        alpha: alpha);
  }

  @override
  OkHsvColor brighten([final double amount = 20]) {
    return OkHsvColor(hue, saturation, min(1.0, val + amount / 100),
        alpha: alpha);
  }

  @override
  OkHsvColor saturate([final double amount = 25]) {
    return OkHsvColor(hue, min(1.0, saturation + amount / 100), val,
        alpha: alpha);
  }

  @override
  OkHsvColor desaturate([final double amount = 25]) =>
      copyWith(saturation: max(0.0, saturation - amount / 100));

  @override
  OkHsvColor intensify([final double amount = 10]) {
    return OkHsvColor(
      hue,
      min(1.0, saturation + amount / 100),
      max(0.0, val - (amount / 200)),
      alpha: alpha,
    );
  }

  @override
  OkHsvColor deintensify([final double amount = 10]) {
    return OkHsvColor(
      hue,
      max(0.0, saturation - amount / 100),
      min(1.0, val + (amount / 200)),
      alpha: alpha,
    );
  }

  @override
  OkHsvColor accented([final double amount = 15]) {
    return OkHsvColor(
      hue,
      min(1.0, saturation + amount / 100),
      min(1.0, val + (amount / 200)),
      alpha: alpha,
    );
  }

  @override
  OkHsvColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkHsv();
  }

  @override
  OkHsvColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  OkHsvColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  OkHsvColor lerp(final ColorSpacesIQ other, final double t) {
    final OkHsvColor otherOkHsv =
        other is OkHsvColor ? other : other.toColor().toOkHsv();
    return OkHsvColor(
      lerpHue(hue, otherOkHsv.hue, t),
      lerpDouble(saturation, otherOkHsv.saturation, t),
      lerpDouble(val, otherOkHsv.val, t),
    );
  }

  @override
  OkHsvColor lighten([final double amount = 20]) {
    return OkHsvColor(hue, saturation, min(1.0, val + amount / 100),
        alpha: alpha);
  }

  @override
  HctColor toHctColor() => HctColor.fromInt(value);

  @override
  OkHsvColor fromHct(final HctColor hct) => OkHsvColor.fromInt(hct.toInt());

  @override
  OkHsvColor adjustTransparency([final double amount = 20]) {
    final double z = (alpha.val * (1 - amount / 100)).clamp(0.0, 1.0);
    return copyWith(alpha: Percent(z));
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkHsvColor copyWith({
    final double? hue,
    final double? saturation,
    final double? v,
    final Percent? alpha,
  }) {
    return OkHsvColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      v ?? val,
      alpha: alpha ?? super.a,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    final List<OkHsvColor> results = <OkHsvColor>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 0.1;
      final double newVal = (val + delta).clamp(0.0, 1.0);
      results.add(OkHsvColor(hue, saturation, newVal, alpha: alpha));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <OkHsvColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <OkHsvColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  ColorSpacesIQ get random {
    final Random rng = Random();
    return OkHsvColor(
      rng.nextDouble() * 360.0,
      rng.nextDouble(),
      rng.nextDouble(),
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  double _lerpHue(final double start, final double end, final double t) {
    final double delta = ((end - start + 540) % 360) - 180;
    return wrapHue(start + delta * _clamp01(t));
  }

  double _clamp01(final double value) => value.clamp(0.0, 1.0);

  OkHsvColor _withHueShift(final double delta) =>
      copyWith(hue: wrapHue(hue + delta));

  OkHsvColor _asOkHsv(final ColorSpacesIQ color) {
    if (color is OkHsvColor) {
      return color;
    }
    if (color is OkLabColor) {
      return color.toOkHsv();
    }
    if (color is ColorIQ) {
      return color.toOkHsv();
    }
    return color.toOkLab().toOkHsv();
  }

  @override
  OkHsvColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    final OkHsvColor target = _asOkHsv(other);
    final double t = _clamp01(amount / 100);
    final double blendedHue = _lerpHue(hue, target.hue, t);
    final double blendedSaturation = _clamp01(
      saturation + (target.saturation - saturation) * t,
    );
    final double blendedValue = _clamp01(val + (target.val - val) * t);
    final double blendedAlpha =
        _clamp01(alpha.val + (target.alpha.val - alpha.val) * t);
    return OkHsvColor(
      blendedHue,
      blendedSaturation,
      blendedValue,
      alpha: Percent(blendedAlpha),
    );
  }

  @override
  OkHsvColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent(_clamp01(alpha.val + amount / 100)));
  }

  @override
  OkHsvColor adjustHue([final double amount = 20]) => _withHueShift(amount);

  @override
  OkHsvColor get complementary => _withHueShift(180);

  @override
  OkHsvColor warmer([final double amount = 20]) => _withHueShift(-amount);

  @override
  OkHsvColor cooler([final double amount = 20]) => _withHueShift(amount);

  @override
  List<OkHsvColor> generateBasicPalette() => <OkHsvColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<OkHsvColor> tonesPalette() => List<OkHsvColor>.generate(
        6,
        (final int index) => copyWith(v: _clamp01(index / 5)),
      );

  @override
  List<OkHsvColor> analogous({final int count = 5, final double offset = 30}) {
    if (count <= 1) {
      return <OkHsvColor>[this];
    }
    final double center = (count - 1) / 2;
    return List<OkHsvColor>.generate(
      count,
      (final int index) => _withHueShift((index - center) * offset),
    );
  }

  @override
  List<OkHsvColor> square() => List<OkHsvColor>.generate(
        4,
        (final int index) => _withHueShift(index * 90),
      );

  @override
  List<OkHsvColor> tetrad({final double offset = 60}) => <OkHsvColor>[
        this,
        _withHueShift(offset),
        _withHueShift(180),
        _withHueShift(180 + offset),
      ];
  @override
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());

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
      'type': 'OkHsvColor',
      'hue': hue,
      'saturation': saturation,
      'value': val,
      'alpha': alpha,
    };
  }

  @override
  String toString() => 'OkHsvColor(h: ${hue.toStrTrimZeros(3)}, ' //
      's: ${saturation.toStringAsFixed(2)}, v: ${val.toStringAsFixed(2)})';
}
