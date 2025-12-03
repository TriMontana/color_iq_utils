import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('DisplayP3Color Refactor Tests', () {
    test('whiten increases RGB values', () {
      const DisplayP3Color color = DisplayP3Color(0.5, 0.0, 0.0); // Dark Red
      final DisplayP3Color whitened = color.whiten(50);

      expect(whitened.r, greaterThan(color.r));
      expect(whitened.g, greaterThan(color.g));
      expect(whitened.b, greaterThan(color.b));
    });

    test('blacken decreases RGB values', () {
      const DisplayP3Color color = DisplayP3Color(1.0, 0.5, 0.5); // Light Red
      final DisplayP3Color blackened = color.blacken(50);

      expect(blackened.r, lessThan(color.r));
      expect(blackened.g, lessThan(color.g));
      expect(blackened.b, lessThan(color.b));
    });

    test('lerp interpolates correctly', () {
      const DisplayP3Color start = DisplayP3Color(0.0, 0.0, 0.0); // Black
      const DisplayP3Color end = DisplayP3Color(1.0, 1.0, 1.0); // White
      final DisplayP3Color mid = start.lerp(end, 0.5);

      expect(mid.r, closeTo(0.5, 0.01));
      expect(mid.g, closeTo(0.5, 0.01));
      expect(mid.b, closeTo(0.5, 0.01));
    });

    test('lighterPalette generates lighter colors', () {
      const DisplayP3Color color = DisplayP3Color(0.5, 0.0, 0.0);
      final List<ColorSpacesIQ> palette = color.lighterPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final DisplayP3Color c1 = palette[i] as DisplayP3Color;
        final DisplayP3Color c2 = palette[i + 1] as DisplayP3Color;
        // Expect increasing brightness/whiteness
        expect(c2.r, greaterThanOrEqualTo(c1.r));
      }
    });

    test('darkerPalette generates darker colors', () {
      const DisplayP3Color color = DisplayP3Color(0.5, 0.0, 0.0);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final DisplayP3Color c1 = palette[i] as DisplayP3Color;
        final DisplayP3Color c2 = palette[i + 1] as DisplayP3Color;
        // Expect decreasing brightness/whiteness
        expect(c2.r, lessThanOrEqualTo(c1.r));
      }
    });
  });
}
