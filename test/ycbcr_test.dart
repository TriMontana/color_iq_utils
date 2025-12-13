import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for YCbCr color space
///
/// YCbCr separates luminance (Y) from chrominance (Cb, Cr) for
/// video compression and image processing.
void main() {
  group('YCbCrColor Basic Tests', () {
    test('Create YCbCrColor from values', () {
      const YCbCrColor ycbcr = YCbCrColor(0.5, 0.1, -0.1);
      expect(ycbcr.y, equals(0.5));
      expect(ycbcr.cb, equals(0.1));
      expect(ycbcr.cr, equals(-0.1));
      print(
          '✓ YCbCrColor created: y=${ycbcr.y}, cb=${ycbcr.cb}, cr=${ycbcr.cr}');
    });

    test('Create YCbCrColor from ARGB int', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFFFF0000);
      expect(ycbcr.y, greaterThan(0));
      expect(ycbcr.value, equals(0xFFFF0000));
      print('✓ Red YCbCr: y=${ycbcr.y}, cb=${ycbcr.cb}, cr=${ycbcr.cr}');
    });

    test('YCbCrColor value property returns ARGB', () {
      const YCbCrColor ycbcr = YCbCrColor(0.5, 0.0, 0.0);
      expect(ycbcr.value, isA<int>());
      expect((ycbcr.value >> 24) & 0xFF, equals(255));
      print('✓ YCbCrColor.value returns valid ARGB');
    });

    test('Default standard is BT.709', () {
      const YCbCrColor ycbcr = YCbCrColor(0.5, 0.0, 0.0);
      expect(ycbcr.standard, equals(YCbCrStandard.bt709));
      print('✓ Default standard is BT.709');
    });
  });

  group('YCbCr Standard Tests', () {
    test('BT.601 conversion works', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(
        0xFFFF0000,
        standard: YCbCrStandard.bt601,
      );
      expect(ycbcr.standard, equals(YCbCrStandard.bt601));
      expect(ycbcr.y, greaterThan(0));
      print('✓ BT.601: y=${ycbcr.y}, cb=${ycbcr.cb}, cr=${ycbcr.cr}');
    });

    test('BT.709 conversion works', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(
        0xFFFF0000,
        standard: YCbCrStandard.bt709,
      );
      expect(ycbcr.standard, equals(YCbCrStandard.bt709));
      expect(ycbcr.y, greaterThan(0));
      print('✓ BT.709: y=${ycbcr.y}, cb=${ycbcr.cb}, cr=${ycbcr.cr}');
    });

    test('BT.2020 conversion works', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(
        0xFFFF0000,
        standard: YCbCrStandard.bt2020,
      );
      expect(ycbcr.standard, equals(YCbCrStandard.bt2020));
      expect(ycbcr.y, greaterThan(0));
      print('✓ BT.2020: y=${ycbcr.y}, cb=${ycbcr.cb}, cr=${ycbcr.cr}');
    });

    test('Different standards produce different Y values', () {
      final YCbCrColor bt601 =
          YCbCrColor.fromInt(0xFFFF0000, standard: YCbCrStandard.bt601);
      final YCbCrColor bt709 =
          YCbCrColor.fromInt(0xFFFF0000, standard: YCbCrStandard.bt709);

      // BT.601 has higher Kr (0.299) than BT.709 (0.2126) for red
      expect(bt601.y, isNot(equals(bt709.y)));
      print('✓ BT.601 Y=${bt601.y} differs from BT.709 Y=${bt709.y}');
    });
  });

  group('YCbCr Luma Tests', () {
    test('White has maximum Y', () {
      final YCbCrColor white = YCbCrColor.fromInt(0xFFFFFFFF);
      expect(white.y, closeTo(1.0, 0.01));
      expect(white.cb, closeTo(0.0, 0.01));
      expect(white.cr, closeTo(0.0, 0.01));
      print('✓ White: y=${white.y}, cb=${white.cb}, cr=${white.cr}');
    });

    test('Black has minimum Y', () {
      final YCbCrColor black = YCbCrColor.fromInt(0xFF000000);
      expect(black.y, closeTo(0.0, 0.01));
      expect(black.cb, closeTo(0.0, 0.01));
      expect(black.cr, closeTo(0.0, 0.01));
      print('✓ Black: y=${black.y}, cb=${black.cb}, cr=${black.cr}');
    });

    test('Gray has Y proportional to brightness', () {
      final YCbCrColor midGray = YCbCrColor.fromInt(0xFF808080);
      expect(midGray.y, closeTo(0.5, 0.05));
      expect(midGray.cb, closeTo(0.0, 0.01));
      expect(midGray.cr, closeTo(0.0, 0.01));
      print('✓ Mid gray Y: ${midGray.y}');
    });
  });

  group('YCbCr Chroma Tests', () {
    test('Pure blue has positive Cb', () {
      final YCbCrColor blue = YCbCrColor.fromInt(0xFF0000FF);
      expect(blue.cb, greaterThan(0));
      print('✓ Blue Cb: ${blue.cb} > 0');
    });

    test('Pure red has positive Cr', () {
      final YCbCrColor red = YCbCrColor.fromInt(0xFFFF0000);
      expect(red.cr, greaterThan(0));
      print('✓ Red Cr: ${red.cr} > 0');
    });

    test('Yellow has negative Cb (opposite of blue)', () {
      final YCbCrColor yellow = YCbCrColor.fromInt(0xFFFFFF00);
      expect(yellow.cb, lessThan(0));
      print('✓ Yellow Cb: ${yellow.cb} < 0');
    });

    test('Cyan has negative Cr (opposite of red)', () {
      final YCbCrColor cyan = YCbCrColor.fromInt(0xFF00FFFF);
      expect(cyan.cr, lessThan(0));
      print('✓ Cyan Cr: ${cyan.cr} < 0');
    });
  });

  group('YCbCrColor Conversions', () {
    test('toColor returns valid ColorIQ', () {
      const YCbCrColor ycbcr = YCbCrColor(0.5, 0.1, 0.1);
      final ColorIQ color = ycbcr.toColor();
      expect(color.value, isA<int>());
      print('✓ toColor returns ColorIQ: ${color.hexStr}');
    });

    test('ColorIQ.ycbcr getter works', () {
      final ColorIQ color = ColorIQ(0xFFFF6B6B);
      final YCbCrColor ycbcr = color.ycbcr;
      expect(ycbcr.y, greaterThan(0));
      print('✓ ColorIQ.ycbcr getter: y=${ycbcr.y}');
    });

    test('Round-trip ColorIQ -> YCbCr -> ColorIQ', () {
      final ColorIQ original = ColorIQ(0xFF4080C0);
      final YCbCrColor ycbcr = original.ycbcr;
      final ColorIQ roundTrip = ycbcr.toColor();

      final int origR = (original.value >> 16) & 0xFF;
      final int origG = (original.value >> 8) & 0xFF;
      final int origB = original.value & 0xFF;
      final int rtR = (roundTrip.value >> 16) & 0xFF;
      final int rtG = (roundTrip.value >> 8) & 0xFF;
      final int rtB = roundTrip.value & 0xFF;

      expect((origR - rtR).abs(), lessThan(2));
      expect((origG - rtG).abs(), lessThan(2));
      expect((origB - rtB).abs(), lessThan(2));
      print('✓ Round-trip: ${original.hexStr} -> ${roundTrip.hexStr}');
    });

    test('toStandard converts between standards', () {
      final YCbCrColor bt709 =
          YCbCrColor.fromInt(0xFFFF0000, standard: YCbCrStandard.bt709);
      final YCbCrColor bt601 = bt709.toStandard(YCbCrStandard.bt601);

      expect(bt601.standard, equals(YCbCrStandard.bt601));
      expect(bt601.y, isNot(equals(bt709.y)));
      print(
          '✓ Standard conversion: BT.709 Y=${bt709.y} -> BT.601 Y=${bt601.y}');
    });
  });

  group('YCbCrColor Manipulations', () {
    test('lighten increases Y', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFF808080);
      final YCbCrColor lightened = ycbcr.lighten(20);
      expect(lightened.y, greaterThan(ycbcr.y));
      print('✓ lighten: Y=${ycbcr.y} -> ${lightened.y}');
    });

    test('darken decreases Y', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFF808080);
      final YCbCrColor darkened = ycbcr.darken(20);
      expect(darkened.y, lessThan(ycbcr.y));
      print('✓ darken: Y=${ycbcr.y} -> ${darkened.y}');
    });

    test('saturate increases chroma magnitude', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFFFF6666);
      final double origChroma = ycbcr.cb.abs() + ycbcr.cr.abs();
      final YCbCrColor saturated = ycbcr.saturate(25);
      final double newChroma = saturated.cb.abs() + saturated.cr.abs();
      expect(newChroma, greaterThan(origChroma));
      print('✓ saturate: chroma $origChroma -> $newChroma');
    });

    test('desaturate decreases chroma magnitude', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFFFF0000);
      final double origChroma = ycbcr.cb.abs() + ycbcr.cr.abs();
      final YCbCrColor desaturated = ycbcr.desaturate(25);
      final double newChroma = desaturated.cb.abs() + desaturated.cr.abs();
      expect(newChroma, lessThan(origChroma));
      print('✓ desaturate: chroma $origChroma -> $newChroma');
    });

    test('lerp interpolates correctly', () {
      final YCbCrColor black = YCbCrColor.fromInt(0xFF000000);
      final YCbCrColor white = YCbCrColor.fromInt(0xFFFFFFFF);
      final YCbCrColor mid = black.lerp(white, 0.5);

      expect(mid.y, closeTo(0.5, 0.05));
      print('✓ lerp: Y ${black.y} -> ${mid.y} -> ${white.y}');
    });
  });

  group('YCbCrColor Palette Generation', () {
    test('monochromatic returns 5 colors', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFF4080C0);
      final List<YCbCrColor> palette = ycbcr.monochromatic;
      expect(palette.length, equals(5));
      print('✓ monochromatic palette has 5 colors');
    });

    test('tonesPalette returns decreasing saturation', () {
      final YCbCrColor ycbcr = YCbCrColor.fromInt(0xFFFF0000);
      final List<YCbCrColor> palette = ycbcr.tonesPalette();
      expect(palette.length, equals(5));

      // Each should have less chroma than previous
      for (int i = 1; i < palette.length; i++) {
        final double prevChroma =
            palette[i - 1].cb.abs() + palette[i - 1].cr.abs();
        final double thisChroma = palette[i].cb.abs() + palette[i].cr.abs();
        expect(thisChroma, lessThanOrEqualTo(prevChroma));
      }
      print('✓ tonesPalette has decreasing saturation');
    });
  });
}
