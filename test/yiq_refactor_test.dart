import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('YiqColor Refactor Tests', () {
    test('whiten increases brightness', () {
      final YiqColor color = YiqColor.alt(0.5, 0.0, 0.0); // Gray
      final YiqColor whitened = color.whiten(50);

      expect(whitened.y, greaterThan(color.y));
    });

    test('blacken decreases brightness', () {
      final YiqColor color = YiqColor.alt(0.5, 0.0, 0.0); // Gray
      final YiqColor blackened = color.blacken(50);

      expect(blackened.y, lessThan(color.y));
    });

    test('lerp interpolates correctly', () {
      final YiqColor start = YiqColor.alt(0.0, 0.0, 0.0); // Black
      const YiqColor end = YiqColor(1.0, 0.0, 0.0); // White
      final YiqColor mid = start.lerp(end, 0.5);

      expect(mid.y, closeTo(0.5, 0.01));
      expect(mid.i, closeTo(0.0, 0.01));
      expect(mid.q, closeTo(0.0, 0.01));
    });

    test('saturate increases chrominance', () {
      const YiqColor color = YiqColor(0.5, 0.1, 0.1);
      final YiqColor saturated = color.saturate(50);

      expect(saturated.i.abs(), greaterThan(color.i.abs()));
      expect(saturated.q.abs(), greaterThan(color.q.abs()));
    });

    test('desaturate decreases chrominance', () {
      final YiqColor color = YiqColor.alt(0.5, 0.1, 0.1);
      final YiqColor desaturated = color.desaturate(50);

      expect(desaturated.i.abs(), lessThan(color.i.abs()));
      expect(desaturated.q.abs(), lessThan(color.q.abs()));
    });
  });
}
