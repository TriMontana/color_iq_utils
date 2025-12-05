import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsvColor Refactor Tests', () {
    test('whiten increases value and desaturates', () {
      final HsvColor color = HsvColor.alt(0, 1.0, 0.5); // Dark Red
      final HsvColor whitened = color.whiten(50);

      expect(whitened.v, greaterThan(color.v));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases value and desaturates', () {
      const HsvColor color = kHsvRed; // Red
      final HsvColor blackened = color.blacken(50);

      expect(blackened.v, lessThan(color.v));
      // lerp(cBlack, 0.5) -> cBlack is (0, 0, 0).
      // Red is (0, 1, 1).
      // Mid is (0, 0.5, 0.5).
      // So S drops too.
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HsvColor start = kHsvRed; // Red
      const HsvColor end = hsvGreen; // Green
      final HsvColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.v, closeTo(1.0, 0.01));
    });

    test('intensify increases saturation', () {
      final HsvColor color = HsvColor.alt(0, 0.5, 1.0);
      final HsvColor intensified = color.intensify(20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      final HsvColor color = HsvColor.alt(0, 0.5, 1.0);
      final HsvColor deintensified = color.deintensify(20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });

    test('blend interpolates correctly', () {
      const HsvColor start = kHsvRed; // Red (0, 1, 1)
      const HsvColor end = hsvGreen; // Green (120, 1, 1)
      final HsvColor blended = start.blend(end, 50);

      expect(blended.h, closeTo(60, 0.1)); // Yellow
      expect(blended.s, closeTo(1.0, 0.01));
      expect(blended.v, closeTo(1.0, 0.01));
    });

    test('opaquer increases alpha', () {
      final HsvColor color =
          HsvColor.alt(0, 1.0, 1.0, alpha: const Percent(0.5));
      final HsvColor opaque = color.opaquer(20);

      expect(opaque.alpha, closeTo(0.7, 0.01));
    });

    test('adjustHue rotates hue', () {
      const HsvColor color = kHsvRed; // 0
      final HsvColor adjusted = color.adjustHue(90);

      expect(adjusted.h, closeTo(90, 0.1));
    });

    test('complementary rotates hue by 180', () {
      const HsvColor color = kHsvRed; // 0
      final HsvColor comp = color.complementary;

      expect(comp.h, closeTo(180, 0.1)); // Cyan
    });
  });
}
