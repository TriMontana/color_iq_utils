import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Distance and Contrast Tests', () {
    test('distanceTo self is 0', () {
      final ColorIQ color = ColorIQ(0xFFFF0000);
      expect(color.distanceTo(color), 0);
    });

    test('distanceTo works for different colors', () {
      final double dist = cWhite.distanceTo(cBlack);
      expect(dist, greaterThan(0));
      // HCT Tone difference is 100. Distance should be at least 100.
      expect(dist, greaterThanOrEqualTo(100));
    });

    test('contrastWith self is 1.0', () {
      final ColorIQ color = ColorIQ(0xFFFF0000);
      expect(color.contrastWith(color), closeTo(1.0, 0.01));
    });

    test('contrastWith black and white is 21.0', () {
      expect(cWhite.contrastWith(cBlack), closeTo(21.0, 0.1));
      expect(cBlack.contrastWith(cWhite), closeTo(21.0, 0.1));
    });

    test('contrastWith delegates correctly', () {
      const CmykColor cmyk = CmykColor(0, 0, 0, 0); // White
      const HslColor hsl = kHslBlack; // Black
      expect(cmyk.contrastWith(hsl), closeTo(21.0, 0.1));
    });
  });

  group('Closest Color Slice Tests', () {
    test('Red maps to Red slice', () {
      final ColorSlice slice = cRed.closestColorSlice();
      expect(slice.name, equals(kRed));
    });

    test('Cyan maps to Turquoise slice in HCT', () {
      final ColorIQ cyan = ColorIQ(0xFF00FFFF); // Hue ~180 in HSV, ~192 in HCT
      final ColorSlice slice = cyan.closestColorSlice();
      // In HCT, #00FFFF is perceptually closer to Turquoise/Sky Blue than pure Cyan (180 deg).
      // Our HCT wheel maps it to "Turquoise".
      expect(slice.name, equals(kTurquoise));
    });

    test('Delegation works', () {
      const HsvColor hsv = HsvColor(0, Percent.max, Percent.max); // Red
      final ColorSlice slice = hsv.closestColorSlice();
      expect(slice.name, equals(kRed));
    });
  });
}
