import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:test/test.dart';

void main() {
  group('WCAG Contrast Tests', () {
    test('Contrast Ratio Calculation', () {
      // Max contrast
      expect(cBlack.contrastWith(cWhite), closeTo(21.0, 0.1));
      expect(cWhite.contrastWith(cBlack), closeTo(21.0, 0.1));

      // Self contrast
      expect(cBlack.contrastWith(cBlack), equals(1.0));
    });

    test('Meets WCAG Levels', () {
      final ColorIQ gray = ColorIQ(0xFF6C6C6C); // ~4.0:1 against black

      // White on Black (21:1) -> Passes everything
      expect(cWhite.meetsWcag(cBlack, level: WcagLevel.aa), isTrue);
      expect(cWhite.meetsWcag(cBlack, level: WcagLevel.aaa), isTrue);

      // Gray on Black (~3.95:1)
      // Fails AA Normal (4.5)
      expect(gray.meetsWcag(cBlack, level: WcagLevel.aa), isFalse);
      // Passes AA Large (3.0)
      expect(
        gray.meetsWcag(cBlack, level: WcagLevel.aa, isLargeText: true),
        isTrue,
      );

      // Gray (108) on White
      // Luminance ~0.15. White ~1.0.
      // Ratio: (1.05) / (0.2) = 5.25.
      // Passes AA Normal (4.5)
      expect(gray.meetsWcag(cWhite, level: WcagLevel.aa), isTrue);
      // Fails AAA Normal (7.0)
      expect(gray.meetsWcag(cWhite, level: WcagLevel.aaa), isFalse);
    });

    test('Extension works on other models', () {
      expect(kHslWhite.meetsWcag(kHslBlack), isTrue);
    });
  });
}
