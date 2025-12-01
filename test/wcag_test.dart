import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('WCAG Contrast Tests', () {
    test('Contrast Ratio Calculation', () {
      final black = ColorIQ(0xFF000000);
      final white = ColorIQ(0xFFFFFFFF);
      
      // Max contrast
      expect(black.contrastWith(white), closeTo(21.0, 0.1));
      expect(white.contrastWith(black), closeTo(21.0, 0.1));
      
      // Self contrast
      expect(black.contrastWith(black), equals(1.0));
    });

    test('Meets WCAG Levels', () {
      final black = ColorIQ(0xFF000000);
      final white = ColorIQ(0xFFFFFFFF);
      final gray = ColorIQ(0xFF6C6C6C); // ~4.0:1 against black

      // White on Black (21:1) -> Passes everything
      expect(white.meetsWcag(black, level: WcagLevel.aa), isTrue);
      expect(white.meetsWcag(black, level: WcagLevel.aaa), isTrue);

      // Gray on Black (~3.95:1)
      // Fails AA Normal (4.5)
      expect(gray.meetsWcag(black, level: WcagLevel.aa), isFalse);
      // Passes AA Large (3.0)
      expect(gray.meetsWcag(black, level: WcagLevel.aa, isLargeText: true), isTrue);
      
      // Gray (108) on White
      // Luminance ~0.15. White ~1.0.
      // Ratio: (1.05) / (0.2) = 5.25.
      // Passes AA Normal (4.5)
      expect(gray.meetsWcag(white, level: WcagLevel.aa), isTrue);
      // Fails AAA Normal (7.0)
      expect(gray.meetsWcag(white, level: WcagLevel.aaa), isFalse);
    });

    test('Extension works on other models', () {
      final hslBlack = HslColor(0, 0, 0);
      final hslWhite = HslColor(0, 0, 1.0);
      
      expect(hslWhite.meetsWcag(hslBlack), isTrue);
    });
  });
}
