import 'package:test/test.dart';
import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  group('HCT and Temperature Tests', () {
    test('Color to HCT and back', () {
      final color = Color.fromARGB(255, 255, 0, 0); // Red
      final hct = color.toHct();
      expect(hct, isA<HctColor>());
      // Hue of red is roughly 27 (in HCT/CAM16) or 0 (in HSL). 
      // HCT hue is different from HSL hue. 
      // Let's just verify round trip.
      final back = color.fromHct(hct);
      // HCT conversion is not perfectly lossless due to gamut mapping, but should be close.
      // However, for pure sRGB red, it might shift slightly.
      // Let's check if it's close.
      expect(back.red, closeTo(255, 2));
      expect(back.green, closeTo(0, 2));
      expect(back.blue, closeTo(0, 2));
    });

    test('Transparency Adjustment', () {
      final color = Color.fromARGB(255, 100, 150, 200);
      expect(color.transparency, 1.0);

      final transparent = color.adjustTransparency(50); // Reduce opacity by 50%
      expect(transparent.transparency, closeTo(0.5, 0.01));
      expect(transparent.alpha, closeTo(127, 2));

      final moreTransparent = color.adjustTransparency(80); // Reduce by 80% -> 20% opacity
      expect(moreTransparent.transparency, closeTo(0.2, 0.01));
      expect(moreTransparent.alpha, closeTo(51, 2));
    });

    test('Transparency on other models (lossy)', () {
      final hsl = HslColor(0, 1, 0.5); // Red
      // Other models don't store alpha, so transparency is always 1.0
      expect(hsl.transparency, 1.0);
      
      // adjustTransparency returns the same model, so alpha is lost (reset to 1.0)
      final adjusted = hsl.adjustTransparency(50);
      expect(adjusted, isA<HslColor>());
      expect(adjusted.transparency, 1.0); 
    });

    test('Color Temperature', () {
      // Warm colors
      expect(Color.fromARGB(255, 255, 0, 0).temperature, ColorTemperature.warm); // Red
      expect(Color.fromARGB(255, 255, 165, 0).temperature, ColorTemperature.warm); // Orange
      expect(Color.fromARGB(255, 255, 255, 0).temperature, ColorTemperature.warm); // Yellow

      // Cool colors
      expect(Color.fromARGB(255, 0, 255, 0).temperature, ColorTemperature.cool); // Green
      expect(Color.fromARGB(255, 0, 0, 255).temperature, ColorTemperature.cool); // Blue
      expect(Color.fromARGB(255, 0, 255, 255).temperature, ColorTemperature.cool); // Cyan

      
      // Logic: Warm: 0-90, 270-360. Cool: 90-270.
      // Purple (RGB 128,0,128) -> HSL Hue is 300. 
      // 300 is >= 270, so it should be Warm.
      // Let's check logic again.
      // "Warm: 0-90 (Red-Yellow-Greenish) and 270-360 (Purple-Red)"
      // "Cool: 90-270 (Green-Cyan-Blue-Purple)"
      // So Purple (300) is Warm.
      expect(Color.fromARGB(255, 128, 0, 128).temperature, ColorTemperature.warm); 

      // Blue (240) -> Cool.
      expect(Color.fromARGB(255, 0, 0, 255).temperature, ColorTemperature.cool);
    });

    test('HctColor Temperature', () {
      // HCT Hue is similar to CAM16 hue.
      // Red ~ 27 -> Warm
      // Blue ~ 264 -> Cool? 
      // Let's verify with known HCT values if possible, or just trust the hue property logic.
      final redHct = HctColor(27, 100, 50);
      expect(redHct.temperature, ColorTemperature.warm);

      final blueHct = HctColor(260, 100, 50);
      expect(blueHct.temperature, ColorTemperature.cool);
    });
  });
}
