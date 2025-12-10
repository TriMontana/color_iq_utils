import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

/// A representation of a color in the HSB (Hue, Saturation, Brightness) color space.
///
/// HSB is often used in design and graphics applications. It's an alternative name for
/// the HSV (Hue, Saturation, Value) color model, where Brightness corresponds to Value.
///
/// - `h` (Hue): The type of color, represented as an angle from 0 to 360 degrees.
/// - `s` (Saturation): The intensity of the color, from 0 (grayscale) to 1 (fully saturated).
/// - `b` (Brightness): The lightness of the color, from 0 (black) to 1 (full brightness).
class HsbColor extends CommonIQ implements ColorSpacesIQ {
  /// The hue component of the color, ranging from 0 to 360.
  final double h;

  /// The saturation component of the color, ranging from 0.0 to 1.0.
  final double s;

  /// The brightness component of the color, ranging from 0.0 to 1.0.

  final Percent brightnessHsb;

  /// Creates a new HSB color from its component values.
  ///
  /// `h` is hue (0-360), `s` is saturation (0-1), and `b` is brightness (0-1).
  /// An optional `alpha` (0-255) can be provided. Defaults to 255 (opaque).
  const HsbColor(this.h, this.s, this.brightnessHsb,
      {final int? argb,
      final Percent alpha = Percent.max,
      final List<String> names = kEmptyNames})
      : super(argb, names: names, alpha: alpha);

  @override
  int get value => super.colorId ?? HsbColor.hexIdFromHsb(h, s, brightnessHsb);

// Note: THERE are two methods to ops HSB to ARGB
// This function takes hue (0-360 degrees), saturation (0-1), and
// brightness (0-1) as inputs and returns a 32-bit integer in ARGB format (with full opacity). If you're using this in a context
// like Flutter, you can pass the result to Color(value) for rendering.
  static int hexIdFromHSB(
      double hue, final double saturation, final double brightness) {
    // Normalize hue to 0-360
    hue = hue % 360;
    if (hue < 0) {
      hue += 360;
    }

    // Handle achromatic case
    if (saturation == 0) {
      final int val = (brightness * 255).round();
      return 0xFF000000 | (val << 16) | (val << 8) | val;
    }

    final double h = hue / 60;
    final int i = h.floor();
    final double f = h - i;
    final double p = brightness * (1 - saturation);
    final double q = brightness * (1 - saturation * f);
    final double t = brightness * (1 - saturation * (1 - f));

    double r, g, b;
    switch (i) {
      case 0:
        r = brightness;
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        g = brightness;
        b = p;
        break;
      case 2:
        r = p;
        g = brightness;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        b = brightness;
        break;
      case 4:
        r = t;
        g = p;
        b = brightness;
        break;
      case 5:
        r = brightness;
        g = p;
        b = q;
        break;
      default:
        r = 0;
        g = 0;
        b = 0;
    }

    final int ir = (r * 255).round();
    final int ig = (g * 255).round();
    final int ib = (b * 255).round();

    // Return 32-bit ARGB color (alpha=255)
    return 0xFF000000 | (ir << 16) | (ig << 8) | ib;
  }

