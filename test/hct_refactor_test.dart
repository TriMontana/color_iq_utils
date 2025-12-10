import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HctColor Refactor Tests', () {
    test('whiten increases tone', () {
      const HctData color = HctData(0.0, 50.0, 50.0);
      final HctData whitened = color.whiten(50);

      expect(whitened.tone, greaterThan(color.tone));
    });

    test('blacken decreases tone', () {
      const HctData color = HctData(0.0, 50.0, 50.0);
      final HctData blackened = color.blacken(50);

      expect(blackened.tone, lessThan(color.tone));
      print(blackened.tone);
    });

    test('lerp interpolates correctly', () {
      const HctData start = HctData(0.0, 0.0, 0.0); // Black
      const HctData end = HctData(0.0, 0.0, 100.0); // White
      final HctData mid = start.lerp(end, 0.5);

      expect(mid.tone, closeTo(50.0, 1.0)); // HCT tone is perceptually uniform
      print('interpolated tone: ${mid.tone}');
    });
  });
}
