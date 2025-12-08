import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsbColor Refactor Tests', () {
    test('whiten increases brightness and desaturates', () {
      const HsbColor color = HsbColor(0, 1.0, Percent.mid); // Dark Red
      final HsbColor whitened = color.whiten(Percent.mid);

      expect(whitened.b, greaterThan(color.b));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases brightness and desaturates', () {
      const HsbColor color = HsbColor(0, 1.0, Percent.mid); // Red
      final HsbColor blackened = color.blacken(Percent.mid);

      expect(blackened.b, lessThan(color.b));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HsbColor start = HsbColor(0, 1.0, Percent.mid); // Red
      const HsbColor end = HsbColor(120, 1.0, Percent.mid); // Green
      final HsbColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.b, closeTo(0.5, 0.01));
    });

    test('intensify increases saturation', () {
      const HsbColor color = HsbColor(0, 0.5, Percent.mid);
      final HsbColor intensified = color.intensify(Percent.v20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HsbColor color = HsbColor(0, 0.5, Percent.mid);
      final HsbColor deintensified = color.deintensify(Percent.v20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
