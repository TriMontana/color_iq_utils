import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsbColor Refactor Tests', () {
    test('whiten increases brightness and desaturates', () {
      const HsbColor color = HsbColor(0, 1.0, 0.5); // Dark Red
      final HsbColor whitened = color.whiten(50);

      expect(whitened.b, greaterThan(color.b));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases brightness and desaturates', () {
      const HsbColor color = HsbColor(0, 1.0, 0.5); // Red
      final HsbColor blackened = color.blacken(50);

      expect(blackened.b, lessThan(color.b));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HsbColor start = HsbColor(0, 1.0, 0.5); // Red
      const HsbColor end = HsbColor(120, 1.0, 0.5); // Green
      final HsbColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.b, closeTo(0.5, 0.01));
    });

    test('intensify increases saturation', () {
      const HsbColor color = HsbColor(0, 0.5, 0.5);
      final HsbColor intensified = color.intensify(20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HsbColor color = HsbColor(0, 0.5, 0.5);
      final HsbColor deintensified = color.deintensify(20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
