import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Color Blindness Tests', () {
    test('Simulate Protanopia', () {
      final ColorIQ red = ColorIQ.fromARGB(255, 255, 0, 0);
      final ColorIQ simulated = red.simulate(ColorBlindnessType.protanopia);
      // Red should look much darker/brownish in Protanopia
      expect(simulated.red, lessThan(150));
      expect(simulated.green, lessThan(150));
      expect(simulated.blue, lessThan(50));
    });

    test('Simulate Deuteranopia', () {
      final ColorIQ green = ColorIQ.fromARGB(255, 0, 255, 0);
      final ColorIQ simulated = green.simulate(ColorBlindnessType.deuteranopia);
      // Green looks yellowish/brownish
      expect(simulated.red, greaterThan(150));
      expect(simulated.green, greaterThan(150));
    });

    test('Simulate Tritanopia', () {
      final ColorIQ blue = ColorIQ.fromARGB(255, 0, 0, 255);
      final ColorIQ simulated = blue.simulate(ColorBlindnessType.tritanopia);
      // Blue looks greenish/teal
      expect(simulated.green, greaterThan(50));
    });

    test('Simulate Achromatopsia', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 100, 150, 200);
      final ColorIQ simulated = color.simulate(
        ColorBlindnessType.achromatopsia,
      );
      // Should be grayscale (R=G=B)
      expect(simulated.red, equals(simulated.green));
      expect(simulated.green, equals(simulated.blue));
    });

    test('Delegation works for other models', () {
      const HslColor hsl = HslColor(0, 100, 50); // Red
      final HslColor simulated = hsl.simulate(ColorBlindnessType.protanopia);
      expect(simulated, isA<HslColor>());
      // Should match the ColorIQ simulation converted back to HSL
      final HslColor expected = hsl
          .toColor()
          .simulate(ColorBlindnessType.protanopia)
          .toHsl();
      expect(simulated.h, closeTo(expected.h, 1.0));
      expect(simulated.s, closeTo(expected.s, 1.0));
      expect(simulated.l, closeTo(expected.l, 1.0));
    });
  });
}
