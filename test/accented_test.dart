import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Accented Method Tests', () {
    test('HctColor accented increases chroma and tone', () {
      final hct = HctColor(120, 50, 50);
      final accented = hct.accented(10);

      expect(accented.chroma, greaterThan(hct.chroma));
      expect(accented.tone, greaterThan(hct.tone));
      expect(accented.hue, equals(hct.hue));
    });

    test('Color accented delegates to HctColor', () {
      final color = Color.fromARGB(255, 100, 150, 200);
      final accented = color.accented(10);

      final hct = color.toHct();
      final expectedHct = hct.accented(10);
      final expectedColor = expectedHct.toColor();

      expect(accented.value, equals(expectedColor.value));
    });

    test('Accented clamps tone to 100', () {
      final hct = HctColor(120, 50, 95);
      final accented = hct.accented(20); // Should increase tone by 10, but clamp at 100

      expect(accented.tone, equals(100));
    });

    test('Accented works across different color models', () {
      final rgb = Color.fromARGB(255, 100, 150, 200);
      final xyz = rgb.toXyz();
      final lab = rgb.toLab();
      final luv = rgb.toLuv();
      
      final accentedRgb = rgb.accented();
      final accentedXyz = xyz.accented();
      final accentedLab = lab.accented();
      final accentedLuv = luv.accented();

      // Since they all delegate to Color -> Hct -> accented -> Color -> Model
      // They should represent approximately the same color (allowing for conversion errors)
      
      expect(accentedXyz.toColor().value, closeTo(accentedRgb.value, 1));
      expect(accentedLab.toColor().value, closeTo(accentedRgb.value, 1));
      expect(accentedLuv.toColor().value, closeTo(accentedRgb.value, 1));
    });
  });
}
