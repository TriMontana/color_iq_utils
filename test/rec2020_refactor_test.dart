import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Rec2020Color Refactor Tests', () {
    test('whiten increases RGB values', () {
      const Rec2020Color color =
          Rec2020Color(Percent.mid, Percent.zero, Percent.zero); // Dark Red
      final Rec2020Color whitened = color.whiten(50);

      expect(whitened.r, greaterThan(color.r));
      expect(whitened.g, greaterThan(color.g));
      expect(whitened.b, greaterThan(color.b));
      print('✓ Rec2020Color Refactor Tests');
    });

    test('blacken decreases RGB values', () {
      const Rec2020Color color =
          Rec2020Color(Percent.max, Percent.mid, Percent.mid); // Light Red
      final Rec2020Color blackened = color.blacken(50);

      expect(blackened.r, lessThan(color.r));
      expect(blackened.g, lessThan(color.g));
      expect(blackened.b, lessThan(color.b));
      print('✓ Rec2020Color Refactor Tests');
    });

    test('lerp interpolates correctly', () {
      const Rec2020Color start =
          Rec2020Color(Percent.min, Percent.zero, Percent.zero); // Black
      const Rec2020Color end =
          Rec2020Color(Percent.max, Percent.max, Percent.max); // White
      final Rec2020Color mid = start.lerp(end, 0.5);

      expect(mid.r, closeTo(0.5, 0.01));
      expect(mid.g, closeTo(0.5, 0.01));
      expect(mid.b, closeTo(0.5, 0.01));
      print('✓ lerp interpolates correctly');
    });

    test('lighterPalette generates lighter colors', () {
      const Rec2020Color color =
          Rec2020Color(Percent.mid, Percent.zero, Percent.zero);
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
      const Rec2020Color color =
          Rec2020Color(Percent.mid, Percent.zero, Percent.zero);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);

      expect(palette.length, 5);
      for (int i = 0; i < palette.length - 1; i++) {
        final Rec2020Color c1 = palette[i] as Rec2020Color;
        final Rec2020Color c2 = palette[i + 1] as Rec2020Color;
        // Expect decreasing brightness/whiteness
        expect(c2.r, lessThanOrEqualTo(c1.r));
        print('✓ darkerPalette generates darker colors');
      }
    });
  });
}
