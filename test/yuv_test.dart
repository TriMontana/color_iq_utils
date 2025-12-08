import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('YuvColor Tests', () {
    test('darken decreases Y', () {
      const YuvColor color = YuvColor(0.5, 0.1, 0.1);
      final YuvColor darkened = color.darken(20);
      expect(darkened.y, closeTo(0.3, 0.001));
      expect(darkened.u, equals(color.u));
      expect(darkened.v, equals(color.v));
    });

    test('brighten increases Y', () {
      const YuvColor color = YuvColor(0.5, 0.1, 0.1);
      final YuvColor brightened = color.brighten(20);
      expect(brightened.y, closeTo(0.7, 0.001));
      expect(brightened.u, equals(color.u));
      expect(brightened.v, equals(color.v));
    });

    test('lighten increases Y', () {
      const YuvColor color = YuvColor(0.5, 0.1, 0.1);
      final YuvColor lightened = color.lighten(20);
      expect(lightened.y, closeTo(0.7, 0.001));
      expect(lightened.u, equals(color.u));
      expect(lightened.v, equals(color.v));
    });

    test('saturate increases U and V magnitude', () {
      const YuvColor color = YuvColor(0.5, 0.1, -0.1);
      final YuvColor saturated = color.saturate(20);
      // factor = 1 + 20/100 = 1.2
      expect(saturated.y, equals(color.y));
      expect(saturated.u, closeTo(0.12, 0.001));
      expect(saturated.v, closeTo(-0.12, 0.001));
    });

    test('desaturate decreases U and V magnitude', () {
      const YuvColor color = YuvColor(0.5, 0.1, -0.1);
      final YuvColor desaturated = color.desaturate(20);
      // factor = 1 - 20/100 = 0.8
      expect(desaturated.y, equals(color.y));
      expect(desaturated.u, closeTo(0.08, 0.001));
      expect(desaturated.v, closeTo(-0.08, 0.001));
    });

    test('whiten moves towards white', () {
      const YuvColor color = YuvColor(0.0, 0.1, 0.1); // Black-ish with color
      final YuvColor whitened = color.whiten(50);
      // Lerp 50% to White (Y=1, U=0, V=0)
      // Y: 0.0 -> 1.0 (50%) = 0.5
      // U: 0.1 -> 0.0 (50%) = 0.05
      // V: 0.1 -> 0.0 (50%) = 0.05
      expect(whitened.y, closeTo(0.5, 0.001));
      expect(whitened.u, closeTo(0.05, 0.001));
      expect(whitened.v, closeTo(0.05, 0.001));
    });

    test('blacken moves towards black', () {
      const YuvColor color = YuvColor(1.0, 0.1, 0.1); // White-ish with color
      final YuvColor blackened = color.blacken(50);
      // Lerp 50% to Black (Y=0, U=0, V=0)
      // Y: 1.0 -> 0.0 (50%) = 0.5
      // U: 0.1 -> 0.0 (50%) = 0.05
      // V: 0.1 -> 0.0 (50%) = 0.05
      expect(blackened.y, closeTo(0.5, 0.001));
      expect(blackened.u, closeTo(0.05, 0.001));
      expect(blackened.v, closeTo(0.05, 0.001));
    });

    test('lerp interpolates correctly', () {
      const YuvColor color1 = YuvColor(0.0, 0.0, 0.0);
      const YuvColor color2 = YuvColor(1.0, 1.0, 1.0);
      final YuvColor lerped = color1.lerp(color2, 0.5);
      expect(lerped.y, closeTo(0.5, 0.001));
      expect(lerped.u, closeTo(0.5, 0.001));
      expect(lerped.v, closeTo(0.5, 0.001));
    });
  });
}
