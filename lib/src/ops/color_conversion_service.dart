import 'dart:math' as math;

import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';
import 'package:material_color_utilities/hct/hct.dart';

class HsvColorSegment {
  final Hue hue; // 0.0 to 360.0
  final double saturation; // 0.0 to 1.0
  final double value; // 0.0 to 1.0
  HsvColorSegment(this.hue, this.saturation, this.value);
}

// Placeholder for a single color in the output list
class HctColorSegment {
  final double hue; // 0.0 to 360.0
  final double chroma; // 0.0 to approx 150.0
  final double tone; // 0.0 to 100.0
  HctColorSegment(this.hue, this.chroma, this.tone);
}

// (Insert the HsvColorSegment and HctColorSegment classes here)

/// Converts a list of HsvColorSegment objects to a list of HctColorSegment objects.
List<HctColorSegment> convertHsvListToHctList(
    final List<HsvColorSegment> hsvList) {
  final List<HctColorSegment> hctList = <HctColorSegment>[];

  for (final HsvColorSegment hsvSegment in hsvList) {
    // Stage 1: Convert HSV to Flutter Color (ARGB)
    // The HSVColor class is used to handle the conversion from H, S, V components.
    final ColorIQ flutterColor = HSV
        .fromAHSV(
          Percent.max, // Full opacity
          hsvSegment.hue,
          Percent(hsvSegment.saturation),
          Percent(hsvSegment.value),
        )
        .toColor();

    // Stage 2: Convert ARGB (int) to HCT
    final Hct hct = Hct.fromInt(flutterColor.value);

    // Stage 3: Create the new HctColorSegment
    final HctColorSegment hctSegment = HctColorSegment(
      hct.hue,
      hct.chroma,
      hct.tone,
    );

    hctList.add(hctSegment);
  }

  return hctList;
}

// -------------------------------------------------------------------
// COLOR CONVERSION LOGIC (OkLCH <-> RGB)
// -------------------------------------------------------------------

class ColorConverter {
  // --- Convert sRGB Color to OkLCH ---
  // L, C, H are Lightness [0, 1], Chroma [0, ~0.4], Hue [0, 360)
  static OkLCH fromRGB(final ColorIQ color) {
    // 1. Convert sRGB [0-255] to Linear sRGB [0-1]
    final double r = color.red / 255.0;
    final double g = color.green / 255.0;
    final double b = color.blue / 255.0;

    double linearize(final double c) =>
        c > 0.04045 ? math.pow((c + 0.055) / 1.055, 2.4).toDouble() : c / 12.92;

    final double lr = linearize(r);
    final double lg = linearize(g);
    final double lb = linearize(b);

    // 2. Convert Linear sRGB to LMS (Long-Wavelength, Medium, Short)
    // LMS Matrix (standard D65 matrix)
    final double L = 0.4121656120 * lr + 0.5362752080 * lg + 0.0514570080 * lb;
    final double M = 0.2118591070 * lr + 0.6807189584 * lg + 0.1074061555 * lb;
    final double S = 0.0883097947 * lr + 0.2818474174 * lg + 0.6300096956 * lb;

// 3. Apply Power Function to get L' M' S'
    final double lPrime = math.pow(L, 1.0 / 3.0).toDouble(); // Fix
    final double mPrime = math.pow(M, 1.0 / 3.0).toDouble(); // Fix
    final double sPrime = math.pow(S, 1.0 / 3.0).toDouble(); // Fix

    // 4. Convert L' M' S' to Oklab (L, a, b)
    // Oklab Matrix
    final double oklabL =
        0.2104542553 * lPrime + 0.7936177850 * mPrime - 0.0040720468 * sPrime;
    final double oklabA =
        1.9779984951 * lPrime - 2.4285922050 * mPrime + 0.4505937102 * sPrime;
    final double oklabB =
        0.0259040371 * lPrime + 0.7827717662 * mPrime - 0.8086757660 * sPrime;

    // 5. Convert Oklab (L, a, b) to OkLCH (L, C, H)
    final double c = math.sqrt(oklabA * oklabA + oklabB * oklabB);
    double h = math.atan2(oklabB, oklabA) * 180.0 / math.pi;

    if (h < 0) {
      h += 360.0;
    }

    return OkLCH(oklabL.clampToPercent, c, h);
  }

  // --- Convert OkLCH to sRGB Color ---
  static ColorIQ toRGB(final OkLCH oklch) {
    // 1. Convert OkLCH (L, C, H) to Oklab (L, a, b)
    final double hRad = oklch.h * math.pi / 180.0;
    final double oklabA = oklch.c * math.cos(hRad);
    final double oklabB = oklch.c * math.sin(hRad);
    final double oklabL = oklch.l;

    // 2. Convert Oklab (L, a, b) to L' M' S'
    // Inverse Oklab Matrix
    final double lPrime =
        1.0000000000 * oklabL + 0.3963377774 * oklabA + 0.2158037580 * oklabB;
    final double mPrime =
        1.0000000000 * oklabL - 0.1055613458 * oklabA - 0.0638541728 * oklabB;
    final double sPrime =
        1.0000000000 * oklabL - 0.0894841793 * oklabA - 1.2914855480 * oklabB;

    // 3. Apply Inverse Power Function to get LMS (L, M, S)
    final double L = lPrime * lPrime * lPrime;
    final double M = mPrime * mPrime * mPrime;
    final double S = sPrime * sPrime * sPrime;

    // 4. Convert LMS to Linear sRGB (lr, lg, lb)
    // Inverse LMS Matrix
    final double lr = 4.0767245293 * L - 3.3079737976 * M + 0.2309759764 * S;
    final double lg = -1.2681437731 * L + 2.6093323231 * M - 0.3411995298 * S;
    final double lb = -0.0041119885 * L - 0.7034920875 * M + 1.7068625690 * S;

    // 5. Convert Linear sRGB [0-1] to sRGB [0-255] with Gamut Clamping
    double delinearize(final double c) =>
        c > 0.0031308 ? (1.055 * math.pow(c, 1.0 / 2.4) - 0.055) : c * 12.92;

    // 💡 Gamut Clamping: Use .clamp(0.0, 1.0) to force values back into the sRGB cube [0, 1]
    final int r = (delinearize(lr).clamp(0.0, 1.0) * 255).round();
    final int g = (delinearize(lg).clamp(0.0, 1.0) * 255).round();
    final int b = (delinearize(lb).clamp(0.0, 1.0) * 255).round();

    return ColorIQ.fromArgbInts(
        red: r.toIq255, green: g.toIq255, blue: b.toIq255);
  }
}
