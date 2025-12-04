import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/constants.dart';
import 'package:test/test.dart';

void main() {
  group('YuvColor Refactor Tests', () {
    test('whiten increases brightness', () {
      final YuvColor color = YuvColor.alt(0.5, 0.0, 0.0); // Gray
      final YuvColor whitened = color.whiten(50);

      expect(whitened.y, greaterThan(color.y));
    });

    test('blacken decreases brightness', () {
      final YuvColor color = YuvColor.alt(0.5, 0.0, 0.0); // Gray
      final YuvColor blackened = color.blacken(50);

      expect(blackened.y, lessThan(color.y));
    });

    test('lerp interpolates correctly', () {
      const YuvColor start = yuvBlack; // Black
      final YuvColor end = YuvColor.alt(1.0, 0.0, 0.0); // White
      final YuvColor mid = start.lerp(end, 0.5);

      expect(mid.y, closeTo(0.5, 0.01));
      expect(mid.u, closeTo(0.0, 0.01));
      expect(mid.v, closeTo(0.0, 0.01));
    });

    test('saturate increases chrominance', () {
      final YuvColor color = YuvColor.alt(0.5, 0.1, 0.1);
      final YuvColor saturated = color.saturate(50);

      expect(saturated.u.abs(), greaterThan(color.u.abs()));
      expect(saturated.v.abs(), greaterThan(color.v.abs()));
    });

    test('desaturate decreases chrominance', () {
      final YuvColor color = YuvColor.alt(0.5, 0.1, 0.1);
      final YuvColor desaturated = color.desaturate(50);

      expect(desaturated.u.abs(), lessThan(color.u.abs()));
      expect(desaturated.v.abs(), lessThan(color.v.abs()));
    });
  });
}
