import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkHsvColor Refactor Tests', () {
    test('adjustTransparency decreases alpha', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.0, 0.0, 1.0);
      final OkHsvColor transparent = color.adjustTransparency(50);

      expect(transparent.alpha, closeTo(0.5, 0.01));
    });

    test('transparency returns alpha', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.0, 0.0, 0.5);
      expect(color.transparency, 0.5);
    });

    test('temperature returns correct value', () {
      const OkHsvColor warm = OkHsvColor(30.0, 1.0, 1.0);
      const OkHsvColor cool = OkHsvColor(210.0, 1.0, 1.0);

      expect(warm.temperature, ColorTemperature.warm);
      expect(cool.temperature, ColorTemperature.cool);
    });

    test('whiten increases value', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.0, 0.0);
      final OkHsvColor whitened = color.whiten(50);
      expect(whitened.val, greaterThan(color.val));
    });

    test('blacken decreases value', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.0, 1.0);
      final OkHsvColor blackened = color.blacken(50);
      expect(blackened.val, lessThan(color.val));
    });

    test('lerp interpolates correctly', () {
      const OkHsvColor start = OkHsvColor(0.0, 0.0, 0.0);
      const OkHsvColor end = OkHsvColor(0.0, 0.0, 1.0);
      final OkHsvColor mid = start.lerp(end, 0.5);
      expect(mid.val, closeTo(0.5, 0.01));
    });

    test('intensify increases saturation', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.5, 0.5);
      final OkHsvColor intensified = color.intensify(10);
      expect(intensified.saturation, greaterThan(color.saturation));
    });

    test('deintensify decreases saturation', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.5, 0.5);
      final OkHsvColor deintensified = color.deintensify(10);
      expect(deintensified.saturation, lessThan(color.saturation));
    });
  });
}
