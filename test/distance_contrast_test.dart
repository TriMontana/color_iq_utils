import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Distance and Contrast Tests', () {
    test('distanceTo self is 0', () {
      final color = ColorIQ(0xFFFF0000);
      expect(color.distanceTo(color), 0);
    });

    test('distanceTo works for different colors', () {
      final white = ColorIQ(0xFFFFFFFF);
      final black = ColorIQ(0xFF000000);
      final dist = white.distanceTo(black);
      expect(dist, greaterThan(0));
      // HCT Tone difference is 100. Distance should be at least 100.
      expect(dist, greaterThanOrEqualTo(100));
    });

    test('contrastWith self is 1.0', () {
      final color = ColorIQ(0xFFFF0000);
      expect(color.contrastWith(color), closeTo(1.0, 0.01));
    });

    test('contrastWith black and white is 21.0', () {
      final white = ColorIQ(0xFFFFFFFF);
      final black = ColorIQ(0xFF000000);
      expect(white.contrastWith(black), closeTo(21.0, 0.1));
      expect(black.contrastWith(white), closeTo(21.0, 0.1));
    });

    test('contrastWith delegates correctly', () {
      final cmyk = CmykColor(0, 0, 0, 0); // White
      final hsl = HslColor(0, 0, 0); // Black
      expect(cmyk.contrastWith(hsl), closeTo(21.0, 0.1));
    });
  });

  group('Closest Color Slice Tests', () {
    test('Red maps to Red slice', () {
      final red = ColorIQ(0xFFFF0000); // Hue ~0
      final slice = red.closestColorSlice();
      expect(slice.name, equals('Red'));
    });

    test('Cyan maps to Turquoise slice in HCT', () {
      final cyan = ColorIQ(0xFF00FFFF); // Hue ~180 in HSV, ~192 in HCT
      final slice = cyan.closestColorSlice();
      // In HCT, #00FFFF is perceptually closer to Turquoise/Sky Blue than pure Cyan (180 deg).
      // Our HCT wheel maps it to "Turquoise".
      expect(slice.name, equals('Turquoise'));
    });

    test('Delegation works', () {
      final hsv = HsvColor(0, 1.0, 1.0); // Red
      final slice = hsv.closestColorSlice();
      expect(slice.name, equals('Red'));
    });
  });
}
