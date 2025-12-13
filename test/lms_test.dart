import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for LMS color space
///
/// LMS represents the response of cone photoreceptors (Long, Medium, Short)
/// in the human eye. It's fundamental to color blindness simulation.
void main() {
  group('LmsColor Basic Tests', () {
    test('Create LmsColor from values', () {
      const LmsColor lms = LmsColor(0.5, 0.4, 0.3);
      expect(lms.l, equals(0.5));
      expect(lms.m, equals(0.4));
      expect(lms.s, equals(0.3));
      print('✓ LmsColor created with l=${lms.l}, m=${lms.m}, s=${lms.s}');
    });

    test('Create LmsColor from ARGB int', () {
      final LmsColor lmsRed = LmsColor.fromInt(0xFFFF0000);
      expect(lmsRed.l, greaterThan(0));
      expect(lmsRed.value, equals(0xFFFF0000));
      print('✓ Red LmsColor: l=${lmsRed.l}, m=${lmsRed.m}, s=${lmsRed.s}');
    });

    test('LmsColor value property returns ARGB', () {
      const LmsColor lms = LmsColor(0.5, 0.4, 0.3);
      expect(lms.value, isA<int>());
      expect((lms.value >> 24) & 0xFF, equals(255)); // Full alpha
      print(
          '✓ LmsColor.value returns valid ARGB: ${lms.value.toRadixString(16)}');
    });
  });

  group('LmsColor Cone Response Tests', () {
    test('Red primarily stimulates L cones', () {
      final LmsColor red = LmsColor.fromInt(0xFFFF0000);
      expect(red.l, greaterThan(red.m));
      expect(red.l, greaterThan(red.s));
      print('✓ Red: L=${red.l} > M=${red.m}, S=${red.s}');
    });

    test('Green primarily stimulates M cones', () {
      final LmsColor green = LmsColor.fromInt(0xFF00FF00);
      expect(green.m, greaterThan(green.s));
      print('✓ Green: M=${green.m} > S=${green.s}');
    });

    test('Blue primarily stimulates S cones', () {
      final LmsColor blue = LmsColor.fromInt(0xFF0000FF);
      expect(blue.s, greaterThan(blue.l));
      expect(blue.s, greaterThan(blue.m));
      print('✓ Blue: S=${blue.s} > L=${blue.l}, M=${blue.m}');
    });

    test('White stimulates all cones equally', () {
      final LmsColor white = LmsColor.fromInt(0xFFFFFFFF);
      // All cones should be highly stimulated
      expect(white.l, greaterThan(0.9));
      expect(white.m, greaterThan(0.9));
      print('✓ White: L=${white.l}, M=${white.m}, S=${white.s}');
    });

    test('Black has minimal cone response', () {
      final LmsColor black = LmsColor.fromInt(0xFF000000);
      expect(black.l, lessThan(0.01));
      expect(black.m, lessThan(0.01));
      expect(black.s, lessThan(0.01));
      print('✓ Black: L=${black.l}, M=${black.m}, S=${black.s}');
    });
  });

  group('LmsColor Conversions', () {
    test('toColor returns valid ColorIQ', () {
      const LmsColor lms = LmsColor(0.5, 0.4, 0.3);
      final ColorIQ color = lms.toColor();
      expect(color.value, isA<int>());
      print('✓ toColor returns ColorIQ: ${color.hexStr}');
    });

    test('ColorIQ.lms getter works', () {
      final ColorIQ color = ColorIQ(0xFFFF6B6B);
      final LmsColor lms = color.lms;
      expect(lms.l, greaterThan(0));
      print('✓ ColorIQ.lms getter: l=${lms.l}, m=${lms.m}, s=${lms.s}');
    });

    test('Round-trip ColorIQ -> LMS -> ColorIQ', () {
      final ColorIQ original = ColorIQ(0xFF4080C0);
      final LmsColor lms = original.lms;
      final ColorIQ roundTrip = lms.toColor();

      // Colors should be very close (within small tolerance due to conversions)
      final int origR = (original.value >> 16) & 0xFF;
      final int origG = (original.value >> 8) & 0xFF;
      final int origB = original.value & 0xFF;
      final int rtR = (roundTrip.value >> 16) & 0xFF;
      final int rtG = (roundTrip.value >> 8) & 0xFF;
      final int rtB = roundTrip.value & 0xFF;

      expect((origR - rtR).abs(), lessThan(5));
      expect((origG - rtG).abs(), lessThan(5));
      expect((origB - rtB).abs(), lessThan(5));
      print('✓ Round-trip: ${original.hexStr} -> LMS -> ${roundTrip.hexStr}');
    });
  });

  group('LmsColor Manipulations', () {
    test('lighten increases cone responses', () {
      final LmsColor lms = LmsColor.fromInt(0xFF808080);
      final LmsColor lightened = lms.lighten(20);
      expect(lightened.l, greaterThan(lms.l));
      expect(lightened.m, greaterThan(lms.m));
      print('✓ lighten: L=${lms.l} -> ${lightened.l}');
    });

    test('darken decreases cone responses', () {
      final LmsColor lms = LmsColor.fromInt(0xFF808080);
      final LmsColor darkened = lms.darken(20);
      expect(darkened.l, lessThan(lms.l));
      expect(darkened.m, lessThan(lms.m));
      print('✓ darken: L=${lms.l} -> ${darkened.l}');
    });

    test('lerp interpolates correctly', () {
      final LmsColor black = LmsColor.fromInt(0xFF000000);
      final LmsColor white = LmsColor.fromInt(0xFFFFFFFF);
      final LmsColor mid = black.lerp(white, 0.5);

      expect(mid.l, closeTo((black.l + white.l) / 2, 0.1));
      print('✓ lerp: ${black.l} -> ${mid.l} -> ${white.l}');
    });

    test('copyWith creates modified copy', () {
      const LmsColor original = LmsColor(0.5, 0.4, 0.3);
      final LmsColor modified = original.copyWith(l: 0.8);

      expect(modified.l, equals(0.8));
      expect(modified.m, equals(original.m));
      expect(modified.s, equals(original.s));
      print('✓ copyWith: l=${original.l} -> ${modified.l}');
    });
  });

  group('LmsColor Palette Generation', () {
    test('monochromatic returns 5 colors', () {
      final LmsColor lms = LmsColor.fromInt(0xFF4080C0);
      final List<LmsColor> palette = lms.monochromatic;
      expect(palette.length, equals(5));
      print('✓ monochromatic palette has 5 colors');
    });

    test('generateBasicPalette returns 5 colors', () {
      final LmsColor lms = LmsColor.fromInt(0xFF4080C0);
      final List<LmsColor> palette = lms.generateBasicPalette();
      expect(palette.length, equals(5));
      print('✓ generateBasicPalette has 5 colors');
    });
  });
}