  // // Note: THERE are two methods to ops HSB to ARGB
  /// Creates a 32-bit ARGB hex value from HSB components.
  ///
  /// `h` is hue (0-360), `s` is saturation (0-1), and `b` is brightness (0-1).
  /// An optional `alpha` (0-255) can be provided. Defaults to 255 (opaque).
  static int hexIdFromHsb(double h, double s, double b,
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

  static HsbColor fromInt(final int color) {
    // Extract RGB components (ignore alpha)
    final int r = (color >> 16) & 0xFF;
    final int g = (color >> 8) & 0xFF;
    final int b = color & 0xFF;

    final double red = r / 255.0;
    final double green = g / 255.0;
    final double blue = b / 255.0;

    final double maxVal = <double>[red, green, blue]
        .reduce((final double a, final double b) => a > b ? a : b);
    final double minVal = <double>[red, green, blue]
        .reduce((final double a, final double b) => a < b ? a : b);
    final double delta = maxVal - minVal;

    double hue = 0.0;
    double saturation = 0.0;
    final double brightness = maxVal;

    if (delta > 0) {
      if (maxVal == red) {
        hue = ((green - blue) / delta) % 6;
      } else if (maxVal == green) {
        hue = ((blue - red) / delta) + 2;
      } else {
        hue = ((red - green) / delta) + 4;
      }
      hue *= 60;
      if (hue < 0) hue += 360;

      saturation = (maxVal == 0) ? 0 : delta / maxVal;
    }

    return HsbColor(hue, saturation, Percent(brightness), argb: color);
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  @override
  HsbColor darken([final double amount = 20]) {
    final double q = max(0.0, brightnessHsb.val - amount / 100);
    return copyWith(b: Percent(q));
  }

  @override
  HsbColor brighten([final double amount = 20]) {
    final double q = min(1.0, brightnessHsb.val + amount / 100);
    return copyWith(b: Percent(q));
  }

  @override
  HsbColor saturate([final double amount = 25]) =>
      HsbColor(h, min(1.0, s + amount / 100), b);

  @override
  HsbColor desaturate([final double amount = 25]) =>
      HsbColor(h, max(0.0, s - amount / 100), b);

  HsbColor intensify([final double amount = 10]) =>
      HsbColor(h, min(1.0, s + amount / 100), b);

  HsbColor deintensify([final double amount = 10]) =>
      HsbColor(h, max(0.0, s - amount / 100), b);

  @override
  HsbColor accented([final double amount = 15]) => intensify(amount);

  @override
  HsbColor simulate(final ColorBlindnessType type) {
    // Convert to RGB
    final int argb = HsbColor.hexIdFromHsb(h, s, b);
    final int r = (argb >> 16) & 0xFF;
    final int g = (argb >> 8) & 0xFF;
    final int bVal = argb & 0xFF;

    // Convert to Linear RGB
    final List<double> linear = rgbToLinearRgb(r, g, bVal);

    // Simulate
    final List<double> simulated = ColorBlindness.simulate(
      linear[0],
      linear[1],
      linear[2],
      type,
    );

    // Convert back to sRGB (Gamma Corrected)
    final int rSim = (linearToSrgb(simulated[0]) * 255).round().clamp(0, 255);
    final int gSim = (linearToSrgb(simulated[1]) * 255).round().clamp(0, 255);
    final int bSim = (linearToSrgb(simulated[2]) * 255).round().clamp(0, 255);

    return _fromRgb(rSim, gSim, bSim);
  }

  HsbColor get grayscale =>
      HsbColor(0, 0, Percent(brightnessHsb.val * (1 - s / 2)));

  @override
  HsbColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  HsbColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  HsbColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final HsbColor otherHsb =
        other is HsbColor ? other : other.toColor().toHsb();
    if (t == 1.0) return otherHsb;

    return HsbColor(
      lerpHue(h, otherHsb.h, t),
      lerpDouble(s, otherHsb.s, t),
      brightnessHsb.lerpTo(otherHsb.brightnessHsb.val, t),
    );
  }

  @override
  HsbColor lighten([final double amount = 20]) =>
      HsbColor(h, s, Percent(min(1.0, brightnessHsb.val + amount / 100)));

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
  HsbColor copyWith({final double? h, final double? s, final Percent? b}) {
    return HsbColor(h ?? this.h, s ?? this.s, b ?? brightnessHsb);
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Generate 5 variations based on brightness.
    final List<HsbColor> results = <HsbColor>[];
    for (int i = 0; i < 5; i++) {
      // -2, -1, 0, 1, 2
      final double delta = (i - 2) * 10.0;
      final double newB = (b * 100 + delta).clamp(0.0, 100.0);
      results.add(HsbColor(h, s, Percent(newB / 100)));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final double sVal = step ?? 10.0;
    final List<HsbColor> colors = <HsbColor>[];
    // Generate 3 lighter shades
    for (int i = 1; i <= 3; i++) {
      colors.add(lighten(sVal * i));
    }
    return colors;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final double sVal = step ?? 10.0;
    final List<HsbColor> colors = <HsbColor>[];
    // Generate 3 darker shades
    for (int i = 1; i <= 3; i++) {
      colors.add(darken(sVal * i));
    }
    return colors;
  }

  @override
  ColorSpacesIQ get random {
    final Random rng = Random();
    return HsbColor(
      rng.nextDouble() * 360,
      rng.nextDouble(),
      Percent(rng.nextDouble()),
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is! HsbColor) return false;
    const double epsilon = 0.001;
    return (h - other.h).abs() < epsilon &&
        (s - other.s).abs() < epsilon &&
        (b - other.b).abs() < epsilon;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  HsbColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  HsbColor opaquer([final double amount = 20]) {
    final int currentAlpha = (value >> 24) & 0xFF;
    final int newAlpha =
        (currentAlpha + (amount / 100 * 255)).round().clamp(0, 255);
    final int newHexId = HsbColor.hexIdFromHsb(h, s, b, newAlpha);
    return HsbColor(h, s, b, argb: newHexId);
  }

  @override
  HsbColor adjustHue([final double amount = 20]) {
    return HsbColor((h + amount) % 360, s, b);
  }

  @override
  HsbColor get complementary => HsbColor((h + 180) % 360, s, b);

  @override
  HsbColor warmer([final double amount = 20]) {
    const double targetHue = 30.0;
    final double diff = differenceDegrees(targetHue, h);
    final double direction = rotationDirection(h, targetHue);
    final double newHue = h + (diff * amount / 100 * direction);
    return HsbColor(newHue % 360, s, b);
  }

  @override
  HsbColor cooler([final double amount = 20]) {
    const double targetHue = 210.0;
    final double diff = differenceDegrees(targetHue, h);
    final double direction = rotationDirection(h, targetHue);
    final double newHue = h + (diff * amount / 100 * direction);
    return HsbColor(newHue % 360, s, b);
  }

  @override
  List<HsbColor> generateBasicPalette() {
    return <HsbColor>[
      lighten(40),
      lighten(20),
      this,
      darken(20),
      darken(40),
    ];
  }

  @override
  List<HsbColor> tonesPalette() {
    // Mix with gray (0, 0, 0.5) which corresponds to 0xFF808080
    const HsbColor gray = HsbColor(0, 0, Percent(0.5));
    return <HsbColor>[
      this,
      lerp(gray, 0.15),
      lerp(gray, 0.30),
      lerp(gray, 0.45),
      lerp(gray, 0.60),
    ];
  }

  @override
  List<HsbColor> analogous({final int count = 5, final double offset = 30}) {
    final List<HsbColor> results = <HsbColor>[];
    final double step = (offset * 2) / (count - 1);
    final double startHue = (h - offset + 360) % 360;

    for (int i = 0; i < count; i++) {
      final double newHue = (startHue + step * i) % 360;
      results.add(HsbColor(newHue, s, b));
    }
    return results;
  }

  @override
  List<HsbColor> square() {
    return <HsbColor>[
      this,
      HsbColor((h + 90) % 360, s, b),
      HsbColor((h + 180) % 360, s, b),
      HsbColor((h + 270) % 360, s, b),
    ];
  }

  @override
  List<HsbColor> tetrad({final double offset = 60}) {
    return <HsbColor>[
      this,
      HsbColor((h + offset) % 360, s, b),
      HsbColor((h + 180) % 360, s, b),
      HsbColor((h + 180 + offset) % 360, s, b),
    ];
  }

  @override
  double get luminance {
    // Calculate luminance from HSB -> RGB -> Luminance
    // We can use argbFromHsb to get the int, then extract RGB and compute.
    final int argb = HsbColor.hexIdFromHsb(h, s, b);
    final int r = (argb >> 16) & 0xFF;
    final int g = (argb >> 8) & 0xFF;
    final int bVal = argb & 0xFF;
    return computeLuminanceViaInts(r, g, bVal);
  }

  @override
  double contrastWith(final ColorSpacesIQ other) {
    final double l1 = luminance;
    // ColorSpacesIQ might not have luminance getter exposed directly if it's not in the interface.
    // We can use toColor().luminance for the 'other' color as a fallback,
    // or cast if we know it has it. Safe bet is toColor().luminance or check interface.
    // Given the error, it's likely not in ColorSpacesIQ.
    final double l2 = other.toColor().luminance;
    final double lighter = max(l1, l2);
    final double darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

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
      'HsbColor(h: ${h.toStrTrimZeros(2)}, s: ${s.toStringAsFixed(2)}, ' //
      'b: ${b.toStringAsFixed(2)})';

  static HsbColor _fromRgb(final int r, final int g, final int b) {
    final double rd = r / 255.0;
    final double gd = g / 255.0;
    final double bd = b / 255.0;

    final double maxVal = max(rd, max(gd, bd));
    final double minVal = min(rd, min(gd, bd));
    double h, s, v = maxVal;

    final double d = maxVal - minVal;
    s = maxVal == 0 ? 0 : d / maxVal;

    if (maxVal == minVal) {
      h = 0; // achromatic
    } else {
      if (maxVal == rd) {
        h = (gd - bd) / d + (gd < bd ? 6 : 0);
      } else if (maxVal == gd) {
        h = (bd - rd) / d + 2;
      } else {
        h = (rd - gd) / d + 4;
      }
      h /= 6;
    }

    return HsbColor(h * 360, s, Percent(v));
  }
}
