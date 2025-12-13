import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:test/test.dart';

/// Test suite for JAB (J'a'b') color space
///
/// JAB is a perceptually uniform color space derived from CAM16-UCS using
/// rectangular coordinates. It's similar to CIE Lab but based on CAM16.
void main() {
  group('JabColor Basic Tests', () {
    test('Create JabColor from values', () {
      const JabColor jab = JabColor(50, 10, -5);
      expect(jab.j, equals(50));
      expect(jab.aJab, equals(10));
      expect(jab.bJab, equals(-5));
      print('✓ JabColor created with j=${jab.j}, a=${jab.aJab}, b=${jab.bJab}');
    });

    test('Create JabColor from ARGB int', () {
      final JabColor jabRed = JabColor.fromInt(0xFFFF0000);
      expect(jabRed.j, greaterThan(0));
      expect(jabRed.value, equals(0xFFFF0000));
      print(
          '✓ Red JabColor: j=${jabRed.j}, a=${jabRed.aJab}, b=${jabRed.bJab}');
    });

    test('JabColor value property returns ARGB', () {
      const JabColor jab = JabColor(50, 0, 0);
      expect(jab.value, isA<int>());
      expect((jab.value >> 24) & 0xFF, equals(255)); // Full alpha
      print(
          '✓ JabColor.value returns valid ARGB: ${jab.value.toRadixString(16)}');
    });
  });

  group('JabColor CAM16 Consistency Tests', () {
    test('JabColor values match CAM16 jstar/astar/bstar', () {
      const int testColor = 0xFFFF6B6B;
      final JabColor jab = JabColor.fromInt(testColor);
      final Cam16 cam16 = Cam16.fromInt(testColor);

      expect(jab.j, closeTo(cam16.jstar, 0.001));
      expect(jab.aJab, closeTo(cam16.astar, 0.001));
      expect(jab.bJab, closeTo(cam16.bstar, 0.001));
      print('✓ JAB matches CAM16: j=${jab.j}, jstar=${cam16.jstar}');
    });

    test('Multiple colors match CAM16', () {
      final List<int> colors = <int>[
        0xFFFF0000, // Red
        0xFF00FF00, // Green
        0xFF0000FF, // Blue
        0xFFFFFF00, // Yellow
        0xFF808080, // Gray
      ];

      for (final int color in colors) {
        final JabColor jab = JabColor.fromInt(color);
        final Cam16 cam16 = Cam16.fromInt(color);

        expect(jab.j, closeTo(cam16.jstar, 0.001),
            reason: 'Color ${color.toRadixString(16)} j mismatch');
        expect(jab.aJab, closeTo(cam16.astar, 0.001),
            reason: 'Color ${color.toRadixString(16)} a mismatch');
        expect(jab.bJab, closeTo(cam16.bstar, 0.001),
            reason: 'Color ${color.toRadixString(16)} b mismatch');
      }
      print('✓ All colors match CAM16 jstar/astar/bstar');
    });
  });

  group('JabColor Conversions', () {
    test('toJch converts to cylindrical', () {
      final JabColor jab = JabColor.fromInt(0xFFFF0000);
      final JchColor jch = jab.toJch();

      expect(jch.j, closeTo(jab.j, 0.001));
      // Chroma should be sqrt(a^2 + b^2)
      final double expectedChroma =
          sqrt(jab.aJab * jab.aJab + jab.bJab * jab.bJab);
      expect(jch.c, closeTo(expectedChroma, 0.001));
      print('✓ JAB to JCH conversion: j=${jch.j}, c=${jch.c}, h=${jch.h}');
    });

    test('toColor returns valid ColorIQ', () {
      const JabColor jab = JabColor(50, 10, 5);
      final ColorIQ color = jab.toColor();
      expect(color.value, isA<int>());
      expect((color.value >> 24) & 0xFF, equals(255));
      print('✓ toColor returns valid ColorIQ: ${color.hexStr}');
    });

    test('ColorIQ.jab getter works', () {
      final ColorIQ color = ColorIQ(0xFFFF6B6B);
      final JabColor jab = color.jab;
      expect(jab.j, greaterThan(0));
      expect(jab.value, equals(color.value));
      print('✓ ColorIQ.jab getter: j=${jab.j}, a=${jab.aJab}, b=${jab.bJab}');
    });
  });

  group('JabColor Manipulations', () {
    test('lighten increases J', () {
      final JabColor jab = JabColor.fromInt(0xFF808080);
      final JabColor lightened = jab.lighten(20);
      expect(lightened.j, greaterThan(jab.j));
      print('✓ lighten: ${jab.j} -> ${lightened.j}');
    });

    test('darken decreases J', () {
      final JabColor jab = JabColor.fromInt(0xFF808080);
      final JabColor darkened = jab.darken(20);
      expect(darkened.j, lessThan(jab.j));
      print('✓ darken: ${jab.j} -> ${darkened.j}');
    });

    test('saturate increases chroma via JCH', () {
      final JabColor jab = JabColor.fromInt(0xFF996666);
      final JabColor saturated = jab.saturate(20);
      final double originalChroma =
          sqrt(jab.aJab * jab.aJab + jab.bJab * jab.bJab);
      final double newChroma = sqrt(
          saturated.aJab * saturated.aJab + saturated.bJab * saturated.bJab);
      expect(newChroma, greaterThan(originalChroma));
      print('✓ saturate: chroma $originalChroma -> $newChroma');
    });

    test('lerp interpolates correctly', () {
      final JabColor start = JabColor.fromInt(0xFF000000);
      final JabColor end = JabColor.fromInt(0xFFFFFFFF);
      final JabColor mid = start.lerp(end, 0.5);

      expect(mid.j, closeTo((start.j + end.j) / 2, 1.0));
      print('✓ lerp: ${start.j} -> ${mid.j} -> ${end.j}');
    });

    test('copyWith creates modified copy', () {
      const JabColor original = JabColor(50, 10, -5);
      final JabColor modified = original.copyWith(j: 70);

      expect(modified.j, equals(70));
      expect(modified.aJab, equals(original.aJab));
      expect(modified.bJab, equals(original.bJab));
      print('✓ copyWith: j=${original.j} -> ${modified.j}');
    });
  });

  group('JabColor Color Properties', () {
    test('White has high J', () {
      final JabColor white = JabColor.fromInt(0xFFFFFFFF);
      expect(white.j, greaterThan(90));
      print('✓ White J: ${white.j}');
    });

    test('Black has low J', () {
      final JabColor black = JabColor.fromInt(0xFF000000);
      expect(black.j, lessThan(10));
      print('✓ Black J: ${black.j}');
    });

    test('Gray has low a and b', () {
      final JabColor gray = JabColor.fromInt(0xFF808080);
      expect(gray.aJab.abs(), lessThan(5));
      expect(gray.bJab.abs(), lessThan(5));
      print('✓ Gray a=${gray.aJab}, b=${gray.bJab}');
    });
  });

  group('JabColor Palette Generation', () {
    test('monochromatic returns 5 colors', () {
      final JabColor jab = JabColor.fromInt(0xFF4080C0);
      final List<JabColor> palette = jab.monochromatic;
      expect(palette.length, equals(5));
      print('✓ monochromatic palette has 5 colors');
    });

    test('generateBasicPalette returns 5 colors', () {
      final JabColor jab = JabColor.fromInt(0xFF4080C0);
      final List<JabColor> palette = jab.generateBasicPalette();
      expect(palette.length, equals(5));
      print('✓ generateBasicPalette has 5 colors');
    });

    test('analogous returns correct count', () {
      final JabColor jab = JabColor.fromInt(0xFF4080C0);
      final List<JabColor> palette = jab.analogous(count: 5);
      expect(palette.length, equals(5));
      print('✓ analogous palette has 5 colors');
    });
  });
}
