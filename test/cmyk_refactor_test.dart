import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('CmykColor Refactor Tests', () {
    test('whiten decreases K', () {
      const CMYK color = CMYK(0.0, 0.0, 0.0, 0.5); // Gray
      final CMYK whitened = color.whiten(50);

      expect(whitened.k, lessThan(color.k));
      print('✓ CMYK.whiten decreases K');
    });

    test('blacken increases K', () {
      const CMYK color = CMYK(0.0, 0.0, 0.0, 0.5); // Gray
      final CMYK blackened = color.blacken(50);

      expect(blackened.k, greaterThan(color.k));
      print('✓ CMYK.blacken increases K');
    });

    test('lerp interpolates correctly', () {
      const CMYK start = CMYK(0.0, 0.0, 0.0, 1.0); // Black
      const CMYK end = CMYK(0.0, 0.0, 0.0, 0.0); // White
      final CMYK mid = start.lerp(end, 0.5);

      expect(mid.k, closeTo(0.5, 0.01));
    });

    test('lighterPalette generates lighter colors', () {
      const CMYK color = CMYK(0.0, 0.0, 0.0, 0.5);
      final List<ColorSpacesIQ> palette = color.lighterPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final CMYK c1 = palette[i] as CMYK;
        final CMYK c2 = palette[i + 1] as CMYK;
        // Expect decreasing K (lighter)
        expect(c2.k, lessThanOrEqualTo(c1.k));
      }
    });

    test('darkerPalette generates darker colors', () {
      const CMYK color = CMYK(0.0, 0.0, 0.0, 0.5);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final CMYK c1 = palette[i] as CMYK;
        final CMYK c2 = palette[i + 1] as CMYK;
        // Expect increasing K (darker)
        expect(c2.k, greaterThanOrEqualTo(c1.k));
      }
      print('✓ CMYK.darkerPalette generates darker colors');
    });
  });
}
