import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HslColor', () {
    test('closestColorSlice returns correct slice', () {
      // Red hue is 0. Index 0.
      final HslColor red = HslColor(0, 1.0, Percent.mid, hexId: hxRed);
      expect(red.closestColorSlice().name, equals('Red'));

      // Cyan hue is 180. Index 30.
      final HslColor cyan = HslColor(180, 1.0, Percent.mid, hexId: hxCyan);
      expect(cyan.closestColorSlice().name, equals('Cyan'));
    });

    test('contrastWith calculates contrast ratio', () {
      final HslColor black = HslColor(0, 0, 0, hexId: hxBlack);
      final HslColor white = HslColor(0, 0, 1, hexId: hxWhite);

      // Contrast between black and white should be 21.0
      expect(black.contrastWith(white), closeTo(21.0, 0.1));
      expect(white.contrastWith(black), closeTo(21.0, 0.1));
    });
  });
}
