import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Cam16Color Refactor Tests', () {
    test('whiten increases J', () {
      const Cam16Color color =
          Cam16Color(0.0, 0.0, 50.0, 0.0, 0.0, 0.0); // Gray
      final Cam16Color whitened = color.whiten(50);

      expect(whitened.j, greaterThan(color.j));
    });

    test('blacken decreases J', () {
      const Cam16Color color =
          Cam16Color(0.0, 0.0, 50.0, 0.0, 0.0, 0.0); // Gray
      final Cam16Color blackened = color.blacken(50);

      expect(blackened.j, lessThan(color.j));
    });

    test('lerp interpolates correctly', () {
      const Cam16Color start =
          Cam16Color(0.0, 0.0, 0.0, 0.0, 0.0, 0.0); // Black
      const Cam16Color end =
          Cam16Color(0.0, 0.0, 100.0, 0.0, 0.0, 0.0); // White
      final Cam16Color mid = start.lerp(end, 0.5);

      expect(mid.j, closeTo(50.0, 0.01));
    });

    test('lerp handles hue wrapping', () {
      const Cam16Color start = Cam16Color(10.0, 50.0, 50.0, 0.0, 0.0, 0.0);
      const Cam16Color end = Cam16Color(350.0, 50.0, 50.0, 0.0, 0.0, 0.0);
      final Cam16Color mid = start.lerp(end, 0.5);

      // Shortest path is through 0/360, so average is 0 or 360
      expect(mid.hue, closeTo(0.0, 0.01));
    });

    test('saturate increases chroma', () {
      const Cam16Color color = Cam16Color(0.0, 50.0, 50.0, 0.0, 0.0, 0.0);
      final Cam16Color saturated = color.saturate(10);

      expect(saturated.chroma, greaterThan(color.chroma));
    });

    test('desaturate decreases chroma', () {
      const Cam16Color color = Cam16Color(0.0, 50.0, 50.0, 0.0, 0.0, 0.0);
      final Cam16Color desaturated = color.desaturate(10);

      expect(desaturated.chroma, lessThan(color.chroma));
    });

    test('intensify increases s', () {
      const Cam16Color color = Cam16Color(0.0, 50.0, 50.0, 0.0, 0.0, 50.0);
      final Cam16Color intensified = color.intensify(10);

      expect(intensified.s, greaterThan(color.s));
    });

    test('deintensify decreases s', () {
      const Cam16Color color = Cam16Color(0.0, 50.0, 50.0, 0.0, 0.0, 50.0);
      final Cam16Color deintensified = color.deintensify(10);

      expect(deintensified.s, lessThan(color.s));
    });
  });
}
