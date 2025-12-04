import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsluvColor Refactor Tests', () {
    test('whiten increases lightness and desaturates', () {
      final HsluvColor color = HsluvColor.alt(0, 100, 50); // Red
      final HsluvColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases lightness and desaturates', () {
      final HsluvColor color = HsluvColor.alt(0, 100, 50); // Red
      final HsluvColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      final HsluvColor start = HsluvColor.alt(0, 100, 50); // Red
      final HsluvColor end = HsluvColor.alt(120, 100, 50); // Green
      final HsluvColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(100, 0.01));
      expect(mid.l, closeTo(50, 0.01));
    });

    test('grayscale sets saturation to 0', () {
      final HsluvColor color = HsluvColor.alt(0, 100, 50);
      final HsluvColor gray = color.grayscale;

      expect(gray.s, equals(0));
      expect(gray.l, equals(color.l));
    });
  });
}
