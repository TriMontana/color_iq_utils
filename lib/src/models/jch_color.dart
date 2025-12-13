import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/jab_color.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// A representation of a color in the CAM16-UCS J'C'h (JCH) color space.
///
/// JCH is the cylindrical (polar) form of the CAM16-UCS color space, similar
/// to how LCH is the cylindrical form of Lab. It provides an intuitive way to
/// work with hue, chroma (colorfulness), and lightness.
///
/// Components:
/// - **J' (j):** Lightness, ranging from 0 (black) to ~100 (white).
/// - **C' (c):** Chroma (colorfulness/saturation). 0 is achromatic (gray),
///   higher values are more colorful.
/// - **h (h):** Hue angle in degrees, ranging from 0 to 360.
///
/// This color space is particularly useful for:
/// - Perceptually uniform hue manipulation
/// - Creating color harmonies and palettes
/// - Adjusting saturation without affecting perceived lightness
///
/// See also: [JabColor] for the rectangular coordinate version of this space.
class JchColor extends CommonIQ implements ColorSpacesIQ {
  /// The lightness component (J'), ranging from 0 to ~100.
  final double j;

  /// The chroma component (C'), representing colorfulness.
  final double c;

  /// The hue angle in degrees (0-360).
  final double h;

  /// Creates a [JchColor] from J'C'h components.
  ///
  /// - [j]: Lightness, typically 0 to ~100.
  /// - [c]: Chroma (colorfulness), 0 or greater.
  /// - [h]: Hue angle in degrees, 0 to 360.
  /// - [alpha]: Opacity, defaults to fully opaque.
  const JchColor(
    this.j,
    this.c,
    this.h, {
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? _computeHexId();

  /// Computes the ARGB hex ID from the JCH components.
  int _computeHexId() {
    // Convert J' (jstar) back to J for Cam16.fromJch
    // jstar = (1 + 100 * 0.007) * j / (1 + 0.007 * j)
    // Solving for j: j = jstar / (1 + 100 * 0.007 - 0.007 * jstar)
    final double jFromJstar = j / (1.007 - 0.007 * j / 100);
    final Cam16 cam16 = Cam16.fromJch(jFromJstar.clamp(0, 100), c, h);
    return cam16.toInt();
  }

  /// Creates a [JchColor] from an ARGB integer.
  factory JchColor.fromInt(final int argb) {
    final Cam16 cam16 = Cam16.fromInt(argb);
    // Calculate chroma and hue from astar/bstar
    final double chroma =
        sqrt(cam16.astar * cam16.astar + cam16.bstar * cam16.bstar);
    double hue = atan2(cam16.bstar, cam16.astar) * 180 / pi;
    if (hue < 0) hue += 360;

    return JchColor(
      cam16.jstar,
      chroma,
      hue,
      hexId: argb,
      alpha: argb.a2,
    );
  }

  /// Creates a [JchColor] from another [ColorSpacesIQ] instance.
  factory JchColor.from(final ColorSpacesIQ color) =>
      JchColor.fromInt(color.value);

  /// Creates a [JchColor] from a [Cam16] instance.
  factory JchColor.fromCam16(final Cam16 cam16) {
    final double chroma =
        sqrt(cam16.astar * cam16.astar + cam16.bstar * cam16.bstar);
    double hue = atan2(cam16.bstar, cam16.astar) * 180 / pi;
    if (hue < 0) hue += 360;

    return JchColor(
      cam16.jstar,
      chroma,
      hue,
      hexId: cam16.toInt(),
    );
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Converts this JCH color to CAM16.
  @override
  Cam16 toCam16() => Cam16.fromInt(value);

  /// Converts this JCH color to rectangular JAB representation.
  JabColor toJab() {
    final double hRad = h * pi / 180;
    final double a = c * cos(hRad);
    final double b = c * sin(hRad);
    return JabColor(j, a, b, hexId: value, alpha: alpha);
  }

  @override
  JchColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  JchColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  JchColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final JchColor otherJch = other is JchColor ? other : JchColor.from(other);
    if (t == 1.0) return otherJch;

    double newHue = h;
    final double thisC = c;
    final double otherC = otherJch.c;

    // Handle achromatic hues (if chroma is near zero, preserve the other hue)
    const double kAchromaticThreshold = 0.05;
    if (thisC < kAchromaticThreshold && otherC > kAchromaticThreshold) {
      newHue = otherJch.h;
    } else if (otherC < kAchromaticThreshold && thisC > kAchromaticThreshold) {
      newHue = h;
    } else if (thisC < kAchromaticThreshold && otherC < kAchromaticThreshold) {
      newHue = h; // Both achromatic, keep current
    } else {
      // Shortest path interpolation for hue
      final double diff = otherJch.h - h;
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
    if (newHue < 0) newHue += 360;

    return JchColor(
      lerpDouble(j, otherJch.j, t),
      lerpDouble(thisC, otherC, t),
      newHue,
    );
  }

  @override
  JchColor lighten([final double amount = 20]) {
    return copyWith(j: min(100.0, j + amount));
  }

  @override
  JchColor darken([final double amount = 20]) {
    return copyWith(j: max(0.0, j - amount));
  }

  @override
  JchColor saturate([final double amount = 25]) {
    return copyWith(c: c + amount);
  }

  @override
  JchColor desaturate([final double amount = 25]) {
    return copyWith(c: max(0.0, c - amount));
  }

  @override
  JchColor accented([final double amount = 15]) {
    return toColor().jch.accented(amount);
  }

  @override
  JchColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).jch;
  }

  /// Creates a copy of this color with the given fields replaced.
  @override
  JchColor copyWith({
    final double? j,
    final double? c,
    final double? h,
    final Percent? alpha,
  }) {
    return JchColor(
      j ?? this.j,
      c ?? this.c,
      h ?? this.h,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<JchColor> get monochromatic {
    return <JchColor>[
      darken(20),
      darken(10),
      this,
      lighten(10),
      lighten(20),
    ];
  }

  @override
  List<JchColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <JchColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<JchColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <JchColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  JchColor get random {
    final Random rng = Random();
    return JchColor(
      rng.nextDouble() * 100,
      rng.nextDouble() * 100,
      rng.nextDouble() * 360,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is JchColor) {
      const double epsilon = 0.001;
      return (j - other.j).abs() < epsilon &&
          (c - other.c).abs() < epsilon &&
          (h - other.h).abs() < epsilon;
    }
    return value == other.value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  JchColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  JchColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  JchColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return copyWith(h: newHue);
  }

  @override
  JchColor get complementary => adjustHue(180);

  @override
  JchColor warmer([final double amount = 20]) {
    const double targetHue = 30.0; // Orange/warm hue
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return copyWith(h: newHue);
  }

  @override
  JchColor cooler([final double amount = 20]) {
    const double targetHue = 210.0; // Blue/cool hue
    final double currentHue = h;

    // Calculate shortest path difference
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return copyWith(h: newHue);
  }

  @override
  List<JchColor> generateBasicPalette() => <JchColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<JchColor> tonesPalette() {
    // Create tones by reducing chroma (moving towards gray)
    return <JchColor>[
      this,
      copyWith(c: c * 0.85),
      copyWith(c: c * 0.70),
      copyWith(c: c * 0.55),
      copyWith(c: c * 0.40),
    ];
  }

  @override
  List<JchColor> analogous({final int count = 5, final double offset = 30}) {
    final List<JchColor> palette = <JchColor>[];
    final double startHue = h - ((count - 1) / 2) * offset;
    for (int i = 0; i < count; i++) {
      double newHue = (startHue + i * offset) % 360;
      if (newHue < 0) newHue += 360;
      palette.add(copyWith(h: newHue));
    }
    return palette;
  }

  @override
  List<JchColor> square() {
    return <JchColor>[
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<JchColor> tetrad({final double offset = 60}) {
    return <JchColor>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  List<JchColor> split({final double offset = 30}) => <JchColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<JchColor> triad({final double offset = 120}) => <JchColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<JchColor> twoTone({final double offset = 60}) => <JchColor>[
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
      'type': 'JchColor',
      'j': j,
      'c': c,
      'h': h,
      'alpha': alpha.val,
    };
  }

  @override
  String toString() => 'JchColor(j: ${j.toStringAsFixed(2)}, '
      'c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
