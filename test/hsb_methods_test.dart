import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsbColor Methods Tests', () {
    test('grayscale converts to grayscale correctly', () {
      final HsbColor color = HsbColor(0, 1.0, Percent.max);
      final HsbColor gray = color.grayscale;

      expect(gray.s, equals(0.0));
      expect(gray.b, closeTo(0.5, 0.01));
      expect(gray.h, equals(0.0));
    });

    test('inverted inverts color correctly', () {
      final HsbColor color = HsbColor(0, 1.0, Percent.max);
      final HsbColor inverted = color.inverted;

      expect(inverted.h, closeTo(180, 0.1));
      expect(inverted.s, closeTo(1.0, 0.01));
      expect(inverted.b, closeTo(1.0, 0.01));
    });

    test('simulate returns same color for none', () {
      final HsbColor color = HsbColor(120, 0.5, Percent.v80);
      final HsbColor simulated = color.simulate(ColorBlindnessType.none);

      expect(simulated.h, closeTo(color.h, 0.1));
      expect(simulated.s, closeTo(color.s, 0.01));
      expect(simulated.b, closeTo(color.b, 0.01));
    });

    test('simulate achromatopsia results in grayscale', () {
      final HsbColor color = HsbColor(0, 1.0, Percent.max); // Red
      final HsbColor simulated =
          color.simulate(ColorBlindnessType.achromatopsia);

      expect(simulated.s, closeTo(0.0, 0.01));
      expect(simulated.b, closeTo(0.46, 0.1));
    });

    test('monochromatic generates 5 colors', () {
      final HsbColor color = HsbColor(120, 0.5, Percent.mid);
      final List<ColorSpacesIQ> palette = color.monochromatic;
      expect(palette.length, 5);
      expect(palette[2], isA<HsbColor>());
      final HsbColor center = palette[2] as HsbColor;
      expect(center.b, closeTo(color.b, 0.01));
      expect(center.h, closeTo(color.h, 0.1));
      expect(center.s, closeTo(color.s, 0.01));
    });

    test('lighterPalette generates lighter colors', () {
      final HsbColor color = HsbColor(120, 0.5, Percent.mid);
      final List<ColorSpacesIQ> palette = color.lighterPalette(10);
      expect(palette.length, 3);
      for (ColorSpacesIQ c in palette) {
        expect((c as HsbColor).b, greaterThan(color.b));
      }
    });

    test('darkerPalette generates darker colors', () {
      final HsbColor color = HsbColor(120, 0.5, Percent.mid);
      final List<ColorSpacesIQ> palette = color.darkerPalette(10);
      expect(palette.length, 3);
      for (ColorSpacesIQ c in palette) {
        expect((c as HsbColor).b, lessThan(color.b));
      }
    });

    test('random generates valid HsbColor', () {
      final HsbColor color = HsbColor(0, 0, Percent.zero);
      final ColorSpacesIQ randomColor = color.random;
      expect(randomColor, isA<HsbColor>());
      final HsbColor hsb = randomColor as HsbColor;
      expect(hsb.h, inInclusiveRange(0, 360));
      expect(hsb.s, inInclusiveRange(0, 1));
      expect(hsb.b, inInclusiveRange(0, 1));
    });

    test('isEqual compares correctly', () {
      final HsbColor c1 = HsbColor(100, 0.5, Percent.mid);
      final HsbColor c2 = HsbColor(100, 0.5, Percent.mid);
      final HsbColor c3 = HsbColor(101, 0.5, Percent.mid);

      expect(c1.isEqual(c2), isTrue);
      expect(c1.isEqual(c3), isFalse);
    });
  });
}
