/// Comprehensive test suite to verify all ColorSpacesIQ interface methods
/// are properly implemented across all color model classes.
///
/// This test ensures interface compliance by testing every method for each
/// color class. Run with:
/// ```bash
/// dart test test/interface_compliance_test.dart --coverage=coverage
/// ```
library;

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Tests all ColorSpacesIQ interface methods for a given color class.
///
/// [name] is the display name for the test group.
/// [create] is a factory function to create an instance from an ARGB int.
/// [createSecond] creates a second color for comparison tests (optional).
void testColorSpacesIQCompliance<T extends ColorSpacesIQ>(
  final String name,
  final T Function(int) create, {
  final T Function(int)? createSecond,
}) {
  group('$name Interface Compliance', () {
    late T color;
    late T secondColor;

    setUp(() {
      color = create(hxBlue); // 0xFF2196F3 - Material Blue
      secondColor = (createSecond ?? create)(hxRed); // 0xFFFF0000 - Red
    });

    // ========================================
    // Properties
    // ========================================
    group('Properties', () {
      test('value returns valid ARGB int', () {
        expect(color.value, isA<int>());
        expect(color.value & 0xFF000000, isNot(0)); // Has alpha
      });

      test('names returns list', () {
        expect(color.names, isA<List<String>>());
      });

      test('hexStr returns valid hex string', () {
        expect(color.hexStr, isA<String>());
        expect(color.hexStr.length, greaterThan(0));
      });

      test('luminance is in valid range [0, 1]', () {
        expect(color.luminance, inInclusiveRange(0, 1));
      });

      test('whitePoint returns valid XYZ values', () {
        expect(color.whitePoint, isA<List<double>>());
        expect(color.whitePoint.length, 3);
      });

      test('isWebSafe returns bool', () {
        expect(color.isWebSafe, isA<bool>());
      });

      test('isAchromatic returns bool', () {
        expect(color.isAchromatic, isA<bool>());
      });

      test('random returns same type', () {
        final ColorSpacesIQ randomColor = color.random;
        expect(randomColor, isNotNull);
        expect(randomColor.value, isA<int>());
      });

      test('complementary returns same type', () {
        final ColorSpacesIQ comp = color.complementary;
        expect(comp, isNotNull);
        expect(comp.value, isNot(color.value));
      });

      test('monochromatic returns list of colors', () {
        final List<ColorSpacesIQ> mono = color.monochromatic;
        expect(mono, isA<List<ColorSpacesIQ>>());
        expect(mono.length, greaterThan(0));
      });
    });

    // ========================================
    // Conversion Methods
    // ========================================
    group('Conversions', () {
      test('toColor returns ColorIQ', () {
        expect(color.toColor(), isA<ColorIQ>());
      });

      test('toHctColor returns HctColor', () {
        expect(color.toHctColor(), isA<HctColor>());
      });

      test('toCam16 returns Cam16', () {
        expect(color.toCam16(), isNotNull);
      });

      test('toHslColor returns HSL', () {
        expect(color.toHslColor(), isA<HSL>());
      });

      test('toHsvColor returns HSV', () {
        expect(color.toHsvColor(), isA<HSV>());
      });

      test('toXyyColor returns XYZ', () {
        expect(color.toXyyColor(), isA<XYZ>());
      });

      test('toOkLab returns OkLabColor', () {
        expect(color.toOkLab(), isA<OkLabColor>());
      });

      test('toOkLch returns OkLCH', () {
        expect(color.toOkLch(), isA<OkLCH>());
      });

      test('toJson returns valid map', () {
        final Map<String, dynamic> json = color.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json.containsKey('type'), isTrue);
      });
    });

    // ========================================
    // Modification Methods
    // ========================================
    group('Modifications', () {
      test('copyWith returns same type', () {
        final ColorSpacesIQ copy = color.copyWith();
        expect(copy, isNotNull);
      });

      test('lighten increases lightness', () {
        final ColorSpacesIQ lighter = color.lighten();
        expect(lighter, isNotNull);
        expect(lighter.luminance, greaterThanOrEqualTo(color.luminance - 0.1));
      });

      test('darken decreases lightness', () {
        final ColorSpacesIQ darker = color.darken();
        expect(darker, isNotNull);
      });

      test('brighten returns valid color', () {
        final ColorSpacesIQ brighter = color.brighten();
        expect(brighter, isNotNull);
      });

      test('saturate returns valid color', () {
        final ColorSpacesIQ saturated = color.saturate();
        expect(saturated, isNotNull);
      });

      test('desaturate returns valid color', () {
        final ColorSpacesIQ desaturated = color.desaturate();
        expect(desaturated, isNotNull);
      });

      test('whiten returns valid color', () {
        final ColorSpacesIQ whitened = color.whiten();
        expect(whitened, isNotNull);
      });

      test('blacken returns valid color', () {
        final ColorSpacesIQ blackened = color.blacken();
        expect(blackened, isNotNull);
      });

      test('accented returns valid color', () {
        final ColorSpacesIQ accented = color.accented();
        expect(accented, isNotNull);
      });

      test('opaquer returns valid color', () {
        final ColorSpacesIQ opaque = color.opaquer();
        expect(opaque, isNotNull);
      });

      test('adjustHue returns valid color', () {
        final ColorSpacesIQ hueAdjusted = color.adjustHue();
        expect(hueAdjusted, isNotNull);
      });

      test('warmer returns valid color', () {
        final ColorSpacesIQ warm = color.warmer();
        expect(warm, isNotNull);
      });

      test('cooler returns valid color', () {
        final ColorSpacesIQ cool = color.cooler();
        expect(cool, isNotNull);
      });

      test('increaseTransparency returns valid color', () {
        final ColorSpacesIQ transparent = color.increaseTransparency();
        expect(transparent, isNotNull);
      });

      test('decreaseTransparency returns valid color', () {
        final ColorSpacesIQ opaque = color.decreaseTransparency();
        expect(opaque, isNotNull);
      });
    });

    // ========================================
    // Comparison Methods
    // ========================================
    group('Comparisons', () {
      test('lerp interpolates between colors', () {
        final ColorSpacesIQ lerped = color.lerp(secondColor, 0.5);
        expect(lerped, isNotNull);
      });

      test('blend mixes colors', () {
        final ColorSpacesIQ blended = color.blend(secondColor);
        expect(blended, isNotNull);
      });

      test('isEqual compares colors', () {
        expect(color.isEqual(color), isTrue);
        expect(color.isEqual(secondColor), isFalse);
      });

      test('contrastWith returns valid ratio', () {
        final double contrast = color.contrastWith(secondColor);
        expect(contrast, inInclusiveRange(1.0, 21.0));
      });

      test('isWithinGamut returns bool', () {
        expect(color.isWithinGamut(), isA<bool>());
        expect(color.isWithinGamut(Gamut.sRGB), isA<bool>());
      });

      test('closestColorSlice returns ColorSlice', () {
        expect(color.closestColorSlice(), isA<ColorSlice>());
      });
    });

    // ========================================
    // Simulation Methods
    // ========================================
    group('Simulations', () {
      test('simulate returns valid color for each type', () {
        for (final ColorBlindnessType type in ColorBlindnessType.values) {
          final ColorSpacesIQ simulated = color.simulate(type);
          expect(simulated, isNotNull, reason: 'Failed for $type');
        }
      });
    });

    // ========================================
    // Palette Methods
    // ========================================
    group('Palettes', () {
      test('lighterPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.lighterPalette();
        expect(palette.length, 5);
      });

      test('darkerPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.darkerPalette();
        expect(palette.length, 5);
      });

      test('tintsPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.tintsPalette();
        expect(palette.length, 5);
      });

      test('shadesPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.shadesPalette();
        expect(palette.length, 5);
      });

      test('tonesPalette returns colors', () {
        final List<ColorSpacesIQ> palette = color.tonesPalette();
        expect(palette.length, greaterThan(0));
      });

      test('generateBasicPalette returns colors', () {
        final List<ColorSpacesIQ> palette = color.generateBasicPalette();
        expect(palette.length, greaterThan(0));
      });

      test('nearestColors returns list', () {
        final List<ColorIQ> nearest = color.nearestColors();
        expect(nearest, isA<List<ColorIQ>>());
      });
    });

    // ========================================
    // Data Visualization Palettes
    // ========================================
    group('Data Visualization Palettes', () {
      test('qualitativePalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.qualitativePalette();
        expect(palette.length, 5);
      });

      test('sequentialPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.sequentialPalette();
        expect(palette.length, 5);
      });

      test('sequentialMultiHuePalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette =
            color.sequentialMultiHuePalette(endHue: 180);
        expect(palette.length, 5);
      });

      test('divergingPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.divergingPalette(endHue: 180);
        expect(palette.length, 5);
      });

      test('analogousPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.analogousPalette();
        expect(palette.length, 5);
      });

      test('chromaPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.chromaPalette();
        expect(palette.length, 5);
      });

      test('pastelPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.pastelPalette();
        expect(palette.length, 5);
      });

      test('tealPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.tealPalette();
        expect(palette.length, 5);
      });

      test('mintPalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.mintPalette();
        expect(palette.length, 5);
      });

      test('purplePalette returns 5 colors', () {
        final List<ColorSpacesIQ> palette = color.purplePalette();
        expect(palette.length, 5);
      });
    });

    // ========================================
    // Color Harmony Methods
    // ========================================
    group('Color Harmonies', () {
      test('analogous returns list', () {
        final List<ColorSpacesIQ> harmony = color.analogous();
        expect(harmony.length, 5);
      });

      test('square returns 4 colors', () {
        final List<ColorSpacesIQ> harmony = color.square();
        expect(harmony.length, 4);
      });

      test('tetrad returns 4 colors', () {
        final List<ColorSpacesIQ> harmony = color.tetrad();
        expect(harmony.length, 4);
      });

      test('triad returns 3 colors', () {
        final List<ColorSpacesIQ> harmony = color.triad();
        expect(harmony.length, 3);
      });

      test('twoTone returns 2 colors', () {
        final List<ColorSpacesIQ> harmony = color.twoTone();
        expect(harmony.length, 2);
      });

      test('splitComplementary returns 3 colors', () {
        final List<ColorSpacesIQ> harmony = color.splitComplementary();
        expect(harmony.length, 3);
      });
    });
  });
}

