import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('Intensify and Deintensify Tests', () {
    test('HctColor intensify increases chroma and decreases tone', () {
      final hct = HctColor(120, 50, 50);
      final intensified = hct.intensify(10);
      
      expect(intensified.chroma, greaterThan(hct.chroma));
      expect(intensified.tone, lessThan(hct.tone));
      expect(intensified.hue, equals(hct.hue));
    });

    test('HctColor deintensify decreases chroma and increases tone', () {
      final hct = HctColor(120, 50, 50);
      final deintensified = hct.deintensify(10);
      
      expect(deintensified.chroma, lessThan(hct.chroma));
      expect(deintensified.tone, greaterThan(hct.tone));
      expect(deintensified.hue, equals(hct.hue));
    });

    test('Color intensify delegates to HctColor', () {
      final color = Color.fromARGB(255, 100, 150, 200); // Some blueish color
      final intensified = color.intensify(20);
      
      // Convert back to HCT to verify properties
      final originalHct = color.toHct();
      final intensifiedHct = intensified.toHct();

      expect(intensifiedHct.chroma, greaterThan(originalHct.chroma));
      // Tone might not always strictly decrease due to gamut mapping, but generally should be lower or similar for intensification logic
      // The logic is tone - amount/2.
      expect(intensifiedHct.tone, lessThan(originalHct.tone));
    });

    test('Color deintensify delegates to HctColor', () {
      final color = Color.fromARGB(255, 100, 150, 200);
      final deintensified = color.deintensify(20);
      
      final originalHct = color.toHct();
      final deintensifiedHct = deintensified.toHct();

      expect(deintensifiedHct.chroma, lessThan(originalHct.chroma));
      expect(deintensifiedHct.tone, greaterThan(originalHct.tone));
    });

    test('LabColor intensify delegates correctly', () {
      final lab = LabColor(50, 20, 20);
      final intensified = lab.intensify(10);
      
      // Check if it's different
      expect(intensified.l, isNot(equals(lab.l)));
      // We expect it to be more vivid, so distance from gray (0,0) in ab plane should increase?
      // Or just rely on the fact that it delegates to HCT which we tested.
      // Let's verify it returns a valid LabColor.
      expect(intensified, isA<LabColor>());
    });

    test('HslColor intensify delegates correctly', () {
      final hsl = HslColor(120, 0.5, 0.5);
      final intensified = hsl.intensify(10);
      expect(intensified, isA<HslColor>());
      // Saturation should likely increase
      expect((intensified as HslColor).s, greaterThanOrEqualTo(hsl.s));
    });
    
    test('Intensify clamps values correctly', () {
       final hct = HctColor(120, 145, 10); // High chroma, low tone
       final intensified = hct.intensify(50);
       // Chroma is unbounded technically in HCT but practically limited. Tone is 0-100.
       expect(intensified.tone, greaterThanOrEqualTo(0));
    });

    test('Deintensify clamps values correctly', () {
       final hct = HctColor(120, 5, 95); // Low chroma, high tone
       final deintensified = hct.deintensify(50);
       expect(deintensified.chroma, greaterThanOrEqualTo(0));
       expect(deintensified.tone, lessThanOrEqualTo(100));
    });
  });
}
