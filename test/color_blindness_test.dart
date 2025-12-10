import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Color Blindness Tests', () {
    test('Simulate Protanopia', () {
      final ColorIQ red = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final ColorIQ simulated = red.simulate(ColorBlindnessType.protanopia);
      // Red should look much darker/brownish in Protanopia
      expect(simulated.red, lessThan(150));
      expect(simulated.green, lessThan(150));
      expect(simulated.blue, lessThan(50));
      print('✓ Simulate Protanopia');
    });

    test('Simulate Deuteranopia', () {
      final ColorIQ green = ColorIQ.fromArgbInts(255, 0, 255, 0);
      final ColorIQ simulated = green.simulate(ColorBlindnessType.deuteranopia);
      // Green looks yellowish/brownish
      expect(simulated.red, greaterThan(150));
      expect(simulated.green, greaterThan(150));
      expect(simulated.blue, lessThan(50));
      print('✓ Simulate Deuteranopia');
    });

    test('Simulate Tritanopia', () {
      final ColorIQ blue = ColorIQ.fromArgbInts(255, 0, 0, 255);
      final ColorIQ simulated = blue.simulate(ColorBlindnessType.tritanopia);
      // Blue looks greenish/teal
      expect(simulated.green, greaterThan(50));
    });

    test('Simulate Achromatopsia', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 100, 150, 200);
      final ColorIQ simulated = color.simulate(
        ColorBlindnessType.achromatopsia,
      );
      // Should be grayscale (R=G=B)
      expect(simulated.red, equals(simulated.green));
      expect(simulated.green, equals(simulated.blue));
    });

    test('Delegation works for other models', () {
      const HSL hsl = kHslRed; // Red
      final HSL simulated = hsl.simulate(ColorBlindnessType.protanopia);
      expect(simulated, isA<HSL>());
      // Should match the ColorIQ simulation converted back to HSL
      final HSL expected =
          hsl.toColor().simulate(ColorBlindnessType.protanopia).hsl;
      expect(simulated.h, closeTo(expected.h, 1.0));
      expect(simulated.s, closeTo(expected.s, 1.0));
      expect(simulated.l, closeTo(expected.l, 1.0));
      print('✓ Delegation works for other models');
    });
  });
}
