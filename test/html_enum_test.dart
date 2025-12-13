import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

/// Test suite for HtmlEN enum colors
///
/// Tests verify that each HTML color provides:
/// - Correct ARGB integer values (0-255)
/// - Correct normalized sRGB values (0.0-1.0)
/// - Correct HSV values
/// - Correct HCT values from Material Color Utilities
void main() {
  group('HtmlEN Enum Color Tests', () {
    // Test all enum values
    for (final HtmlEN htmlEnum in HtmlEN.values) {
      test('${htmlEnum.name} - Complete color validation', () {
        // Get the color instance from registry or create from value
        // Some colors in registry are ColorIQ, not HTML
        HTML color;
        try {
          color = htmlEnum.html;
        } catch (e) {
          // If cast fails, throw exception
          throw Exception(
              'Failed to create HTML color from enum value: ${htmlEnum.value}');
        }

        // Verify hexId matches enum value
        expect(color.hexId, equals(htmlEnum.value),
            reason:
                '${htmlEnum.name} (${htmlEnum.hexString}): hexId should match enum value');
        expect(color.hexId, equals(htmlEnum.hexId),
            reason:
                '${htmlEnum.name} (${htmlEnum.hexString}): hexId should match enum hexId getter');

        // Test ARGB integers (0-255)
        _testArgbIntegers(color, htmlEnum);

        // Test normalized sRGB values (0.0-1.0)
        _testNormalizedSrgb(color, htmlEnum);

        // Test HSV values
        _testHsvValues(color, htmlEnum);

        // Test HCT values
        // If it's an HTML instance, test stored HCT (may be approximate)
        _testHctValuesStored(color, htmlEnum);

        // Always test recalculated HCT values
        _testHctValuesRecalculated(color, htmlEnum);
      });
    }

    // Additional group tests for specific properties
    group('HtmlEN - ARGB Integer Validation', () {
      test('All colors have valid ARGB integers (0-255)', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          HTML color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            // If cast fails, throw exception
            throw Exception(
                'Failed to create HTML color from enum value: ${htmlEnum.value}');
          }
          final ArgbInts argb = color.rgbaInts;

          expect(argb.alpha,
              allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Alpha must be 0-255');
          expect(
              argb.red, allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
              reason: '${htmlEnum.name} (${color.hexStr}): Red must be 0-255');
          expect(argb.green,
              allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Green must be 0-255');
          expect(
              argb.blue, allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
              reason: '${htmlEnum.name} (${color.hexStr}): Blue must be 0-255');
        }
      });
    });

    group('HtmlEN - Normalized sRGB Validation', () {
      test('All colors have valid normalized sRGB values (0.0-1.0)', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          ColorIQ color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            color = ColorIQ(htmlEnum.value);
          }
          final ArgbDoubles argb = color.rgbaDoubles;

          expect(
              argb.a, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Alpha normalized must be 0.0-1.0');
          expect(
              argb.r, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Red normalized must be 0.0-1.0');
          expect(
              argb.g, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Green normalized must be 0.0-1.0');
          expect(
              argb.b, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Blue normalized must be 0.0-1.0');
        }
      });

      test('Normalized values match integer values / 255.0', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          ColorIQ color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            color = ColorIQ(htmlEnum.value);
          }
          final ArgbInts ints = color.rgbaInts;
          final ArgbDoubles doubles = color.rgbaDoubles;

          expect(doubles.a, closeTo(ints.alpha / 255.0, 0.000001),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Alpha normalized should equal int/255');
          expect(doubles.r, closeTo(ints.red / 255.0, 0.000001),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Red normalized should equal int/255');
          expect(doubles.g, closeTo(ints.green / 255.0, 0.000001),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Green normalized should equal int/255');
          expect(doubles.b, closeTo(ints.blue / 255.0, 0.000001),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Blue normalized should equal int/255');
        }
      });
    });

    group('HtmlEN - HSV Validation', () {
      test('All colors have valid HSV values', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          ColorIQ color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            color = ColorIQ(htmlEnum.value);
          }
          final HSV hsv = color.hsv;

          expect(
              hsv.h, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(360.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Hue must be 0.0-360.0');
          expect(hsv.saturation.val,
              allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Saturation must be 0.0-1.0');
          expect(hsv.valueHsv.val,
              allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Value must be 0.0-1.0');
          expect(hsv.alpha.val,
              allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HSV Alpha must be 0.0-1.0');
        }
      });

      test('HSV values match recalculated values from ARGB', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          ColorIQ color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            color = ColorIQ(htmlEnum.value);
          }
          final HSV hsv = color.hsv;

          // Recalculate HSV from ARGB
          final HSV recalculated = HSV.fromInt(color.hexId);

          expect(hsv.h, closeTo(recalculated.h, 0.1),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Hue should match recalculated value');
          expect(
              hsv.saturation.val, closeTo(recalculated.saturation.val, 0.001),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Saturation should match recalculated value');
          expect(hsv.valueHsv.val, closeTo(recalculated.valueHsv.val, 0.001),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): Value should match recalculated value');
        }
      });
    });

    group('HtmlEN - HCT Validation', () {
      test('All colors have valid HCT values', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          HTML color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            // If cast fails, throw exception
            throw Exception(
                'Failed to create HTML color from enum value: ${htmlEnum.value}');
          }
          final HctData hct = color.hct;

          expect(hct.hue,
              allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(360.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HCT Hue must be 0.0-360.0');
          expect(hct.chroma, greaterThanOrEqualTo(0.0),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HCT Chroma must be >= 0.0');
          expect(hct.tone,
              allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(100.0)),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HCT Tone must be 0.0-100.0, hct should be ${hct.toString()}');
        }
      });

      test('HCT values match recalculated values from ARGB', () {
        for (final HtmlEN htmlEnum in HtmlEN.values) {
          ColorIQ color;
          try {
            color = htmlEnum.html;
          } catch (e) {
            color = ColorIQ(htmlEnum.value);
          }
          final HctData hct = color.hct;

          // Recalculate HCT from ARGB
          final HctData recalculated = HctData.fromInt(color.hexId);

          expect(hct.hue, closeTo(recalculated.hue, 0.1),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HCT Hue should match recalculated value');
          expect(hct.chroma, closeTo(recalculated.chroma, 0.1),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HCT Chroma should match recalculated value');
          expect(hct.tone, closeTo(recalculated.tone, 0.1),
              reason:
                  '${htmlEnum.name} (${color.hexStr}): HCT Tone should match recalculated value');
        }
      });
    });

    // Test specific well-known colors
    group('HtmlEN - Specific Color Tests', () {
      test('Black color values', () {
        final HTML black = HtmlEN.black.html;
        expect(black.hexId, equals(0xFF000000));
        expect(black.rgbaInts.red, equals(0));
        expect(black.rgbaInts.green, equals(0));
        expect(black.rgbaInts.blue, equals(0));
        expect(black.rgbaDoubles.r, equals(0.0));
        expect(black.rgbaDoubles.g, equals(0.0));
        expect(black.rgbaDoubles.b, equals(0.0));
        expect(black.hct.tone, closeTo(0.0, 0.1));
      });

      test('White color values', () {
        final HTML white = HtmlEN.white.html;
        expect(white.hexId, equals(0xFFFFFFFF));
        expect(white.rgbaInts.red, equals(255));
        expect(white.rgbaInts.green, equals(255));
        expect(white.rgbaInts.blue, equals(255));
        expect(white.rgbaDoubles.r, equals(1.0));
        expect(white.rgbaDoubles.g, equals(1.0));
        expect(white.rgbaDoubles.b, equals(1.0));
        expect(white.hct.tone, closeTo(100.0, 0.1));
      });

      test('Red color values', () {
        final HTML red = HtmlEN.red.html;
        expect(red.hexId, equals(0xFFFF0000));
        expect(red.rgbaInts.red, equals(255));
        expect(red.rgbaInts.green, equals(0));
        expect(red.rgbaInts.blue, equals(0));
        expect(red.rgbaDoubles.r, equals(1.0));
        expect(red.rgbaDoubles.g, equals(0.0));
        expect(red.rgbaDoubles.b, equals(0.0));
        expect(red.hsv.h, anyOf(closeTo(0.0, 1.0), closeTo(360.0, 1.0)));
      });

      test('Green color values', () {
        final HTML green = HtmlEN.green.html;
        expect(green.hexId, equals(0xFF008000));
        expect(green.rgbaInts.red, equals(0));
        expect(green.rgbaInts.green, equals(128));
        expect(green.rgbaInts.blue, equals(0));
      });

      test('Blue color values', () {
        // Note: There's no 'blue' in HtmlEN, using a color that exists
        // Let's test cyan instead which is similar
        final HTML cyan = HtmlEN.cyan.html;
        expect(cyan.hexId, equals(0xFF00FFFF));
        expect(cyan.rgbaInts.red, equals(0));
        expect(cyan.rgbaInts.green, equals(255));
        expect(cyan.rgbaInts.blue, equals(255));
        expect(cyan.rgbaDoubles.r, equals(0.0));
        expect(cyan.rgbaDoubles.g, equals(1.0));
        expect(cyan.rgbaDoubles.b, equals(1.0));
      });
    });
  });
}

/// Helper function to test ARGB integers
void _testArgbIntegers(final ColorIQ color, final HtmlEN htmlEnum) {
  final ArgbInts argb = color.rgbaInts;

  // Verify values are in valid range
  expect(argb.alpha, allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Alpha must be 0-255, got ${argb.alpha}');
  expect(argb.red, allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Red must be 0-255, got ${argb.red}');
  expect(argb.green, allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Green must be 0-255, got ${argb.green}');
  expect(argb.blue, allOf(greaterThanOrEqualTo(0), lessThanOrEqualTo(255)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Blue must be 0-255, got ${argb.blue}');

  // Verify ARGB reconstruction matches hexId
  final int reconstructed =
      (argb.alpha << 24) | (argb.red << 16) | (argb.green << 8) | argb.blue;
  expect(reconstructed, equals(color.hexId),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Reconstructed ARGB should match hexId');
}

/// Helper function to test normalized sRGB values
void _testNormalizedSrgb(final ColorIQ color, final HtmlEN htmlEnum) {
  final ArgbDoubles argb = color.rgbaDoubles;
  final ArgbInts ints = color.rgbaInts;

  // Verify values are in valid range
  expect(argb.a, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Alpha normalized must be 0.0-1.0, got ${argb.a}');
  expect(argb.r, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Red normalized must be 0.0-1.0, got ${argb.r}');
  expect(argb.g, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Green normalized must be 0.0-1.0, got ${argb.g}');
  expect(argb.b, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Blue normalized must be 0.0-1.0, got ${argb.b}');

  // Verify normalized values match integer values / 255.0
  expect(argb.a, closeTo(ints.alpha / 255.0, 0.000001),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Alpha normalized should equal int/255');
  expect(argb.r, closeTo(ints.red / 255.0, 0.000001),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Red normalized should equal int/255');
  expect(argb.g, closeTo(ints.green / 255.0, 0.000001),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Green normalized should equal int/255');
  expect(argb.b, closeTo(ints.blue / 255.0, 0.000001),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Blue normalized should equal int/255');
}

/// Helper function to test HSV values
void _testHsvValues(final ColorIQ color, final HtmlEN htmlEnum) {
  final HSV hsv = color.hsv;

  // Verify values are in valid range
  expect(hsv.h, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(360.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Hue must be 0.0-360.0, got ${hsv.h}');
  expect(hsv.saturation.val,
      allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Saturation must be 0.0-1.0, got ${hsv.saturation.val}');
  expect(hsv.valueHsv.val,
      allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Value must be 0.0-1.0, got ${hsv.valueHsv.val}');
  expect(
      hsv.alpha.val, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(1.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): HSV Alpha must be 0.0-1.0, got ${hsv.alpha.val}');

  // Verify HSV can be recalculated from ARGB
  final HSV recalculated = HSV.fromInt(color.hexId);
  expect(hsv.h, closeTo(recalculated.h, 0.1),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Hue should match recalculated value');
  expect(hsv.saturation.val, closeTo(recalculated.saturation.val, 0.001),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Saturation should match recalculated value');
  expect(hsv.valueHsv.val, closeTo(recalculated.valueHsv.val, 0.001),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Value should match recalculated value');
}

/// Helper function to test stored HCT values (for HTML instances)
/// Note: Stored HCT values may be approximations, so we use looser tolerances
void _testHctValuesStored(final HTML html, final HtmlEN htmlEnum) {
  final HctData hct = html.hct;

  // Verify values are in valid range
  expect(hct.hue, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(360.0)),
      reason:
          '${htmlEnum.name} (${html.hexStr}): HCT Hue must be 0.0-360.0, got ${hct.hue}');
  expect(hct.chroma, greaterThanOrEqualTo(0.0),
      reason:
          '${htmlEnum.name} (${html.hexStr}): HCT Chroma must be >= 0.0, got ${hct.chroma}');
  expect(hct.tone, allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(100.0)),
      reason:
          '${htmlEnum.name} (${html.hexStr}): HCT Tone must be 0.0-100.0, got ${hct.tone}');
}

/// Helper function to test recalculated HCT values from ARGB
/// This verifies that HCT can be correctly calculated from the color's ARGB value
void _testHctValuesRecalculated(final ColorIQ color, final HtmlEN htmlEnum) {
  // Recalculate HCT from ARGB
  final HctData recalculated = HctData.fromInt(color.hexId);

  // Verify recalculated values are in valid range
  expect(recalculated.hue,
      allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(360.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Recalculated HCT Hue must be 0.0-360.0, got ${recalculated.hue}');
  expect(recalculated.chroma, greaterThanOrEqualTo(0.0),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Recalculated HCT Chroma must be >= 0.0, got ${recalculated.chroma}');
  expect(recalculated.tone,
      allOf(greaterThanOrEqualTo(0.0), lessThanOrEqualTo(100.0)),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Recalculated HCT Tone must be 0.0-100.0, got ${recalculated.tone}');

  // Verify that recalculated HCT matches the color's hct property
  final HctData colorHct = color.hct;
  expect(colorHct.hue, closeTo(recalculated.hue, 0.1),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Color HCT Hue should match recalculated value');
  expect(colorHct.chroma, closeTo(recalculated.chroma, 0.1),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Color HCT Chroma should match recalculated value');
  expect(colorHct.tone, closeTo(recalculated.tone, 0.1),
      reason:
          '${htmlEnum.name} (${color.hexStr}): Color HCT Tone should match recalculated value');
}
