import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('MunsellColor Refactor Tests', () {
    test('whiten increases value', () {
      final MunsellColor color = MunsellColor('5R', 5.0, 10.0);
      final MunsellColor whitened = color.whiten(50);

      expect(whitened.munsellValue, greaterThan(color.munsellValue));
    });

    test('blacken decreases value', () {
      final MunsellColor color = MunsellColor('5R', 5.0, 10.0);
      final MunsellColor blackened = color.blacken(50);

      expect(blackened.munsellValue, lessThan(color.munsellValue));
    });

    test('lerp interpolates correctly', () {
      final MunsellColor start = MunsellColor('5R', 0.0, 0.0); // Black-ish
      final MunsellColor end = MunsellColor('5R', 10.0, 0.0); // White-ish
      final MunsellColor mid = start.lerp(end, 0.5);

      expect(mid.munsellValue, closeTo(5.0, 0.01));
    });

    test('intensify increases chroma', () {
      final MunsellColor color = MunsellColor('5R', 5.0, 10.0);
      final MunsellColor intensified = color.intensify(10);

      expect(intensified.chroma, greaterThan(color.chroma));
    });

    test('deintensify decreases chroma', () {
      final MunsellColor color = MunsellColor('5R', 5.0, 10.0);
      final MunsellColor deintensified = color.deintensify(10);

      expect(deintensified.chroma, lessThan(color.chroma));
    });
  });
}
