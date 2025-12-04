import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HspColor Refactor Tests', () {
    test('whiten increases brightness and desaturates', () {
      final HspColor color = HspColor.alt(0, 1.0, 0.5); // Dark Red
      final HspColor whitened = color.whiten(50);

      expect(whitened.p, greaterThan(color.p));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases brightness and desaturates', () {
      final HspColor color = HspColor.alt(0, 1.0, 1.0); // Red
      final HspColor blackened = color.blacken(50);

      expect(blackened.p, lessThan(color.p));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      final HspColor start = HspColor.alt(0, 1.0, 1.0); // Red
      final HspColor end = HspColor.alt(120, 1.0, 1.0); // Green
      final HspColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.p, closeTo(1.0, 0.01));
    });

    test('intensify increases saturation', () {
      final HspColor color = HspColor.alt(0, 0.5, 1.0);
      final HspColor intensified = color.intensify(20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      final HspColor color = HspColor.alt(0, 0.5, 1.0);
      final HspColor deintensified = color.deintensify(20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
