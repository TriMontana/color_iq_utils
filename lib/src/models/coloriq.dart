import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/cam16_color.dart';
import 'package:color_iq_utils/src/models/cmyk_color.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/display_p3_color.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hsb_color.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/hsluv_color.dart';
import 'package:color_iq_utils/src/models/hsp_color.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:color_iq_utils/src/models/hunter_lab_color.dart';
import 'package:color_iq_utils/src/models/hwb_color.dart';
import 'package:color_iq_utils/src/models/lab_color.dart';
import 'package:color_iq_utils/src/models/lch_color.dart';
import 'package:color_iq_utils/src/models/luv_color.dart';
import 'package:color_iq_utils/src/models/munsell_color.dart';
import 'package:color_iq_utils/src/models/ok_hsl_color.dart';
import 'package:color_iq_utils/src/models/ok_hsv_color.dart';
import 'package:color_iq_utils/src/models/rec2020_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';
import 'package:color_iq_utils/src/models/yiq_color.dart';
import 'package:color_iq_utils/src/models/yuv_color.dart';
import 'package:color_iq_utils/src/utils/misc_utils.dart';
import 'package:color_iq_utils/src/utils_lib.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;

/// A versatile color representation class, `ColorIQ`, designed for advanced color
/// manipulation and conversion.
///
/// `ColorIQ` serves as the primary entry point for working with colors in the
/// sRGB space. It stores color information as a 32-bit integer, similar to
/// Flutter's `Color` class, but extends functionality significantly. It provides
/// direct access to ARGB components, both as 8-bit integers (0-255) and as
/// normalized `double` values (0.0-1.0).
///
/// Through the `ColorModelsMixin` and `ColorSpacesIQ` interface, this class
/// offers a rich set of methods for:
/// - Converting to and from a wide array of color models (e.g., HSL, HSV, LAB, HCT, CMYK).
/// - Performing color manipulations like lightening, darkening, saturation adjustments,
///   and hue shifting.
/// - Generating color palettes (monochromatic, analogous, etc.).
/// - Simulating color blindness.
/// - Calculating color properties like luminance, contrast, and perceptual distance.
class ColorIQ extends ColorSpacesIQ with ColorModelsMixin {
  /// The color space of this color.
  final ColorSpace colorSpace;
  HctColor? _hctColor;

  /// Construct a color from the lower 32 bits of an [int].
  ColorIQ(
    super.value, {
    final Percent? a,
    final Percent? r,
    final Percent? g,
    final Percent? b,
    final int? alpha,
    final int? red,
    final int? green,
    final int? blue,
    final Percent? luminance,
    this.colorSpace = ColorSpace.sRGB,
    final List<String>? names,
    final HctColor? hctColor,
  })  : _hctColor = hctColor,
        super(
            lrv: luminance,
            a: a ?? Percent(((value >> 24 & 0xFF) / 255).clamp0to1),
            alphaIntVal: alpha != null
                ? alpha.assertRange0to255('ColorIQ-COTR-alpha')
                : (value >> 24 & 0xFF),
            r: r ?? Percent(((value >> 16 & 0xFF) / 255).clamp0to1),
            redIntVal: red != null
                ? red.assertRange0to255('ColorIQ-COTR-red')
                : (value >> 16 & 0xFF),
            g: g ?? Percent(((value >> 8 & 0xFF) / 255).clamp0to1),
            greenIntVal: green != null
                ? green.assertRange0to255('ColorIQ-COTR-green')
                : (value >> 8 & 0xFF),
            b: b ?? Percent(((value & 0xFF) / 255).clamp0to1),
            blueIntVal: blue != null
                ? blue.assertRange0to255('ColorIQ()-blue')
                : (value & 0xFF),
            names: names ?? const <String>[]);

