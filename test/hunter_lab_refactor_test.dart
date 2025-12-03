import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HunterLabColor Refactor Tests', () {
    test('whiten increases lightness', () {
      const HunterLabColor color = HunterLabColor(50.0, 0.0, 0.0); // Gray
      final HunterLabColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
    });

    test('blacken decreases lightness', () {
      const HunterLabColor color = HunterLabColor(50.0, 0.0, 0.0); // Gray
      final HunterLabColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
    });

    test('lerp interpolates correctly', () {
      const HunterLabColor start = HunterLabColor(0.0, 0.0, 0.0); // Black
      const HunterLabColor end = HunterLabColor(100.0, 0.0, 0.0); // White
      final HunterLabColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50.0, 0.01));
      expect(mid.a, closeTo(0.0, 0.01));
      expect(mid.b, closeTo(0.0, 0.01));
    });

    test('saturate increases chrominance', () {
      const HunterLabColor color = HunterLabColor(50.0, 10.0, 10.0);
      final HunterLabColor saturated = color.saturate(50);

      expect(saturated.a.abs(), greaterThan(color.a.abs()));
      expect(saturated.b.abs(), greaterThan(color.b.abs()));
    });

    test('desaturate decreases chrominance', () {
      const HunterLabColor color = HunterLabColor(50.0, 10.0, 10.0);
      final HunterLabColor desaturated = color.desaturate(50);

      expect(desaturated.a.abs(), lessThan(color.a.abs()));
      expect(desaturated.b.abs(), lessThan(color.b.abs()));
    });
  });
}
