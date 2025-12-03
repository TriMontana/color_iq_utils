import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/extensions/double_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('sRGB and Linear sRGB Tests', () {
    test('ColorIQ srgb getter', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 100, 150, 200);
      expect(color.srgb, <int>[100, 150, 200, 255]);

      print('✓ ColorIQ srgb getter test completed');
      print('  sRGB values: ${color.srgb}');
    });

    test('ColorIQ linearSrgb getter (Red)', () {
      final ColorIQ red = ColorIQ.fromARGB(255, 255, 0, 0);
      expect(red.linearSrgb, <double>[1.0, 0.0, 0.0, 1.0]);

      print('✓ ColorIQ linearSrgb getter (Red) test completed');
      print('  Linear sRGB values: ${red.linearSrgb}');
    });

    test('ColorIQ linearSrgb getter (Mid Gray)', () {
      final ColorIQ gray = ColorIQ.fromARGB(255, 128, 128, 128);
      // 128/255 = 0.50196
      // ((0.50196 + 0.055) / 1.055) ^ 2.4 = 0.21586
      final List<double> linear = gray.linearSrgb;
      expect(linear[0], closeTo(0.21586, 0.001));
      expect(linear[1], closeTo(0.21586, 0.001));
      expect(linear[2], closeTo(0.21586, 0.001));
      expect(linear[3], 1.0);

      print('✓ ColorIQ linearSrgb getter (Mid Gray) test completed');
      print(
        '  Linear sRGB values: [${linear[0].toStrTrimZeros(5)}, ' //
        '${linear[1].toStringAsFixed(5)}, ${linear[2].toStringAsFixed(5)}, ${linear[3]}]',
      );
    });

    test('ColorIQ linearSrgb getter (Dark Gray - Linear Segment)', () {
      final ColorIQ dark = ColorIQ.fromARGB(255, 10, 10, 10);
      // 10/255 = 0.039215
      // 0.039215 / 12.92 = 0.003035
      final List<double> linear = dark.linearSrgb;
      expect(linear[0], closeTo(0.003035, 0.0001));

      print(
        '✓ ColorIQ linearSrgb getter (Dark Gray - Linear Segment) test completed',
      );
      print(
        '  Linear sRGB values: [${linear[0].toStringAsFixed(6)}, ${linear[1].toStringAsFixed(6)}, ${linear[2].toStringAsFixed(6)}, ${linear[3]}]',
      );
    });

    test('Other models delegation (HslColor)', () {
      const HslColor hsl = HslColor(0, 1.0, 0.5); // Red
      expect(hsl.srgb, <int>[255, 0, 0, 255]);
      expect(hsl.linearSrgb, <double>[1.0, 0.0, 0.0, 1.0]);

      print('✓ Other models delegation (HslColor) test completed');
      print('  HslColor(${hsl.h}, ${hsl.s}, ${hsl.l})');
      print('  sRGB: ${hsl.srgb}');
      print('  Linear sRGB: ${hsl.linearSrgb}');
    });

    test('Other models delegation (LabColor)', () {
      // Lab approx for Red
      const LabColor lab = LabColor(53.24, 80.09, 67.20);
      final List<int> srgb = lab.srgb;
      // Precision might vary slightly due to conversions
      expect(srgb[0], closeTo(255, 2));
      expect(srgb[1], closeTo(0, 2));
      expect(srgb[2], closeTo(0, 2));

      print('✓ Other models delegation (LabColor) test completed');
      print(
        '  LabColor(${lab.l.toStrTrimZeros(2)}, ' //
        '${lab.aLab.toStringAsFixed(2)}, ${lab.bLab.toStringAsFixed(2)})',
      );
      print('  sRGB: $srgb');
    });
  });
}
