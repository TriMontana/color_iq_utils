import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HslColor Refactor Tests', () {
    test('whiten increases lightness and desaturates', () {
      final HslColor color = HslColor.alt(0, 1.0, 0.5); // Red
      final HslColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases lightness and desaturates', () {
      final HslColor color = HslColor.alt(0, 1.0, 0.5); // Red
      final HslColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      final HslColor start = HslColor.alt(0, 1.0, 0.5); // Red
      final HslColor end = HslColor.alt(120, 1.0, 0.5); // Green
      final HslColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.l, closeTo(0.5, 0.01));
    });

    test('intensify increases saturation', () {
      final HslColor color = HslColor.alt(0, 0.5, 0.5);
      final HslColor intensified = color.intensify(20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      final HslColor color = HslColor.alt(0, 0.5, 0.5);
      final HslColor deintensified = color.deintensify(20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
