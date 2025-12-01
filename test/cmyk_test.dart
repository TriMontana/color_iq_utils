import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('CMYK Conversion Tests', () {
    test('Black conversion', () {
      final color = ColorIQ.fromARGB(255, 0, 0, 0);
      final cmyk = color.toCmyk();
      expect(cmyk.c, 0.0);
      expect(cmyk.m, 0.0);
      expect(cmyk.y, 0.0);
      expect(cmyk.k, 1.0);
      
      final backToColor = cmyk.toColor();
      expect(backToColor.red, 0);
      expect(backToColor.green, 0);
      expect(backToColor.blue, 0);
    });

    test('White conversion', () {
      final color = ColorIQ.fromARGB(255, 255, 255, 255);
      final cmyk = color.toCmyk();
      expect(cmyk.c, 0.0);
      expect(cmyk.m, 0.0);
      expect(cmyk.y, 0.0);
      expect(cmyk.k, 0.0);

      final backToColor = cmyk.toColor();
      expect(backToColor.red, 255);
      expect(backToColor.green, 255);
      expect(backToColor.blue, 255);
    });

    test('Red conversion', () {
      final color = ColorIQ.fromARGB(255, 255, 0, 0);
      final cmyk = color.toCmyk();
      expect(cmyk.c, 0.0);
      expect(cmyk.m, 1.0);
      expect(cmyk.y, 1.0);
      expect(cmyk.k, 0.0);

      final backToColor = cmyk.toColor();
      expect(backToColor.red, 255);
      expect(backToColor.green, 0);
      expect(backToColor.blue, 0);
    });

    test('Green conversion', () {
      final color = ColorIQ.fromARGB(255, 0, 255, 0);
      final cmyk = color.toCmyk();
      expect(cmyk.c, 1.0);
      expect(cmyk.m, 0.0);
      expect(cmyk.y, 1.0);
      expect(cmyk.k, 0.0);

      final backToColor = cmyk.toColor();
      expect(backToColor.red, 0);
      expect(backToColor.green, 255);
      expect(backToColor.blue, 0);
    });

    test('Blue conversion', () {
      final color = ColorIQ.fromARGB(255, 0, 0, 255);
      final cmyk = color.toCmyk();
      expect(cmyk.c, 1.0);
      expect(cmyk.m, 1.0);
      expect(cmyk.y, 0.0);
      expect(cmyk.k, 0.0);

      final backToColor = cmyk.toColor();
      expect(backToColor.red, 0);
      expect(backToColor.green, 0);
      expect(backToColor.blue, 255);
    });

    test('Arbitrary color conversion', () {
      // Teal-ish color: R=0, G=128, B=128
      final color = ColorIQ.fromARGB(255, 0, 128, 128);
      final cmyk = color.toCmyk();
      
      // Expected: C=1.0, M=0.0, Y=0.0, K=0.5 (approx)
      // Calculation:
      // R'=0, G'=0.5, B'=0.5
      // K = 1 - 0.5 = 0.5
      // C = (1 - 0 - 0.5) / 0.5 = 1.0
      // M = (1 - 0.5 - 0.5) / 0.5 = 0.0
      // Y = (1 - 0.5 - 0.5) / 0.5 = 0.0
      
      expect(cmyk.c, closeTo(1.0, 0.01));
      expect(cmyk.m, closeTo(0.0, 0.01));
      expect(cmyk.y, closeTo(0.0, 0.01));
      expect(cmyk.k, closeTo(0.5, 0.01));

      final backToColor = cmyk.toColor();
      expect(backToColor.red, 0);
      expect(backToColor.green, 128);
      expect(backToColor.blue, 128);
    });
  });
}
