import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('Additional Color Conversion Tests', () {
    test('RGB to HSP conversion (Red)', () {
      final color = ColorIQ.fromARGB(255, 255, 0, 0);
      final hsp = color.toHsp();
      
      expect(hsp.h, closeTo(0, 0.1));
      expect(hsp.s, closeTo(1.0, 0.1));
      expect(hsp.p, closeTo(sqrt(0.299), 0.01));
    });

    test('RGB to YIQ conversion (White)', () {
      final color = ColorIQ.fromARGB(255, 255, 255, 255);
      final yiq = color.toYiq();
      
      expect(yiq.y, closeTo(1.0, 0.01));
      expect(yiq.i, closeTo(0.0, 0.01));
      expect(yiq.q, closeTo(0.0, 0.01));
    });

    test('RGB to YUV conversion (White)', () {
      final color = ColorIQ.fromARGB(255, 255, 255, 255);
      final yuv = color.toYuv();
      
      expect(yuv.y, closeTo(1.0, 0.01));
      expect(yuv.u, closeTo(0.0, 0.01));
      expect(yuv.v, closeTo(0.0, 0.01));
    });

    test('RGB to OkLab conversion (White)', () {
      final color = ColorIQ.fromARGB(255, 255, 255, 255);
      final oklab = color.toOkLab();
      
      expect(oklab.l, closeTo(1.0, 0.01));
      expect(oklab.a, closeTo(0.0, 0.01));
      expect(oklab.b, closeTo(0.0, 0.01));
    });
    
    test('RGB to OkLch conversion (Red)', () {
       // Red is approx L=0.627, C=0.257, h=29.2
       final color = ColorIQ.fromARGB(255, 255, 0, 0);
       final oklch = color.toOkLch();
       
       expect(oklch.l, closeTo(0.627, 0.05));
       expect(oklch.c, closeTo(0.257, 0.05));
       expect(oklch.h, closeTo(29.2, 1.0));
    });

    test('RGB to Hunter Lab conversion (White)', () {
      final color = ColorIQ.fromARGB(255, 255, 255, 255);
      final hunter = color.toHunterLab();
      
      expect(hunter.l, closeTo(100.0, 0.1));
      expect(hunter.a, closeTo(0.0, 0.1));
      expect(hunter.b, closeTo(0.0, 0.1));
    });
  });
}
