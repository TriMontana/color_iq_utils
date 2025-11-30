import 'package:test/test.dart';
import 'package:color_iq_utils/color_iq_utils.dart';


void main() {
  group('sRGB and Linear sRGB Tests', () {
    test('Color srgb getter', () {
      final color = Color.fromARGB(255, 100, 150, 200);
      expect(color.srgb, [100, 150, 200, 255]);
    });

    test('Color linearSrgb getter (Red)', () {
      final red = Color.fromARGB(255, 255, 0, 0);
      expect(red.linearSrgb, [1.0, 0.0, 0.0, 1.0]);
    });

    test('Color linearSrgb getter (Mid Gray)', () {
      final gray = Color.fromARGB(255, 128, 128, 128);
      // 128/255 = 0.50196
      // ((0.50196 + 0.055) / 1.055) ^ 2.4 = 0.21586
      final linear = gray.linearSrgb;
      expect(linear[0], closeTo(0.21586, 0.001));
      expect(linear[1], closeTo(0.21586, 0.001));
      expect(linear[2], closeTo(0.21586, 0.001));
      expect(linear[3], 1.0);
    });

    test('Color linearSrgb getter (Dark Gray - Linear Segment)', () {
      final dark = Color.fromARGB(255, 10, 10, 10);
      // 10/255 = 0.039215
      // 0.039215 / 12.92 = 0.003035
      final linear = dark.linearSrgb;
      expect(linear[0], closeTo(0.003035, 0.0001));
    });

    test('Other models delegation (HslColor)', () {
      final hsl = HslColor(0, 1.0, 0.5); // Red
      expect(hsl.srgb, [255, 0, 0, 255]);
      expect(hsl.linearSrgb, [1.0, 0.0, 0.0, 1.0]);
    });

    test('Other models delegation (LabColor)', () {
      // Lab approx for Red
      final lab = LabColor(53.24, 80.09, 67.20); 
      final srgb = lab.srgb;
      // Precision might vary slightly due to conversions
      expect(srgb[0], closeTo(255, 2)); 
      expect(srgb[1], closeTo(0, 2));
      expect(srgb[2], closeTo(0, 2));
    });
  });
}
