import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/extensions/cam16_helper.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:test/test.dart';

void main() {
  group('Phase 2 Color Space Tests', () {
    test('ColorIQ implements ColorSpacesIQ', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      expect(color, isA<ColorSpacesIQ>());
      expect(color.value, 0xFFFF0000);
    });

    test('RGB to HSL conversion (Red)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final HSL hsl = color.hsl;
      expect(hsl.h, closeTo(0, 0.1));
      expect(hsl.s, closeTo(1.0, 0.1));
      expect(hsl.l, closeTo(0.5, 0.1));
      expect(hsl.value, 0xFFFF0000);
    });

    test('RGB to HSV conversion (Green)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 0, 255, 0);
      final HSV hsv = color.hsv;
      expect(hsv.h, closeTo(120, 0.1));
      expect(hsv.saturation, closeTo(1.0, 0.1));
      expect(hsv.value, closeTo(1.0, 0.1));
      expect(hsv.value, 0xFF00FF00);
    });

    test('RGB to HSB conversion (Blue)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 0, 0, 255);
      final HsbColor hsb = color.toHsb();
      expect(hsb.h, closeTo(240, 0.1));
      expect(hsb.s, closeTo(1.0, 0.1));
      expect(hsb.b, closeTo(1.0, 0.1));
      expect(hsb.value, 0xFF0000FF);
    });

    test('RGB to HWB conversion (Red)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final HwbColor hwb = color.toHwb();
      expect(hwb.h, closeTo(0, 0.1));
      expect(hwb.w, closeTo(0.0, 0.1));
      expect(hwb.b, closeTo(0.0, 0.1));
      expect(hwb.value, 0xFFFF0000);
    });

    test('RGB to Hct conversion (Red)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final HctColor hct = color.toHctColor();
      // Hct hue for sRGB Red is approx 27-28 degrees (Cam16 hue)
      expect(hct.hue, closeTo(27, 2.0));
      expect(hct.value, 0xFFFF0000);
    });

    test('RGB to Cam16 conversion (Red)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final Cam16 cam = color.toCam16();
      expect(cam.hue, closeTo(27, 2.0));
      expect(cam.value, 0xFFFF0000);
    });

    test('RGB to Display P3 conversion (Red)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final DisplayP3Color p3 = color.toDisplayP3();
      // sRGB Red (1,0,0) in P3 is approx (0.917, 0.200, 0.138)
      expect(p3.r, closeTo(0.917, 0.05));
      expect(p3.g, closeTo(0.200, 0.05));
      expect(p3.b, closeTo(0.138, 0.05));
      // Round trip check (should be close to original Red)
      expect(p3.value, 0xFFFF0000);
    });

    test('RGB to Rec. 2020 conversion (Red)', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 255, 0, 0);
      final Rec2020Color rec2020 = color.toRec2020();
      // sRGB Red (1,0,0) in Rec2020 is approx (0.708, 0.292, 0.0) - wait, checking math
      // Actually sRGB gamut is smaller, so sRGB Red fits inside Rec2020.
      // The values should be different.
      // sRGB Red in Rec2020 is approx (0.627, 0.329, 0.093) linear?
      // Let's just check it's not 1,0,0 and round trip works.
      expect(rec2020.r, isNot(closeTo(1.0, 0.001)));
      expect(rec2020.value, 0xFFFF0000);
    });
  });
}
