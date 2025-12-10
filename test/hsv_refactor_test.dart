import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsvColor Refactor Tests', () {
    test('whiten increases value and desaturates', () {
      const HSV color = HSV(0, Percent.max, Percent.mid); // Dark Red
      final HSV whitened = color.whiten(Percent.mid);

      expect(whitened.value, greaterThan(color.value));
      expect(whitened.saturation, lessThan(color.saturation));
    });

    test('blacken decreases value and desaturates', () {
      const HSV color = HSV(0, Percent.max, Percent.max); // Red
      final HSV blackened = color.blacken(Percent.mid);

      expect(blackened.value, lessThan(color.value));
      // lerp(cBlack, 0.5) -> cBlack is (0, 0, 0).
      // Red is (0, 1, 1).
      // Mid is (0, 0.5, 0.5).
      // So S drops too.
      expect(blackened.saturation, lessThan(color.saturation));
    });

    test('lerp interpolates correctly', () {
      const HSV start = HSV(0, Percent.max, Percent.max); // Red
      const HSV end = HSV(120, Percent.max, Percent.max); // Green
      final HSV mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.saturation, closeTo(1.0, 0.01));
      expect(mid.value, closeTo(1.0, 0.01));
    });

    test('intensify increases saturation', () {
      const HSV color = HSV(0, Percent.mid, Percent.max);
      final HSV intensified = color.intensify(Percent.v20);

      expect(intensified.saturation, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HSV color = HSV(0, Percent.mid, Percent.max);
      final HSV deintensified = color.deintensify(Percent.v20);

      expect(deintensified.saturation, closeTo(0.3, 0.01));
    });

    test('blend interpolates correctly', () {
      const HSV start = HSV(0, Percent.max, Percent.max); // Red (0, 1, 1)
      const HSV end = HSV(120, Percent.max, Percent.max); // Green (120, 1, 1)
      final HSV blended = start.blend(end, Percent.mid);

      expect(blended.h, closeTo(60, 0.1)); // Yellow
      expect(blended.saturation, closeTo(1.0, 0.01));
      expect(blended.value, closeTo(1.0, 0.01));
    });

    test('opaquer increases alpha', () {
      const HSV color = HSV(0, Percent.max, Percent.max, a: Percent.mid);
      final HSV opaque = color.opaquer(Percent.mid);

      expect(opaque.a, closeTo(0.7, 0.01));
    });

    test('adjustHue rotates hue', () {
      const HSV color = HSV(0, Percent.max, Percent.max); // 0
      final HSV adjusted = color.adjustHue(90);

      expect(adjusted.h, closeTo(90, 0.1));
    });

    test('complementary rotates hue by 180', () {
      const HSV color = HSV(0, Percent.max, Percent.max); // 0
      final HSV comp = color.complementary;

      expect(comp.h, closeTo(180, 0.1)); // Cyan
    });
  });
}
