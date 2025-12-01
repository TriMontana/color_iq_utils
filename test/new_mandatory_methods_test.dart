import 'package:test/test.dart';
import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  group('New Mandatory Methods Tests', () {
    test('Random Color Generation', () {
      final color = ColorIQ(0xFF000000);
      final random = color.random;
      expect(random, isA<ColorIQ>());
      expect(random.value, isNot(0xFF000000)); // Unlikely to be black again
      
      final hsl = HslColor(0, 0, 0);
      final randomHsl = hsl.random;
      expect(randomHsl, isA<HslColor>());
    });

    test('isEqual', () {
      final c1 = ColorIQ.fromARGB(255, 100, 100, 100);
      final c2 = ColorIQ.fromARGB(255, 100, 100, 100);
      final c3 = ColorIQ.fromARGB(255, 200, 200, 200);
      
      expect(c1.isEqual(c2), isTrue);
      expect(c1.isEqual(c3), isFalse);
      
      final hsl1 = c1.toHsl();
      expect(c1.isEqual(hsl1), isTrue); // Should work across types
    });

    test('Luminance', () {
      final white = ColorIQ(0xFFFFFFFF);
      final black = ColorIQ(0xFF000000);
      final red = ColorIQ(0xFFFF0000);
      
      expect(white.luminance, closeTo(1.0, 0.01));
      expect(black.luminance, closeTo(0.0, 0.01));
      // Red luminance: 0.2126
      expect(red.luminance, closeTo(0.2126, 0.01));
      
      final hslWhite = HslColor(0, 0, 1.0);
      expect(hslWhite.luminance, closeTo(1.0, 0.01));
    });

    test('Brightness', () {
      final white = ColorIQ(0xFFFFFFFF);
      final black = ColorIQ(0xFF000000);
      
      expect(white.brightness, Brightness.light);
      expect(black.brightness, Brightness.dark);
      
      // Threshold check
      // kThreshold = 0.15
      // (lum + 0.05)^2 > 0.15
      // lum + 0.05 > sqrt(0.15) ~ 0.387
      // lum > 0.337
      
      final darkGrey = ColorIQ.fromARGB(255, 50, 50, 50); // Lum ~ 0.03
      expect(darkGrey.brightness, Brightness.dark);
      
      final lightGrey = ColorIQ.fromARGB(255, 200, 200, 200); // Lum ~ 0.5
      expect(lightGrey.brightness, Brightness.light);
    });
  });
}
