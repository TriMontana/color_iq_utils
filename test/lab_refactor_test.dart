import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('LabColor Refactor Tests', () {
    test('whiten increases lightness', () {
      final LabColor color = LabColor.alt(50.0, 0.0, 0.0); // Gray
      final LabColor whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
    });

    test('blacken decreases lightness', () {
      final LabColor color = LabColor.alt(50.0, 0.0, 0.0); // Gray
      final LabColor blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
    });

    test('lerp interpolates correctly', () {
      final LabColor start = LabColor.alt(0.0, 0.0, 0.0); // Black
      final LabColor end = LabColor.alt(100.0, 0.0, 0.0); // White
      final LabColor mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50.0, 0.01));
      expect(mid.aLab, closeTo(0.0, 0.01));
      expect(mid.bLab, closeTo(0.0, 0.01));
    });
  });
}
