import 'package:color_iq_utils/src/extensions/cam16_helper.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:test/test.dart';

void main() {
  group('Cam16Color Refactor Tests', () {
    test('whiten increases J', () {
      final Cam16 color = Cam16.fromJch(0.0, 0.0, 50.0); // Gray
      final Cam16 whitened = color.whiten(50);

      expect(whitened.j, greaterThan(color.j));
    });

    test('blacken decreases J', () {
      final Cam16 color = Cam16.fromJch(0.0, 0.0, 50.0); // Gray
      final Cam16 blackened = color.blacken(50);

      expect(blackened.j, lessThan(color.j));
    });

    test('lerp interpolates correctly', () {
      final Cam16 start = Cam16.fromJch(0.0, 0.0, 0.0); // Black
      final Cam16 end = Cam16.fromJch(0.0, 0.0, 100.0); // White
      final Cam16 mid = start.lerp(end, 0.5);

      expect(mid.j, closeTo(50.0, 0.01));
    });

    test('lerp handles hue wrapping', () {
      final Cam16 start = Cam16.fromJch(10.0, 50.0, 50.0);
      final Cam16 end = Cam16.fromJch(350.0, 50.0, 50.0);
      final Cam16 mid = start.lerp(end, 0.5);

      // Shortest path is through 0/360, so average is 0 or 360
      expect(mid.hue, closeTo(0.0, 0.01));
    });

    test('saturate increases chroma', () {
      final Cam16 color = Cam16.fromJch(0.0, 50.0, 50.0);
      final Cam16 saturated = color.saturate(10);

      expect(saturated.chroma, greaterThan(color.chroma));
    });

    test('desaturate decreases chroma', () {
      final Cam16 color = Cam16.fromJch(0.0, 50.0, 50.0);
      final Cam16 desaturated = color.desaturate(10);

      expect(desaturated.chroma, lessThan(color.chroma));
    });

    test('intensify increases s', () {
      final Cam16 color = Cam16.fromJch(0.0, 50.0, 50.0);
      final Cam16 intensified = color.intensify(10);

      expect(intensified.s, greaterThan(color.s));
    });

    test('deintensify decreases s', () {
      final Cam16 color = Cam16.fromJch(0.0, 50.0, 50.0);
      final Cam16 deintensified = color.deintensify(10);

      expect(deintensified.s, lessThan(color.s));
    });
  });
}
