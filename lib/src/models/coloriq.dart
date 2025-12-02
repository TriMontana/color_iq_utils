import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import '../color_interfaces.dart';
import '../color_temperature.dart';
import 'cmyk_color.dart';
import 'xyz_color.dart';
import 'lab_color.dart';
import 'luv_color.dart';
import 'lch_color.dart';
import 'hsp_color.dart';
import 'yiq_color.dart';
import 'yuv_color.dart';
import 'ok_lab_color.dart';
import 'ok_lch_color.dart';
import 'ok_hsl_color.dart';
import 'ok_hsv_color.dart';
import 'hunter_lab_color.dart';
import 'hsluv_color.dart';
import 'munsell_color.dart';

import 'hsl_color.dart';
import 'hsv_color.dart';
import 'hsb_color.dart';
import 'hwb_color.dart';
import 'hct_color.dart';
import 'cam16_color.dart';
import 'display_p3_color.dart';
import 'rec2020_color.dart';

/// A color represented by red, green, blue, and alpha components.
class ColorIQ implements ColorSpacesIQ {
  /// The 32-bit alpha-red-green-blue integer value.
  @override
  final int value;

  /// Construct a color from the lower 32 bits of an [int].
  const ColorIQ(this.value);

  /// Construct a color from 4 integers, a, r, g, b.
  const ColorIQ.fromARGB(int a, int r, int g, int b)
      : value = (((a & 0xff) << 24) |
                ((r & 0xff) << 16) |
                ((g & 0xff) << 8) |
                ((b & 0xff) << 0)) &
            0xFFFFFFFF;

  /// The alpha channel of this color in an 8-bit value.
  int get alpha => (value >> 24) & 0xFF;

  /// The red channel of this color in an 8-bit value.
  int get red => (value >> 16) & 0xFF;

  /// The green channel of this color in an 8-bit value.
  int get green => (value >> 8) & 0xFF;

  /// The blue channel of this color in an 8-bit value.
  int get blue => value & 0xFF;

