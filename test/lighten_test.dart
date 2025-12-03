import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Lighten Tests', () {
    test('HslColor lighten increases lightness', () {
      const HslColor hsl = HslColor(0, 0, 0.5); // 50% lightness
      final HslColor lightened = hsl.lighten(20);
      expect(lightened.l, closeTo(0.7, 0.001)); // 50% + 20% = 70%
    });

    test('HslColor lighten clamps to 1.0', () {
      const HslColor hsl = HslColor(0, 0, 0.9);
      final HslColor lightened = hsl.lighten(20);
      expect(lightened.l, 1.0);
    });

    test('ColorIQ lighten works via HSL conversion', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 100, 100, 100); // Grey
      final ColorIQ lightened = color.lighten(20);

      // Original L approx 0.39 (100/255)
      // New L approx 0.59
      // 0.59 * 255 = 150

      expect(lightened.red, greaterThan(100));
      expect(lightened.green, greaterThan(100));
      expect(lightened.blue, greaterThan(100));
    });

    test('LabColor lighten increases L', () {
      const LabColor lab = LabColor(50, 0, 0);
      final LabColor lightened = lab.lighten(20);
      expect(lightened.l, closeTo(70, 0.001));
    });
  });
}
