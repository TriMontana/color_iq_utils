import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkLabColor Refactor Tests', () {
    test('whiten increases lightness', () {
      const OkLabColor color = OkLabColor(0.5, 0.0, 0.0); // Gray
      final OkLabColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
    });

    test('blacken decreases lightness', () {
      const OkLabColor color = OkLabColor(0.5, 0.0, 0.0); // Gray
      final OkLabColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
    });

    test('lerp interpolates correctly', () {
      const OkLabColor start = OkLabColor(0.0, 0.0, 0.0); // Black
      const OkLabColor end = OkLabColor(1.0, 0.0, 0.0); // White
      final OkLabColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(0.5, 0.01));
      expect(mid.aLab, closeTo(0.0, 0.01));
      expect(mid.bLab, closeTo(0.0, 0.01));
    });
  });
}
