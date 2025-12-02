import 'package:test/test.dart';
import 'package:color_iq_utils/color_iq_utils.dart';


void main() {
  group('Darken Tests', () {
    test('ColorIQ darken', () {
      const ColorIQ color = ColorIQ.fromARGB(255, 255, 0, 0); // Red
      final ColorIQ darkened = color.darken(20);
      // Red HSL: 0, 1.0, 0.5. Darkened: 0, 1.0, 0.3
      final HslColor hsl = darkened.toHsl();
      expect(hsl.l, closeTo(0.3, 0.01));
    });

    test('LabColor darken', () {
      const LabColor lab = LabColor(50, 20, 30);
      final LabColor darkened = lab.darken(20);
      expect(darkened.l, closeTo(30, 0.01));
      expect(darkened.a, closeTo(20, 0.01));
      expect(darkened.b, closeTo(30, 0.01));
    });

    test('HslColor darken', () {
      const HslColor hsl = HslColor(100, 0.5, 0.5);
      final HslColor darkened = hsl.darken(20);
      expect(darkened.l, closeTo(0.3, 0.01));
    });

    test('HsvColor darken', () {
      const HsvColor hsv = HsvColor(100, 0.5, 0.5);
      final HsvColor darkened = hsv.darken(20);
      expect(darkened.v, closeTo(0.3, 0.01));
    });

    test('OkLabColor darken', () {
      const OkLabColor oklab = OkLabColor(0.5, 0.1, 0.1);
      final OkLabColor darkened = oklab.darken(20);
      expect(darkened.l, closeTo(0.3, 0.01));
    });

    test('HctColor darken', () {
      const HctColor hct = HctColor(100, 50, 50);
      final HctColor darkened = hct.darken(20);
      expect(darkened.tone, closeTo(30, 0.01));
    });
    
    test('Darken clamping', () {
        const HslColor hsl = HslColor(0, 0, 0.1);
        final HslColor darkened = hsl.darken(20);
        expect(darkened.l, 0.0);
    });
  });
}
