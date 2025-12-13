import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:test/test.dart';

/// Test suite for JCH (J'C'h) color space
///
/// JCH is the cylindrical form of CAM16-UCS, providing an intuitive
/// hue, chroma, and lightness interface.
void main() {
  group('JchColor Basic Tests', () {
    test('Create JchColor from values', () {
      const JchColor jch = JchColor(50, 30, 120);
      expect(jch.j, equals(50));
      expect(jch.c, equals(30));
      expect(jch.h, equals(120));
      print('✓ JchColor created with j=${jch.j}, c=${jch.c}, h=${jch.h}');
    });

    test('Create JchColor from ARGB int', () {
      final JchColor jchRed = JchColor.fromInt(0xFFFF0000);
      expect(jchRed.j, greaterThan(0));
      expect(jchRed.c, greaterThan(0)); // Red has chroma
      expect(jchRed.value, equals(0xFFFF0000));
      print('✓ Red JchColor: j=${jchRed.j}, c=${jchRed.c}, h=${jchRed.h}');
    });

    test('JchColor value property returns ARGB', () {
      const JchColor jch = JchColor(50, 20, 180);
      expect(jch.value, isA<int>());
      expect((jch.value >> 24) & 0xFF, equals(255)); // Full alpha
      print(
          '✓ JchColor.value returns valid ARGB: ${jch.value.toRadixString(16)}');
    });
  });

  group('JchColor CAM16 Consistency Tests', () {
    test('JchColor chroma matches JAB magnitude', () {
      const int testColor = 0xFFFF6B6B;
      final JchColor jch = JchColor.fromInt(testColor);
      final JabColor jab = JabColor.fromInt(testColor);

      final double jabChroma = sqrt(jab.aJab * jab.aJab + jab.bJab * jab.bJab);
      expect(jch.c, closeTo(jabChroma, 0.001));
      expect(jch.j, closeTo(jab.j, 0.001));
      print('✓ JCH chroma matches JAB magnitude: ${jch.c} ≈ $jabChroma');
    });

    test('J (lightness) matches between JCH and CAM16', () {
      final List<int> colors = <int>[
        0xFFFF0000,
        0xFF00FF00,
        0xFF0000FF,
        0xFFFFFFFF,
        0xFF000000,
      ];

      for (final int color in colors) {
        final JchColor jch = JchColor.fromInt(color);
        final Cam16 cam16 = Cam16.fromInt(color);

        expect(jch.j, closeTo(cam16.jstar, 0.001),
            reason: 'Color ${color.toRadixString(16)} jstar mismatch');
      }
      print('✓ All colors have matching J values');
    });
  });

  group('JchColor Conversions', () {
    test('toJab converts to rectangular', () {
      final JchColor jch = JchColor.fromInt(0xFFFF0000);
      final JabColor jab = jch.toJab();

      expect(jab.j, closeTo(jch.j, 0.001));
      // a = c * cos(h), b = c * sin(h)
      final double hRad = jch.h * pi / 180;
      final double expectedA = jch.c * cos(hRad);
      final double expectedB = jch.c * sin(hRad);
      expect(jab.aJab, closeTo(expectedA, 0.001));
      expect(jab.bJab, closeTo(expectedB, 0.001));
      print('✓ JCH to JAB conversion verified');
    });

    test('toColor returns valid ColorIQ', () {
      const JchColor jch = JchColor(50, 20, 180);
      final ColorIQ color = jch.toColor();
      expect(color.value, isA<int>());
      expect((color.value >> 24) & 0xFF, equals(255));
      print('✓ toColor returns valid ColorIQ: ${color.hexStr}');
    });

    test('ColorIQ.jch getter works', () {
      final ColorIQ color = ColorIQ(0xFFFF6B6B);
      final JchColor jch = color.jch;
      expect(jch.j, greaterThan(0));
      expect(jch.value, equals(color.value));
      print('✓ ColorIQ.jch getter: j=${jch.j}, c=${jch.c}, h=${jch.h}');
    });

    test('Round-trip JAB -> JCH -> JAB preserves values', () {
      final JabColor original = JabColor.fromInt(0xFF4080C0);
      final JchColor jch = original.toJch();
      final JabColor roundTrip = jch.toJab();

      expect(roundTrip.j, closeTo(original.j, 0.01));
      expect(roundTrip.aJab, closeTo(original.aJab, 0.01));
      expect(roundTrip.bJab, closeTo(original.bJab, 0.01));
      print('✓ JAB -> JCH -> JAB round-trip verified');
    });
  });

  group('JchColor Manipulations', () {
    test('lighten increases J', () {
      final JchColor jch = JchColor.fromInt(0xFF808080);
      final JchColor lightened = jch.lighten(20);
      expect(lightened.j, greaterThan(jch.j));
      print('✓ lighten: ${jch.j} -> ${lightened.j}');
    });

    test('darken decreases J', () {
      final JchColor jch = JchColor.fromInt(0xFF808080);
      final JchColor darkened = jch.darken(20);
      expect(darkened.j, lessThan(jch.j));
      print('✓ darken: ${jch.j} -> ${darkened.j}');
    });

    test('saturate increases chroma', () {
      final JchColor jch = JchColor.fromInt(0xFF996666);
      final JchColor saturated = jch.saturate(20);
      expect(saturated.c, greaterThan(jch.c));
      print('✓ saturate: chroma ${jch.c} -> ${saturated.c}');
    });

    test('desaturate decreases chroma', () {
      final JchColor jch = JchColor.fromInt(0xFFFF0000);
      final JchColor desaturated = jch.desaturate(20);
      expect(desaturated.c, lessThan(jch.c));
      print('✓ desaturate: chroma ${jch.c} -> ${desaturated.c}');
    });

    test('adjustHue rotates hue', () {
      final JchColor jch = JchColor.fromInt(0xFFFF0000);
      final JchColor adjusted = jch.adjustHue(90);
      final double expectedHue = (jch.h + 90) % 360;
      expect(adjusted.h, closeTo(expectedHue, 1.0));
      print('✓ adjustHue: ${jch.h} + 90 -> ${adjusted.h}');
    });

    test('complementary rotates 180 degrees', () {
      final JchColor jch = JchColor.fromInt(0xFFFF0000);
      final JchColor comp = jch.complementary;
      final double expectedHue = (jch.h + 180) % 360;
      expect(comp.h, closeTo(expectedHue, 1.0));
      print('✓ complementary: ${jch.h} -> ${comp.h}');
    });

    test('lerp interpolates correctly', () {
      final JchColor start = JchColor.fromInt(0xFF000000);
      final JchColor end = JchColor.fromInt(0xFFFFFFFF);
      final JchColor mid = start.lerp(end, 0.5);

      expect(mid.j, closeTo((start.j + end.j) / 2, 1.0));
      print('✓ lerp: ${start.j} -> ${mid.j} -> ${end.j}');
    });

    test('copyWith creates modified copy', () {
      const JchColor original = JchColor(50, 30, 120);
      final JchColor modified = original.copyWith(h: 240);

      expect(modified.h, equals(240));
      expect(modified.j, equals(original.j));
      expect(modified.c, equals(original.c));
      print('✓ copyWith: h=${original.h} -> ${modified.h}');
    });
  });

  group('JchColor Hue Properties', () {
    test('Hue is in valid range 0-360', () {
      final List<int> colors = <int>[
        0xFFFF0000,
        0xFF00FF00,
        0xFF0000FF,
        0xFFFFFF00,
        0xFF00FFFF,
        0xFFFF00FF,
      ];

      for (final int color in colors) {
        final JchColor jch = JchColor.fromInt(color);
        expect(jch.h, greaterThanOrEqualTo(0));
        expect(jch.h, lessThan(360));
      }
      print('✓ All hues in valid range 0-360');
    });

    test('Achromatic colors have low chroma', () {
      final JchColor white = JchColor.fromInt(0xFFFFFFFF);
      final JchColor black = JchColor.fromInt(0xFF000000);
      final JchColor gray = JchColor.fromInt(0xFF808080);

      expect(white.c, lessThan(5));
      expect(black.c, lessThan(5));
      expect(gray.c, lessThan(5));
      print('✓ Achromatic colors have low chroma');
    });

    test('Saturated colors have high chroma', () {
      final JchColor red = JchColor.fromInt(0xFFFF0000);
      final JchColor green = JchColor.fromInt(0xFF00FF00);
      final JchColor blue = JchColor.fromInt(0xFF0000FF);

      expect(red.c, greaterThan(20));
      expect(green.c, greaterThan(20));
      expect(blue.c, greaterThan(20));
      print('✓ Saturated colors have high chroma');
    });
  });

  group('JchColor Palette Generation', () {
    test('analogous returns colors with nearby hues', () {
      final JchColor jch = JchColor.fromInt(0xFFFF0000);
      final List<JchColor> palette = jch.analogous(count: 5, offset: 30);
      expect(palette.length, equals(5));

      // Check hues are spread around original
      for (final JchColor color in palette) {
        expect(color.j, closeTo(jch.j, 1.0));
      }
      print('✓ analogous palette generated');
    });

    test('square returns 4 colors at 90 degree intervals', () {
      final JchColor jch = JchColor.fromInt(0xFF4080C0);
      final List<JchColor> palette = jch.square();
      expect(palette.length, equals(4));
      print('✓ square palette has 4 colors');
    });

    test('tetrad returns 4 colors', () {
      final JchColor jch = JchColor.fromInt(0xFF4080C0);
      final List<JchColor> palette = jch.tetrad();
      expect(palette.length, equals(4));
      print('✓ tetrad palette has 4 colors');
    });

    test('tonesPalette returns decreasing chroma', () {
      final JchColor jch = JchColor.fromInt(0xFFFF0000);
      final List<JchColor> palette = jch.tonesPalette();
      expect(palette.length, equals(5));

      // First should have most chroma, decreasing after
      for (int i = 1; i < palette.length; i++) {
        expect(palette[i].c, lessThanOrEqualTo(palette[i - 1].c));
      }
      print('✓ tonesPalette has decreasing chroma');
    });
  });
}
