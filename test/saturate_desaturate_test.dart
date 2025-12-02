import 'package:test/test.dart';
import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  group('Saturate/Desaturate Tests', () {
    test('HslColor saturate/desaturate', () {
      const HslColor hsl = HslColor(0, 0.5, 0.5);
      final HslColor saturated = hsl.saturate(25);
      expect(saturated.s, closeTo(0.75, 0.01));
      
      final HslColor desaturated = hsl.desaturate(25);
      expect(desaturated.s, closeTo(0.25, 0.01));
    });

    test('HsvColor saturate/desaturate', () {
      const HsvColor hsv = HsvColor(0, 0.5, 0.5);
      final HsvColor saturated = hsv.saturate(25);
      expect(saturated.s, closeTo(0.75, 0.01));
      
      final HsvColor desaturated = hsv.desaturate(25);
      expect(desaturated.s, closeTo(0.25, 0.01));
    });

    test('LchColor saturate/desaturate', () {
      const LchColor lch = LchColor(50, 50, 0);
      final LchColor saturated = lch.saturate(25);
      expect(saturated.c, closeTo(75, 0.01));
      
      final LchColor desaturated = lch.desaturate(25);
      expect(desaturated.c, closeTo(25, 0.01));
    });

    test('OkLchColor saturate/desaturate', () {
      const OkLchColor oklch = OkLchColor(0.5, 0.1, 0);
      final OkLchColor saturated = oklch.saturate(25);
      // 0.1 + 25/100 = 0.35
      expect(saturated.c, closeTo(0.35, 0.01));
      
      final OkLchColor desaturated = oklch.desaturate(5);
      // 0.1 - 5/100 = 0.05
      expect(desaturated.c, closeTo(0.05, 0.01));
    });

    test('ColorIQ saturate/desaturate (via HSL)', () {
      // Red: HSL(0, 1.0, 0.5)
      const ColorIQ red = ColorIQ.fromARGB(255, 255, 0, 0);
      final ColorIQ desaturated = red.desaturate(50);
      // HSL(0, 0.5, 0.5) -> RGB approx (191, 64, 64)
      final HslColor hsl = desaturated.toHsl();
      expect(hsl.s, closeTo(0.5, 0.01));
    });

    test('LabColor saturate/desaturate (via Lch)', () {
      // Lab(50, 50, 0) -> Lch(50, 50, 0)
      const LabColor lab = LabColor(50, 50, 0);
      final LabColor saturated = lab.saturate(25);
      // Lch(50, 75, 0) -> Lab(50, 75, 0)
      expect(saturated.a, closeTo(75, 0.01));
      expect(saturated.b, closeTo(0, 0.01));
    });

    test('HsluvColor saturate/desaturate', () {
        const HsluvColor hsluv = HsluvColor(0, 50, 50);
        final HsluvColor saturated = hsluv.saturate(25);
        expect(saturated.s, closeTo(75, 0.01));
        
        final HsluvColor desaturated = hsluv.desaturate(25);
        expect(desaturated.s, closeTo(25, 0.01));
    });

    test('Clamping', () {
      const HslColor hsl = HslColor(0, 0.9, 0.5);
      final HslColor saturated = hsl.saturate(25);
      expect(saturated.s, 1.0);
      
      final HslColor desaturated = hsl.desaturate(100);
      expect(desaturated.s, 0.0);
    });
  });
}
