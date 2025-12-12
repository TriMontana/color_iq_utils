import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/foundation/num_iq.dart';
import 'package:test/test.dart';

void main() {
  group('Utility Methods Tests', () {
    test('ColorIQ inverted', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: Iq255.v255, red: Iq255.v0, green: Iq255.v100, blue: Iq255.v200);
      final ColorIQ inverted = ColorIQ(color.inverted);
      expect(inverted.red, 255);
      expect(inverted.green, 155);
      expect(inverted.blue, 55);
      expect(inverted.alphaInt, 255);
      print('✓ ColorIQ inverted');
    });

    test('ColorIQ grayscale', () {
      final ColorIQ color = cRed; // Red
      final ColorIQ grayscale = color.grayscale;
      // Desaturate(100) should result in gray.
      // HSL for red is (0, 1.0, 0.5). Desaturated: (0, 0.0, 0.5).
      // RGB for (0, 0.0, 0.5) is (128, 128, 128).
      expect(grayscale.red, closeTo(128, 1));
      expect(grayscale.green, closeTo(128, 1));
      expect(grayscale.blue, closeTo(128, 1));
      expect(grayscale.alphaInt, 255);
    });

    test('ColorIQ whiten', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: 0, green: 0, blue: 0); // Black
      final ColorIQ whitened = color.whiten(50); // Mix 50% with white
      expect(whitened.red, closeTo(128, 1));
      expect(whitened.green, closeTo(128, 1));
      expect(whitened.blue, closeTo(128, 1));
      print('✓ ColorIQ whiten');
    });

    test('ColorIQ blacken', () {
      final ColorIQ color = cWhite; // White
      final ColorIQ blackened = color.blacken(50); // Mix 50% with black
      expect(blackened.red, closeTo(128, 1));
      expect(blackened.green, closeTo(128, 1));
      expect(blackened.blue, closeTo(128, 1));
    });

    test('ColorIQ lerp', () {
      final ColorIQ start = cBlack;
      final ColorIQ end =
          ColorIQ.fromArgbInts(red: Iq255.v100, green: Iq255.v200, blue: Iq255.v255);
      final ColorIQ mid = start.lerp(end, 0.5) as ColorIQ;
      expect(mid.red, 50);
      expect(mid.green, 100);
      expect(mid.blue, 128); // 127.5 rounds to 128
      print('✓ ColorIQ lerp');
    });

    test('HslColor grayscale optimization', () {
      const HSL hsl = HSL(120, 1.0, 0.5); // Green
      final HSL gray = hsl.grayscale;
      expect(gray.s, 0.0);
      expect(gray.h, 120);
      expect(gray.l, 0.5);
    });

    test('Other models delegation (CmykColor)', () {
      const CMYK cmyk = CMYK(0, 0, 0, 1); // Black
      final CMYK inverted =
          CMYK.fromInt(cmyk.inverted); // Should be White (0, 0, 0, 0)
      expect(inverted.k, 0.0);
    });
  });
}
