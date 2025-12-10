import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('LuvColor Refactor Tests', () {
    test('whiten increases lightness', () {
      const CIELuv color = CIELuv(50, 0, 0); // Middle gray
      final CIELuv whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.u, closeTo(0, 0.1));
      expect(whitened.v, closeTo(0, 0.1));
      // print('✓ LuvColor Refactor Tests');
    });

    test('blacken decreases lightness', () {
      const CIELuv color = CIELuv(50, 0, 0); // Middle gray
      final CIELuv blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.u, closeTo(0, 0.1));
      expect(blackened.v, closeTo(0, 0.1));
    });

    test('lerp interpolates correctly', () {
      const CIELuv start = luvBlack; // Black
      const CIELuv end = CIELuv(100, 100, 100); // White-ish with color
      final CIELuv mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(50, 0.1));
      expect(mid.u, closeTo(50, 0.1));
      expect(mid.v, closeTo(50, 0.1));
    });
  });
}
