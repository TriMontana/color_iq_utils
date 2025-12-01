import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('CSS String Tests', () {
    test('toCssString Hex', () {
      final c = ColorIQ(0xFFFF0000);
      expect(c.toCssString(space: CssColorSpace.hex), equals('#ff0000'));
      
      final cAlpha = ColorIQ(0x80FF0000);
      expect(cAlpha.toCssString(space: CssColorSpace.hex), equals('#ff000080'));
    });

    test('toCssString RGB', () {
      final c = ColorIQ(0xFFFF0000);
      expect(c.toCssString(space: CssColorSpace.rgb), equals('rgb(255, 0, 0)'));
      
      final cAlpha = ColorIQ(0x80FF0000); // 128/255 = 0.5019
      expect(cAlpha.toCssString(space: CssColorSpace.rgb), startsWith('rgba(255, 0, 0, 0.5'));
    });

    test('toCssString HSL', () {
      final c = HslColor(0, 1.0, 0.5); // Red
      expect(c.toCssString(space: CssColorSpace.hsl), equals('hsl(0, 100%, 50%)'));
    });

    test('toCssString OKLAB', () {
      final c = OkLabColor(0.5, 0.1, -0.1);
      expect(c.toCssString(space: CssColorSpace.oklab), equals('oklab(0.5 0.1 -0.1)'));
    });

    test('fromCssString Hex', () {
      final c = CssColor.fromCssString('#ff0000');
      expect(c.toColor().value, equals(0xFFFF0000));
      
      final cShort = CssColor.fromCssString('#f00');
      expect(cShort.toColor().value, equals(0xFFFF0000));
      
      final cAlpha = CssColor.fromCssString('#ff000080');
      expect(cAlpha.toColor().value, equals(0x80FF0000));
    });

    test('fromCssString RGB', () {
      final c = CssColor.fromCssString('rgb(255, 0, 0)');
      expect(c.toColor().value, equals(0xFFFF0000));
      
      final cAlpha = CssColor.fromCssString('rgba(255, 0, 0, 0.5)');
      expect(cAlpha.toColor().alpha, equals(128));
    });

    test('fromCssString HSL', () {
      final c = CssColor.fromCssString('hsl(0, 100%, 50%)');
      expect(c.toColor().value, equals(0xFFFF0000));
    });

    test('fromCssString OKLAB', () {
      final c = CssColor.fromCssString('oklab(0.5 0.1 -0.1)');
      expect(c, isA<OkLabColor>());
      final oklab = c as OkLabColor;
      expect(oklab.l, equals(0.5));
      expect(oklab.a, equals(0.1));
      expect(oklab.b, equals(-0.1));
    });
  });
}
