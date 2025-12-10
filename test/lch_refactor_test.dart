import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('LchColor Refactor Tests', () {
    test('whiten increases lightness and desaturates', () {
      const LchColor color = LchColor(50, 100, 0); // Red-ish
      final LchColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      // White is achromatic, so hue might drift or be irrelevant.
      // Ideally it stays close if we handle achromatic interpolation correctly.
      // However, cWhite might have a different hue definition in Lch.
      // Let's check if it's achromatic (chroma near 0).
      expect(whitened.c, lessThan(color.c));
      // If chroma is low, hue is less important, but let's see if our lerp preserved it.
      // Our lerp preserves hue if one side is achromatic.
      // But cWhite (0xFFFFFFFF) -> Lch might have non-zero chroma due to gamut mapping or conversion noise?
      // Actually cWhite is L=100, C=0.
      expect(whitened.h, closeTo(color.h, 1.0));
      print('✓ LchColor Refactor Tests');
    });

    test('blacken decreases lightness and desaturates', () {
      const LchColor color = LchColor(50, 100, 0); // Red-ish
      final LchColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.c, lessThan(color.c));
      expect(blackened.h, closeTo(color.h, 0.1));
      print('✓ LchColor Refactor Tests');
    });

    test('lerp interpolates correctly', () {
      const LchColor start = LchColor(50, 100, 0); // Red-ish
      const LchColor end = LchColor(50, 100, 120); // Green-ish
      final LchColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50, 0.1));
      expect(mid.c, closeTo(100, 0.1));
      expect(mid.h, closeTo(60, 0.1)); // Yellow-ish
    });

    test('lerp handles hue wrapping', () {
      const LchColor start = LchColor(50, 100, 350);
      const LchColor end = LchColor(50, 100, 10);
      final LchColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(0, 0.1) /* or 360 */);
    });

    test('lerp handles achromatic colors', () {
      const LchColor color = LchColor(50, 100, 120);
      const LchColor gray = LchColor(50, 0, 0); // Hue doesn't matter

      final LchColor mid = color.lerp(gray, 0.5);
      expect(mid.h, closeTo(120, 0.1)); // Should preserve color hue

      final LchColor mid2 = gray.lerp(color, 0.5);
      expect(mid2.h, closeTo(120, 0.1)); // Should preserve color hue
    });
  });
}
