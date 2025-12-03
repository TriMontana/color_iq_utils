import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('LabColor Refactor Tests', () {
    test('whiten increases lightness', () {
      const LabColor color = LabColor(50.0, 0.0, 0.0); // Gray
      final LabColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
    });

    test('blacken decreases lightness', () {
      const LabColor color = LabColor(50.0, 0.0, 0.0); // Gray
      final LabColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
    });

    test('lerp interpolates correctly', () {
      const LabColor start = LabColor(0.0, 0.0, 0.0); // Black
      const LabColor end = LabColor(100.0, 0.0, 0.0); // White
      final LabColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50.0, 0.01));
      expect(mid.aLab, closeTo(0.0, 0.01));
      expect(mid.bLab, closeTo(0.0, 0.01));
    });
  });
}
