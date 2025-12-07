import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HwbColor Darken/Brighten', () {
    test('darken increases blackness', () {
      final HwbColor color = HwbColor(0.0, 0.0, 0.2); // B = 0.2
      final HwbColor darkened = color.darken(20);
      expect(darkened.b, closeTo(0.4, 0.001));
      expect(darkened.w, color.w);
      expect(darkened.h, color.h);
    });

    test('brighten decreases blackness', () {
      final HwbColor color = HwbColor(0.0, 0.0, 0.5); // B = 0.5
      final HwbColor brightened = color.brighten(20);
      expect(brightened.b, closeTo(0.3, 0.001));
      expect(brightened.w, color.w);
      expect(brightened.h, color.h);
    });

    test('darken clamps to 1.0', () {
      final HwbColor color = HwbColor(0.0, 0.0, 0.9);
      final HwbColor darkened = color.darken(20);
      expect(darkened.b, 1.0);
    });

    test('brighten clamps to 0.0', () {
      final HwbColor color = HwbColor(0.0, 0.0, 0.1);
      final HwbColor brightened = color.brighten(20);
      expect(brightened.b, 0.0);
    });
  });
}
