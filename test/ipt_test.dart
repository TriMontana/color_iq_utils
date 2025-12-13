import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for IPT (Intensity, Protan, Tritan) color space
///
/// IPT is a perceptually uniform color space optimized for gamut mapping
/// and hue uniformity, developed by Ebner and Fairchild.
void main() {
  group('IptColor Basic Tests', () {
    test('Create IptColor from values', () {
      const IptColor ipt = IptColor(0.5, 0.1, -0.1);
      expect(ipt.i, equals(0.5));
      expect(ipt.p, equals(0.1));
      expect(ipt.t, equals(-0.1));
      print('✓ IptColor created: i=${ipt.i}, p=${ipt.p}, t=${ipt.t}');
    });

    test('Create IptColor from ARGB int', () {
      final IptColor ipt = IptColor.fromInt(0xFFFF0000);
      expect(ipt.i, greaterThan(0));
      expect(ipt.value, equals(0xFFFF0000));
      print('✓ Red IptColor: i=${ipt.i}, p=${ipt.p}, t=${ipt.t}');
    });

    test('IptColor value property returns ARGB', () {
      const IptColor ipt = IptColor(0.5, 0.0, 0.0);
      expect(ipt.value, isA<int>());
      expect((ipt.value >> 24) & 0xFF, equals(255));
      print('✓ IptColor.value returns valid ARGB');
    });
  });

  group('IptColor Intensity Tests', () {
    test('White has high intensity', () {
      final IptColor white = IptColor.fromInt(0xFFFFFFFF);
      expect(white.i, greaterThan(0.9));
      expect(white.p, closeTo(0.0, 0.01));
      expect(white.t, closeTo(0.0, 0.01));
      print('✓ White: i=${white.i}, p=${white.p}, t=${white.t}');
    });

    test('Black has low intensity', () {
      final IptColor black = IptColor.fromInt(0xFF000000);
      expect(black.i, lessThan(0.1));
      expect(black.p, closeTo(0.0, 0.01));
      expect(black.t, closeTo(0.0, 0.01));
      print('✓ Black: i=${black.i}, p=${black.p}, t=${black.t}');
    });

    test('Gray has neutral P and T', () {
      final IptColor gray = IptColor.fromInt(0xFF808080);
      expect(gray.p.abs(), lessThan(0.05));
      expect(gray.t.abs(), lessThan(0.05));
      print('✓ Gray: p=${gray.p}, t=${gray.t}');
    });
  });

  group('IptColor Opponent Tests', () {
    test('Red has positive P (protan)', () {
      final IptColor red = IptColor.fromInt(0xFFFF0000);
      expect(red.p, greaterThan(0));
      print('✓ Red P: ${red.p} > 0');
    });

    test('Green has negative P (protan)', () {
      final IptColor green = IptColor.fromInt(0xFF00FF00);
      expect(green.p, lessThan(0));
      print('✓ Green P: ${green.p} < 0');
    });

    test('Blue has negative T (tritan)', () {
      final IptColor blue = IptColor.fromInt(0xFF0000FF);
      expect(blue.t, lessThan(0));
      print('✓ Blue T: ${blue.t} < 0');
    });

    test('Yellow has positive T (tritan)', () {
      final IptColor yellow = IptColor.fromInt(0xFFFFFF00);
      expect(yellow.t, greaterThan(0));
      print('✓ Yellow T: ${yellow.t} > 0');
    });
  });

  group('IptColor Chroma and Hue', () {
    test('Chroma is sqrt(p^2 + t^2)', () {
      final IptColor color = IptColor.fromInt(0xFFFF0000);
      final double expectedChroma = sqrt(color.p * color.p + color.t * color.t);
      expect(color.chroma, closeTo(expectedChroma, 0.001));
      print('✓ Chroma: ${color.chroma}');
    });

    test('Hue is computed correctly', () {
      final IptColor color = IptColor.fromInt(0xFFFF0000);
      expect(color.hue, greaterThanOrEqualTo(0));
      expect(color.hue, lessThan(360));
      print('✓ Red hue: ${color.hue}');
    });
  });

  group('IptColor Conversions', () {
    test('toColor returns valid ColorIQ', () {
      const IptColor ipt = IptColor(0.5, 0.1, 0.1);
      final ColorIQ color = ipt.toColor();
      expect(color.value, isA<int>());
      print('✓ toColor returns ColorIQ: ${color.hexStr}');
    });

    test('ColorIQ.ipt getter works', () {
      final ColorIQ color = ColorIQ(0xFFFF6B6B);
      final IptColor ipt = color.ipt;
      expect(ipt.i, greaterThan(0));
      print('✓ ColorIQ.ipt getter: i=${ipt.i}');
    });

    test('Round-trip ColorIQ -> IPT -> ColorIQ', () {
      final ColorIQ original = ColorIQ(0xFF4080C0);
      final IptColor ipt = original.ipt;
      final ColorIQ roundTrip = ipt.toColor();

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
  });

  group('IptColor Manipulations', () {
    test('lighten increases intensity', () {
      final IptColor ipt = IptColor.fromInt(0xFF808080);
      final IptColor lightened = ipt.lighten(20);
      expect(lightened.i, greaterThan(ipt.i));
      print('✓ lighten: i=${ipt.i} -> ${lightened.i}');
    });

    test('darken decreases intensity', () {
      final IptColor ipt = IptColor.fromInt(0xFF808080);
      final IptColor darkened = ipt.darken(20);
      expect(darkened.i, lessThan(ipt.i));
      print('✓ darken: i=${ipt.i} -> ${darkened.i}');
    });

    test('adjustHue rotates in PT plane', () {
      final IptColor ipt = IptColor.fromInt(0xFFFF0000);
      final IptColor adjusted = ipt.adjustHue(90);
      expect(adjusted.hue, closeTo((ipt.hue + 90) % 360, 1.0));
      print('✓ adjustHue: ${ipt.hue} + 90 -> ${adjusted.hue}');
    });

    test('lerp interpolates correctly', () {
      final IptColor black = IptColor.fromInt(0xFF000000);
      final IptColor white = IptColor.fromInt(0xFFFFFFFF);
      final IptColor mid = black.lerp(white, 0.5);

      expect(mid.i, closeTo((black.i + white.i) / 2, 0.05));
      print('✓ lerp: i ${black.i} -> ${mid.i} -> ${white.i}');
    });

    test('copyWith creates modified copy', () {
      const IptColor original = IptColor(0.5, 0.1, -0.1);
      final IptColor modified = original.copyWith(i: 0.8);

      expect(modified.i, equals(0.8));
      expect(modified.p, equals(original.p));
      expect(modified.t, equals(original.t));
      print('✓ copyWith: i=${original.i} -> ${modified.i}');
    });
  });

  group('IptColor Palette Generation', () {
    test('monochromatic returns 5 colors', () {
      final IptColor ipt = IptColor.fromInt(0xFF4080C0);
      final List<IptColor> palette = ipt.monochromatic;
      expect(palette.length, equals(5));
      print('✓ monochromatic palette has 5 colors');
    });

    test('analogous returns correct count', () {
      final IptColor ipt = IptColor.fromInt(0xFFFF0000);
      final List<IptColor> palette = ipt.analogous(count: 5);
      expect(palette.length, equals(5));
      print('✓ analogous palette has 5 colors');
    });
  });
}
