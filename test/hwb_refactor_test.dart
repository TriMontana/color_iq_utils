import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HwbColor Refactor Tests', () {
    test('whiten increases whiteness', () {
      const HwbColor color = HwbColor(0, 0, 0); // Red (pure)
      final HwbColor whitened = color.whiten(50);

      expect(whitened.w, greaterThan(color.w));
      expect(whitened.b,
          equals(color.b)); // Blackness shouldn't change for pure whiten?
      // Actually whiten(50) lerps to white (0, 1, 0).
      // So w goes 0 -> 0.5. b goes 0 -> 0.
    });

    test('blacken increases blackness', () {
      const HwbColor color = HwbColor(0, 0, 0); // Red (pure)
      final HwbColor blackened = color.blacken(50);

      expect(blackened.b, greaterThan(color.b));
      expect(blackened.w, equals(color.w));
      // blacken(50) lerps to black (0, 0, 1).
      // So b goes 0 -> 0.5. w goes 0 -> 0.
    });

    test('lerp interpolates correctly', () {
      const HwbColor start = HwbColor(0, 0, 0); // Red
      const HwbColor end = HwbColor(120, 0.5, 0); // Light Green
      final HwbColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.w, closeTo(0.25, 0.01));
      expect(mid.b, closeTo(0, 0.01));
    });

    test('saturate decreases w and b', () {
      const HwbColor color = HwbColor(0, 0.5, 0.5); // Grayish
      final HwbColor saturated = color.saturate(50);

      expect(saturated.w, lessThan(color.w));
      expect(saturated.b, lessThan(color.b));
    });

    test('desaturate increases w and b', () {
      const HwbColor color = HwbColor(0, 0, 0); // Pure Red
      final HwbColor desaturated = color.desaturate(50);

      expect(desaturated.w, greaterThan(color.w));
      expect(desaturated.b, greaterThan(color.b));
    });
  });
}
