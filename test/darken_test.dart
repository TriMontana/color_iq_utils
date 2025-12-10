import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Darken Tests', () {
    test('ColorIQ darken', () {
      final ColorIQ color = cRed; // Red
      final ColorIQ darkened = color.darken(20);
      // Red HSL: 0, 1.0, 0.5. Darkened: 0, 1.0, 0.3
      final HSL hsl = darkened.hsl;
      expect(hsl.l, closeTo(0.3, 0.01));
      print('ColorIQ darken: $darkened');
    });

    test('LabColor darken', () {
      final LabColor lab = LabColor(50, 20, 30);
      final LabColor darkened = lab.darken(20);
      expect(darkened.l, closeTo(30, 0.01));
      expect(darkened.aLab, closeTo(20, 0.01));
      expect(darkened.bLab, closeTo(30, 0.01));
      print('LabColor darken: $darkened');
    });

    test('HslColor darken', () {
      const HSL hsl = HSL(100, 0.5, 0.5);
      final HSL darkened = hsl.darken(20);
      expect(darkened.l, closeTo(0.3, 0.01));
      print('HslColor darken: $darkened');
    });

    test('HsvColor darken', () {
      const HSV hsv = HSV(100, Percent.v50, Percent.v50);
      final HSV darkened = hsv.darken(20);
      expect(darkened.val, closeTo(0.3, 0.01));
      print('HsvColor darken: $darkened');
    });

    test('OkLabColor darken', () {
      const OkLabColor oklab = OkLabColor(0.5, 0.1, 0.1);
      final OkLabColor darkened = oklab.darken(20);
      expect(darkened.l, closeTo(0.3, 0.01));
      print('OkLabColor darken: $darkened');
    });

    test('HctColor darken', () {
      const HctColor hct = HctColor(100, 50, 50);
      final HctColor darkened = hct.darken(20);
      expect(darkened.tone, closeTo(30, 0.01));
      print('HctColor darken: $darkened');
    });

    test('Darken clamping', () {
      const HSL hsl = HSL(0, 0, Percent.tenth);
      final HSL darkened = hsl.darken(20);
      expect(darkened.l, 0.0);
      print('Darken clamping: $darkened');
    });
  });
}
