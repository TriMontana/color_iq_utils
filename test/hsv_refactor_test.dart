import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsvColor Refactor Tests', () {
    test('whiten increases value and desaturates', () {
      const HsvColor color = HsvColor(0, 1.0, 0.5); // Dark Red
      final HsvColor whitened = color.whiten(50);

      expect(whitened.v, greaterThan(color.v));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases value and desaturates', () {
      const HsvColor color = HsvColor(0, 1.0, 1.0); // Red
      final HsvColor blackened = color.blacken(50);

      expect(blackened.v, lessThan(color.v));
      // lerp(cBlack, 0.5) -> cBlack is (0, 0, 0).
      // Red is (0, 1, 1).
      // Mid is (0, 0.5, 0.5).
      // So S drops too.
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HsvColor start = HsvColor(0, 1.0, 1.0); // Red
      const HsvColor end = HsvColor(120, 1.0, 1.0); // Green
      final HsvColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.v, closeTo(1.0, 0.01));
    });

    test('intensify increases saturation', () {
      const HsvColor color = HsvColor(0, 0.5, 1.0);
      final HsvColor intensified = color.intensify(20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HsvColor color = HsvColor(0, 0.5, 1.0);
      final HsvColor deintensified = color.deintensify(20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
