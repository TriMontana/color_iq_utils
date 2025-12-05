import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:material_color_utilities/hct/cam16.dart';

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
class HspColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The hue component of the color, ranging from 0.0 to 1.0.
  final double h;

  /// The saturation component of the color, ranging from 0.0 to 1.0.
  final double s;

  /// The perceived brightness component of the color, ranging from 0.0 to 1.0.
  final double p;

  /// The alpha channel of the color, ranging from 0.0 (transparent) to 1.0 (opaque).
  Percent get alpha => super.a;

  /// Creates a new `HspColor`.
  const HspColor(this.h, this.s, this.p,
      {final Percent alpha = Percent.max, required final int hexId})
      : super(hexId, a: alpha);

  /// Creates a new `HspColor`.
  HspColor.alt(this.h, this.s, this.p,
      {final Percent alpha = Percent.max, final int? hexId})
      : super(hexId ?? toHex(h, s, p, alpha), a: alpha);

  /// Creates a 32-bit hex ID/ARGB from this class's properties.
  /// This is a standalone static method for conversion.
  static int toHex(final double h, final double s, final double p,
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
    final int greenInt = (g * 255).round().clamp(0, 255);
    final int blueInt = (b * 255).round().clamp(0, 255);

    return (alphaInt << 24) | (redInt << 16) | (greenInt << 8) | blueInt;
  }

  @override
  ColorIQ toColor() {
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
        r = sqrt(
          p *
              p /
              (0.299 +
                  0.587 * hLocal * hLocal +
                  0.114 * (1.0 - hLocal) * (1.0 - hLocal)),
        );
        g = sqrt(
          p *
              p /
              (0.299 / hLocal / hLocal +
                  0.587 +
                  0.114 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)),
        );
        b = 0.0;
      } else if (hLocal < 2.0 / 6.0) {
        hLocal = 6.0 * (-hLocal + 2.0 / 6.0);
        g = sqrt(
          p *
              p /
              (0.587 +
                  0.299 * hLocal * hLocal +
                  0.114 * (1.0 - hLocal) * (1.0 - hLocal)),
        );
        r = sqrt(
          p *
              p /
              (0.587 / hLocal / hLocal +
                  0.299 +
                  0.114 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)),
        );
        b = 0.0;
      } else if (hLocal < 3.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 2.0 / 6.0);
        g = sqrt(
          p *
              p /
              (0.587 +
                  0.114 * hLocal * hLocal +
                  0.299 * (1.0 - hLocal) * (1.0 - hLocal)),
        );
        b = sqrt(
          p *
              p /
              (0.587 / hLocal / hLocal +
                  0.114 +
                  0.299 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)),
        );
        r = 0.0;
      } else if (hLocal < 4.0 / 6.0) {
        hLocal = 6.0 * (-hLocal + 4.0 / 6.0);
        b = sqrt(
          p *
              p /
              (0.114 +
                  0.587 * hLocal * hLocal +
                  0.299 * (1.0 - hLocal) * (1.0 - hLocal)),
        );
        g = sqrt(
          p *
              p /
              (0.114 / hLocal / hLocal +
                  0.587 +
                  0.299 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)),
        );
        r = 0.0;
      } else if (hLocal < 5.0 / 6.0) {
        hLocal = 6.0 * (hLocal - 4.0 / 6.0);
        b = sqrt(
          p *
              p /
              (0.114 +
                  0.299 * hLocal * hLocal +
                  0.587 * (1.0 - hLocal) * (1.0 - hLocal)),
        );
        r = sqrt(
          p *
              p /
              (0.114 / hLocal / hLocal +
                  0.299 +
                  0.587 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)),
        );
        g = 0.0;
      } else {
        hLocal = 6.0 * (-hLocal + 6.0 / 6.0);
        r = sqrt(
          p *
              p /
              (0.299 +
                  0.114 * hLocal * hLocal +
                  0.587 * (1.0 - hLocal) * (1.0 - hLocal)),
        );
        b = sqrt(
          p *
              p /
              (0.299 / hLocal / hLocal +
                  0.114 +
                  0.587 * (1.0 / hLocal - 1.0) * (1.0 / hLocal - 1.0)),
        );
        g = 0.0;
      }
    }

    return ColorIQ.fromARGB(
      (alpha * 255).round(),
      (r * 255).round().clamp(0, 255),
      (g * 255).round().clamp(0, 255),
      (b * 255).round().clamp(0, 255),
    );
  }

  @override
  int get value => toColor().value;

  @override
  HspColor darken([final double amount = 20]) {
    return HspColor.alt(h, s, max(0.0, p - amount / 100), alpha: alpha);
  }

  @override
  HspColor brighten([final double amount = 20]) {
    return HspColor.alt(h, s, min(1.0, p + amount / 100), alpha: alpha);
  }

  @override
  HspColor lighten([final double amount = 20]) {
    return HspColor.alt(h, s, min(1.0, p + amount / 100), alpha: alpha);
  }

  @override
  HspColor saturate([final double amount = 25]) {
    return HspColor.alt(h, min(1.0, s + amount / 100), p, alpha: alpha);
  }

  @override
  HspColor desaturate([final double amount = 25]) {
    return HspColor.alt(h, max(0.0, s - amount / 100), p, alpha: alpha);
  }

  @override
  HspColor intensify([final double amount = 10]) {
    return HspColor.alt(h, min(1.0, s + amount / 100), p, alpha: alpha);
  }

  @override
  HspColor deintensify([final double amount = 10]) {
    return HspColor.alt(h, max(0.0, s - amount / 100), p, alpha: alpha);
  }

  @override
  HspColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  HspColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsp();
  }

  @override
  HspColor get inverted => toColor().inverted.toHsp();

  @override
  HspColor get grayscale => toColor().grayscale.toHsp();

  @override
  HspColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HspColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HspColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HspColor otherHsp =
        other is HspColor ? other : other.toColor().toHsp();
    if (t == 1.0) {
      return otherHsp;
    }

    return HspColor.alt(
      lerpHue(h, otherHsp.h, t),
      lerpDouble(s, otherHsp.s, t),
      lerpDouble(p, otherHsp.p, t),
    );
  }

  @override
  HspColor fromHct(final HctColor hct) => hct.toColor().toHsp();

  @override
  HspColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsp();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  HspColor copyWith({
    final double? h,
    final double? s,
    final double? p,
    final Percent? alpha,
  }) {
    return HspColor.alt(h ?? this.h, s ?? this.s, p ?? this.p,
        alpha: alpha ?? super.a);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsp())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsp())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsp())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsp();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;
  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HspColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHsp();

  @override
  HspColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHsp();

  @override
  HspColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toHsp();

  @override
  HspColor get complementary => toColor().complementary.toHsp();

  @override
  HspColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHsp();

  @override
  HspColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHsp();

  @override
  List<HspColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHsp())
      .toList();

  @override
  List<HspColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHsp()).toList();

  @override
  List<HspColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHsp())
          .toList();

  @override
  List<HspColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHsp()).toList();

  @override
  List<HspColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHsp())
      .toList();

  @override
  double distanceTo(final ColorSpacesIQ other) => toColor().distanceTo(other);

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

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

  @override
  Cam16 toCam16() => Cam16.fromInt(value);
}
