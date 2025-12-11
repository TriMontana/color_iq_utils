import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('sRGB and Linear sRGB Tests', () {
    test('ColorIQ srgb getter', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(alpha: 255, red: 100, green: 150, blue: 200);
      expect(color.argb255Ints, <int>[255, 100, 150, 200]);

      print('✓ ColorIQ srgb getter test completed');
      print('  sRGB values: ${color.argb255Ints}');
      print('  Linear sRGB values: ${color.rgbaLinearized}');
    });

    test('ColorIQ linearSrgb getter (Red)', () {
      final ColorIQ red =
          ColorIQ.fromArgbInts(alpha: 255, red: 255, green: 0, blue: 0);
      expect(red.rgbaLinearized, <double>[1.0, 0.0, 0.0, 1.0]);

      print('✓ ColorIQ linearSrgb getter (Red) test completed');
      print('  Linear sRGB values: ${red.redLinearized}');
    });

    test('ColorIQ linearSrgb getter (Mid Gray)', () {
      final ColorIQ gray =
          ColorIQ.fromArgbInts(alpha: 255, red: 128, green: 128, blue: 128);
      // 128/255 = 0.50196
      // ((0.50196 + 0.055) / 1.055) ^ 2.4 = 0.21586
      final List<double> linear = gray.rgbaLinearized;
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
      final ColorIQ dark =
          ColorIQ.fromArgbInts(alpha: 255, red: 10, green: 10, blue: 10);
      // 10/255 = 0.039215
      // 0.039215 / 12.92 = 0.003035
      final List<double> linear = dark.rgbaLinearized;
      expect(linear[0], closeTo(0.003035, 0.0001));

      print(
        '✓ ColorIQ linearSrgb getter (Dark Gray - Linear Segment) test completed',
      );
      print(
        '  Linear sRGB values: [${linear[0].toStrTrimZeros(6)}, ' //
        '${linear[1].toStringAsFixed(6)}, ${linear[2].toStringAsFixed(6)}, ${linear[3]}]',
      );
    });

    test('Other models delegation (HslColor)', () {
      const HSL hsl = HSL(0, Percent.max, Percent.mid); // Red
      expect(hsl.argb255Ints, <int>[255, 255, 0, 0]);
      expect(hsl.rgbaLinearized, <double>[1.0, 0.0, 0.0, 1.0]);

      print('✓ Other models delegation (HslColor) test completed');
      print('  HslColor(${hsl.h}, ${hsl.s}, ${hsl.l})');
      print('  sRGB: ${hsl.argb255Ints}');
      print('  Linear sRGB: ${hsl.rgbaLinearized}');
    });

    test('Other models delegation (LabColor)', () {
      // Lab approx for Red
      final LabColor lab = LabColor(53.24, 80.09, 67.20);
      final List<int> srgb = lab.argb255Ints;
      // Precision might vary slightly due to conversions
      expect(srgb[1], closeTo(255, 2));
      expect(srgb[2], closeTo(0, 2));
      expect(srgb[3], closeTo(0, 2));

      print('✓ Other models delegation (LabColor) test completed');
      print(
        '  LabColor(${lab.l.toStrTrimZeros(2)}, ' //
        '${lab.aLab.toStringAsFixed(2)}, ${lab.bLab.toStrTrimZeros(3)})',
      );
      print('  sRGB: $srgb');
    });
  });
}
