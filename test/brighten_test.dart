import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Brighten', () {
    test('ColorIQ.brighten increases HSV Value', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 100, 0, 0); // Dark Red
      final ColorIQ brightened = color.brighten(Percent.v20);

      final HSV hsvOriginal = color.hsv;
      final HSV hsvBrightened = brightened.hsv;

      expect(hsvBrightened.value, greaterThan(hsvOriginal.value));
      expect(hsvBrightened.h, closeTo(hsvOriginal.h, 1.0));
      expect(hsvBrightened.saturation, closeTo(hsvOriginal.saturation, 0.01));
    });

    test('HsvColor.brighten increases Value', () {
      const HSV color = HSV(0, Percent.max, Percent.v50); // Dark Red
      final HSV brightened = color.brighten(Percent.v20);

      expect(brightened.value, closeTo(0.7, 0.01));
      expect(brightened.h, equals(0));
      expect(brightened.saturation, equals(1.0));
    });

    test('Brighten vs Lighten', () {
      final ColorIQ color = ColorIQ.fromArgbInts(255, 200, 0, 0); // Red

      final ColorIQ brightened = color.brighten(Percent.v20);
      // Increases Value (maxes out at 1.0)
      final ColorIQ lightened = color.lighten(
        20,
      ); // Increases Lightness (adds white)

      // Brightening a saturated red shouldn't change it much if it's already high value,
      // but lightening it should make it pink.

      final HSV hsvBright = brightened.hsv;
      final HSV hsvLight = lightened.hsv;

      // Lighten reduces saturation (adds white)
      expect(hsvLight.saturation, lessThan(color.hsv.saturation));

      // Brighten keeps saturation (if possible)
      expect(hsvBright.saturation, closeTo(color.hsv.saturation, 0.01));
    });

    test('CmykColor.brighten delegates correctly', () {
      const CMYK cmyk = CMYK(0, 1, 1, 0.5); // Dark Red
      final CMYK brightened = cmyk.brighten(20);
      expect(
        brightened.toColor().hsv.value,
        greaterThan(cmyk.toColor().hsv.value),
      );
    });
  });
}
