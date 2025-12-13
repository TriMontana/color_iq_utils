import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/lch_color.dart';

/// Cache for computed CIELab color objects.
///
/// The key is the 32-bit ARGB integer representation of the color and the
/// value is the corresponding cached [CIELab] instance. Caching avoids
/// repeated expensive conversions between color spaces.
Map<int, CIELab> mapLAB = <int, CIELab>{
  //
};

/// Extension helpers for the `mapLAB` cache.
///
/// Provides a convenience method to retrieve a cached [CIELab] or create and
/// insert one when missing.
extension MapLabColorsExtension on Map<int, CIELab> {
  /// Returns the cached [CIELab] for [key], or creates, inserts and returns a
  /// new one with [CIELab.fromInt] when no cached value exists.
  ///
  /// The [key] is expected to be a 32-bit ARGB integer.
  CIELab getOrCreate(final int key) {
    final CIELab? color = this[key];
    if (color != null) {
      return color;
    }
    return putIfAbsent(key, () => CIELab.fromInt(key));
  }
}

/// Represents a color in the CIE L\*a\*b\* (CIELAB) color space.
///
/// Instances are immutable. The class implements common color transformation
/// helpers and conversions to other color representations used in the library.
class CIELab extends CommonIQ implements ColorSpacesIQ {
  /// Lightness component (0..100).
  final double l;

  /// Green–red component (negative = green, positive = red).
  final double aLab;

  /// Blue–yellow component (negative = blue, positive = yellow).
  final double bLab;

  /// Creates a [CIELab] instance.
  ///
  /// * `l` — Lightness in range 0..100 (asserted).
  /// * `aLab` — a\* component.
  /// * `bLab` — b\* component.
  /// * `hexId` — optional 32-bit ARGB id used to populate the underlying color id.
  /// * `alpha` — transparency as a [Percent] (defaults to fully opaque).
  /// * `names` — optional list of descriptive names for the color.
  CIELab(this.l, this.aLab, this.bLab,
      {final int? hexId,
        final Percent alpha = Percent.max,
        final List<String>? names})
      : assert(l >= 0 && l <= 100, 'L must be between 0 and 100'),
        super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? CIELab.hexIdFromLAB(l, aLab, bLab);

  /// Constructs a [CIELab] from a 32-bit ARGB integer.
  ///
  /// The ARGB value is converted into CIELab components using the library's
  /// color conversion utility `labFromArgb`.
  static CIELab fromInt(final int hexId) {
    final List<double> lab = labFromArgb(hexId);
    return CIELab(lab[0], lab[1], lab[2], hexId: hexId);
  }

