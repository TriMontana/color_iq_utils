import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('LuvColor Refactor Tests', () {
    test('whiten increases lightness', () {
      const LuvColor color = LuvColor(50, 0, 0); // Middle gray
      final LuvColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.u, closeTo(0, 0.1));
      expect(whitened.v, closeTo(0, 0.1));
    });

    test('blacken decreases lightness', () {
      const LuvColor color = LuvColor(50, 0, 0); // Middle gray
      final LuvColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.u, closeTo(0, 0.1));
      expect(blackened.v, closeTo(0, 0.1));
    });

    test('lerp interpolates correctly', () {
      const LuvColor start = luvBlack; // Black
      const LuvColor end = LuvColor(100, 100, 100); // White-ish with color
      final LuvColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50, 0.1));
      expect(mid.u, closeTo(50, 0.1));
      expect(mid.v, closeTo(50, 0.1));
    });
  });
}
