import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('CmykColor Refactor Tests', () {
    test('whiten decreases K', () {
      final CmykColor color = CmykColor(0.0, 0.0, 0.0, 0.5); // Gray
      final CmykColor whitened = color.whiten(50);

      expect(whitened.k, lessThan(color.k));
    });

    test('blacken increases K', () {
      final CmykColor color = CmykColor(0.0, 0.0, 0.0, 0.5); // Gray
      final CmykColor blackened = color.blacken(50);

      expect(blackened.k, greaterThan(color.k));
    });

    test('lerp interpolates correctly', () {
      final CmykColor start = CmykColor(0.0, 0.0, 0.0, 1.0); // Black
      final CmykColor end = CmykColor(0.0, 0.0, 0.0, 0.0); // White
      final CmykColor mid = start.lerp(end, 0.5);

      expect(mid.k, closeTo(0.5, 0.01));
    });

    test('lighterPalette generates lighter colors', () {
      final CmykColor color = CmykColor(0.0, 0.0, 0.0, 0.5);
      final List<ColorSpacesIQ> palette = color.lighterPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final CmykColor c1 = palette[i] as CmykColor;
        final CmykColor c2 = palette[i + 1] as CmykColor;
        // Expect decreasing K (lighter)
        expect(c2.k, lessThanOrEqualTo(c1.k));
      }
    });

    test('darkerPalette generates darker colors', () {
      final CmykColor color = CmykColor(0.0, 0.0, 0.0, 0.5);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final CmykColor c1 = palette[i] as CmykColor;
        final CmykColor c2 = palette[i + 1] as CmykColor;
        // Expect increasing K (darker)
        expect(c2.k, greaterThanOrEqualTo(c1.k));
      }
    });
  });
}
