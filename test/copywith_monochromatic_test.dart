import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('CopyWith and Monochromatic Tests', () {
    test('ColorIQ copyWith', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 100, 150, 200);
      final ColorIQ copy = color.copyWith(red: 255, alpha: 128);
      expect(copy.red, 255);
      expect(copy.alpha, 128);
      expect(copy.green, 150); // Unchanged
      expect(copy.blue, 200); // Unchanged
    });

    test('HslColor copyWith', () {
      final HslColor hsl = HslColor(180, 0.5, 0.5);
      final HslColor copy = hsl.copyWith(hue: 90, lightness: 0.8);
      expect(copy.h, 90);
      expect(copy.l, 0.8);
      expect(copy.s, 0.5); // Unchanged
    });

    test('CmykColor copyWith', () {
      final CmykColor cmyk = CmykColor(0.1, 0.2, 0.3, 0.4);
      final CmykColor copy = cmyk.copyWith(c: 0.5, k: 0.0);
      expect(copy.c, 0.5);
      expect(copy.k, 0.0);
      expect(copy.m, 0.2); // Unchanged
    });

    test('ColorIQ Monochromatic', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 255, 0, 0); // Red
      final List<ColorSpacesIQ> palette = color.monochromatic;
      expect(palette.length, 5);
      expect(
        palette[2],
        color,
      ); // Middle color should be original (approximately)

      // Check that all colors have same hue (approximately)
      final HslColor hsl = color.toHsl();
      for (ColorSpacesIQ c in palette) {
        final HslColor cHsl = (c as ColorIQ).toHsl();
        // Hue might wrap around or be slightly off due to clamping, but for Red (0) it should be close.
        // Actually, if we change lightness, hue stays same.
        // But if lightness goes to 0 or 1, hue is undefined/0.
        if (cHsl.l > 0.01 && cHsl.l < 0.99) {
          // Allow some tolerance
          // Hue difference logic: min(|a-b|, 360-|a-b|)
          double diff = (cHsl.h - hsl.h).abs();
          if (diff > 180) diff = 360 - diff;
          expect(diff, closeTo(0, 1.0));
        }
      }
    });

    test('HslColor Monochromatic (Native)', () {
      final HslColor hsl = HslColor(120, 1.0, 0.5); // Green
      final List<ColorSpacesIQ> palette = hsl.monochromatic;
      expect(palette.length, 5);
      expect((palette[2] as HslColor).l, 0.5);
      expect((palette[0] as HslColor).l, closeTo(0.3, 0.001)); // 0.5 - 0.2
      expect((palette[4] as HslColor).l, closeTo(0.7, 0.001)); // 0.5 + 0.2
    });

    test('CmykColor Monochromatic (Delegated)', () {
      final CmykColor cmyk = CmykColor(0, 0, 0, 0); // White
      final List<ColorSpacesIQ> palette = cmyk.monochromatic;
      expect(palette.length, 5);
      expect(palette.first, isA<CmykColor>());
    });
  });
}
