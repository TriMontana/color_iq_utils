import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkHslColor Refactor Tests', () {
    test('whiten increases lightness and desaturates', () {
      final OkHslColor color = OkHslColor.alt(0, 1.0, 0.5); // Red
      final OkHslColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.s, lessThan(color.s));
      // Hue should be preserved because white is achromatic
      // Note: OkHslColor lerp now handles achromatic hue preservation
      expect(whitened.h, closeTo(color.h, 0.1));
    });

    test('blacken decreases lightness and desaturates', () {
      const OkHslColor color = OkHslColor(0, 1.0, 0.5); // Red
      final OkHslColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.s,
          lessThan(color.s)); // Saturation drops as we mix with black (S=0)
      // Hue should be preserved because black is achromatic
      expect(blackened.h, closeTo(color.h, 0.1));
    });

    test('lerp interpolates correctly', () {
      const OkHslColor start = OkHslColor(0, 1.0, 0.5); // Red
      const OkHslColor end = OkHslColor(120, 1.0, 0.5); // Green
      final OkHslColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.l, closeTo(0.5, 0.01));
    });

    test('lerp handles hue wrapping', () {
      const OkHslColor start = OkHslColor(350, 1.0, 0.5);
      const OkHslColor end = OkHslColor(10, 1.0, 0.5);
      final OkHslColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(0, 0.1) /* or 360 */);
    });
  });
}