  /// Construct a color from 4 integers, a, r, g, b.
  ColorIQ.fromARGB(
    final int alpha,
    final int red,
    final int green,
    final int blue, {
    final Percent? a,
    final Percent? r,
    final Percent? g,
    final Percent? b,
    final Percent? luminance,
    this.colorSpace = ColorSpace.sRGB,
    final List<String>? names,
    final HctColor? hctColor,
  })  : assert(red >= 0 && red <= 255, 'Invalid Red 0-255 value: $red'),
        assert(green >= 0 && green <= 255, 'Invalid Green 0-255 value: $green'),
        assert(blue >= 0 && blue <= 255, 'Invalid Blue 0-255 value: $blue'),
        assert(alpha >= 0 && alpha <= 255, 'Invalid Alpha 0-255 value: $alpha'),
        _hctColor = hctColor,
        super.alt(
            (((alpha & 0xff) << 24) |
                    ((red & 0xff) << 16) |
                    ((green & 0xff) << 8) |
                    ((blue & 0xff) << 0)) &
                0xFFFFFFFF,
            a: a ?? alpha.normalized,
            alphaIntVal: alpha,
            r: r ?? red.normalized,
            redIntVal: red,
            g: g ?? green.normalized,
            greenIntVal: green,
            b: b ?? blue.normalized,
            blueIntVal: blue,
            lrv: luminance ?? computeLuminanceViaInts(red, green, blue),
            names: names ?? const <String>[]);

  /// Construct a color from sRGB delinearized values a, r, g, b (0.0 to 1.0)
  factory ColorIQ.fromSrgb({
    required final Percent r,
    required final Percent g,
    required final Percent b,
    final Percent a = Percent.max,
    int? alphaInt,
    int? redInt,
    int? greenInt,
    int? blueInt,
    int? argb,
    Percent? luminance,
    final ColorSpace colorSpace = ColorSpace.sRGB,
    final List<String>? names,
    final HctColor? hctColor,
  }) {
    a.assertRange0to1('ColorIQ.fromSrgb--a');
    r.assertRange0to1('ColorIQ.fromSrgb--r');
    g.assertRange0to1('ColorIQ.fromSrgb--g');
    b.assertRange0to1('ColorIQ.fromSrgb--b');

    redInt = redInt != null
        ? redInt.assertRange0to255('ColorIQ.fromSrgb-RedInt')
        : r.int255FromNormalized0to1('ColorIQ.fromSrgb-RedInt2');
    greenInt = greenInt != null
        ? greenInt.assertRange0to255('ColorIQ.fromSrgb-GreenInt')
        : g.int255FromNormalized0to1('ColorIQ.fromSrgb-GreenInt2');
    blueInt = blueInt != null
        ? blueInt.assertRange0to255('ColorIQ.fromSrgb-BlueInt')
        : b.int255FromNormalized0to1('ColorIQ.fromSrgb-BlueInt2');
    alphaInt = alphaInt != null
        ? alphaInt.assertRange0to255('ColorIQ.fromSrgb-AlphaInt')
        : a.int255FromNormalized0to1('ColorIQ.fromSrgb-A');
    argb ??= (alphaInt << 24) | (redInt << 16) | (greenInt << 8) | blueInt;
    luminance = luminance ?? computeLuminanceViaInts(redInt, greenInt, blueInt);
    return ColorIQ(argb,
        alpha: alphaInt,
        red: redInt,
        green: greenInt,
        blue: blueInt,
        colorSpace: colorSpace,
        luminance: luminance,
        a: a,
        r: r,
        g: g,
        b: b,
        hctColor: hctColor,
        names: names ?? const <String>[]);
  }

  /// Accepts hex like "#RRGGBB" or "RRGGBB" or "AARRGGBB".
  factory ColorIQ.fromHexStr(final String hexStr, {final List<String>? names}) {
    String hex = hexStr.replaceAll('#', '').toUpperCase();
    // hex = hex.substring(1);
    if (hex.length == 3) {
      hex = hex.split('').map((final String c) => '$c$c').join('');
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
      return ColorIQ(int.parse(hex, radix: 16), names: names);
    }

    if (hex.length == 8) {
      // CSS hex is RRGGBBAA, Dart Color is AARRGGBB
      // So we need to move AA to the front.
      // Input: RRGGBBAA
      // Output: AARRGGBB
      final String r = hex.substring(0, 2);
      final String g = hex.substring(2, 4);
      final String b = hex.substring(4, 6);
      final String a = hex.substring(6, 8);
      hex = '$a$r$g$b';
      return ColorIQ(int.parse(hex, radix: 16), names: names);
    }

    throw FormatException('Invalid hex color: #$hex');
  }

