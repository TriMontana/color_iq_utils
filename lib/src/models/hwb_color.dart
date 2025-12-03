import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// A representation of color in the HWB (Hue, Whiteness, Blackness) color model.
///
/// HWB is designed to be more intuitive for humans to understand. It's a cylindrical
/// representation of the RGB color model, similar to HSL and HSV.
///
/// - **Hue (h):** The type of color, represented as an angle from 0 to 360 degrees.
///   0 is red, 120 is green, 240 is blue.
/// - **Whiteness (w):** The amount of white mixed with the hue, from 0 to 1 (or 0% to 100%).
/// - **Blackness (b):** The amount of black mixed with the hue, from 0 to 1 (or 0% to 100%).
///
/// One constraint of the HWB model is that the sum of whiteness and blackness
/// cannot exceed 1 (or 100%). If `w + b > 1`, the values are normalized.
///
/// This class provides methods to convert HWB colors to other color spaces,
/// perform color manipulations (like darkening, saturating), and generate color palettes.
class HwbColor with ColorModelsMixin implements ColorSpacesIQ {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The whiteness component of the color, ranging from 0.0 to 1.0.
  final double w;

  /// The blackness component of the color, ranging from 0.0 to 1.0.
  final double b;

  /// The alpha (transparency) component of the color, ranging from 0.0 to 1.0.
  final double alpha;

  const HwbColor(this.h, this.w, this.b, [this.alpha = 1.0]);

  @override
  ColorIQ toColor() {
    final double ratio = w + b;
    double wNorm = w;
    double bNorm = b;
    if (ratio > 1) {
      wNorm /= ratio;
      bNorm /= ratio;
    }

    final double v = 1 - bNorm;
    final double s = (v == 0) ? 0 : 1 - wNorm / v;

    return HsvColor(h, s, v, alpha).toColor();
  }

  @override
  int get value => toColor().value;

  @override
  HwbColor darken([final double amount = 20]) {
    return toColor().darken(amount).toHwb();
  }

  @override
  HwbColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toHwb();
  }

  @override
  HwbColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).toHwb();
  }

  @override
  HwbColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toHwb();
  }

  @override
  HwbColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toHwb();
  }

  @override
  HwbColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toHwb();
  }

  @override
  HwbColor accented([final double amount = 15]) {
    return toColor().accented(amount).toHwb();
  }

  @override
  HwbColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toHwb();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  HwbColor get inverted => toColor().inverted.toHwb();

  @override
  HwbColor get grayscale => toColor().grayscale.toHwb();

  @override
  HwbColor whiten([final double amount = 20]) =>
      toColor().whiten(amount).toHwb();

  @override
  HwbColor blacken([final double amount = 20]) =>
      toColor().blacken(amount).toHwb();

  @override
  HwbColor lerp(final ColorSpacesIQ other, final double t) =>
      (toColor().lerp(other, t) as ColorIQ).toHwb();

  @override
  HwbColor lighten([final double amount = 20]) {
    return toColor().lighten(amount).toHwb();
  }

  @override
  HctColor toHct() => toColor().toHct();

  @override
  HwbColor fromHct(final HctColor hct) => hct.toColor().toHwb();

  @override
  HwbColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toHwb();
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
  HwbColor copyWith({
    final double? h,
    final double? w,
    final double? b,
    final double? alpha,
  }) {
    return HwbColor(h ?? this.h, w ?? this.w, b ?? this.b, alpha ?? this.alpha);
  }

  @override
  List<ColorSpacesIQ> get monochromatic => toColor().monochromatic
      .map((final ColorSpacesIQ c) => (c as ColorIQ).toHwb())
      .toList();

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toColor()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHwb())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toColor()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as ColorIQ).toHwb())
        .toList();
  }

  @override
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toHwb();

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
  HwbColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toHwb();

  @override
  HwbColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toHwb();

  @override
  HwbColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toHwb();

  @override
  HwbColor get complementary => toColor().complementary.toHwb();

  @override
  HwbColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toHwb();

  @override
  HwbColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toHwb();

  @override
  List<HwbColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toHwb())
      .toList();

  @override
  List<HwbColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toHwb()).toList();

  @override
  List<HwbColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toHwb())
          .toList();

  @override
  List<HwbColor> square() =>
      toColor().square().map((final ColorIQ c) => c.toHwb()).toList();

  @override
  List<HwbColor> tetrad({final double offset = 60}) => toColor()
      .tetrad(offset: offset)
      .map((final ColorIQ c) => c.toHwb())
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
      'type': 'HwbColor',
      'hue': h,
      'whiteness': w,
      'blackness': b,
      'alpha': alpha,
    };
  }

  @override
  String toString() =>
      'HwbColor(h: ${h.toStrTrimZeros(3)}, w: ${w.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)}, alpha: ${alpha.toStringAsFixed(2)})';

  @override
  Cam16 toCam16() => Cam16.fromInt(value);
}
