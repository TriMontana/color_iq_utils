import 'package:test/test.dart';
import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  group('New Mandatory Methods Tests', () {
    test('Random Color Generation', () {
      const ColorIQ color = ColorIQ(0xFF000000);
      final ColorSpacesIQ random = color.random;
      expect(random, isA<ColorIQ>());
      expect(random.value, isNot(0xFF000000)); // Unlikely to be black again
      
      const HslColor hsl = HslColor(0, 0, 0);
      final HslColor randomHsl = hsl.random as HslColor;
      expect(randomHsl, isA<HslColor>());
      
      print('✓ Random Color Generation test completed');
      print('  Original ColorIQ: 0x${color.value.toRadixString(16).toUpperCase()}');
      print('  Random ColorIQ: 0x${random.value.toRadixString(16).toUpperCase()}');
      print('  Random HslColor: H=${randomHsl.h.toStringAsFixed(1)}, S=${randomHsl.s.toStringAsFixed(2)}, L=${randomHsl.l.toStringAsFixed(2)}');
    });

    test('isEqual', () {
      const ColorIQ c1 = ColorIQ.fromARGB(255, 100, 100, 100);
      const ColorIQ c2 = ColorIQ.fromARGB(255, 100, 100, 100);
      const ColorIQ c3 = ColorIQ.fromARGB(255, 200, 200, 200);
      
      expect(c1.isEqual(c2), isTrue);
      expect(c1.isEqual(c3), isFalse);
      
      final HslColor hsl1 = c1.toHsl();
      expect(c1.isEqual(hsl1), isTrue); // Should work across types
      
      print('✓ isEqual test completed');
      print('  c1 == c2: ${c1.isEqual(c2)}');
      print('  c1 == c3: ${c1.isEqual(c3)}');
      print('  c1 == hsl1 (cross-type): ${c1.isEqual(hsl1)}');
    });

    test('Luminance', () {
      const ColorIQ white = ColorIQ(0xFFFFFFFF);
      const ColorIQ black = ColorIQ(0xFF000000);
      const ColorIQ red = ColorIQ(0xFFFF0000);
      
      expect(white.luminance, closeTo(1.0, 0.01));
      expect(black.luminance, closeTo(0.0, 0.01));
      // Red luminance: 0.2126
      expect(red.luminance, closeTo(0.2126, 0.01));
      
      const HslColor hslWhite = HslColor(0, 0, 1.0);
      expect(hslWhite.luminance, closeTo(1.0, 0.01));
      
      print('✓ Luminance test completed');
      print('  White luminance: ${white.luminance.toStringAsFixed(4)}');
      print('  Black luminance: ${black.luminance.toStringAsFixed(4)}');
      print('  Red luminance: ${red.luminance.toStringAsFixed(4)}');
      print('  HSL White luminance: ${hslWhite.luminance.toStringAsFixed(4)}');
    });

    test('Brightness', () {
      const ColorIQ white = ColorIQ(0xFFFFFFFF);
      const ColorIQ black = ColorIQ(0xFF000000);
      
      expect(white.brightness, Brightness.light);
      expect(black.brightness, Brightness.dark);
      
      // Threshold check
      // kThreshold = 0.15
      // (lum + 0.05)^2 > 0.15
      // lum + 0.05 > sqrt(0.15) ~ 0.387
      // lum > 0.337
      
      const ColorIQ darkGrey = ColorIQ.fromARGB(255, 50, 50, 50); // Lum ~ 0.03
      expect(darkGrey.brightness, Brightness.dark);
      
      const ColorIQ lightGrey = ColorIQ.fromARGB(255, 200, 200, 200); // Lum ~ 0.5
      expect(lightGrey.brightness, Brightness.light);
      
      print('✓ Brightness test completed');
      print('  White brightness: ${white.brightness} (lum: ${white.luminance.toStringAsFixed(4)})');
      print('  Black brightness: ${black.brightness} (lum: ${black.luminance.toStringAsFixed(4)})');
      print('  Dark grey brightness: ${darkGrey.brightness} (lum: ${darkGrey.luminance.toStringAsFixed(4)})');
      print('  Light grey brightness: ${lightGrey.brightness} (lum: ${lightGrey.luminance.toStringAsFixed(4)})');
    });
  });
}