  int get alpha => super.alphaInt;
  @override
  int get red => super.redInt;
  @override
  int get green => super.greenInt;
  @override
  int get blue => super.blueInt;

  @override
  ColorIQ toColor() => this;

  /// LAB representation, computed once and cached.
  late final LabColor lab = LabColor.fromInt(value);
  late final HctColor hct = _hctColor ?? HctColor.fromInt(value);
  late final Cam16Color cam16 = Cam16Color.fromInt(value);

  /// Converts this color to XYZ once and cached.
  late final XYZ xyz = XYZ.xyxFromRgb(red, green, blue);
  late final LuvColor luv = xyz.toLuv();

  @override
  late final double luminance = super.toLRV;

  /// Converts this color to CIELCH.
  LchColor toLch() => lab.toLch();

  /// Converts this color to HSP.
  HspColor toHsp() => HspColor.fromInt(value);

  /// Converts this color to YIQ.
  YiqColor toYiq() {
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double y = 0.299 * r + 0.587 * g + 0.114 * b;
    final double i = 0.596 * r - 0.274 * g - 0.322 * b;
    final double q = 0.211 * r - 0.523 * g + 0.312 * b;

    return YiqColor(y, i, q);
  }

  /// Human-friendly description ("soft blue", "warm neutral", etc.), cached.
  late final String descriptiveName = ColorNamerSuperSimple.instance.name(this);

  /// Converts this color to YUV.
  YuvColor toYuv() {
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double y = 0.299 * r + 0.587 * g + 0.114 * b;
    final double u = -0.14713 * r - 0.28886 * g + 0.436 * b;
    final double v = 0.615 * r - 0.51499 * g - 0.10001 * b;

    return YuvColor(y, u, v);
  }

  /// Converts this color to OkLch.
  // OkLCH toOkLch() => toOkLab().toOkLch();

  /// Converts this color to OkHSL.
  OkHslColor toOkHsl() => toOkLab().toOkHsl();

  /// Converts this color to OkHSV.
  OkHsvColor toOkHsv() => toOkLab().toOkHsv();

