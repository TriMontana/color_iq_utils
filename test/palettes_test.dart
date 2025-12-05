import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Palette Methods Tests', () {
    test('generateBasicPalette returns 7 colors', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 100, 150, 200);
      final List<ColorIQ> palette = color.generateBasicPalette();
      expect(palette.length, 7);
      expect(palette[3], equals(color)); // Base color
      // Check ordering (darkest to lightest)
      expect(palette[0].brightness, equals(Brightness.dark)); // Darkest
      // Note: Lightness check depends on implementation, but index 0 should be darker than index 6
      expect(palette[0].toHsl().l, lessThan(palette[6].toHsl().l));
    });

    test('tonesPalette returns 5 colors', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 255, 0, 0); // Red
      final List<ColorIQ> palette = color.tonesPalette();
      expect(palette.length, 5);
      expect(palette[0], equals(color)); // Base color
      // Check that subsequent colors are more gray (less saturated)
      expect(palette[1].toHsl().s, lessThan(palette[0].toHsl().s));
      expect(palette[4].toHsl().s, lessThan(palette[1].toHsl().s));
    });

    test('analogous returns correct count and offset', () {
      final HslColor color = HslColor.alt(180, 1.0, 0.5); // Cyan

      // Default (count 5, offset 30)
      final List<HslColor> palette5 = color.analogous();
      expect(palette5.length, 5);
      expect(palette5[2].h, closeTo(180, 1.0)); // Base
      expect(palette5[3].h, closeTo(210, 1.0)); // +30
      expect(palette5[1].h, closeTo(150, 1.0)); // -30

      // Count 3, offset 10
      final List<HslColor> palette3 = color.analogous(count: 3, offset: 10);
      expect(palette3.length, 3);
      expect(palette3[1].h, closeTo(180, 1.0)); // Base
      expect(palette3[2].h, closeTo(190, 1.0)); // +10
      expect(palette3[0].h, closeTo(170, 1.0)); // -10
    });

    test('Delegation works for other models', () {
      final HctColor hct = HctColor.alt(180, 50, 50);
      final List<HctColor> palette = hct.generateBasicPalette();
      expect(palette.length, 7);
      expect(palette.first, isA<HctColor>());

      final List<HctColor> tones = hct.tonesPalette();
      expect(tones.length, 5);
      expect(tones.first, isA<HctColor>());

      final List<HctColor> analogous = hct.analogous();
      expect(analogous.length, 5);
      expect(analogous.first, isA<HctColor>());

      final List<HctColor> square = hct.square();
      expect(square.length, 4);
      expect(square.first, isA<HctColor>());

      final List<HctColor> tetrad = hct.tetrad();
      expect(tetrad.length, 4);
      expect(tetrad.first, isA<HctColor>());
    });

    test('square returns 4 colors with 90 degree spacing', () {
      final HslColor color = HslColor.alt(0, 1.0, 0.5); // Red
      final List<HslColor> palette = color.square();
      expect(palette.length, 4);
      expect(palette[0].h, closeTo(0, 1.0));
      expect(palette[1].h, closeTo(90, 1.0));
      expect(palette[2].h, closeTo(180, 1.0));
      expect(palette[3].h, closeTo(270, 1.0));
    });

    test('tetrad returns 4 colors with correct spacing', () {
      const HslColor color = kHslRed; // Red

      // Default offset 60
      final List<HslColor> palette = color.tetrad();
      expect(palette.length, 4);
      expect(palette[0].h, closeTo(0, 1.0));
      expect(palette[1].h, closeTo(60, 1.0));
      expect(palette[2].h, closeTo(180, 1.0));
      expect(palette[3].h, closeTo(240, 1.0)); // 180 + 60

      // Custom offset 30
      final List<HslColor> palette30 = color.tetrad(offset: 30);
      expect(palette30.length, 4);
      expect(palette30[1].h, closeTo(30, 1.0));
      expect(palette30[3].h, closeTo(210, 1.0)); // 180 + 30
    });
  });
}
