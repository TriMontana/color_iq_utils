import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for Brightness calculations
///
/// Brightness is determined from the LRV (Light Reflectance Value) using
/// a threshold-based formula similar to Flutter's ThemeData.estimateBrightnessForColor.
/// Colors are classified as either Brightness.light or Brightness.dark.
void main() {
  group('Brightness Basic Classification', () {
    test('Pure white is classified as light', () {
      final ColorIQ white = ColorIQ(0xFFFFFFFF);
      expect(white.brightness, equals(Brightness.light));
      expect(white.isLight, isTrue);
      expect(white.isDark, isFalse);
      print('✓ White brightness: ${white.brightness}');
    });

    test('Pure black is classified as dark', () {
      final ColorIQ black = ColorIQ(0xFF000000);
      expect(black.brightness, equals(Brightness.dark));
      expect(black.isDark, isTrue);
      expect(black.isLight, isFalse);
      print('✓ Black brightness: ${black.brightness}');
    });

    test('Mid gray is classified correctly based on threshold', () {
      final ColorIQ gray = ColorIQ.fromArgbInts(
          alpha: Iq255.v255,
          red: Iq255.v128,
          green: Iq255.v128,
          blue: Iq255.v128);
      // LRV ≈ 0.214, (0.214 + 0.05)^2 ≈ 0.0697

      // Threshold is 0.15, so gray should be dark
      expect(gray.brightness, equals(Brightness.dark));
      print('✓ Mid gray brightness: ${gray.brightness}');
    });
  });

  group('Brightness Threshold Testing', () {
    test('Colors with LRV above threshold are light', () {
      // The threshold formula is: (lrv + 0.05)^2 > 0.15
      // Solving: lrv + 0.05 > sqrt(0.15) ≈ 0.387
      // So lrv > 0.337 means light

      // A lighter gray with higher LRV
      final ColorIQ lightGray = ColorIQ.fromArgbInts(
          alpha: Iq255.v255,
          red: Iq255.v180,
          green: Iq255.v180,
          blue: Iq255.v180);

      expect(lightGray.brightness, equals(Brightness.light));
      print('✓ Light gray (180,180,180) brightness: ${lightGray.brightness}');
      print('  LRV: ${lightGray.lrv.val}');
    });

    test('Colors with LRV below threshold are dark', () {
      final ColorIQ darkGray = ColorIQ.fromArgbInts(
          alpha: Iq255.v255, red: Iq255.v60, green: Iq255.v60, blue: Iq255.v60);

      expect(darkGray.brightness, equals(Brightness.dark));
      print('✓ Dark gray (60,60,60) brightness: ${darkGray.brightness}');
      print('  LRV: ${darkGray.lrv.val}');
    });
  });

  group('Brightness with Primary Colors', () {
    test('Pure red is classified as dark', () {
      final ColorIQ red = ColorIQ(0xFFFF0000);
      // Red LRV ≈ 0.2126, (0.2126 + 0.05)^2 ≈ 0.0689 < 0.15
      expect(red.brightness, equals(Brightness.dark));
      expect(red.isDark, isTrue);
      print('✓ Red brightness: ${red.brightness}');
    });

    test('Pure green is classified as light', () {
      final ColorIQ green = ColorIQ(0xFF00FF00);
      // Green LRV ≈ 0.7152, (0.7152 + 0.05)^2 ≈ 0.5857 > 0.15
      expect(green.brightness, equals(Brightness.light));
      expect(green.isLight, isTrue);
      print('✓ Green brightness: ${green.brightness}');
    });

    test('Pure blue is classified as dark', () {
      final ColorIQ blue = cBlue;
      // Blue LRV ≈ 0.0722, (0.0722 + 0.05)^2 ≈ 0.0149 < 0.15
      expect(blue.brightness, equals(Brightness.dark));
      expect(blue.isDark, isTrue);
      print('✓ Blue brightness: ${blue.brightness}');
    });
  });

  group('Brightness with Secondary Colors', () {
    test('Yellow is classified as light', () {
      final ColorIQ yellow = ColorIQ(0xFFFFFF00);
      // Yellow LRV ≈ 0.9278
      expect(yellow.brightness, equals(Brightness.light));
      print('✓ Yellow brightness: ${yellow.brightness}');
    });

    test('Cyan is classified as light', () {
      final ColorIQ cyan = ColorIQ(0xFF00FFFF);
      // Cyan LRV ≈ 0.7874
      expect(cyan.brightness, equals(Brightness.light));
      print('✓ Cyan brightness: ${cyan.brightness}');
    });

    test('Magenta is classified as dark', () {
      final ColorIQ magenta = ColorIQ(0xFFFF00FF);
      // Magenta LRV ≈ 0.2848, (0.2848 + 0.05)^2 ≈ 0.112 < 0.15
      expect(magenta.brightness, equals(Brightness.dark));
      print('✓ Magenta brightness: ${magenta.brightness}');
    });
  });

  group('Brightness with Various Colors', () {
    test('Various colors have valid brightness classification', () {
      final List<ColorIQ> testColors = <ColorIQ>[
        cRed, // Red
        cGreen, // Green
        cBlue, // Blue
        cYellow, // Yellow
        cCyan, // Cyan
        cMagenta, // Magenta
        cWhite, // White
        cBlack, // Black
        ColorIQ(0xFF808080), // Gray
      ];

      for (final ColorIQ color in testColors) {
        expect(color.brightness,
            isIn(<Brightness>[Brightness.light, Brightness.dark]),
            reason: '${color.hexStr}: must be light or dark');
      }
      print('✓ All test colors have valid brightness values');
    });

    test('isDark and isLight are mutually exclusive', () {
      final List<ColorIQ> testColors = <ColorIQ>[
        cRed,
        cGreen,
        cBlue,
        cYellow,
        cCyan,
        cMagenta,
        cWhite,
        cBlack,
        ColorIQ(0xFF808080), // Gray
      ];

      for (final ColorIQ color in testColors) {
        expect(color.isDark, isNot(equals(color.isLight)),
            reason: '${color.hexStr}: isDark and isLight must be opposites');
      }
      print('✓ isDark and isLight are mutually exclusive for all colors');
    });
  });

  group('Brightness with Color Models', () {
    test('HSL model provides consistent brightness', () {
      const HSL hsl = HSL(0, Percent.max, Percent.mid); // Red
      expect(hsl.brightness, equals(Brightness.dark));
      expect(hsl.isDark, isTrue);
      print('✓ HSL brightness: ${hsl.brightness}');
    });

    test('HSV model provides consistent brightness', () {
      const HSV hsv = HSV(Hue.zero, Percent.max, Percent.max); // Red
      expect(hsv.brightness, equals(Brightness.dark));
      expect(hsv.isDark, isTrue);
      print('✓ HSV brightness: ${hsv.brightness}');
    });

    test('HCT model brightness delegates correctly', () {
      final HctColor hctRed = HctColor.fromInt(0xFFFF0000);
      final HctColor hctGreen = HctColor.fromInt(0xFF00FF00);

      expect(hctRed.brightness, equals(Brightness.dark));
      expect(hctRed.isDark, isTrue);
      expect(hctGreen.brightness, equals(Brightness.light));
      expect(hctGreen.isLight, isTrue);
      print('✓ HCT brightness delegates correctly');
    });

    test('CMYK model provides consistent brightness', () {
      const CMYK cmykWhite = CMYK(0, 0, 0, 0);
      const CMYK cmykBlack = CMYK(0, 0, 0, 1);

      expect(cmykWhite.brightness, equals(Brightness.light));
      expect(cmykBlack.brightness, equals(Brightness.dark));
      print(
          '✓ CMYK brightness: white=${cmykWhite.brightness}, black=${cmykBlack.brightness}');
    });
  });

  group('calculateBrightness Function', () {
    test('High LRV returns Brightness.light', () {
      expect(calculateBrightness(const Percent(0.8)), equals(Brightness.light));
      expect(calculateBrightness(const Percent(0.5)), equals(Brightness.light));
      expect(calculateBrightness(Percent.max), equals(Brightness.light));
      print('✓ High LRV values return Brightness.light');
    });

    test('Low LRV returns Brightness.dark', () {
      expect(calculateBrightness(const Percent(0.1)), equals(Brightness.dark));
      expect(calculateBrightness(const Percent(0.05)), equals(Brightness.dark));
      expect(calculateBrightness(Percent.zero), equals(Brightness.dark));
      print('✓ Low LRV values return Brightness.dark');
    });

    test('Threshold boundary behavior', () {
      // (lrv + 0.05)^2 > 0.15
      // lrv > sqrt(0.15) - 0.05 ≈ 0.337

      // Just below threshold
      expect(calculateBrightness(const Percent(0.33)), equals(Brightness.dark));

      // Just above threshold
      expect(
          calculateBrightness(const Percent(0.35)), equals(Brightness.light));

      print('✓ Threshold boundary works correctly');
    });
  });

  group('Brightness Edge Cases', () {
    test('Very dark colors are classified as dark', () {
      final ColorIQ veryDark = ColorIQ.fromArgbInts(
          alpha: Iq255.v255, red: Iq255.v5, green: Iq255.v5, blue: Iq255.v5);
      expect(veryDark.brightness, equals(Brightness.dark));
      print('✓ Very dark (5,5,5) brightness: ${veryDark.brightness}');
    });

    test('Very light colors are classified as light', () {
      final ColorIQ veryLight = ColorIQ.fromArgbInts(
          alpha: Iq255.v255,
          red: Iq255.v250,
          green: Iq255.v250,
          blue: Iq255.v250);
      expect(veryLight.brightness, equals(Brightness.light));
      print('✓ Very light (250,250,250) brightness: ${veryLight.brightness}');
    });

    test('Semitransparent colors have same brightness as opaque', () {
      // Alpha does not affect brightness calculation (it's based on RGB only)
      final ColorIQ opaqueRed = ColorIQ(0xFFFF0000);
      final ColorIQ semiRed = ColorIQ(0x80FF0000);

      expect(opaqueRed.brightness, equals(semiRed.brightness));
      print('✓ Semitransparent colors have same brightness as opaque');
    });
  });
}
