import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HwbColor Refactor V2 Tests', () {
    test('intensify decreases whiteness and blackness', () {
      final HwbColor color = HwbColor(0.0, 0.5, 0.5);
      final HwbColor intensified = color.intensify(10);

      expect(intensified.w, lessThan(color.w));
      expect(intensified.b, lessThan(color.b));
    });

    test('deintensify increases whiteness and blackness', () {
      final HwbColor color = HwbColor(0.0, 0.2, 0.2);
      final HwbColor deintensified = color.deintensify(10);

      expect(deintensified.w, greaterThan(color.w));
      expect(deintensified.b, greaterThan(color.b));
    });

    test('accented delegates to intensify', () {
      final HwbColor color = HwbColor(0.0, 0.5, 0.5);
      final HwbColor accented = color.accented(15);

      expect(accented.w, lessThan(color.w));
      expect(accented.b, lessThan(color.b));
    });
  });
}