  /// Converts CIE-LAB components to a 32-bit ARGB integer.
  ///
  /// Delegates to the shared `argbFromLab` helper which performs
  /// LAB -> sRGB conversion and packs the result into an ARGB int.
  static int hexIdFromLAB(
      final double l, final double aLab, final double bLab) {
    return argbFromLab(l, aLab, bLab);
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Converts this Lab color to the LCH color space.
  ///
  /// Returns an [LchColor] with the same lightness and computed chroma and hue.
  LchColor toLch() {
    final double c = sqrt(aLab * aLab + bLab * bLab);
    double h = atan2(bLab, aLab);
    h = h * 180 / pi;
    if (h < 0) {
      h += 360;
    }
    return LchColor(l, c, h);
  }

  /// Mixes this color with white by [amount] percent (default 20).
  @override
  CIELab whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  /// Mixes this color with black by [amount] percent (default 20).
  @override
  CIELab blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  /// Returns a lightened version of the color by increasing `l` by `amount`.
  ///
  /// `l` is clamped to a maximum of 100.
  @override
  CIELab lighten([final double amount = 20]) {
    return CIELab(min(100, l + amount), aLab, bLab);
  }

  /// Returns a darkened version of the color by decreasing `l` by `amount`.
  ///
  /// `l` is clamped to a minimum of 0.
  @override
  CIELab darken([final double amount = 20]) {
    return CIELab(max(0, l - amount), aLab, bLab);
  }

  /// Increases chroma (saturation) using the LCH intermediary.
  @override
  CIELab saturate([final double amount = 25]) {
    return toLch().saturate(amount).toLab();
  }

  /// Decreases chroma (saturation) using the LCH intermediary.
  @override
  CIELab desaturate([final double amount = 25]) {
    return toLch().desaturate(amount).toLab();
  }

  /// Returns an accented variant of this color.
  @override
  CIELab accented([final double amount = 15]) {
    return toColor().accented(amount).lab;
  }

  /// Simulates a form of color blindness for this color and returns the
  /// resulting Lab color.
  @override
  CIELab simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).lab;
  }

  /// Linearly interpolates between this color and [other] by interpolation
  /// factor `t` in range 0..1.
  ///
  /// If [other] is not a [CIELab], it is converted via `toColor().lab`.
  @override
  CIELab lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final CIELab otherLab = other is CIELab ? other : other.toColor().lab;
    if (t == 1.0) {
      return otherLab;
    }

    return CIELab(
      lerpDouble(l, otherLab.l, t),
      lerpDouble(aLab, otherLab.aLab, t),
      lerpDouble(bLab, otherLab.bLab, t),
    );
  }

  /// Returns a copy of this color with the provided fields replaced.
  ///
  /// Use this to modify `l`, `a`, `b` or `alpha` while preserving other values.
  @override
  CIELab copyWith(
      {final double? l,
        final double? a,
        final double? b,
        final Percent? alpha}) {
    return CIELab(l ?? this.l, a ?? aLab, b ?? bLab, alpha: alpha ?? super.a);
  }

  /// Generates a small monochromatic set (5 steps) around this color by
  /// varying the lightness.
  @override
  List<CIELab> get monochromatic {
    final List<CIELab> results = <CIELab>[];
    for (int i = 0; i < 5; i++) {
      final double delta = (i - 2) * 10.0;
      final double newL = (l + delta).clamp(0.0, 100.0);
      results.add(CIELab(newL, aLab, bLab, alpha: alpha));
    }
    return results;
  }

  /// Returns a palette of progressively lighter variants.
  @override
  List<CIELab> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <CIELab>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  /// Returns a palette of progressively darker variants.
  @override
  List<CIELab> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <CIELab>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  /// Random Lab color generator (lightness in 0..100, a and b in -128..128).
  @override
  CIELab get random {
    final Random rng = Random();
    return CIELab(
      rng.nextDouble() * 100.0,
      rng.nextDouble() * 256.0 - 128.0,
      rng.nextDouble() * 256.0 - 128.0,
      alpha: alpha,
    );
  }

  /// Tests equality with another color space object using a small epsilon.
  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is CIELab) {
      const double epsilon = 0.001;
      return (l - other.l).abs() < epsilon &&
          (aLab - other.aLab).abs() < epsilon &&
          (bLab - other.bLab).abs() < epsilon &&
          (alpha.val - other.alpha.val).abs() < epsilon;
    }
    return false;
  }

  /// Returns true if this color is considered light according to brightness.
  @override
  bool get isLight => brightness == Brightness.light;

  /// Blends this color with [other] by `amount` percent (default 50).
  @override
  CIELab blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  /// Returns a copy with increased opacity (alpha) by [amount] percent.
  @override
  CIELab opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  /// Adjusts hue through LCH intermediary by [amount] degrees.
  @override
  CIELab adjustHue([final double amount = 20]) {
    return toLch().adjustHue(amount).toLab();
  }

  /// Complement color (180 degrees hue shift).
  @override
  CIELab get complementary => adjustHue(180);

  /// Warmer color by increasing hue through LCH.
  @override
  CIELab warmer([final double amount = 20]) {
    return toLch().warmer(amount).toLab();
  }

  /// Cooler color by decreasing hue through LCH.
  @override
  CIELab cooler([final double amount = 20]) {
    return toLch().cooler(amount).toLab();
  }

  /// Generate a basic 5-color palette centered on this color.
  @override
  List<CIELab> generateBasicPalette() => <CIELab>[
    darken(40),
    darken(20),
    this,
    lighten(20),
    lighten(40),
  ];

  /// Generate a tonal palette of 6 steps from black to white (L values).
  @override
  List<CIELab> tonesPalette() => List<CIELab>.generate(
    6,
        (final int index) => copyWith(l: (index / 5 * 100).clamp(0.0, 100.0)),
  );

  /// Returns analogous colors via the LCH intermediary.
  @override
  List<CIELab> analogous({final int count = 5, final double offset = 30}) {
    return toLch()
        .analogous(count: count, offset: offset)
        .map((final ColorSpacesIQ c) => (c as LchColor).toLab())
        .toList();
  }

  /// Square harmony via LCH intermediary.
  @override
  List<CIELab> square() => toLch()
      .square()
      .map((final ColorSpacesIQ c) => (c as LchColor).toLab())
      .toList();

  /// Tetrad harmony via LCH intermediary.
  @override
  List<CIELab> tetrad({final double offset = 60}) => toLch()
      .tetrad(offset: offset)
      .map((final ColorSpacesIQ c) => (c as LchColor).toLab())
      .toList();


  /// Contrast ratio with another color (delegated to ColorIQ).
  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  /// Returns the closest named color slice (delegated to ColorIQ).
  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  /// Checks whether this Lab color is within the specified [gamut].
  ///
  /// Current implementation supports sRGB checks by converting to linear sRGB
  /// and validating component ranges. For other gamuts the method currently
  /// returns true.
  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    if (gamut == Gamut.sRGB) {
      // Convert to RGB without clamping and check bounds
      // We can use the logic from toColor but return false if out of 0-1 range (before scaling to 255)

      final double y = (l + 16) / 116;
      final double x = aLab / 500 + y;
      final double z = y - bLab / 200;

      final double x3 = x * x * x;
      final double y3 = y * y * y;
      final double z3 = z * z * z;

      const double xn = 95.047;
      const double yn = 100.0;
      const double zn = 108.883;

      final double rX = xn * ((x3 > 0.008856) ? x3 : ((x - 16 / 116) / 7.787));
      final double gY = yn * ((y3 > 0.008856) ? y3 : ((y - 16 / 116) / 7.787));
      final double bZ = zn * ((z3 > 0.008856) ? z3 : ((z - 16 / 116) / 7.787));

      final double rS = rX / 100;
      final double gS = gY / 100;
      final double bS = bZ / 100;

      double rL = rS * 3.2406 + gS * -1.5372 + bS * -0.4986;
      double gL = rS * -0.9689 + gS * 1.8758 + bS * 0.0415;
      double bL = rS * 0.0557 + gS * -0.2040 + bS * 1.0570;

      // Linear to sRGB gamma correction
      rL = (rL > 0.0031308) ? (1.055 * pow(rL, 1 / 2.4) - 0.055) : (12.92 * rL);
      gL = (gL > 0.0031308) ? (1.055 * pow(gL, 1 / 2.4) - 0.055) : (12.92 * gL);
      bL = (bL > 0.0031308) ? (1.055 * pow(bL, 1 / 2.4) - 0.055) : (12.92 * bL);

      // Check if within 0.0 - 1.0 (with small epsilon)
      const double epsilon = 0.0001;
      return rL >= -epsilon &&
          rL <= 1.0 + epsilon &&
          gL >= -epsilon &&
          gL <= 1.0 + epsilon &&
          bL >= -epsilon &&
          bL <= 1.0 + epsilon;
    }
    // For other gamuts, we'd need their conversion matrices.
    // Defaulting to true for now if not sRGB.
    return true;
  }

  /// Serializes this color to a simple JSON map.
  ///
  /// The returned map uses the key `'type'` to identify the color model.
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'LabColor', 'l': l, 'a': aLab, 'b': bLab};
  }

  /// Human-friendly string representation.
  @override
  String toString() =>
      'LabColor(l: ${l.toStrTrimZeros(3)}, a: ${aLab.toStrTrimZeros(2)}, ' //
          'b: ${bLab.toStrTrimZeros(3)})';
}
