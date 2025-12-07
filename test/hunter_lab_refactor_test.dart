import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HunterLabColor Refactor Tests', () {
    test('whiten increases lightness', () {
      final HunterLabColor color = HunterLabColor(50.0, 0.0, 0.0); // Gray
      final HunterLabColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
    });

    test('blacken decreases lightness', () {
      final HunterLabColor color = HunterLabColor(50.0, 0.0, 0.0); // Gray
      final HunterLabColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
    });

    test('lerp interpolates correctly', () {
      final HunterLabColor start = HunterLabColor(0.0, 0.0, 0.0); // Black
      final HunterLabColor end = HunterLabColor(100.0, 0.0, 0.0); // White
      final HunterLabColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50.0, 0.01));
      expect(mid.aLab, closeTo(0.0, 0.01));
      expect(mid.bLab, closeTo(0.0, 0.01));
    });

    test('saturate increases chrominance', () {
      final HunterLabColor color = HunterLabColor(50.0, 10.0, 10.0);
      final HunterLabColor saturated = color.saturate(50);

      expect(saturated.aLab.abs(), greaterThan(color.aLab.abs()));
      expect(saturated.bLab.abs(), greaterThan(color.bLab.abs()));
    });

    test('desaturate decreases chrominance', () {
      final HunterLabColor color = HunterLabColor(50.0, 10.0, 10.0);
      final HunterLabColor desaturated = color.desaturate(50);

      expect(desaturated.aLab.abs(), lessThan(color.aLab.abs()));
      expect(desaturated.bLab.abs(), lessThan(color.bLab.abs()));
    });
  });
}