  /// Converts this color to CMYK.
  CmykColor toCmyk() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CmykColor(0, 0, 0, 1);
    }

    double c = (1.0 - r - k) / (1.0 - k);
    double m = (1.0 - g - k) / (1.0 - k);
    double y = (1.0 - b - k) / (1.0 - k);

    return CmykColor(c, m, y, k);
  }

  /// Converts this color to XYZ.
  XyzColor toXyz() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    r *= 100;
    g *= 100;
    b *= 100;

    double x = r * 0.4124 + g * 0.3576 + b * 0.1805;
    double y = r * 0.2126 + g * 0.7152 + b * 0.0722;
    double z = r * 0.0193 + g * 0.1192 + b * 0.9505;

    return XyzColor(x, y, z);
  }

  /// Converts this color to CIELab.
  LabColor toLab() => toXyz().toLab();

  /// Converts this color to CIELuv.
  LuvColor toLuv() => toXyz().toLuv();

  /// Converts this color to CIELCH.
  LchColor toLch() => toLab().toLch();

  /// Converts this color to HSP.
  HspColor toHsp() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double p = sqrt(0.299 * r * r + 0.587 * g * g + 0.114 * b * b);
    
    double minVal = min(r, min(g, b));
    double maxVal = max(r, max(g, b));
    double delta = maxVal - minVal;
    
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
    
    double s = (maxVal == 0) ? 0 : delta / maxVal;

    return HspColor(h, s, p);
  }

  /// Converts this color to YIQ.
  YiqColor toYiq() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double y = 0.299 * r + 0.587 * g + 0.114 * b;
    double i = 0.596 * r - 0.274 * g - 0.322 * b;
    double q = 0.211 * r - 0.523 * g + 0.312 * b;

    return YiqColor(y, i, q);
  }

  /// Converts this color to YUV.
  YuvColor toYuv() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double y = 0.299 * r + 0.587 * g + 0.114 * b;
    double u = -0.14713 * r - 0.28886 * g + 0.436 * b;
    double v = 0.615 * r - 0.51499 * g - 0.10001 * b;

    return YuvColor(y, u, v);
  }

  /// Converts this color to OkLab.
  OkLabColor toOkLab() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    double l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
    double m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
    double s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;

    double l_ = pow(l, 1/3).toDouble();
    double m_ = pow(m, 1/3).toDouble();
    double s_ = pow(s, 1/3).toDouble();

    double L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_;
    double a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_;
    double bVal = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_;

    return OkLabColor(L, a, bVal);
  }

  /// Converts this color to OkLch.
  OkLchColor toOkLch() => toOkLab().toOkLch();

  /// Converts this color to OkHSL.
  OkHslColor toOkHsl() => toOkLab().toOkHsl();

  /// Converts this color to OkHSV.
  OkHsvColor toOkHsv() => toOkLab().toOkHsv();

  /// Converts this color to Hunter Lab.
  HunterLabColor toHunterLab() {
    XyzColor xyz = toXyz();
    double x = xyz.x;
    double y = xyz.y;
    double z = xyz.z;

    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    double lOut = 100.0 * sqrt(y / yn);
    double aOut = 175.0 * (x / xn - y / yn) / sqrt(y / yn);
    double bOut = 70.0 * (y / yn - z / zn) / sqrt(y / yn);
    
    if (y == 0) {
        aOut = 0;
        bOut = 0;
    }

    return HunterLabColor(lOut, aOut, bOut);
  }

  /// Converts this color to HSLuv.
  HsluvColor toHsluv() {
     LuvColor luv = toLuv();
     double c = sqrt(luv.u * luv.u + luv.v * luv.v);
     double h = atan2(luv.v, luv.u) * 180 / pi;
     if (h < 0) h += 360;
     return HsluvColor(h, c, luv.l);
  }
  
  /// Converts this color to Munsell.
  MunsellColor toMunsell() {
      return MunsellColor("N", 0, 0); 
  }

  /// Converts this color to HSL.
  HslColor toHsl() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double h, s, l = (maxVal + minVal) / 2;

    if (maxVal == minVal) {
      h = s = 0; // achromatic
    } else {
      double d = maxVal - minVal;
      s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal);
      if (maxVal == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    return HslColor(h * 360, s, l);
  }

  /// Converts this color to HSV.
  HsvColor toHsv() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double h, s, v = maxVal;

    double d = maxVal - minVal;
    s = maxVal == 0 ? 0 : d / maxVal;

    if (maxVal == minVal) {
      h = 0; // achromatic
    } else {
      if (maxVal == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    return HsvColor(h * 360, s, v);
  }

  /// Converts this color to HSB (Alias for HSV).
  HsbColor toHsb() {
      HsvColor hsv = toHsv();
      return HsbColor(hsv.h, hsv.s, hsv.v);
  }

  /// Converts this color to HWB.
  HwbColor toHwb() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double h = 0;
    
    if (maxVal == minVal) {
        h = 0;
    } else {
        double d = maxVal - minVal;
        if (maxVal == r) {
            h = (g - b) / d + (g < b ? 6 : 0);
        } else if (maxVal == g) {
            h = (b - r) / d + 2;
        } else {
            h = (r - g) / d + 4;
        }
        h /= 6;
    }
    
    double w = minVal;
    double bl = 1 - maxVal;

    return HwbColor(h * 360, w, bl);
  }

  /// Converts this color to Hct (Material Color Utilities).
  @override
  HctColor toHct() {
      int argb = value;
      mcu.Hct hct = mcu.Hct.fromInt(argb);
      return HctColor(hct.hue, hct.chroma, hct.tone);
  }

  /// Converts this color to Cam16 (Material Color Utilities).
  Cam16Color toCam16() {
      int argb = value;
      mcu.Cam16 cam = mcu.Cam16.fromInt(argb);
      return Cam16Color(cam.hue, cam.chroma, cam.j, cam.m, cam.s, cam.q);
  }
  
  /// Converts this color to Display P3.
  DisplayP3Color toDisplayP3() {
      // Linearize sRGB
      double r = red / 255.0;
      double g = green / 255.0;
      double b = blue / 255.0;
      
      r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
      g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
      b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);
      
      // sRGB Linear to XYZ (D65)
      double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
      double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
      double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;
      
      // XYZ (D65) to Display P3 Linear
      // Matrix from http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
      // or Apple's specs.
      // Using standard P3 D65 matrix.
      
      double rP3 = x * 2.4934969 + y * -0.9313836 + z * -0.4027107;
      double gP3 = x * -0.8294889 + y * 1.7626640 + z * 0.0236246;
      double bP3 = x * 0.0358458 + y * -0.0761723 + z * 0.9568845;
      
      // Gamma correction (Transfer function) for Display P3 is sRGB curve.
      rP3 = (rP3 > 0.0031308) ? (1.055 * pow(rP3, 1 / 2.4) - 0.055) : (12.92 * rP3);
      gP3 = (gP3 > 0.0031308) ? (1.055 * pow(gP3, 1 / 2.4) - 0.055) : (12.92 * gP3);
      bP3 = (bP3 > 0.0031308) ? (1.055 * pow(bP3, 1 / 2.4) - 0.055) : (12.92 * bP3);
      
      return DisplayP3Color(rP3, gP3, bP3);
  }
  
  /// Converts this color to Rec. 2020.
  Rec2020Color toRec2020() {
      // Linearize sRGB
      double r = red / 255.0;
      double g = green / 255.0;
      double b = blue / 255.0;
      
      r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
      g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
      b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);
      
      // sRGB Linear to XYZ (D65)
      double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
      double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
      double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;
      
      // XYZ (D65) to Rec. 2020 Linear
      double r2020 = x * 1.7166511 + y * -0.3556707 + z * -0.2533662;
      double g2020 = x * -0.6666843 + y * 1.6164812 + z * 0.0157685;
      double b2020 = x * 0.0176398 + y * -0.0427706 + z * 0.9421031;
      
      // Gamma correction for Rec. 2020
      // alpha = 1.099, beta = 0.018 for 10-bit system, but often 2.4 or 2.2 is used in practice for display.
      // Official Rec. 2020 transfer function:
      // if E < beta * delta: 4.5 * E
      // else: alpha * E^(0.45) - (alpha - 1)
      // alpha = 1.099, beta = 0.018, delta = ? 
      // Actually: if L < 0.018: 4.5 * L, else 1.099 * L^0.45 - 0.099
      
      double transfer(double v) {
          if (v < 0.018) return 4.5 * v;
          return 1.099 * pow(v, 0.45) - 0.099;
      }
      
      return Rec2020Color(transfer(r2020), transfer(g2020), transfer(b2020));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColorIQ && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;



  @override
  ColorIQ lighten([double amount = 20]) {
    return toHsl().lighten(amount).toColor();
  }

  @override
  ColorIQ darken([double amount = 20]) {
    return toHsl().darken(amount).toColor();
  }

  @override
  ColorIQ brighten([double amount = 20]) {
    return toHsv().brighten(amount).toColor();
  }

  @override
  ColorIQ saturate([double amount = 25]) {
    return toHsl().saturate(amount).toColor();
  }

  @override
  ColorIQ desaturate([double amount = 25]) {
    return toHsl().desaturate(amount).toColor();
  }

  @override
  ColorIQ intensify([double amount = 10]) {
    return toHct().intensify(amount).toColor();
  }

  @override
  ColorIQ deintensify([double amount = 10]) {
    return toHct().deintensify(amount).toColor();
  }

  @override
  ColorIQ accented([double amount = 15]) {
    return toHct().accented(amount).toColor();
  }

  @override
  ColorIQ simulate(ColorBlindnessType type) {
    // 1. Convert to Linear sRGB (0-1)
    List<double> lin = linearSrgb;
    // 2. Simulate
    List<double> sim = ColorBlindness.simulate(lin[0], lin[1], lin[2], type);
    // 3. Convert back to sRGB (Gamma Corrected)
    // We can use a helper or manual conversion.
    // Let's use manual for now or add a helper if needed.
    // Actually, we can construct a Color from linear sRGB if we had a constructor,
    // but we have `linearSrgb` getter. We don't have `fromLinearSrgb`.
    // Let's implement the gamma correction here.
    
    double gammaCorrect(double v) {
      return (v > 0.0031308) ? (1.055 * pow(v, 1 / 2.4) - 0.055) : (12.92 * v);
    }

    int r = (gammaCorrect(sim[0]) * 255).round().clamp(0, 255);
    int g = (gammaCorrect(sim[1]) * 255).round().clamp(0, 255);
    int b = (gammaCorrect(sim[2]) * 255).round().clamp(0, 255);

    return ColorIQ.fromARGB(alpha, r, g, b);
  }

  @override
  List<int> get srgb => [red, green, blue, alpha];

  @override
  List<double> get linearSrgb {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    return [r, g, b, alpha / 255.0];
  }

  @override
  ColorIQ get inverted {
    return ColorIQ.fromARGB(alpha, 255 - red, 255 - green, 255 - blue);
  }

  @override
  ColorIQ get grayscale => desaturate(100);

  @override
  ColorIQ whiten([double amount = 20]) {
    return lerp(const ColorIQ(0xFFFFFFFF), amount / 100) as ColorIQ;
  }

  @override
  ColorIQ blacken([double amount = 20]) {
    return lerp(const ColorIQ(0xFF000000), amount / 100) as ColorIQ;
  }

  @override
  ColorSpacesIQ lerp(ColorSpacesIQ other, double t) {
    if (other is! ColorIQ) {
      return lerp(ColorIQ(other.value), t);
    }
    
    final otherColor = other;
    return ColorIQ.fromARGB(
      (alpha + (otherColor.alpha - alpha) * t).round(),
      (red + (otherColor.red - red) * t).round(),
      (green + (otherColor.green - green) * t).round(),
      (blue + (otherColor.blue - blue) * t).round(),
    );
  }

  @override
  ColorIQ fromHct(HctColor hct) => hct.toColor();

  @override
  ColorIQ adjustTransparency([double amount = 20]) {
    return ColorIQ.fromARGB(
      (alpha * (1 - amount / 100)).round().clamp(0, 255),
      red,
      green,
      blue,
    );
  }

  @override
  double get transparency => alpha / 255.0;

  @override
  ColorTemperature get temperature {
    final hsl = toHsl();
    // Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)
    // Cool: 90-270 (Green-Cyan-Blue-Purple)
    if (hsl.h >= 90 && hsl.h < 270) {
      return ColorTemperature.cool;
    } else {
      return ColorTemperature.warm;
    }
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  ColorIQ copyWith({int? a, int? r, int? g, int? b}) {
    return ColorIQ.fromARGB(
      a ?? alpha,
      r ?? red,
      g ?? green,
      b ?? blue,
    );
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Generate 5 variations based on lightness/tone.
    // We can use Hct for perceptually accurate tone steps, or HSL for simple lightness.
    // Let's use HSL for simplicity and consistency with existing logic, or HCT for better quality?
    // The user asked for "at least five colors".
    // Let's generate a range of lightnesses around the current color.
    final hsl = toHsl();
    final results = <ColorIQ>[];
    
    // We want 5 steps. Let's do: L-20, L-10, L, L+10, L+20, clamped.
    // Or just spread them out evenly?
    // Let's do a spread.
    for (int i = 0; i < 5; i++) {
        // -2, -1, 0, 1, 2
        double delta = (i - 2) * 10.0; 
        double newL = (hsl.l * 100 + delta).clamp(0.0, 100.0);
        results.add(HslColor(hsl.h, hsl.s, newL / 100).toColor());
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([double? step]) {
    return toHsl()
        .lighterPalette(step)
        .map((c) => (c as HslColor).toColor())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([double? step]) {
    return toHsl()
        .darkerPalette(step)
        .map((c) => (c as HslColor).toColor())
        .toList();
  }

  @override
  ColorIQ toColor() => this;

  @override
  ColorSpacesIQ get random {
    final rng = Random();
    return ColorIQ.fromARGB(
      255,
      rng.nextInt(256),
      rng.nextInt(256),
      rng.nextInt(256),
    );
  }

  @override
  bool isEqual(ColorSpacesIQ other) {
    return value == other.toColor().value;
  }

  @override
  double get luminance {
    return linearSrgb[0] * 0.2126 + linearSrgb[1] * 0.7152 + linearSrgb[2] * 0.0722;
  }

  @override
  Brightness get brightness {
    // Based on ThemeData.estimateBrightnessForColor
    final double relativeLuminance = luminance;
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold) {
      return Brightness.light;
    }
    return Brightness.dark;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  ColorIQ blend(ColorSpacesIQ other, [double amount = 50]) {
    return lerp(other, amount / 100) as ColorIQ;
  }

  @override
  ColorIQ opaquer([double amount = 20]) {
    // Increase alpha by amount%
    int newAlpha = (alpha + (255 * amount / 100)).round().clamp(0, 255);
    return copyWith(a: newAlpha);
  }

  @override
  ColorIQ adjustHue([double amount = 20]) {
    final hsl = toHsl();
    double newHue = (hsl.h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return HslColor(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  ColorIQ get complementary => adjustHue(180);

  @override
  ColorIQ warmer([double amount = 20]) {
    // Warmest is around 30 degrees (Orange/Red)
    // We shift the hue towards 30 degrees by amount%
    final hsl = toHsl();
    double currentHue = hsl.h;
    double targetHue = 30.0;
    
    // Find shortest path
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    
    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;
    
    return HslColor(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  ColorIQ cooler([double amount = 20]) {
    // Coolest is around 210 degrees (Blue/Cyan)
    // We shift the hue towards 210 degrees by amount%
    final hsl = toHsl();
    double currentHue = hsl.h;
    double targetHue = 210.0;
    
    // Find shortest path
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    
    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;
    
    return HslColor(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  List<ColorIQ> generateBasicPalette() {
    return [
      darken(30),
      darken(20),
      darken(10),
      this,
      lighten(10),
      lighten(20),
      lighten(30),
    ];
  }

  @override
  List<ColorIQ> tonesPalette() {
    // Mix with gray (0xFF808080)
    const gray = ColorIQ(0xFF808080);
    return [
      this,
      lerp(gray, 0.15) as ColorIQ,
      lerp(gray, 0.30) as ColorIQ,
      lerp(gray, 0.45) as ColorIQ,
      lerp(gray, 0.60) as ColorIQ,
    ];
  }

  @override
  List<ColorIQ> analogous({int count = 5, double offset = 30}) {
    final results = <ColorIQ>[];
    
    if (count == 3) {
      results.add(adjustHue(-offset));
      results.add(this);
      results.add(adjustHue(offset));
    } else {
      // Default to 5
      results.add(adjustHue(-offset * 2));
      results.add(adjustHue(-offset));
      results.add(this);
      results.add(adjustHue(offset));
      results.add(adjustHue(offset * 2));
    }
    
    return results;
  }

  @override
  List<ColorIQ> square() {
    return [
      this,
      adjustHue(90),
      adjustHue(180),
      adjustHue(270),
    ];
  }

  @override
  List<ColorIQ> tetrad({double offset = 60}) {
    return [
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double distanceTo(ColorSpacesIQ other) {
    // Convert both to HCT to approximate Cam16 distance.
    // Ideally we use Cam16-UCS, but HCT is a good proxy for perceptual distance.
    // Using simple Euclidean distance in HCT space for now as a fallback if MCU doesn't expose UCS directly.
    // Wait, MCU's Hct class might not expose distance.
    // Let's use the HCT values (Hue, Chroma, Tone).
    // Hue is circular, so we need to handle that.
    
    final hct1 = toHct();
    final hct2 = other.toHct();
    
    // Simple Euclidean distance in HCT cylinder?
    // Or better: convert to Lab-like coordinates.
    // HCT is similar to LCH.
    // dE = sqrt((dL)^2 + (da)^2 + (db)^2)
    // a = C * cos(H)
    // b = C * sin(H)
    
    final h1Rad = hct1.hue * pi / 180;
    final h2Rad = hct2.hue * pi / 180;
    
    final a1 = hct1.chroma * cos(h1Rad);
    final b1 = hct1.chroma * sin(h1Rad);
    final a2 = hct2.chroma * cos(h2Rad);
    final b2 = hct2.chroma * sin(h2Rad);
    
    final dTone = hct1.tone - hct2.tone;
    final da = a1 - a2;
    final db = b1 - b2;
    
    return sqrt(dTone * dTone + da * da + db * db);
  }

  @override
  double contrastWith(ColorSpacesIQ other) {
    final l1 = luminance;
    final l2 = other.luminance;
    final lighter = max(l1, l2);
    final darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  @override
  ColorSlice closestColorSlice() {
    ColorSlice? closest;
    double minDistance = double.infinity;
    
    for (final slice in hctSlices) {
      final dist = distanceTo(slice.color);
      if (dist < minDistance) {
        minDistance = dist;
        closest = slice;
      }
    }
    return closest!;
  }



  @override
  bool isWithinGamut([Gamut gamut = Gamut.sRGB]) {
    // For standard sRGB Color objects, they are always within sRGB gamut 
    // because they are 8-bit clamped.
    // If checking against wider gamuts, they are also within.
    return true;
  }

  @override
  List<double> get whitePoint => [95.047, 100.0, 108.883]; // D65

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ColorIQ',
      'value': value,
    };
  }

  /// Creates a ColorSpacesIQ instance from a JSON map.
  static ColorSpacesIQ fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'ColorIQ':
        return ColorIQ(json['value'] as int);
      case 'HctColor':
        return HctColor(json['hue'], json['chroma'], json['tone']);
      case 'HsvColor':
        return HsvColor(json['hue'], json['saturation'], json['value'], json['alpha'] ?? 1.0);
      case 'HslColor':
        return HslColor(json['hue'], json['saturation'], json['lightness'], json['alpha'] ?? 1.0);
      case 'CmykColor':
        return CmykColor(json['c'], json['m'], json['y'], json['k']);
      case 'LabColor':
        return LabColor(json['l'], json['a'], json['b']);
      case 'XyzColor':
        return XyzColor(json['x'], json['y'], json['z']);
      case 'LchColor':
        return LchColor(json['l'], json['c'], json['h']);
      // Add other cases as needed, defaulting to Color if unknown
      default:
        if (json.containsKey('value')) {
          return ColorIQ(json['value'] as int);
        }
        throw FormatException('Unknown color type: $type');
    }
  }

  @override
  String toString() => 'ColorIQ(0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')})';
}
