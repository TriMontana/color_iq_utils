import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/jch_color.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// A representation of a color in the CAM16-UCS J'a'b' (JAB) color space.
///
/// JAB is a perceptually uniform color space derived from CAM16 (Color Appearance
/// Model 2016). It uses rectangular coordinates similar to CIE L*a*b*, but with
/// better perceptual uniformity based on the CAM16 appearance model.
///
/// Components:
/// - **J' (j):** Lightness, ranging from 0 (black) to ~100 (white).
/// - **a' (aJab):** The red-green opponent axis. Positive values are reddish,
///   negative values are greenish.
/// - **b' (bJab):** The yellow-blue opponent axis. Positive values are yellowish,
///   negative values are bluish.
///
/// This color space is particularly useful for:
/// - Calculating perceptual color differences (ΔE)
/// - Creating perceptually uniform gradients
/// - Color interpolation that appears natural to human vision
///
/// See also: [JchColor] for the cylindrical (hue/chroma) version of this space.
class JabColor extends CommonIQ implements ColorSpacesIQ {
  /// The lightness component (J'), ranging from 0 to ~100.
  final double j;

  /// The red-green opponent component (a').
  final double aJab;

  /// The yellow-blue opponent component (b').
  final double bJab;

  /// Creates a [JabColor] from J'a'b' components.
  ///
  /// - [j]: Lightness, typically 0 to ~100.
  /// - [aJab]: Red-green axis.
  /// - [bJab]: Yellow-blue axis.
  /// - [alpha]: Opacity, defaults to fully opaque.
  const JabColor(
    this.j,
    this.aJab,
    this.bJab, {
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? _computeHexId();

  /// Computes the ARGB hex ID from the JAB components.
  int _computeHexId() {
    final Cam16 cam16 = _toCam16FromJab();
    return cam16.toInt();
  }

  /// Converts JAB to CAM16 using the inverse transformation.
  Cam16 _toCam16FromJab() {
    // Convert J'a'b' to JCh (cylindrical)
    final double chroma = sqrt(aJab * aJab + bJab * bJab);
    double hue = atan2(bJab, aJab) * 180 / pi;
    if (hue < 0) hue += 360;

    // Use Cam16.fromJch to create a proper Cam16 instance
    // Note: J' (jstar) is not the same as J, we need to reverse the transformation
    // jstar = (1 + 100 * 0.007) * j / (1 + 0.007 * j)
    // Solving for j: j = jstar / (1 + 100 * 0.007 - 0.007 * jstar)
    final double jFromJstar = j / (1.007 - 0.007 * j / 100);

    return Cam16.fromJch(jFromJstar.clamp(0, 100), chroma, hue);
  }

  /// Creates a [JabColor] from an ARGB integer.
  factory JabColor.fromInt(final int argb) {
    final Cam16 cam16 = Cam16.fromInt(argb);
    return JabColor(
      cam16.jstar,
      cam16.astar,
      cam16.bstar,
      hexId: argb,
      alpha: argb.a2,
    );
  }

  /// Creates a [JabColor] from another [ColorSpacesIQ] instance.
  factory JabColor.from(final ColorSpacesIQ color) =>
      JabColor.fromInt(color.value);

  /// Creates a [JabColor] from a [Cam16] instance.
  factory JabColor.fromCam16(final Cam16 cam16) => JabColor(
        cam16.jstar,
        cam16.astar,
        cam16.bstar,
        hexId: cam16.toInt(),
      );

  /// Converts this JAB color to cylindrical JCH representation.
  JchColor toJch() {
    final double chroma = sqrt(aJab * aJab + bJab * bJab);
    double hue = atan2(bJab, aJab) * 180 / pi;
    if (hue < 0) hue += 360;
    return JchColor(j, chroma, hue, hexId: value, alpha: alpha);
  }

  @override
  JabColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  JabColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  JabColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final JabColor otherJab = other is JabColor ? other : JabColor.from(other);
    if (t == 1.0) return otherJab;

    return JabColor(
      lerpDouble(j, otherJab.j, t),
      lerpDouble(aJab, otherJab.aJab, t),
      lerpDouble(bJab, otherJab.bJab, t),
    );
  }

  @override
  JabColor lighten([final double amount = 20]) {
    return copyWith(j: min(100.0, j + amount));
  }

  @override
  JabColor darken([final double amount = 20]) {
    return copyWith(j: max(0.0, j - amount));
  }

  @override
  JabColor saturate([final double amount = 25]) {
    return toJch().saturate(amount).toJab();
  }

  @override
  JabColor desaturate([final double amount = 25]) {
    return toJch().desaturate(amount).toJab();
  }

  @override
  JabColor accented([final double amount = 15]) {
    return toColor().jab.accented(amount);
  }

  @override
  JabColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).jab;
  }

  /// Creates a copy of this color with the given fields replaced.
  @override
  JabColor copyWith({
    final double? j,
    final double? aJab,
    final double? bJab,
    final Percent? alpha,
  }) {
    return JabColor(
      j ?? this.j,
      aJab ?? this.aJab,
      bJab ?? this.bJab,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<JabColor> get monochromatic {
    return <JabColor>[
      darken(20),
      darken(10),
      this,
      lighten(10),
      lighten(20),
    ];
  }

  @override
  List<JabColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <JabColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<JabColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <JabColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  JabColor get random {
    final Random rng = Random();
    return JabColor(
      rng.nextDouble() * 100,
      rng.nextDouble() * 100 - 50,
      rng.nextDouble() * 100 - 50,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is JabColor) {
      const double epsilon = 0.001;
      return (j - other.j).abs() < epsilon &&
          (aJab - other.aJab).abs() < epsilon &&
          (bJab - other.bJab).abs() < epsilon;
    }
    return value == other.value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  JabColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  JabColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  JabColor adjustHue([final double amount = 20]) {
    return toJch().adjustHue(amount).toJab();
  }

  @override
  JabColor get complementary => adjustHue(180);

  @override
  JabColor warmer([final double amount = 20]) {
    return toJch().warmer(amount).toJab();
  }

  @override
  JabColor cooler([final double amount = 20]) {
    return toJch().cooler(amount).toJab();
  }

  @override
  List<JabColor> generateBasicPalette() => <JabColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<JabColor> tonesPalette() => List<JabColor>.generate(
        6,
        (final int index) => copyWith(j: (index / 5 * 100).clamp(0.0, 100.0)),
      );

  @override
  List<JabColor> analogous({final int count = 5, final double offset = 30}) {
    return toJch()
        .analogous(count: count, offset: offset)
        .map((final ColorSpacesIQ c) => (c as JchColor).toJab())
        .toList();
  }

  @override
  List<JabColor> square() => toJch()
      .square()
      .map((final ColorSpacesIQ c) => (c as JchColor).toJab())
      .toList();

  @override
  List<JabColor> tetrad({final double offset = 60}) => toJch()
      .tetrad(offset: offset)
      .map((final ColorSpacesIQ c) => (c as JchColor).toJab())
      .toList();

  @override
  List<JabColor> split({final double offset = 30}) => <JabColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<JabColor> triad({final double offset = 120}) => <JabColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<JabColor> twoTone({final double offset = 60}) => <JabColor>[
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
      'type': 'JabColor',
      'j': j,
      'a': aJab,
      'b': bJab,
      'alpha': alpha.val,
    };
  }

  @override
  String toString() => 'JabColor(j: ${j.toStringAsFixed(2)}, '
      'a: ${aJab.toStringAsFixed(2)}, b: ${bJab.toStringAsFixed(2)})';
}
