import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HslColor', () {
    test('closestColorSlice returns correct slice', () {
      // Red hue is 0. Index 0.
      const HSL red = HSL(0, 1.0, Percent.mid, hexId: hxRed);
      expect(red.closestColorSlice().name, equals('Red'));

      // Cyan hue is 180. Index 30.
      const HSL cyan = HSL(180, 1.0, Percent.mid, hexId: hxCyan);
      expect(cyan.closestColorSlice().name, equals('Cyan'));
    });

    test('contrastWith calculates contrast ratio', () {
      // Contrast between black and white should be 21.0
      expect(kHslBlack.contrastWith(kHslWhite), closeTo(21.0, 0.1));
      expect(kHslWhite.contrastWith(kHslBlack), closeTo(21.0, 0.1));
    });
  });
}
