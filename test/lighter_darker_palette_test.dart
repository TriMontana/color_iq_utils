import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:test/test.dart';

void main() {
  group('Lighter and Darker Palette Tests', () {
    test('HslColor Lighter Palette (Default Steps)', () {
      final HslColor hsl = HslColor.alt(0, 1.0, 0.5); // Red
      final List<ColorSpacesIQ> palette = hsl.lighterPalette();
      expect(palette.length, 5);

      // Should be progressively lighter
      double lastL = 0.5;
      for (ColorSpacesIQ c in palette) {
        final double currentL = (c as HslColor).l;
        expect(currentL, greaterThan(lastL));
        lastL = currentL;
      }

      // Last color should be close to white but not necessarily white
      expect(
        (palette.last as HslColor).l,
        closeTo(0.916, 0.01),
      ); // 0.5 + 5 * (0.5/6) = 0.5 + 0.416 = 0.916
    });

    test('HslColor Darker Palette (Default Steps)', () {
      const HslColor hsl = kHslRed; // Red
      final List<ColorSpacesIQ> palette = hsl.darkerPalette();
      expect(palette.length, 5);

      // Should be progressively darker
      double lastL = 0.5;
      for (ColorSpacesIQ c in palette) {
        final double currentL = (c as HslColor).l;
        expect(currentL, lessThan(lastL));
        lastL = currentL;
      }

      // Last color should be close to black
      expect(
        (palette.last as HslColor).l,
        closeTo(0.083, 0.01),
      ); // 0.5 - 5 * (0.5/6) = 0.5 - 0.416 = 0.083
    });

    test('ColorIQ Lighter Palette (Custom Step)', () {
      final ColorIQ color = ColorIQ.fromARGB(
        255,
        128,
        128,
        128,
      ); // Grey (L=0.5)
      final List<ColorSpacesIQ> palette = color.lighterPalette(10); // 10% steps
      expect(palette.length, 5);

      final ColorIQ first = palette.first as ColorIQ;
      final HslColor hslFirst = first.toHsl();
      expect(hslFirst.l, closeTo(0.6, 0.01)); // 0.5 + 0.1
    });

    test('CmykColor Darker Palette (Delegated)', () {
      const CmykColor cmyk = cmykWhite; // White
      final List<ColorSpacesIQ> palette = cmyk.darkerPalette();
      expect(palette.length, 5);
      expect(palette.first, isA<CmykColor>());

      // Should get darker (K increases or CMY increases)
      // White in CMYK is 0,0,0,0. Darker means K goes up.
      final CmykColor first = palette.first as CmykColor;
      // Converting to HSL logic: L goes down.
      // 0,0,0,0 -> L=1.0.
      // Step = 1.0/6 = 0.166.
      // First step L=0.833.
      // K = 1 - L (roughly) = 0.166
      expect(first.k, closeTo(0.16, 0.05));
    });
  });
}
