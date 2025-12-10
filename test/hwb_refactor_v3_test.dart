import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HwbColor Refactor V3 Tests', () {
    test('monochromatic returns correct list', () {
      const HwbColor color = HwbColor(0.0, 0.5, 0.0);
      final List<ColorSpacesIQ> palette = color.monochromatic;

      expect(palette.length, 5);
      expect(palette[2], color);
      expect((palette[0] as HwbColor).blackness,
          greaterThan(color.blackness)); // Blackened
      expect((palette[4] as HwbColor).w, greaterThan(color.w)); // Whitened
    });

    test('lighterPalette returns whiter colors', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.0);
      final List<ColorSpacesIQ> palette = color.lighterPalette();

      expect(palette.length, 5);
      expect((palette[0] as HwbColor).w, greaterThan(color.w));
    });

    test('darkerPalette returns blacker colors', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.0);
      final List<ColorSpacesIQ> palette = color.darkerPalette();

      expect(palette.length, 5);
      expect((palette[0] as HwbColor).blackness, greaterThan(color.blackness));
    });

    test('random returns valid HwbColor', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.0);
      final ColorSpacesIQ randomColor = color.random;

      expect(randomColor, isA<HwbColor>());
      final HwbColor hwb = randomColor as HwbColor;
      expect(hwb.w + hwb.blackness,
          lessThanOrEqualTo(1.0001)); // Allow float precision
    });
  });
}