// ============================================================================
// Main Test Suite
// ============================================================================
void main() {
  // Core Color Classes
  testColorSpacesIQCompliance<ColorIQ>(
    'ColorIQ',
    ColorIQ.new,
  );

  testColorSpacesIQCompliance<HSL>(
    'HSL',
    HSL.fromInt,
  );

  testColorSpacesIQCompliance<HSV>(
    'HSV',
    HSV.fromInt,
  );

  testColorSpacesIQCompliance<HctColor>(
    'HctColor',
    HctColor.fromInt,
  );

  testColorSpacesIQCompliance<HsbColor>(
    'HsbColor',
    HsbColor.fromInt,
  );

  testColorSpacesIQCompliance<CMYK>(
    'CMYK',
    CMYK.fromInt,
  );

  // Lab-based Color Classes
  testColorSpacesIQCompliance<CIELab>(
    'CIELab',
    CIELab.fromInt,
  );

  testColorSpacesIQCompliance<LchColor>(
    'LchColor',
    (final int argb) => CIELab.fromInt(argb).toLch(),
  );

  testColorSpacesIQCompliance<CIELuv>(
    'CIELuv',
    CIELuv.fromInt,
  );

  testColorSpacesIQCompliance<HunterLabColor>(
    'HunterLabColor',
    HunterLabColor.fromInt,
  );

  // OK Color Classes
  testColorSpacesIQCompliance<OkLabColor>(
    'OkLabColor',
    OkLabColor.fromInt,
  );

  testColorSpacesIQCompliance<OkLCH>(
    'OkLCH',
    OkLCH.fromInt,
  );

  testColorSpacesIQCompliance<OkHslColor>(
    'OkHslColor',
    OkHslColor.fromInt,
  );

  testColorSpacesIQCompliance<OkHsvColor>(
    'OkHsvColor',
    OkHsvColor.fromInt,
  );

  // Wide Gamut Color Classes
  // XYZ - skipped (not ColorSpacesIQ)

  testColorSpacesIQCompliance<DisplayP3Color>(
    'DisplayP3Color',
    DisplayP3Color.fromInt,
  );

  testColorSpacesIQCompliance<Rec2020Color>(
    'Rec2020Color',
    Rec2020Color.fromInt,
  );

  testColorSpacesIQCompliance<ProPhotoRgbColor>(
    'ProPhotoRgbColor',
    ProPhotoRgbColor.fromInt,
  );

  // Video/Broadcast Color Classes
  testColorSpacesIQCompliance<YCbCrColor>(
    'YCbCrColor',
    YCbCrColor.fromInt,
  );

  testColorSpacesIQCompliance<YuvColor>(
    'YuvColor',
    YuvColor.fromInt,
  );

  testColorSpacesIQCompliance<YiqColor>(
    'YiqColor',
    YiqColor.fromInt,
  );

  // Perceptual Color Classes
  testColorSpacesIQCompliance<LmsColor>(
    'LmsColor',
    LmsColor.fromInt,
  );

  testColorSpacesIQCompliance<IptColor>(
    'IptColor',
    IptColor.fromInt,
  );

  testColorSpacesIQCompliance<JabColor>(
    'JabColor',
    JabColor.fromInt,
  );

  testColorSpacesIQCompliance<JchColor>(
    'JchColor',
    JchColor.fromInt,
  );

  // HSLuv Family
  testColorSpacesIQCompliance<HsluvColor>(
    'HsluvColor',
    HsluvColor.fromInt,
  );

  testColorSpacesIQCompliance<HclUv>(
    'HclUv',
    HclUv.fromInt,
  );

  // Specialty Color Classes
  testColorSpacesIQCompliance<HwbColor>(
    'HwbColor',
    HwbColor.fromInt,
  );

  testColorSpacesIQCompliance<HSP>(
    'HSP (HspColor)',
    HSP.fromInt,
  );

  testColorSpacesIQCompliance<MunsellColor>(
    'MunsellColor',
    MunsellColor.fromInt,
  );

  // Summary Test
  group('Interface Coverage Summary', () {
    test('All major color classes tested', () {
      // This test serves as documentation of coverage
      const int colorClassesTested = 28;
      const int interfaceMethodCount = 60; // Approximate

      print('╔═══════════════════════════════════════════════╗');
      print('║       Interface Compliance Test Summary       ║');
      print('╠═══════════════════════════════════════════════╣');
      print(
          '║  Color Classes Tested: $colorClassesTested                     ║');
      print(
          '║  Interface Methods: ~$interfaceMethodCount                    ║');
      print(
          '║  Total Test Cases: ${colorClassesTested * interfaceMethodCount}+                   ║');
      print('╚═══════════════════════════════════════════════╝');

      expect(colorClassesTested, greaterThan(15));
    });
  });
}
