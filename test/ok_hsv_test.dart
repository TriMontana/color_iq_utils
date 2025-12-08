import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkHsvColor Tests', () {
    test('intensify increases saturation and decreases value', () {
      const OkHsvColor color = OkHsvColor(180.0, 0.5, 0.5);
      final OkHsvColor intensified = color.intensify(20);
      // S: 0.5 + 0.2 = 0.7
      // V: 0.5 - 0.1 = 0.4
      expect(intensified.saturation, closeTo(0.7, 0.001));
      expect(intensified.val, closeTo(0.4, 0.001));
    });

    test('deintensify decreases saturation and increases value', () {
      const OkHsvColor color = OkHsvColor(180.0, 0.5, 0.5);
      final OkHsvColor deintensified = color.deintensify(20);
      // S: 0.5 - 0.2 = 0.3
      // V: 0.5 + 0.1 = 0.6
      expect(deintensified.saturation, closeTo(0.3, 0.001));
      expect(deintensified.val, closeTo(0.6, 0.001));
    });

    test('accented increases saturation and increases value', () {
      const OkHsvColor color = OkHsvColor(180.0, 0.5, 0.5);
      final OkHsvColor accented = color.accented(20);
      // S: 0.5 + 0.2 = 0.7
      // V: 0.5 + 0.1 = 0.6
      expect(accented.saturation, closeTo(0.7, 0.001));
      expect(accented.val, closeTo(0.6, 0.001));
    });

    test('whiten moves towards white', () {
      const OkHsvColor color = OkHsvColor(0.0, 1.0, 0.0); // Black/Red
      final OkHsvColor whitened = color.whiten(50);
      // White is S=0, V=1
      // Lerp 50% from S=1, V=0 to S=0, V=1
      // S: 0.5
      // V: 0.5
      expect(whitened.saturation, closeTo(0.5, 0.001));
      expect(whitened.val, closeTo(0.5, 0.001));
    });

    test('blacken moves towards black', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.0, 1.0); // White
      final OkHsvColor blackened = color.blacken(50);
      // Black is V=0
      // Lerp 50% from V=1 to V=0 -> V=0.5
      expect(blackened.val, closeTo(0.5, 0.001));
    });

    test('lerp interpolates correctly', () {
      const OkHsvColor color1 = OkHsvColor(0.0, 0.0, 0.0);
      const OkHsvColor color2 = OkHsvColor(100.0, 1.0, 1.0);
      final OkHsvColor lerped = color1.lerp(color2, 0.5);
      expect(lerped.hue, closeTo(50.0, 0.001));
      expect(lerped.saturation, closeTo(0.5, 0.001));
      expect(lerped.val, closeTo(0.5, 0.001));
    });

    test('monochromatic generates 5 colors', () {
      const OkHsvColor color = OkHsvColor(180.0, 0.5, 0.5);
      final List<ColorSpacesIQ> palette = color.monochromatic;
      expect(palette.length, 5);
      expect(palette[2].value, equals(color.value));
      // Variations in value
      expect((palette[0] as OkHsvColor).val, closeTo(0.3, 0.001));
      expect((palette[4] as OkHsvColor).val, closeTo(0.7, 0.001));
    });

    test('lighterPalette generates lighter colors', () {
      const OkHsvColor color = OkHsvColor(180.0, 0.5, 0.5);
      final List<ColorSpacesIQ> palette = color.lighterPalette(10);
      expect(palette.length, 5);
      expect((palette[0] as OkHsvColor).val, closeTo(0.6, 0.001));
      expect((palette[4] as OkHsvColor).val, closeTo(1.0, 0.001));
    });

    test('darkerPalette generates darker colors', () {
      const OkHsvColor color = OkHsvColor(180.0, 0.5, 0.5);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);
      expect(palette.length, 5);
      expect((palette[0] as OkHsvColor).val, closeTo(0.4, 0.001));
      expect((palette[4] as OkHsvColor).val, closeTo(0.0, 0.001));
    });

    test('random generates valid color', () {
      const OkHsvColor color = OkHsvColor(0.0, 0.0, 0.0);
      final ColorSpacesIQ randomColor = color.random;
      expect(randomColor, isA<OkHsvColor>());
      final OkHsvColor okHsv = randomColor as OkHsvColor;
      expect(okHsv.hue, greaterThanOrEqualTo(0.0));
      expect(okHsv.hue, lessThanOrEqualTo(360.0));
      expect(okHsv.saturation, greaterThanOrEqualTo(0.0));
      expect(okHsv.saturation, lessThanOrEqualTo(1.0));
      expect(okHsv.val, greaterThanOrEqualTo(0.0));
      expect(okHsv.val, lessThanOrEqualTo(1.0));
    });
  });
}
