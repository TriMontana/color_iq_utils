import 'dart:math';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Additional Color Conversion Tests', () {
    test('RGB to HSP conversion (Red)', () {
      final ColorIQ color = cRed;
      final HSP hsp = color.hsp;
      expect(hsp.h, closeTo(0, 0.1));
      expect(hsp.s, closeTo(1.0, 0.1));
      expect(hsp.p, closeTo(sqrt(0.299), 0.01));
      print('✓ RGB to HSP conversion (Red)');
    });

    test('RGB to YIQ conversion (White)', () {
      final ColorIQ color = cWhite;
      final YiqColor yiq = color.toYiq();
      expect(yiq.y, closeTo(1.0, 0.01));
      expect(yiq.i, closeTo(0.0, 0.01));
      expect(yiq.q, closeTo(0.0, 0.01));
      print('✓ RGB to YIQ conversion (White)');
    });

    test('RGB to YUV conversion (White)', () {
      final ColorIQ color = cWhite;
      final YuvColor yuv = color.toYuv();

      expect(yuv.y, closeTo(1.0, 0.01));
      expect(yuv.u, closeTo(0.0, 0.01));
      expect(yuv.v, closeTo(0.0, 0.01));
      print('✓ RGB to YUV conversion (White)');
    });

    test('RGB to OkLab conversion (White)', () {
      final ColorIQ color = cWhite;
      final OkLabColor oklab = color.toOkLab();
      expect(oklab.l, closeTo(1.0, 0.01));
      expect(oklab.aLab, closeTo(0.0, 0.01));
      expect(oklab.bLab, closeTo(0.0, 0.01));
      print('✓ RGB to OkLab conversion (White)');
    });

    test('RGB to OkLch conversion (Red)', () {
      // Red is approx L=0.627, C=0.257, h=29.2
      final ColorIQ color = cRed;
      final OkLCH oklch = color.toOkLch();

      expect(oklch.l, closeTo(0.627, 0.05));
      expect(oklch.c, closeTo(0.257, 0.05));
      expect(oklch.h, closeTo(29.2, 1.0));
      print('✓ RGB to OkLch conversion (Red)');
    });

    test('RGB to Hunter Lab conversion (White)', () {
      final ColorIQ color = cWhite;
      final HunterLabColor hunter = color.toHunterLab();

      expect(hunter.l, closeTo(100.0, 0.1));
      expect(hunter.aLab, closeTo(0.0, 0.1));
      expect(hunter.bLab, closeTo(0.0, 0.1));
      print('✓ RGB to Hunter Lab conversion (White)');
    });
  });
}
