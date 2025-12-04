import 'dart:math';

import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// A representation of a color in the HSB (Hue, Saturation, Brightness) color space.
///
/// HSB is often used in design and graphics applications. It's an alternative name for
/// the HSV (Hue, Saturation, Value) color model, where Brightness corresponds to Value.
///
/// - `h` (Hue): The type of color, represented as an angle from 0 to 360 degrees.
/// - `s` (Saturation): The intensity of the color, from 0 (grayscale) to 1 (fully saturated).
/// - `b` (Brightness): The lightness of the color, from 0 (black) to 1 (full brightness).
class HsbColor extends ColorSpacesIQ with ColorModelsMixin {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The saturation component of the color, ranging from 0.0 to 1.0.
  final double s;

  /// The brightness component of the color, ranging from 0.0 to 1.0.
  @override
  final double b;

  const HsbColor(this.h, this.s, this.b, {required final int hexId})
      : super(hexId);
  HsbColor.alt(this.h, this.s, this.b, {final int? hexId})
      : super(hexId ?? HsbColor.argbFromHsb(h, s, b));

  /// Creates a 32-bit ARGB hex value from HSB components.
  ///
  /// `h` is hue (0-360), `s` is saturation (0-1), and `b` is brightness (0-1).
  /// An optional `alpha` (0-255) can be provided. Defaults to 255 (opaque).
  static int argbFromHsb(double h, double s, double b,
      [final int alpha = 255]) {
    h = h.clamp(0, 360);
    s = s.clamp(0.0, 1.0);
    b = b.clamp(0.0, 1.0);

    final double c = b * s;
    final double hPrime = h / 60.0;
    final double x = c * (1 - (hPrime % 2 - 1).abs());
    final double m = b - c;

    double r, g, bTemp;
    if (hPrime < 1) {
      r = c;
      g = x;
      bTemp = 0;
    } else if (hPrime < 2) {
      r = x;
      g = c;
      bTemp = 0;
    } else if (hPrime < 3) {
      r = 0;
      g = c;
      bTemp = x;
    } else if (hPrime < 4) {
      r = 0;
      g = x;
      bTemp = c;
    } else if (hPrime < 5) {
      r = x;
      g = 0;
      bTemp = c;
    } else {
      r = c;
      g = 0;
      bTemp = x;
    }
    return (alpha.clamp(0, 255) << 24) |
        (((r + m) * 255).round() << 16) |
        (((g + m) * 255).round() << 8) |
        ((bTemp + m) * 255).round();
  }

  @override
  ColorIQ toColor() {
    // HSB is the same as HSV, just B instead of V
    return HsvColor(h, s, b).toColor();
  }

  @override
  int get value => toColor().value;

  @override
  HsbColor darken([final double amount = 20]) {
    return HsbColor(h, s, max(0.0, b - amount / 100));
  }

  @override
  HsbColor brighten([final double amount = 20]) {
    return HsbColor(h, s, min(1.0, b + amount / 100));
  }

  @override
  HsbColor saturate([final double amount = 25]) {
    return HsbColor(h, min(1.0, s + amount / 100), b);
  }

  @override
  HsbColor desaturate([final double amount = 25]) {
    return HsbColor.alt(h, max(0.0, s - amount / 100), b);
  }

  @override
  HsbColor intensify([final double amount = 10]) {
    return HsbColor.alt(h, min(1.0, s + amount / 100), b);
  }

  @override
  HsbColor deintensify([final double amount = 10]) {
    return HsbColor(h, max(0.0, s - amount / 100), b);
  }

  @override
  HsbColor accented([final double amount = 15]) {
    return intensify(amount);
  }

  @override
  HsbColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHsb();
  }

  @override
  HsbColor get inverted => toColor().inverted.toHsb();

  @override
  HsbColor get grayscale => toColor().grayscale.toHsb();

  @override
  HsbColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HsbColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HsbColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final HsbColor otherHsb =
        other is HsbColor ? other : other.toColor().toHsb();
    if (t == 1.0) return otherHsb;

    return HsbColor(
      lerpHue(h, otherHsb.h, t),
      lerpDouble(s, otherHsb.s, t),
      lerpDouble(b, otherHsb.b, t),
    );
  }

  @override
  HsbColor lighten([final double amount = 20]) {
    return HsbColor(h, s, min(1.0, b + amount / 100));
  }

  @override
  HsbColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHsb();
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature {
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (h >= 90 && h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  HsbColor copyWith({final double? h, final double? s, final double? b}) {
    return HsbColor.alt(h ?? this.h, s ?? this.s, b ?? this.b);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor()
      .monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsb())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsb())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHsb())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHsb();

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
  HsbColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHsb();

  @override
  HsbColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHsb();

  @override
  HsbColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toHsb();

  @override
  HsbColor get complementary => toColor().complementary.toHsb();

  @override
  HsbColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHsb();

  @override
  HsbColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHsb();

  @override
  List<HsbColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHsb())
      .toList();

  @override
  List<HsbColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHsb()).toList();

  @override
  List<HsbColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHsb())
          .toList();

  @override
  List<HsbColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHsb()).toList();

  @override
  List<HsbColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHsb())
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
      'type': 'HsbColor',
      'hue': h,
      'saturation': s,
      'brightness': b,
      'alpha': 1.0 - transparency, // Assuming alpha is 1 - transparency
    };
  }

  @override
  String toString() =>
      'HsbColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';

  @override
  Cam16 toCam16() => Cam16.fromInt(value);
}
