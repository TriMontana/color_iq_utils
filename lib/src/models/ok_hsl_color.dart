import 'dart:math' as math;
import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';

/// A color model that represents colors using Hue, Saturation, and Lightness
/// in the Oklab color space. OkHSL is designed to be more perceptually uniform
/// than traditional HSL, meaning changes in its values correspond more closely
/// to changes perceived by the human eye.
///
/// [h] (Hue) is the angle of the color on the color wheel, ranging from 0 to 360.
/// [s] (Saturation) is the "purity" or "intensity" of the color, ranging from 0.0 (grayscale) to 1.0 (fully saturated).
/// [l] (Lightness) is the perceived brightness of the color, ranging from 0.0 (black) to 1.0 (white).
///
/// Note: Conversion to and from `ColorIQ` (and other color spaces) is done
/// via an approximate conversion to `OkLchColor`. This is because a direct
/// mathematical formula for `OkHslColor` <-> `ColorIQ` is not as straightforward
/// as for other models. The approximation is generally very good for most use cases.
class OkHslColor extends CommonIQ implements ColorSpacesIQ {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The saturation component of the color, ranging from 0.0 to 1.0.
  final double s;

  /// The lightness component of the color, ranging from 0.0 to 1.0.
  final double l;

  const OkHslColor(this.h, this.s, this.l,
      {final int? hexId,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : super(hexId, alpha: alpha, names: names ?? kEmptyNames);
  // names: names ??
  //     <String>[
  //       ColorNames.generateDefaultNameFromInt(
  //           hexId ?? OkHslColor.hexIdFromHsl(h, s, l))
  //     ]);

  @override
  int get value => super.colorId ?? OkHslColor.hexIdFromHsl(h, s, l);

  /// Creates a 32-bit integer ARGB representation of an OKHSL color.
  ///
  /// This is a stand-alone static method that converts OKHSL values to a `ColorIQ`
  /// object and then extracts its 32-bit integer `hexId`. This is useful for
  /// creating the `hexId` required by the constructor without first creating
  /// an intermediate `OkLchColor` object.
  ///
  /// - [h]: Hue, from 0 to 360.
  /// - [s]: Saturation, from 0.0 to 1.0.
  /// - [l]: Lightness, from 0.0 to 1.0.
  ///
  /// Returns the 32-bit ARGB hex value.
  static int hexIdFromHsl(final double h, final double s, final double l) {
    // Approximate conversion via OkLch
    final double C = s * 0.4; // Approximation
    final double hue = h;

    return OkLCH(Percent(l), C, hue).value;
  }

  /// Converts a 32-bit ARGB color ID to OkHSL components.
  static OkHslColor fromInt(final int argb32) {
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

    // 4. Calculate Chroma (C) and Hue (H) from Oklab (a, b)
    final double c = math.sqrt(oklabA * oklabA + oklabB * oklabB);
    double h = math.atan2(oklabB, oklabA) * 180.0 / math.pi;

    if (h < 0) h += 360.0;

    // 5. Calculate Saturation (S) [The key step for OkHSL]
    // In OkHSL, Saturation is defined as Chroma divided by the theoretical maximum chroma (C_max)
    // for the current Lightness (L) and Hue (H).

    // Note: Calculating C_max dynamically is complex and requires gamut mapping.
    // For practical implementation, we use a constant approximation for maximum chroma (C_max)
    // often seen in simplified OkHSL models, and clamp the resulting S value to 1.0.
    // A reasonable approximate C_max for typical display conditions is around 0.3 or 0.4.

    // Saturation S = C / C_max(L, H)
    final double saturation = (c / cMaxApprox).clamp(0.0, 1.0);

    // L is already in the [0, 1] range from the Oklab conversion.
    return OkHslColor(oklabL.clamp(0.0, 1.0), h, saturation,
        hexId: argb32, names: const <String>[]);
  }

  @override
  OkHslColor darken([final double amount = 20]) {
    return OkHslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  OkHslColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  OkHslColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  OkHslColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;

    final OkHslColor otherOkHsl =
        (other is OkHslColor) ? other : other.toColor().toOkHsl();

    if (t == 1.0) return otherOkHsl;

    double newHue = h;
    final double thisS = s;
    final double otherS = otherOkHsl.s;

    // Handle achromatic hues (if saturation is near zero, preserve the other hue)
    if (thisS < 1e-4 && otherS > 1e-4) {
      newHue = otherOkHsl.h;
    } else if (otherS < 1e-4 && thisS > 1e-4) {
      newHue = h;
    } else if (thisS < 1e-4 && otherS < 1e-4) {
      newHue = h; // Both achromatic, keep current or 0
    } else {
      // Shortest path interpolation for hue
      final double diff = otherOkHsl.h - h;
      if (diff.abs() <= 180) {
        newHue += diff * t;
      } else {
        if (diff > 0) {
          newHue += (diff - 360) * t;
        } else {
          newHue += (diff + 360) * t;
        }
      }
    }

    newHue %= 360;
    if (newHue < 0) {
      newHue += 360;
    }

    return OkHslColor(
      newHue,
      thisS + (otherS - thisS) * t,
      l + (otherOkHsl.l - l) * t,
    );
  }

  @override
  OkHslColor lighten([final double amount = 20]) {
    return OkHslColor(h, s, min(1.0, l + amount / 100));
  }

  @override
  OkHslColor saturate([final double amount = 25]) {
    return copyWith(s: min(1.0, s + amount / 100));
  }

  @override
  OkHslColor desaturate([final double amount = 25]) =>
      copyWith(s: max(0.0, s - amount / 100));

  OkHslColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  OkHslColor deintensify([final double amount = 10]) {
    return desaturate(amount);
  }

  @override
  OkHslColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  OkHslColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toOkHsl();
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  OkHslColor copyWith(
      {final double? hue,
      final double? s,
      final double? l,
      final Percent? alpha}) {
    return OkHslColor(hue ?? h, s ?? this.s, l ?? this.l,
        alpha: alpha ?? super.a);
  }

  @override
  List<OkHslColor> get monochromatic {
    return <OkHslColor>[
      darken(20),
      darken(10),
      this,
      lighten(10),
      lighten(20),
    ];
  }

  @override
  List<OkHslColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <OkHslColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<OkHslColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <OkHslColor>[
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
    return OkHslColor(
      rng.nextDouble() * 360,
      rng.nextDouble(),
      rng.nextDouble(),
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is! OkHslColor) {
      return value == other.value;
    }
    const double epsilon = 0.001;
    return (h - other.h).abs() < epsilon &&
        (s - other.s).abs() < epsilon &&
        (l - other.l).abs() < epsilon;
  }

  @override
  OkHslColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  OkHslColor opaquer([final double amount = 20]) {
    // OkHSL doesn't store alpha in this implementation
    return this;
  }

  @override
  OkHslColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return OkHslColor(newHue, s, l);
  }

  @override
  OkHslColor get complementary => adjustHue(180);

  @override
  OkHslColor warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return copyWith(hue: newHue);
  }

