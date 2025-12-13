import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for ProPhoto RGB (ROMM RGB) color space
///
/// ProPhoto RGB is a wide-gamut color space covering ~90% of visible colors,
/// commonly used in photography workflows.
void main() {
  group('ProPhotoRgbColor Basic Tests', () {
    test('Create ProPhotoRgbColor from values', () {
      const ProPhotoRgbColor pro = ProPhotoRgbColor(0.5, 0.4, 0.3);
      expect(pro.rPro, equals(0.5));
      expect(pro.gPro, equals(0.4));
      expect(pro.bPro, equals(0.3));
      print(
          '✓ ProPhotoRgbColor created: r=${pro.rPro}, g=${pro.gPro}, b=${pro.bPro}');
    });

    test('Create ProPhotoRgbColor from ARGB int', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFFFF0000);
      expect(pro.rPro, greaterThan(0));
      expect(pro.value, equals(0xFFFF0000));
      print('✓ Red ProPhoto: r=${pro.rPro}, g=${pro.gPro}, b=${pro.bPro}');
    });

    test('ProPhotoRgbColor value property returns ARGB', () {
      const ProPhotoRgbColor pro = ProPhotoRgbColor(0.5, 0.4, 0.3);
      expect(pro.value, isA<int>());
      expect((pro.value >> 24) & 0xFF, equals(255));
      print('✓ ProPhotoRgbColor.value returns valid ARGB');
    });
  });

  group('ProPhoto RGB Wide Gamut Tests', () {
    test('Pure red in sRGB has high ProPhoto R', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFFFF0000);
      expect(pro.rPro, greaterThan(0.5));
      expect(pro.gPro, lessThan(0.5));
      expect(pro.bPro, lessThan(0.5));
      print('✓ Red: r=${pro.rPro}, g=${pro.gPro}, b=${pro.bPro}');
    });

    test('Pure green in sRGB has high ProPhoto G', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFF00FF00);
      expect(pro.gPro, greaterThan(0.5));
      print('✓ Green: r=${pro.rPro}, g=${pro.gPro}, b=${pro.bPro}');
    });

    test('Pure blue in sRGB has high ProPhoto B', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFF0000FF);
      expect(pro.bPro, greaterThan(0.5));
      print('✓ Blue: r=${pro.rPro}, g=${pro.gPro}, b=${pro.bPro}');
    });

    test('White has all components near 1', () {
      final ProPhotoRgbColor white = ProPhotoRgbColor.fromInt(0xFFFFFFFF);
      expect(white.rPro, closeTo(1.0, 0.1));
      expect(white.gPro, closeTo(1.0, 0.1));
      expect(white.bPro, closeTo(1.0, 0.1));
      print('✓ White: r=${white.rPro}, g=${white.gPro}, b=${white.bPro}');
    });

    test('Black has all components near 0', () {
      final ProPhotoRgbColor black = ProPhotoRgbColor.fromInt(0xFF000000);
      expect(black.rPro, closeTo(0.0, 0.01));
      expect(black.gPro, closeTo(0.0, 0.01));
      expect(black.bPro, closeTo(0.0, 0.01));
      print('✓ Black: r=${black.rPro}, g=${black.gPro}, b=${black.bPro}');
    });
  });

  group('ProPhoto RGB sRGB Gamut Check', () {
    test('sRGB colors are within ProPhoto gamut', () {
      final ColorIQ red = ColorIQ(0xFFFF0000);
      final ProPhotoRgbColor pro = red.proPhoto;
      expect(pro.isInSrgbGamut, isTrue);
      print('✓ Red is in sRGB gamut');
    });

    test('sRGB whites and blacks are in gamut', () {
      final ProPhotoRgbColor white = ProPhotoRgbColor.fromInt(0xFFFFFFFF);
      final ProPhotoRgbColor black = ProPhotoRgbColor.fromInt(0xFF000000);
      expect(white.isInSrgbGamut, isTrue);
      expect(black.isInSrgbGamut, isTrue);
      print('✓ White and black are in sRGB gamut');
    });
  });

  group('ProPhoto RGB Conversions', () {
    test('toColor returns valid ColorIQ', () {
      const ProPhotoRgbColor pro = ProPhotoRgbColor(0.5, 0.4, 0.3);
      final ColorIQ color = pro.toColor();
      expect(color.value, isA<int>());
      print('✓ toColor returns ColorIQ: ${color.hexStr}');
    });

    test('ColorIQ.proPhoto getter works', () {
      final ColorIQ color = ColorIQ(0xFFFF6B6B);
      final ProPhotoRgbColor pro = color.proPhoto;
      expect(pro.rPro, greaterThan(0));
      print('✓ ColorIQ.proPhoto getter: r=${pro.rPro}');
    });

    test('Round-trip ColorIQ -> ProPhoto -> ColorIQ', () {
      final ColorIQ original = ColorIQ(0xFF4080C0);
      final ProPhotoRgbColor pro = original.proPhoto;
      final ColorIQ roundTrip = pro.toColor();

      final int origR = (original.value >> 16) & 0xFF;
      final int origG = (original.value >> 8) & 0xFF;
      final int origB = original.value & 0xFF;
      final int rtR = (roundTrip.value >> 16) & 0xFF;
      final int rtG = (roundTrip.value >> 8) & 0xFF;
      final int rtB = roundTrip.value & 0xFF;

      expect((origR - rtR).abs(), lessThan(3));
      expect((origG - rtG).abs(), lessThan(3));
      expect((origB - rtB).abs(), lessThan(3));
      print('✓ Round-trip: ${original.hexStr} -> ${roundTrip.hexStr}');
    });

    test('toXyzD50 returns XYZ D50', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFFFFFFFF);
      final XYZ xyz = pro.toXyzD50();
      expect(xyz.y, greaterThan(90)); // White point Y ≈ 100
      print('✓ toXyzD50: Y=${xyz.y}');
    });
  });

  group('ProPhoto RGB Manipulations', () {
    test('lighten increases all components', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFF808080);
      final ProPhotoRgbColor lightened = pro.lighten(20);
      expect(lightened.rPro, greaterThan(pro.rPro));
      expect(lightened.gPro, greaterThan(pro.gPro));
      expect(lightened.bPro, greaterThan(pro.bPro));
      print('✓ lighten: r=${pro.rPro} -> ${lightened.rPro}');
    });

    test('darken decreases all components', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFF808080);
      final ProPhotoRgbColor darkened = pro.darken(20);
      expect(darkened.rPro, lessThan(pro.rPro));
      expect(darkened.gPro, lessThan(pro.gPro));
      expect(darkened.bPro, lessThan(pro.bPro));
      print('✓ darken: r=${pro.rPro} -> ${darkened.rPro}');
    });

    test('lerp interpolates correctly', () {
      final ProPhotoRgbColor black = ProPhotoRgbColor.fromInt(0xFF000000);
      final ProPhotoRgbColor white = ProPhotoRgbColor.fromInt(0xFFFFFFFF);
      final ProPhotoRgbColor mid = black.lerp(white, 0.5);

      expect(mid.rPro, closeTo((black.rPro + white.rPro) / 2, 0.1));
      print('✓ lerp: r ${black.rPro} -> ${mid.rPro} -> ${white.rPro}');
    });

    test('copyWith creates modified copy', () {
      const ProPhotoRgbColor original = ProPhotoRgbColor(0.5, 0.4, 0.3);
      final ProPhotoRgbColor modified = original.copyWith(rPro: 0.8);

      expect(modified.rPro, equals(0.8));
      expect(modified.gPro, equals(original.gPro));
      expect(modified.bPro, equals(original.bPro));
      print('✓ copyWith: r=${original.rPro} -> ${modified.rPro}');
    });
  });

  group('ProPhoto RGB Palette Generation', () {
    test('monochromatic returns 5 colors', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFF4080C0);
      final List<ProPhotoRgbColor> palette = pro.monochromatic;
      expect(palette.length, equals(5));
      print('✓ monochromatic palette has 5 colors');
    });

    test('generateBasicPalette returns 5 colors', () {
      final ProPhotoRgbColor pro = ProPhotoRgbColor.fromInt(0xFF4080C0);
      final List<ProPhotoRgbColor> palette = pro.generateBasicPalette();
      expect(palette.length, equals(5));
      print('✓ generateBasicPalette has 5 colors');
    });
  });
}
