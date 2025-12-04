import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:material_color_utilities/hct/cam16.dart';

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
class OkHslColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The saturation component of the color, ranging from 0.0 to 1.0.
  final double s;

  /// The lightness component of the color, ranging from 0.0 to 1.0.
  final double l;

  /// Creates an `OkHslColor` instance.
  const OkHslColor(this.h, this.s, this.l, {required final int hexId})
      : super(hexId);
  OkHslColor.alt(this.h, this.s, this.l, {final int? hexId})
      : super(hexId ?? OkHslColor.hexIdFromHsl(h, s, l));

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
    final double L = l;
    final double C = s * 0.4; // Approximation
    final double hue = h;

    return OkLchColor(L, C, hue).toColor().value;
  }

  @override
  ColorIQ toColor() {
    // Approximate conversion via OkLch
    // s is roughly c/0.4 for s=1.
    // l is roughly L.

    final double L = l;
    final double C = s * 0.4; // Approximation
    final double hue = h;

    return OkLchColor(L, C, hue).toColor();
  }

  @override
  OkHslColor darken([final double amount = 20]) {
    return OkHslColor(h, s, max(0.0, l - amount / 100));
  }

  @override
  OkHslColor get inverted => toColor().inverted.toOkHsl();

  @override
  OkHslColor get grayscale => toColor().grayscale.toOkHsl();

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
    if (newHue < 0) newHue += 360;

    return OkHslColor.alt(
      newHue,
      thisS + (otherS - thisS) * t,
      l + (otherOkHsl.l - l) * t,
    );
  }

  @override
  OkHslColor lighten([final double amount = 20]) {
    return OkHslColor.alt(h, s, min(1.0, l + amount / 100));
  }

  @override
  OkHslColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toOkHsl();
  }

  @override
  OkHslColor saturate([final double amount = 25]) {
    return OkHslColor.alt(h, min(1.0, s + amount / 100), l);
  }

  @override
  OkHslColor desaturate([final double amount = 25]) {
    return OkHslColor.alt(h, max(0.0, s - amount / 100), l);
  }

  @override
  OkHslColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
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



  @override
  OkHslColor fromHct(final HctColor hct) => hct.toColor().toOkHsl();

  @override
  OkHslColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toOkHsl();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  OkHslColor copyWith({final double? h, final double? s, final double? l}) {
    return OkHslColor(h ?? this.h, s ?? this.s, l ?? this.l);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsl())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsl())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toOkHsl())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toOkHsl();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  OkHslColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toOkHsl();

  @override
  OkHslColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toOkHsl();

  @override
  OkHslColor adjustHue([final double amount = 20]) {
    double newHue = (h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return OkHslColor.alt(newHue, s, l);
  }

  @override
  OkHslColor get complementary => adjustHue(180);

  @override
  OkHslColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toOkHsl();

  @override
  OkHslColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toOkHsl();

  @override
  List<OkHslColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toOkHsl())
      .toList();

  @override
  List<OkHslColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toOkHsl())
          .toList();

  @override
  List<OkHslColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toOkHsl()).toList();

  @override
  List<OkHslColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toOkHsl())
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
      'type': 'OkHslColor',
      'hue': h,
      'saturation': s,
      'lightness': l,
      'alpha': transparency,
    };
  }

  @override
  String toString() =>
      'OkHslColor(h: ${h.toStrTrimZeros(3)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';

  @override
  Cam16 toCam16() => Cam16.fromInt(value);
}