  @override
  OkHslColor cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return copyWith(hue: newHue);
  }

  @override
  List<OkHslColor> generateBasicPalette() {
    return <OkHslColor>[
      lighten(40),
      lighten(20),
      this,
      darken(20),
      darken(40),
    ];
  }

  @override
  List<OkHslColor> tonesPalette() {
    // Create tones by reducing saturation (moving towards gray)
    return <OkHslColor>[
      this,
      copyWith(s: s * 0.85),
      copyWith(s: s * 0.70),
      copyWith(s: s * 0.55),
      copyWith(s: s * 0.40),
    ];
  }

  @override
  List<OkHslColor> analogous({final int count = 5, final double offset = 30}) {
    final List<OkHslColor> palette = <OkHslColor>[];
    final double startHue = h - ((count - 1) / 2) * offset;
    for (int i = 0; i < count; i++) {
      double newHue = (startHue + i * offset) % 360;
      if (newHue < 0) newHue += 360;
      palette.add(copyWith(hue: newHue));
    }
    return palette;
  }

  @override
  List<OkHslColor> square() {
    return <OkHslColor>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<OkHslColor> tetrad({final double offset = 60}) {
    return <OkHslColor>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  List<OkHslColor> split({final double offset = 30}) => <OkHslColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<OkHslColor> triad({final double offset = 120}) => <OkHslColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<OkHslColor> twoTone({final double offset = 60}) => <OkHslColor>[
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
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'OkHslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': transparency,
    };
  }

  @override
  String toString() => 'OkHslColor(h: ${h.toStrTrimZeros(3)}, ' //
      's: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}
