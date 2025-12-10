import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HclUv Tests', () {
    test('Constructor assignment', () {
      final HclUv color = HclUv(180, 50, 50);
      expect(color.h, 180);
      expect(color.c, 50);
      expect(color.l, 50);
      expect(color.alpha.val, 1.0);
      print('✓ HclUv Constructor assignment');
    });

    test('Round trip conversion (Red)', () {
      final ColorIQ ref = cRed; // 0xFFFF0000
      final HclUv hcl = HclUv.colorToHclUv(ref);
      final ColorIQ back = HclUv.hclUvToColor(hcl.h, hcl.c, hcl.l);

      // HCL conversions can be lossy or have slight shifts due to gamut mapping
      // but Red should be reasonably preserved.
      expect(back.red, closeTo(ref.red, 2));
      expect(back.green, closeTo(ref.green, 2));
      expect(back.blue, closeTo(ref.blue, 2));
    });

    test('hexId calculation', () {
      final HclUv red = HclUv(12.17, 179.04, 53.24); // Approx Red
      expect(
          red.hexId,
          closeTo(
              0xFFFF0000, 100000)); // HCL->RGB isn't bit exact due to floats
      // Let's test checking via colorToHclUv to get exact values
      final HclUv exactRed = HclUv.colorToHclUv(cRed);
      expect(exactRed.hexId, cRed.value);
    });

    test('lighten/darken modifies L', () {
      final HclUv start = HclUv(100, 50, 50);
      final HclUv lighter = start.lighten(10);
      final HclUv darker = start.darken(10);

      expect(lighter.l, closeTo(60, 0.01));
      expect(darker.l, closeTo(40, 0.01));
      expect(lighter.h, start.h);
      expect(lighter.c, start.c);
    });

    test('saturate/desaturate modifies C', () {
      final HclUv start = HclUv(100, 50, 50);
      final HclUv saturated = start.saturate(10);
      final HclUv desaturated = start.desaturate(10);

      expect(saturated.c, closeTo(60, 0.01));
      expect(desaturated.c, closeTo(40, 0.01));
      expect(saturated.l, start.l);
    });

    test('whiten moves towards L=100, C=0', () {
      final HclUv start = HclUv(100, 50, 50);
      final HclUv white = start.whiten(10); // 10% towards white

      // L goes from 50 -> 100. 10% is +5.
      expect(white.l, closeTo(55, 0.01));
      // C goes from 50 -> 0. 10% is -5.
      expect(white.c, closeTo(45, 0.01));
    });

    test('blacken moves towards L=0, C=0', () {
      final HclUv start = HclUv(100, 50, 50);
      final HclUv black = start.blacken(10);

      // L goes from 50 -> 0. 10% is -5.
      expect(black.l, closeTo(45, 0.01));
      // C goes from 50 -> 0. 10% is -5.
      expect(black.c, closeTo(45, 0.01));
    });

    test('contrastWith uses native luminance', () {
      final HclUv white = HclUv.colorToHclUv(cWhite);
      final HclUv black = HclUv.colorToHclUv(cBlack);

      expect(white.contrastWith(black), closeTo(21.0, 0.1));

      // Check intermediate
      final HclUv mid = HclUv.colorToHclUv(ColorIQ(0xFF808080));
      // 0x808080 is approx L=53 in HCLuv (actually L* via CIELUV should match L* via CIELAB for gray)
      // L* of 0x808080 is ~53.38
      // Luminance of 0x808080 is ~0.21

      expect(mid.luminance, closeTo(0.21, 0.01));
    });

    test('lerp interpolates values', () {
      final HclUv start = HclUv(0, 0, 0);
      final HclUv end = HclUv(100, 100, 100);
      final HclUv mid = start.lerp(end, 0.5);

      expect(mid.h, 50);
      expect(mid.c, 50);
      expect(mid.l, 50);
    });

    test('warm/cool shifts hue', () {
      final HclUv red = HclUv(0, 50, 50);
      final HclUv warmer = red.warmer(10);
      // Warm target 30. Diff 30. 10% of 30 is 3. New hue 3.
      expect(warmer.h, closeTo(3.0, 0.1));

      final HclUv cooler = red.cooler(10);
      // Cool target 210. Diff 210 -> -150. 10% of -150 is -15. New hue -15 -> 345.
      expect(cooler.h, closeTo(345.0, 0.1));
    });

    test('Palettes generation', () {
      final HclUv c = HclUv(100, 50, 50);
      expect(c.monochromatic.length, 5);
      expect(c.analogous().length, 5);
      expect(c.square().length, 4);
      expect(c.tetrad().length, 4);
    });

    test('toJson', () {
      final HclUv c = HclUv(10, 20, 30);
      final Map<String, dynamic> json = c.toJson();
      expect(json['type'], 'HclUv');
      expect(json['h'], 10);
      expect(json['c'], 20);
      expect(json['l'], 30);
    });
  });
}
