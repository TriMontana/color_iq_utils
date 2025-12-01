import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Color Blindness Tests', () {
    test('Simulate Protanopia', () {
      final red = Color.fromARGB(255, 255, 0, 0);
      final simulated = red.simulate(ColorBlindnessType.protanopia);
      // Red should look much darker/brownish in Protanopia
      expect(simulated.red, lessThan(150)); 
      expect(simulated.green, lessThan(150));
      expect(simulated.blue, lessThan(50));
    });

    test('Simulate Deuteranopia', () {
      final green = Color.fromARGB(255, 0, 255, 0);
      final simulated = green.simulate(ColorBlindnessType.deuteranopia);
      // Green looks yellowish/brownish
      expect(simulated.red, greaterThan(150));
      expect(simulated.green, greaterThan(150));
    });

    test('Simulate Tritanopia', () {
      final blue = Color.fromARGB(255, 0, 0, 255);
      final simulated = blue.simulate(ColorBlindnessType.tritanopia);
      // Blue looks greenish/teal
      expect(simulated.green, greaterThan(50));
    });

    test('Simulate Achromatopsia', () {
      final color = Color.fromARGB(255, 100, 150, 200);
      final simulated = color.simulate(ColorBlindnessType.achromatopsia);
      // Should be grayscale (R=G=B)
      expect(simulated.red, equals(simulated.green));
      expect(simulated.green, equals(simulated.blue));
    });

    test('Delegation works for other models', () {
      final hsl = HslColor(0, 100, 50); // Red
      final simulated = hsl.simulate(ColorBlindnessType.protanopia);
      expect(simulated, isA<HslColor>());
      // Should match the Color simulation converted back to HSL
      final expected = hsl.toColor().simulate(ColorBlindnessType.protanopia).toHsl();
      expect(simulated.h, closeTo(expected.h, 1.0));
      expect(simulated.s, closeTo(expected.s, 1.0));
      expect(simulated.l, closeTo(expected.l, 1.0));
    });
  });
}
