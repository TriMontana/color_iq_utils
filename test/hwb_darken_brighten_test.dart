import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HwbColor Darken/Brighten', () {
    test('darken increases blackness', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.2); // B = 0.2
      final HwbColor darkened = color.darken(20);
      expect(darkened.blackness, closeTo(0.4, 0.001));
      expect(darkened.w, color.w);
      expect(darkened.h, color.h);
      print('✓ darken increases blackness');
    });

    test('brighten decreases blackness', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.5); // B = 0.5
      final HwbColor brightened = color.brighten(Percent.v20);
      expect(brightened.blackness, closeTo(0.3, 0.001));
      expect(brightened.w, color.w);
      expect(brightened.h, color.h);
      print('✓ brighten decreases blackness');
    });

    test('darken clamps to 1.0', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.9);
      final HwbColor darkened = color.darken(20);
      expect(darkened.blackness, 1.0);
      print('✓ darken clamps to 1.0');
    });

    test('brighten clamps to 0.0', () {
      const HwbColor color = HwbColor(0.0, 0.0, 0.1);
      final HwbColor brightened = color.brighten(Percent.v20);
      expect(brightened.blackness, 0.0);
    });
  });
}
