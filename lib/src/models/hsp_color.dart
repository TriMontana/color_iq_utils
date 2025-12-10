import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

/// A color model that represents color in terms of Hue, Saturation, and
/// Perceived Brightness (HSP). HSP is designed to be more perceptually uniform
/// than HSL and HSV, particularly in its brightness component.
///
/// The `h` (hue) component is a value between 0.0 and 1.0, representing the
/// angle on the color wheel (0.0 for red, 1/3 for green, 2/3 for blue).
/// The `s` (saturation) component is a value between 0.0 (grayscale) and 1.0 (fully saturated).
/// The `p` (perceived brightness) component is also a value between 0.0 (black)
/// and 1.0 (white).
///
/// This model is based on the HSP color model described by Darel Rex Finley.
/// More details can be found at http://alienryderflex.com/hsp.html
class HSP extends CommonIQ implements ColorSpacesIQ {
  /// The hue component of the color, ranging from 0.0 to 1.0.
  final double h;

  /// The saturation component of the color, ranging from 0.0 to 1.0.
  final double s;

  /// The perceived brightness component of the color, ranging from 0.0 to 1.0.
  final double p;

  /// Creates a new `HspColor`.
  const HSP(this.h, this.s, this.p,
      {final Percent alpha = Percent.max,
      final int? hexId,
      final List<String> names = kEmptyNames})
      : super(hexId, names: names, alpha: alpha);

  @override
  int get value => super.colorId ?? HSP.hexIdFromHSP(h, s, p);

  // super.alt(hexId ?? HspColor.hexIdFromHSP(h, s, p, alpha),
  //     a: alpha,
  //     names: names ??
  //         names ??
  //         <String>[
  //           ColorNames.generateDefaultNameFromInt(
  //               hexId ?? HspColor.hexIdFromHSP(h, s, p, alpha))
  //         ]);

