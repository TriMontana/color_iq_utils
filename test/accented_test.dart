import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Accented Method Tests', () {
    test('HctColor accented increases chroma and tone', () {
      const HctColor hct = HctColor(120, 50, 50);
      final HctColor accented = hct.accented(10);

      expect(accented.chroma, greaterThan(hct.chroma));
      expect(accented.tone, greaterThan(hct.tone));
      expect(accented.hue, equals(hct.hue));
    });

    test('ColorIQ accented delegates to HctColor', () {
      const ColorIQ color = ColorIQ.fromARGB(255, 100, 150, 200);
      final ColorIQ accented = color.accented(10);

      final HctColor hct = color.toHct();
      final HctColor expectedHct = hct.accented(10);
      final ColorIQ expectedColor = expectedHct.toColor();

      expect(accented.value, equals(expectedColor.value));
    });

    test('Accented clamps tone to 100', () {
      const HctColor hct = HctColor(120, 50, 95);
      final HctColor accented = hct.accented(20); // Should increase tone by 10, but clamp at 100

      expect(accented.tone, equals(100));
    });

    test('Accented works across different color models', () {
      const ColorIQ rgb = ColorIQ.fromARGB(255, 100, 150, 200);
      final XyzColor xyz = rgb.toXyz();
      final LabColor lab = rgb.toLab();
      final LuvColor luv = rgb.toLuv();
      
      final ColorIQ accentedRgb = rgb.accented();
      final XyzColor accentedXyz = xyz.accented();
      final LabColor accentedLab = lab.accented();
      final LuvColor accentedLuv = luv.accented();

      // Since they all delegate to ColorIQ -> Hct -> accented -> ColorIQ -> Model
      // They should represent approximately the same color (allowing for conversion errors)
      
      expect(accentedXyz.toColor().value, closeTo(accentedRgb.value, 1));
      expect(accentedLab.toColor().value, closeTo(accentedRgb.value, 1));
      expect(accentedLuv.toColor().value, closeTo(accentedRgb.value, 1));
      
      print('✓ Accented color model test completed');
      print('  Original RGB: ${rgb.value}');
      print('  Accented RGB: ${accentedRgb.value}');
      print('  Accented XYZ: ${accentedXyz.toColor().value}');
      print('  Accented LAB: ${accentedLab.toColor().value}');
      print('  Accented LUV: ${accentedLuv.toColor().value}');
    });
  });
}
