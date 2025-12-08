import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Brighten', () {
    test('ColorIQ.brighten increases HSV Value', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 100, 0, 0); // Dark Red
      final ColorIQ brightened = color.brighten(20);

      final HsvColor hsvOriginal = color.toHsv();
      final HsvColor hsvBrightened = brightened.toHsv();

      expect(hsvBrightened.v, greaterThan(hsvOriginal.v));
      expect(hsvBrightened.h, closeTo(hsvOriginal.h, 1.0));
      expect(hsvBrightened.s, closeTo(hsvOriginal.s, 0.01));
    });

    test('HsvColor.brighten increases Value', () {
      const HsvColor color = HsvColor(0, 1.0, Percent.half); // Dark Red
      final HsvColor brightened = color.brighten(20);

      expect(brightened.v, closeTo(0.7, 0.01));
      expect(brightened.h, equals(0));
      expect(brightened.s, equals(1.0));
    });

    test('Brighten vs Lighten', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 200, 0, 0); // Red

      final ColorIQ brightened = color.brighten(
        20,
      ); // Increases Value (maxes out at 1.0)
      final ColorIQ lightened = color.lighten(
        20,
      ); // Increases Lightness (adds white)

      // Brightening a saturated red shouldn't change it much if it's already high value,
      // but lightening it should make it pink.

      final HsvColor hsvBright = brightened.toHsv();
      final HsvColor hsvLight = lightened.toHsv();

      // Lighten reduces saturation (adds white)
      expect(hsvLight.s, lessThan(color.toHsv().s));

      // Brighten keeps saturation (if possible)
      expect(hsvBright.s, closeTo(color.toHsv().s, 0.01));
    });

    test('CmykColor.brighten delegates correctly', () {
      const CmykColor cmyk = CmykColor(0, 1, 1, 0.5); // Dark Red
      final CmykColor brightened = cmyk.brighten(20);
      expect(
        brightened.toColor().toHsv().v,
        greaterThan(cmyk.toColor().toHsv().v),
      );
    });
  });
}