  /// Converts this color to Hunter Lab.
  HunterLabColor toHunterLab() {
    final XYZ xyz = XYZ.fromInt(value);
    final double x = xyz.x;
    final double y = xyz.y;
    final double z = xyz.z;

    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    final double lOut = 100.0 * sqrt(y / yn);
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
    final LuvColor luv = toLuv();
    final double c = sqrt(luv.u * luv.u + luv.v * luv.v);
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
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double maxVal = max(r, max(g, b));
    final double minVal = min(r, min(g, b));
    double h, s, l = (maxVal + minVal) / 2;

    if (maxVal == minVal) {
      h = s = 0; // achromatic
    } else {
      final double d = maxVal - minVal;
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
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double maxVal = max(r, max(g, b));
    final double minVal = min(r, min(g, b));
    double h, s, v = maxVal;

    final double d = maxVal - minVal;
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

    return HsvColor(h * 360, s, Percent(v));
  }

  /// Converts this color to HSB (Alias for HSV).
  HsbColor toHsb() {
    final HsvColor hsv = toHsv();
    return HsbColor(hsv.h, hsv.s, hsv.v);
  }

  /// Converts this color to HWB.
  HwbColor toHwb() {
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double maxVal = max(r, max(g, b));
    final double minVal = min(r, min(g, b));
    double h = 0;

    if (maxVal == minVal) {
      h = 0;
    } else {
      final double d = maxVal - minVal;
      if (maxVal == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    final double w = minVal;
    final double bl = 1 - maxVal;

    return HwbColor(h * 360, w, bl);
  }

  /// Converts this color to Cam16 (Material Color Utilities).
  @override
  Cam16Color toCam16Color() {
    final mcu.Cam16 cam = mcu.Cam16.fromInt(value);
    return Cam16Color(cam.hue, cam.chroma, cam.j, cam.m, cam.s, cam.q,
        hexId: value);
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
    final double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
    final double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
    final double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;

    // XYZ (D65) to Display P3 Linear
    // Matrix from http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
    // or Apple's specs.
    // Using standard P3 D65 matrix.

    final double rP3 = x * 2.4934969 + y * -0.9313836 + z * -0.4027107;
    final double gP3 = x * -0.8294889 + y * 1.7626640 + z * 0.0236246;
    double bP3 = x * 0.0358458 + y * -0.0761723 + z * 0.9568845;

    // Gamma correction (Transfer function) for Display P3 is sRGB curve.
    bP3 =
        (bP3 > 0.0031308) ? (1.055 * pow(bP3, 1 / 2.4) - 0.055) : (12.92 * bP3);

    return DisplayP3Color(rP3.gammaCorrect, gP3.gammaCorrect, Percent(bP3));
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
    final double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
    final double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
    final double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;

    // XYZ (D65) to Rec. 2020 Linear
    final double r2020 = x * 1.7166511 + y * -0.3556707 + z * -0.2533662;
    final double g2020 = x * -0.6666843 + y * 1.6164812 + z * 0.0157685;
    final double b2020 = x * 0.0176398 + y * -0.0427706 + z * 0.9421031;

    // Gamma correction for Rec. 2020
    // alpha = 1.099, beta = 0.018 for 10-bit system, but often 2.4 or 2.2 is used in practice for display.
    // Official Rec. 2020 transfer function:
    // if E < beta * delta: 4.5 * E
    // else: alpha * E^(0.45) - (alpha - 1)
    // alpha = 1.099, beta = 0.018, delta = ?
    // Actually: if L < 0.018: 4.5 * L, else 1.099 * L^0.45 - 0.099

    Percent transfer(final double v) {
      if (v < 0.018) return Percent(4.5 * v);
      return Percent(1.099 * pow(v, 0.45) - 0.099);
    }

    return Rec2020Color(transfer(r2020), transfer(g2020), transfer(b2020));
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    return other is ColorIQ && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  ColorIQ lighten([final double amount = 20]) {
    return toHsl().lighten(amount).toColor();
  }

  @override
  ColorIQ darken([final double amount = 20]) {
    return toHsl().darken(amount).toColor();
  }

  @override
  ColorIQ brighten([final double amount = 20]) {
    return toHsv().brighten(amount).toColor();
  }

  @override
  ColorIQ saturate([final double amount = 25]) {
    return toHsl().saturate(amount).toColor();
  }

  @override
  ColorIQ desaturate([final double amount = 25]) {
    return toHsl().desaturate(amount).toColor();
  }

  @override
  ColorIQ intensify([final double amount = 10]) {
    return toHctColor().intensify(amount).toColor();
  }

  @override
  ColorIQ deintensify([final double amount = 10]) {
    return toHctColor().deintensify(amount).toColor();
  }

  @override
  ColorIQ accented([final double amount = 15]) {
    return toHctColor().accented(amount).toColor();
  }

  @override
  ColorIQ simulate(final ColorBlindnessType type) {
    // 1. Convert to Linear sRGB (0-1)
    final List<double> lin = <double>[
      redLinearized,
      greenLinearized,
      blueLinearized
    ];
    // 2. Simulate
    final List<double> sim = ColorBlindness.simulate(
      lin[0],
      lin[1],
      lin[2],
      type,
    );
    // 3. Convert back to sRGB (Gamma Corrected)
    // We can use a helper or manual conversion.
    // Let's use manual for now or add a helper if needed.
    // Actually, we can construct a Color from linear sRGB if we had a constructor,
    // but we have `linearSrgb` getter. We don't have `fromLinearSrgb`.
    // Let's implement the gamma correction here.

    double gammaCorrect(final double v) {
      return (v > 0.0031308) ? (1.055 * pow(v, 1 / 2.4) - 0.055) : (12.92 * v);
    }

    final int r = (gammaCorrect(sim[0]) * 255).round().clamp(0, 255);
    final int g = (gammaCorrect(sim[1]) * 255).round().clamp(0, 255);
    final int b = (gammaCorrect(sim[2]) * 255).round().clamp(0, 255);

    return ColorIQ.fromARGB(alpha, r, g, b);
  }

  @override
  ColorIQ get inverted {
    return ColorIQ.fromARGB(alpha, 255 - red, 255 - green, 255 - blue);
  }

  @override
  ColorIQ get grayscale => desaturate(100);

  @override
  ColorIQ whiten([final double amount = 20]) {
    return lerp(cWhite, amount / 100) as ColorIQ;
  }

  @override
  ColorIQ blacken([final double amount = 20]) {
    return lerp(cBlack, amount / 100) as ColorIQ;
  }

  @override
  ColorSpacesIQ lerp(final ColorSpacesIQ other, final double t) {
    if (other is! ColorIQ) {
      return lerp(ColorIQ(other.value), t);
    }

    final ColorIQ otherColor = other;
    return ColorIQ.fromARGB(
      (alpha + (otherColor.alpha - alpha) * t).round(),
      (red + (otherColor.red - red) * t).round(),
      (green + (otherColor.green - green) * t).round(),
      (blue + (otherColor.blue - blue) * t).round(),
    );
  }

  @override
  ColorIQ fromHct(final HctColor hct) => hct.toColor();

  @override
  ColorIQ adjustTransparency([final double amount = 20]) {
    return ColorIQ.fromARGB(
      (alpha * (1 - amount / 100)).round().clamp(0, 255),
      red,
      green,
      blue,
    );
  }

  @override
  double get transparency => alpha / 255.0;

  ColorIQ withAlpha(final int newA) =>
      ColorIQ.fromARGB(newA.clamp(0, 255), red, green, blue);

  ColorIQ withRgb({final int? red, final int? green, final int? blue}) =>
      ColorIQ.fromARGB(
          alpha, red ?? this.red, green ?? this.green, blue ?? this.blue);

  /// Creates a copy of this color with the given fields replaced with the new values.
  ColorIQ copyWith(
      {final int? alpha, final int? red, final int? green, final int? blue}) {
    return ColorIQ.fromARGB(alpha ?? this.alpha, red ?? this.red,
        green ?? this.green, blue ?? this.blue);
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Generate 5 variations based on lightness/tone.
    // We can use Hct for perceptually accurate tone steps, or HSL for simple lightness.
    // Let's use HSL for simplicity and consistency with existing logic, or HCT for better quality?
    // The user asked for "at least five colors".
    // Let's generate a range of lightnesses around the current color.
    final HslColor hsl = toHsl();
    final List<ColorIQ> results = <ColorIQ>[];

    // We want 5 steps. Let's do: L-20, L-10, L, L+10, L+20, clamped.
    // Or just spread them out evenly?
    // Let's do a spread.
    for (int i = 0; i < 5; i++) {
      // -2, -1, 0, 1, 2
      final double delta = (i - 2) * 10.0;
      final double newL = (hsl.l * 100 + delta).clamp(0.0, 100.0);
      results.add(HslColor(hsl.h, hsl.s, newL / 100).toColor());
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return toHsl()
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as HslColor).toColor())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return toHsl()
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as HslColor).toColor())
        .toList();
  }

  @override
  ColorSpacesIQ get random {
    final Random rng = Random();
    return ColorIQ.fromARGB(
      255,
      rng.nextInt(256),
      rng.nextInt(256),
      rng.nextInt(256),
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    return value == other.toColor().value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  ColorIQ blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100) as ColorIQ;
  }

  @override
  ColorIQ opaquer([final double amount = 20]) {
    // Increase alpha by amount%
    final int newAlpha = (alpha + (255 * amount / 100)).round().clamp(0, 255);
    return copyWith(alpha: newAlpha);
  }

  @override
  ColorIQ adjustHue([final double amount = 20]) {
    final HslColor hsl = toHsl();
    double newHue = (hsl.h + amount) % 360;
    if (newHue < 0) newHue += 360;
    return HslColor(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  ColorIQ get complementary => adjustHue(180);

  @override
  ColorIQ warmer([final double amount = 20]) {
    // Warmest is around 30 degrees (Orange/Red)
    // We shift the hue towards 30 degrees by amount%
    final HslColor hsl = toHsl();
    final double currentHue = hsl.h;
    const double targetHue = 30.0;

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
  ColorIQ cooler([final double amount = 20]) {
    // Coolest is around 210 degrees (Blue/Cyan)
    // We shift the hue towards 210 degrees by amount%
    final HslColor hsl = toHsl();
    final double currentHue = hsl.h;
    const double targetHue = 210.0;

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
    return <ColorIQ>[
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
    final ColorIQ gray = ColorIQ(0xFF808080);
    return <ColorIQ>[
      this,
      lerp(gray, 0.15) as ColorIQ,
      lerp(gray, 0.30) as ColorIQ,
      lerp(gray, 0.45) as ColorIQ,
      lerp(gray, 0.60) as ColorIQ,
    ];
  }

  @override
  List<ColorIQ> analogous({final int count = 5, final double offset = 30}) {
    final List<ColorIQ> results = <ColorIQ>[];

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
    return <ColorIQ>[this, adjustHue(90), adjustHue(180), adjustHue(270)];
  }

  @override
  List<ColorIQ> tetrad({final double offset = 60}) {
    return <ColorIQ>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  @override
  double distanceTo(final ColorSpacesIQ other) {
    return toCam16().distance(other.toCam16());
    // // Convert both to HCT to approximate Cam16 distance.
    // // Ideally we use Cam16-UCS, but HCT is a good proxy for perceptual distance.
    // // Using simple Euclidean distance in HCT space for now as a fallback if MCU doesn't expose UCS directly.
    // // Wait, MCU's Hct class might not expose distance.
    // // Let's use the HCT values (Hue, Chroma, Tone).
    // // Hue is circular, so we need to handle that.

    // final HctColor hct1 = toHctColor();
    // final HctColor hct2 = other.toHctColor();

    // // Simple Euclidean distance in HCT cylinder?
    // // Or better: convert to Lab-like coordinates.
    // // HCT is similar to LCH.
    // // dE = sqrt((dL)^2 + (da)^2 + (db)^2)
    // // a = C * cos(H)
    // // b = C * sin(H)

    // final double h1Rad = hct1.hue * pi / 180;
    // final double h2Rad = hct2.hue * pi / 180;

    // final double a1 = hct1.chroma * cos(h1Rad);
    // final double b1 = hct1.chroma * sin(h1Rad);
    // final double a2 = hct2.chroma * cos(h2Rad);
    // final double b2 = hct2.chroma * sin(h2Rad);

    // final double dTone = hct1.tone - hct2.tone;
    // final double da = a1 - a2;
    // final double db = b1 - b2;

    // return sqrt(dTone * dTone + da * da + db * db);
  }

  @override
  double contrastWith(final ColorSpacesIQ other) {
    final double l1 = luminance;
    final double l2 = other.toLRV;
    final double lighter = max(l1, l2);
    final double darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  @override
  ColorSlice closestColorSlice() {
    ColorSlice? closest;
    double minDistance = double.infinity;

    for (final ColorSlice slice in hctSlices) {
      final double dist = distanceTo(slice.color);
      if (dist < minDistance) {
        minDistance = dist;
        closest = slice;
      }
    }
    return closest!;
  }

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    // For standard sRGB Color objects, they are always within sRGB gamut
    // because they are 8-bit clamped.
    // If checking against wider gamuts, they are also within.
    return true;
  }

  @override
  List<double> get whitePoint => kWhitePointD65; // D65

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'ColorIQ', 'value': value};
  }

  /// Creates a ColorSpacesIQ instance from a JSON map.
  static ColorSpacesIQ fromJson(final Map<String, dynamic> json) {
    final String type = json['type'] as String;
    switch (type) {
      case 'ColorIQ':
        return ColorIQ(json[kValue] as int);
      case 'HctColor':
        return HctColor(json['hue'], json[kChroma], json['tone']);
      case 'HsvColor':
        return HsvColor(
          json['hue'],
          json['saturation'],
          json['value'],
          alpha: json['alpha'] ?? 1.0,
        );
      case 'HslColor':
        return HslColor(
          json['hue'],
          json['saturation'],
          json['lightness'],
          alpha: json['alpha'] ?? 1.0,
        );
      case 'CmykColor':
        return CmykColor(json['c'], json['m'], json['y'], json['k']);
      case 'LabColor':
        return LabColor(json['l'], json['a'], json['b']);
      case 'XyzColor':
        return XYZ(json['x'], json['y'], json['z']);
      case 'LchColor':
        return LchColor(json['l'], json['c'], json['h']);
      // Add other cases as needed, defaulting to Color if unknown
      default:
        if (json.containsKey('value')) {
          return ColorIQ(json['value'] as int);
        }
        throw FormatException('Unknown color type: $type, ${type.runtimeType}');
    }
  }

  @override
  String toString() =>
      'ColorIQ(0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')})';
}
