import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for Light Reflectance Value (LRV) calculations
///
/// LRV is a measure of the percentage of light a color reflects,
/// ranging from 0 (pure black, absorbs all light) to 1.0 (pure white,
/// reflects all light). It uses linearized sRGB values with standard
/// luminance coefficients (0.2126, 0.7152, 0.0722).
void main() {
  group('LRV Basic Calculations', () {
    test('Pure white has LRV of 1.0', () {
      final ColorIQ white = ColorIQ(0xFFFFFFFF);
      expect(white.lrv.val, closeTo(1.0, 0.001));
      print('✓ White LRV: ${white.lrv.val}');
    });

    test('Pure black has LRV of 0.0', () {
      final ColorIQ black = ColorIQ(0xFF000000);
      expect(black.lrv.val, closeTo(0.0, 0.001));
      print('✓ Black LRV: ${black.lrv.val}');
    });

    test('Mid gray has LRV around 0.214', () {
      // RGB(128, 128, 128) - mid gray
      final ColorIQ gray = ColorIQ.fromArgbInts(
          alpha: Iq255.v255,
          red: Iq255.v128,
          green: Iq255.v128,
          blue: Iq255.v128);
      // Linearized 128/255 ≈ 0.2158 (since it's a neutral gray)
      expect(gray.lrv.val, closeTo(0.214, 0.01));
      print('✓ Mid gray LRV: ${gray.lrv.val}');
    });

    test('Pure red has specific LRV (based on red coefficient)', () {
      final ColorIQ red = ColorIQ(0xFFFF0000);
      // LRV = 0.2126 (red coefficient) * 1.0 (full red linearized)
      expect(red.lrv.val, closeTo(0.2126, 0.001));
      print('✓ Red LRV: ${red.lrv.val}');
    });

    test('Pure green has highest LRV among primaries', () {
      final ColorIQ green = ColorIQ(0xFF00FF00);
      // LRV = 0.7152 (green coefficient) * 1.0
      expect(green.lrv.val, closeTo(0.7152, 0.001));
      print('✓ Green LRV: ${green.lrv.val}');
    });

    test('Pure blue has lowest LRV among primaries', () {
      final ColorIQ blue = ColorIQ(0xFF0000FF);
      // LRV = 0.0722 (blue coefficient) * 1.0
      expect(blue.lrv.val, closeTo(0.0722, 0.001));
      print('✓ Blue LRV: ${blue.lrv.val}');
    });
  });

  group('LRV Range Validation', () {
    test('Various colors have LRV in valid range (0.0-1.0)', () {
      // Test a variety of colors directly
      final List<ColorIQ> testColors = <ColorIQ>[
        cRed, // Red
        cGreen, // Green
        cBlue, // Blue
        cYellow, // Yellow
        cCyan, // Cyan
        cMagenta, // Magenta
        cWhite, // White
        cBlack, // Black
        cGray, // Gray
      ];

      for (final ColorIQ color in testColors) {
        final Percent lrv = color.lrv;

        expect(lrv.val, greaterThanOrEqualTo(0.0),
            reason: '${color.hexStr}: LRV must be >= 0.0');
        expect(lrv.val, lessThanOrEqualTo(1.0),
            reason: '${color.hexStr}: LRV must be <= 1.0');
      }
      print('✓ All test colors have valid LRV range');
    });

    test('LRV increases with brightness for grayscale', () {
      // Test a gradient from dark to light using specific Iq255 values
      final List<Iq255> grays = <Iq255>[
        Iq255.v0,
        Iq255.v51,
        Iq255.v102,
        Iq255.v153,
        Iq255.v204,
        Iq255.v255
      ];
      double previousLrv = -1.0;

      for (final Iq255 grayValue in grays) {
        final ColorIQ gray = ColorIQ.fromArgbInts(
            alpha: Iq255.v255,
            red: grayValue,
            green: grayValue,
            blue: grayValue);
        expect(gray.lrv.val, greaterThan(previousLrv),
            reason:
                'Gray(${grayValue.intVal}) LRV should be greater than previous');
        previousLrv = gray.lrv.val;
      }
      print('✓ LRV increases with brightness for grayscale gradient');
    });
  });

  group('LRV Caching Behavior', () {
    test('LRV is consistent across multiple accesses', () {
      final ColorIQ color = ColorIQ(0xFF123456);

      // Access LRV multiple times
      final Percent lrv1 = color.lrv;
      final Percent lrv2 = color.lrv;
      final Percent lrv3 = color.lrv;

      expect(lrv1.val, equals(lrv2.val));
      expect(lrv2.val, equals(lrv3.val));
      print('✓ LRV is consistent across multiple accesses');
    });

    test('Different colors have different LRV values', () {
      expect(cRed.lrv.val, isNot(equals(cBlue.lrv.val)));
      expect(cRed.lrv.val, isNot(equals(cGreen.lrv.val)));
      expect(cBlue.lrv.val, isNot(equals(cGreen.lrv.val)));
      print('✓ Different colors have distinct LRV values');
    });
  });

  group('LRV via calculateLrvAsPercent', () {
    test('calculateLrvAsPercent returns value 0-100', () {
      final ColorIQ white = ColorIQ(0xFFFFFFFF);
      final ColorIQ black = ColorIQ(0xFF000000);
      final ColorIQ mid = ColorIQ.fromArgbInts(
          alpha: Iq255.v255,
          red: Iq255.v128,
          green: Iq255.v128,
          blue: Iq255.v128);

      expect(white.calculateLrvAsPercent(), closeTo(100.0, 0.5));
      expect(black.calculateLrvAsPercent(), closeTo(0.0, 0.001));
      expect(mid.calculateLrvAsPercent(), closeTo(21.4, 1.0));

      print('✓ White LRV%: ${white.calculateLrvAsPercent()}');
      print('✓ Black LRV%: ${black.calculateLrvAsPercent()}');
      print('✓ Mid gray LRV%: ${mid.calculateLrvAsPercent()}');
    });

    test('calculateLrvAsPercent is consistent with lrv property', () {
      final ColorIQ color = ColorIQ(0xFF4080C0);
      final double lrvPercent = color.calculateLrvAsPercent();
      final double lrvNormalized = color.lrv.val;

      // lrv property is 0-1, calculateLrvAsPercent is 0-100
      expect(lrvPercent, closeTo(lrvNormalized * 100, 1.0));
      print('✓ calculateLrvAsPercent is consistent with lrv property');
    });
  });

  group('LRV with Color Models', () {
    test('HSL model provides consistent LRV', () {
      const HSL hsl = HSL(Hue.zero, Percent.max, Percent.mid); // Red
      final Percent lrv = hsl.toLrv;
      expect(lrv.val, closeTo(0.2126, 0.001));
      print('✓ HSL toLrv: ${lrv.val}');
    });

    test('HSV model provides consistent LRV', () {
      const HSV hsv = HSV(Hue.zero, Percent.max, Percent.max); // Red
      final Percent lrv = hsv.toLrv;
      expect(lrv.val, closeTo(0.2126, 0.001));
      print('✓ HSV toLrv: ${lrv.val}');
    });

    test('HCT model provides consistent LRV', () {
      final HctColor hct = HctColor.fromInt(0xFFFF0000); // Red
      final Percent lrv = hct.toLrv;
      expect(lrv.val, closeTo(0.2126, 0.001));
      print('✓ HCT toLrv: ${lrv.val}');
    });

    test('CMYK model provides consistent LRV', () {
      const CMYK cmyk = CMYK(0, 1, 1, 0); // Red
      final Percent lrv = cmyk.toLrv;
      expect(lrv.val, closeTo(0.2126, 0.001));
      print('✓ CMYK toLrv: ${lrv.val}');
    });
  });

  group('LRV for Specific Colors', () {
    test('Yellow has high LRV (red + green coefficients)', () {
      final ColorIQ yellow = ColorIQ(0xFFFFFF00);
      // LRV = 0.2126 + 0.7152 = 0.9278
      expect(yellow.lrv.val, closeTo(0.9278, 0.001));
      print('✓ Yellow LRV: ${yellow.lrv.val}');
    });

    test('Cyan has moderate-high LRV (green + blue coefficients)', () {
      final ColorIQ cyan = ColorIQ(0xFF00FFFF);
      // LRV = 0.7152 + 0.0722 = 0.7874
      expect(cyan.lrv.val, closeTo(0.7874, 0.001));
      print('✓ Cyan LRV: ${cyan.lrv.val}');
    });

    test('Magenta has moderate LRV (red + blue coefficients)', () {
      expect(cMagenta.lrv.val, closeTo(0.2848, 0.001));
      print('✓ Magenta LRV: ${cMagenta.lrv.val}');
    });
  });

  group('LRV Edge Cases', () {
    test('Very dark colors have very low LRV', () {
      final ColorIQ veryDark = ColorIQ.fromArgbInts(
          alpha: Iq255.v255, red: Iq255.v5, green: Iq255.v5, blue: Iq255.v5);
      expect(veryDark.lrv.val, lessThan(0.01));
      print('✓ Very dark (5,5,5) LRV: ${veryDark.lrv.val}');
    });

    test('Very light colors have very high LRV', () {
      final ColorIQ veryLight = ColorIQ.fromArgbInts(
          alpha: Iq255.v255,
          red: Iq255.v250,
          green: Iq255.v250,
          blue: Iq255.v250);
      expect(veryLight.lrv.val, greaterThan(0.9));
      print('✓ Very light (250,250,250) LRV: ${veryLight.lrv.val}');
    });

    test('Green dominates LRV due to coefficient', () {
      // Green has coefficient 0.7152, so even partial green increases LRV significantly
      final ColorIQ halfGreen = ColorIQ(0xFF007F00);
      final ColorIQ halfRed = ColorIQ(0xFF7F0000);

      expect(halfGreen.lrv.val, greaterThan(halfRed.lrv.val));
      print(
          '✓ Half green LRV: ${halfGreen.lrv.val} > half red LRV: ${halfRed.lrv.val}');
    });
  });
}
