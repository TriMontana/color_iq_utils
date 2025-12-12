

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/foundation/num_iq.dart';
import 'package:test/test.dart';

void main() {
  group('Advanced Color Conversion Tests', () {
    test('RGB to XYZ conversion (White)', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: Iq255.max, green: Iq255.max, blue: 255);
      final XYZ xyz = color.xyz;

      // D65 White point
      expect(xyz.x, closeTo(95.047, 0.1));
      expect(xyz.y, closeTo(100.000, 0.1));
      expect(xyz.z, closeTo(108.883, 0.1));

      final ColorIQ backToColor = xyz.toColor();
      expect(backToColor.red, 255);
      expect(backToColor.green, 255);
      expect(backToColor.blue, 255);
      print('Tested RGB to XYZ conversion and back successfully.');
    });

    test('RGB to Lab conversion (Red)', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: 255, green: 0, blue: 0);
      final LabColor lab = color.lab;

      // Approximate values for pure red in sRGB -> Lab (D65)
      // L=53.24, a=80.09, b=67.20
      expect(lab.l, closeTo(53.24, 0.5));
      expect(lab.aLab, closeTo(80.09, 0.5));
      expect(lab.bLab, closeTo(67.20, 0.5));

      final ColorIQ backToColor = lab.toColor();
      expect(backToColor.red, 255);
      expect(backToColor.green, 0);
      expect(backToColor.blue, 0);
      print('Tested RGB to Lab conversion and back successfully.');
    });

    test('RGB to Luv conversion (Green)', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: 0, green: 255, blue: 0);
      final CIELuv luv = color.toLuv();

      // Approximate values for pure green in sRGB -> Luv (D65)
      // L=87.73, u=-83.07, v=107.39
      expect(luv.l, closeTo(87.73, 0.5));
      expect(luv.u, closeTo(-83.07, 0.5));
      expect(luv.v, closeTo(107.39, 0.5));

      final ColorIQ backToColor = luv.toColor();
      expect(backToColor.red, 0);
      expect(backToColor.green, 255);
      expect(backToColor.blue, 0);
    });

    test('RGB to LCH conversion (Blue)', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: 0, green: 0, blue: 255);
      final LchColor lch = color.toLch();

      // Blue Lab: L=32.30, a=79.18, b=-107.86
      // C = sqrt(79.18^2 + (-107.86)^2) = 133.8
      // H = atan2(-107.86, 79.18) = -53.7 deg -> 306.3 deg

      expect(lch.l, closeTo(32.30, 0.5));
      expect(lch.c, closeTo(133.8, 0.5));
      expect(lch.h, closeTo(306.3, 0.5));

      final ColorIQ backToColor = lch.toColor();
      expect(backToColor.red, 0);
      expect(backToColor.green, 0);
      expect(backToColor.blue, 255);
      print('Tested RGB to LCH conversion and back successfully.');
    });

    test('Black conversion', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: 0, green: 0, blue: 0);

      final XYZ xyz = color.xyz;
      expect(xyz.x, 0);
      expect(xyz.y, 0);
      expect(xyz.z, 0);

      final LabColor lab = color.lab;
      expect(lab.l, 0);
      expect(lab.aLab, 0);
      expect(lab.bLab, 0);

      final CIELuv luv = color.toLuv();
      expect(luv.l, 0);
      expect(luv.u, 0);
      expect(luv.v, 0);

      final LchColor lch = color.toLch();
      expect(lch.l, 0);
      expect(lch.c, 0);
      // Hue is undefined for black/gray, but implementation might return 0 or something else.
      // Our implementation: atan2(0,0) is 0.
      expect(lch.h, 0);
    });
  });
}