  /// Creates a 32-bit hex ID/ARGB from this class's properties.
  /// This is a standalone static method for conversion.
  static int hexIdFromHSP(final double h, final double s, final double p,
      [final double alpha = 1.0]) {
    // http://alienryderflex.com/hsp.html
    double part = 0.0;
    double r = 0.0;
    double g = 0.0;
    double b = 0.0;
    final double minOverMax = 1.0 - s;

    if (minOverMax > 0.0) {
      double hLocal = h;
      if (hLocal < 1.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 0.0 / 6.0);
        part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
        b = p /
            sqrt(0.299 / minOverMax / minOverMax + 0.587 * part * part + 0.114);
        r = (b) / minOverMax;
        g = (b) + hLocal * ((r) - (b));
      } else if (hLocal < 2.0 / 6.0) {
        hLocal = 6.0 * (-hLocal + 2.0 / 6.0);
        part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
        b = p /
            sqrt(0.587 / minOverMax / minOverMax + 0.299 * part * part + 0.114);
        g = (b) / minOverMax;
        r = (b) + hLocal * ((g) - (b));
      } else if (hLocal < 3.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 2.0 / 6.0);
        part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
        r = p /
            sqrt(0.587 / minOverMax / minOverMax + 0.114 * part * part + 0.299);
        g = (r) / minOverMax;
        b = (r) + hLocal * ((g) - (r));
      } else if (hLocal < 4.0 / 6.0) {
        hLocal = 6.0 * (-hLocal + 4.0 / 6.0);
        part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
        r = p /
            sqrt(0.114 / minOverMax / minOverMax + 0.587 * part * part + 0.299);
        b = (r) / minOverMax;
        g = (r) + hLocal * ((b) - (r));
      } else if (hLocal < 5.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 4.0 / 6.0);
        part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
        g = p /
            sqrt(0.114 / minOverMax / minOverMax + 0.299 * part * part + 0.587);
        b = (g) / minOverMax;
        r = (g) + hLocal * ((b) - (g));
      } else {
        hLocal = 6.0 * (-hLocal + 6.0 / 6.0);
        part = 1.0 + hLocal * (1.0 / minOverMax - 1.0);
        g = p /
            sqrt(0.299 / minOverMax / minOverMax + 0.114 * part * part + 0.587);
        r = (g) / minOverMax;
        b = (g) + hLocal * ((r) - (g));
      }
    } else {
      double hLocal = h;
      if (hLocal < 1.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 0.0 / 6.0);
        r = sqrt(p *
            p /
            (0.299 +
                0.587 * hLocal * hLocal +
                0.114 * (1.0 - hLocal) * (1.0 - hLocal)));
        g = sqrt(p *
            p /
            (0.299 / hLocal / hLocal +
                0.587 +
                0.114 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)));
        b = 0.0;
      } else if (hLocal < 2.0 / 6.0) {
        hLocal = 6.0 * (-hLocal + 2.0 / 6.0);
        g = sqrt(p *
            p /
            (0.587 +
                0.299 * hLocal * hLocal +
                0.114 * (1.0 - hLocal) * (1.0 - hLocal)));
        r = sqrt(p *
            p /
            (0.587 / hLocal / hLocal +
                0.299 +
                0.114 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)));
        b = 0.0;
      } else if (hLocal < 3.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 2.0 / 6.0);
        g = sqrt(p *
            p /
            (0.587 +
                0.114 * hLocal * hLocal +
                0.299 * (1.0 - hLocal) * (1.0 - hLocal)));
        b = sqrt(p *
            p /
            (0.587 / hLocal / hLocal +
                0.114 +
                0.299 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)));
        r = 0.0;
      } else if (hLocal < 4.0 / 6.0) {
        hLocal = 6.0 * (-hLocal + 4.0 / 6.0);
        b = sqrt(p *
            p /
            (0.114 +
                0.587 * hLocal * hLocal +
                0.299 * (1.0 - hLocal) * (1.0 - hLocal)));
        g = sqrt(p *
            p /
            (0.114 / hLocal / hLocal +
                0.587 +
                0.299 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)));
        r = 0.0;
      } else if (hLocal < 5.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 4.0 / 6.0);
        b = sqrt(p *
            p /
            (0.114 +
                0.299 * hLocal * hLocal +
                0.587 * (1.0 - hLocal) * (1.0 - hLocal)));
        r = sqrt(p *
            p /
            (0.114 / hLocal / hLocal +
                0.299 +
                0.587 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)));
        g = 0.0;
      } else {
        hLocal = 6.0 * (-hLocal + 6.0 / 6.0);
        r = sqrt(p *
            p /
            (0.299 +
                0.114 * hLocal * hLocal +
                0.587 * (1.0 - hLocal) * (1.0 - hLocal)));
        b = sqrt(p *
            p /
            (0.299 / hLocal / hLocal +
                0.114 +
                0.587 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)));
        g = 0.0;
      }
    }

    final int alphaInt = (alpha * 255).round();
    final int redInt = (r * 255).round().clamp(0, 255);
    final int greenInt = g.int255FromNormalized0to1();
    final int blueInt = (b * 255).round().clamp(0, 255);

    return (alphaInt << 24) | (redInt << 16) | (greenInt << 8) | blueInt;
  }

  @override
  ColorIQ toColor() => ColorIQ(HSP.hexIdFromHSP(h, s, p));

  /// Converts this color to HSP.
  static HSP fromInt(final int argb) {
    final double r = argb.r;
    final double g = argb.g;
    final double b = argb.b;

    final double p = sqrt(0.299 * r * r + 0.587 * g * g + 0.114 * b * b);

    final double minVal = min(r, min(g, b));
    final double maxVal = max(r, max(g, b));
    final double delta = maxVal - minVal;

    double h = 0;
    if (delta != 0) {
      if (maxVal == r) {
        h = (g - b) / delta;
      } else if (maxVal == g) {
        h = 2 + (b - r) / delta;
      } else {
        h = 4 + (r - g) / delta;
      }
      h *= 60;
      if (h < 0) h += 360;
    }

    final double s = (maxVal == 0) ? 0 : delta / maxVal;

    return HSP(h, s, p);
  }

  @override
  HSP darken([final double amount = 20]) {
    return HSP(h, s, max(0.0, p - amount / 100), alpha: alpha);
  }

  @override
  HSP brighten([final double amount = 20]) {
    return HSP(h, s, min(1.0, p + amount / 100), alpha: alpha);
  }

  @override
  HSP lighten([final double amount = 20]) {
    return HSP(h, s, min(1.0, p + amount / 100), alpha: alpha);
  }

  @override
  HSP saturate([final double amount = 25]) {
    return HSP(h, min(1.0, s + amount / 100), p, alpha: alpha);
  }

  @override
  HSP desaturate([final double amount = 25]) {
    return HSP(h, max(0.0, s - amount / 100), p, alpha: alpha);
  }

  HSP intensify([final double amount = 10]) {
    return HSP(h, min(1.0, s + amount / 100), p, alpha: alpha);
  }

  HSP deintensify([final double amount = 10]) {
    return HSP(h, max(0.0, s - amount / 100), p, alpha: alpha);
  }

  @override
  HSP accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  HSP simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).hsp;
  }

  @override
  HSP whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HSP blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HSP lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HSP otherHsp = other is HSP ? other : other.toColor().hsp;
    if (t == 1.0) {
      return otherHsp;
    }

    return HSP(
      lerpHue(h, otherHsp.h, t),
      lerpDouble(s, otherHsp.s, t),
      lerpDouble(p, otherHsp.p, t),
    );
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HSP copyWith({
    final double? h,
    final double? s,
    final double? p,
    final Percent? alpha,
  }) {
    return HSP(h ?? this.h, s ?? this.s, p ?? this.p, alpha: alpha ?? super.a);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).hsp)
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).hsp)
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).hsp)
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).hsp;

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  HSP blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).hsp;

  @override
  HSP opaquer([final double amount = 20]) => toColor().opaquer(amount).hsp;

  @override
  HSP adjustHue([final double amount = 20]) => toColor().adjustHue(amount).hsp;

  @override
  HSP get complementary => toColor().complementary.hsp;

  @override
  HSP warmer([final double amount = 20]) => toColor().warmer(amount).hsp;

  @override
  HSP cooler([final double amount = 20]) => toColor().cooler(amount).hsp;

  @override
  List<HSP> generateBasicPalette() =>
      toColor().generateBasicPalette().map((final ColorIQ c) => c.hsp).toList();

  @override
  List<HSP> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.hsp).toList();

  @override
  List<HSP> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.hsp)
          .toList();

  @override
  List<HSP> square() =>
      toColor().square().map((final ColorIQ c) => c.hsp).toList();

  @override
  List<HSP> tetrad({final double offset = 60}) =>
      toColor().tetrad(offset: offset).map((final ColorIQ c) => c.hsp).toList();

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'HspColor',
      'hue': h,
      'saturation': s,
      'perceivedBrightness': p,
      'alpha': alpha,
    };
  }

  @override
  String toString() =>
      'HspColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, p: ${p.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';
}
