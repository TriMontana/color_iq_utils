import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HctColor Refactor Tests', () {
    test('whiten increases tone', () {
      final HctColor color = HctColor.from(0.0, 50.0, 50.0);
      final HctColor whitened = color.whiten(50);

      expect(whitened.tone, greaterThan(color.tone));
    });

    test('blacken decreases tone', () {
      final HctColor color = HctColor.from(0.0, 50.0, 50.0);
      final HctColor blackened = color.blacken(50);

      expect(blackened.tone, lessThan(color.tone));
    });

    test('lerp interpolates correctly', () {
      final HctColor start = HctColor.from(0.0, 0.0, 0.0); // Black
      final HctColor end = HctColor.from(0.0, 0.0, 100.0); // White
      final HctColor mid = start.lerp(end, 0.5);

      expect(mid.tone, closeTo(50.0, 1.0)); // HCT tone is perceptually uniform
    });
  });
}
