import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Rec2020Color Refactor Tests', () {
    test('whiten increases RGB values', () {
      final Rec2020Color color = Rec2020Color.alt(0.5, 0.0, 0.0); // Dark Red
      final Rec2020Color whitened = color.whiten(50);

      expect(whitened.r, greaterThan(color.r));
      expect(whitened.g, greaterThan(color.g));
      expect(whitened.b, greaterThan(color.b));
    });

    test('blacken decreases RGB values', () {
      final Rec2020Color color = Rec2020Color.alt(1.0, 0.5, 0.5); // Light Red
      final Rec2020Color blackened = color.blacken(50);

      expect(blackened.r, lessThan(color.r));
      expect(blackened.g, lessThan(color.g));
      expect(blackened.b, lessThan(color.b));
    });

    test('lerp interpolates correctly', () {
      final Rec2020Color start = Rec2020Color.alt(0.0, 0.0, 0.0); // Black
      final Rec2020Color end = Rec2020Color.alt(1.0, 1.0, 1.0); // White
      final Rec2020Color mid = start.lerp(end, 0.5);

      expect(mid.r, closeTo(0.5, 0.01));
      expect(mid.g, closeTo(0.5, 0.01));
      expect(mid.b, closeTo(0.5, 0.01));
    });

    test('lighterPalette generates lighter colors', () {
      final Rec2020Color color = Rec2020Color.alt(0.5, 0.0, 0.0);
      final List<ColorSpacesIQ> palette = color.lighterPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final Rec2020Color c1 = palette[i] as Rec2020Color;
        final Rec2020Color c2 = palette[i + 1] as Rec2020Color;
        // Expect increasing brightness/whiteness
        expect(c2.r, greaterThanOrEqualTo(c1.r));
      }
    });

    test('darkerPalette generates darker colors', () {
      final Rec2020Color color = Rec2020Color.alt(0.5, 0.0, 0.0);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final Rec2020Color c1 = palette[i] as Rec2020Color;
        final Rec2020Color c2 = palette[i + 1] as Rec2020Color;
        // Expect decreasing brightness/whiteness
        expect(c2.r, lessThanOrEqualTo(c1.r));
      }
    });
  });
}
