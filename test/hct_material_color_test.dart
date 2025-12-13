import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('MaterialShade', () {
    test('primaryShades returns 10 shades', () {
      expect(MaterialShade.primaryShades.length, equals(10));
    });

    test('accentShades returns 4 shades', () {
      expect(MaterialShade.accentShades.length, equals(4));
    });

    test('shades are sortable', () {
      final List<MaterialShade> sorted = MaterialShade.values.toList()..sort();

      // Primary shades should come first
      expect(sorted.first, equals(MaterialShade.s50));
      expect(sorted.last, equals(MaterialShade.a700));

      // Verify order within primaries
      final int s500Index = sorted.indexOf(MaterialShade.s500);
      final int s900Index = sorted.indexOf(MaterialShade.s900);
      expect(s500Index, lessThan(s900Index));
    });

    test('displayName formats correctly', () {
      expect(MaterialShade.s500.displayName, equals('500'));
      expect(MaterialShade.a200.displayName, equals('A200'));
    });

    test('isAccent correctly identifies accent shades', () {
      expect(MaterialShade.s500.isAccent, isFalse);
      expect(MaterialShade.a200.isAccent, isTrue);
    });
  });

  group('HctMaterialColor', () {
    test('creates from ColorIQ', () {
      final ColorIQ blue = ColorIQ(0xFF2196F3);
      final HctMaterialColor palette = HctMaterialColor.fromColor(blue);

      expect(palette.hue, greaterThan(0));
      expect(palette.chroma, greaterThan(0));
      print('✓ Blue palette: hue=${palette.hue.toStringAsFixed(1)}, '
          'chroma=${palette.chroma.toStringAsFixed(1)}');
    });

    test('creates from ARGB int', () {
      final HctMaterialColor palette =
          HctMaterialColor.fromInt(0xFFE91E63); // Pink
      expect(palette.hue, greaterThan(0));
      print('✓ Pink palette: hue=${palette.hue.toStringAsFixed(1)}');
    });

    test('generates all shades', () {
      final HctMaterialColor palette =
          HctMaterialColor.fromInt(0xFF4CAF50); // Green
      final Map<MaterialShade, ColorIQ> shades = palette.toSortedMap();

      expect(shades.length, equals(14)); // 10 primary + 4 accent
      print('✓ Generated ${shades.length} shades');
    });

    test('shades have correct ordering by tone', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF2196F3);

      // Lighter shades should have higher luminance
      final double lum50 = palette[MaterialShade.s50].luminance;
      final double lum500 = palette[MaterialShade.s500].luminance;
      final double lum900 = palette[MaterialShade.s900].luminance;

      expect(lum50, greaterThan(lum500));
      expect(lum500, greaterThan(lum900));
      print('✓ Luminance: s50=${lum50.toStringAsFixed(2)}, '
          's500=${lum500.toStringAsFixed(2)}, s900=${lum900.toStringAsFixed(2)}');
    });

    test('accent shades have higher chroma', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF9C27B0);

      // A200 should be more saturated than s500 at similar tone
      final ColorIQ s400 = palette[MaterialShade.s400];
      final ColorIQ a400 = palette[MaterialShade.a400];

      // Compare via HCT chroma
      final double s400Chroma = s400.toHctColor().chroma;
      final double a400Chroma = a400.toHctColor().chroma;

      expect(a400Chroma, greaterThanOrEqualTo(s400Chroma));
      print('✓ Chroma: s400=${s400Chroma.toStringAsFixed(1)}, '
          'a400=${a400Chroma.toStringAsFixed(1)}');
    });

    test('primary and accent getters work', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFFFF5722);

      expect(palette.primary.value, isA<int>());
      expect(palette.accent.value, isA<int>());
      expect(palette.lightest.value, isA<int>());
      expect(palette.darkest.value, isA<int>());

      print('✓ Primary: ${palette.primary.hexStr}');
      print('✓ Accent: ${palette.accent.hexStr}');
    });

    test('primaryShades returns only non-accent shades', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF3F51B5);
      final Map<MaterialShade, ColorIQ> primaries = palette.primaryShades;

      expect(primaries.length, equals(10));
      for (final MaterialShade shade in primaries.keys) {
        expect(shade.isAccent, isFalse);
      }
    });

    test('accentShades returns only accent shades', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF3F51B5);
      final Map<MaterialShade, ColorIQ> accents = palette.accentShades;

      expect(accents.length, equals(4));
      for (final MaterialShade shade in accents.keys) {
        expect(shade.isAccent, isTrue);
      }
    });

    test('closestShade finds correct shade', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF2196F3);

      // Tone 60 should match s500. Tone 95 should match s100
      expect(palette.closestShade(60), equals(MaterialShade.s500));
      expect(palette.closestShade(95), equals(MaterialShade.s100));
      expect(palette.closestShade(20), equals(MaterialShade.s900));
    });

    test('withChroma creates new palette', () {
      final HctMaterialColor original = HctMaterialColor.fromInt(0xFF2196F3);
      final HctMaterialColor modified = original.withChroma(80);

      expect(modified.hue, equals(original.hue));
      expect(modified.chroma, equals(80));
    });

    test('adjustHue shifts correctly', () {
      final HctMaterialColor palette = HctMaterialColor(hue: 100, chroma: 50);
      final HctMaterialColor shifted = palette.adjustHue(60);

      expect(shifted.hue, closeTo(160, 0.1));
    });

    test('complementary creates 180° shift', () {
      final HctMaterialColor palette = HctMaterialColor(hue: 100, chroma: 50);
      final HctMaterialColor comp = palette.complementary;

      expect(comp.hue, closeTo(280, 0.1));
    });

    test('analogous creates correct count', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF2196F3);
      final List<HctMaterialColor> analogous = palette.analogous(count: 5);

      expect(analogous.length, equals(5));
    });

    test('triadic creates 3 palettes', () {
      final HctMaterialColor palette = HctMaterialColor.fromInt(0xFF2196F3);
      final List<HctMaterialColor> triadic = palette.triadic;

      expect(triadic.length, equals(3));
    });
  });
}
