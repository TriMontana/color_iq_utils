import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkHslColor Refactor V2 Tests', () {
    test('intensify increases saturation', () {
      const OkHslColor color = OkHslColor(0.0, 0.5, 0.5);
      final OkHslColor intensified = color.intensify(10);

      expect(intensified.s, greaterThan(color.s));
      print('✓ intensify increases saturation');
    });

    test('deintensify decreases saturation', () {
      const OkHslColor color = OkHslColor(0.0, 0.5, 0.5);
      final OkHslColor deintensified = color.deintensify(10);

      expect(deintensified.s, lessThan(color.s));
      print('✓ deintensify decreases saturation');
    });

    test('accented increases saturation', () {
      const OkHslColor color = OkHslColor(0.0, 0.5, 0.5);
      final OkHslColor accented = color.accented(10);

      expect(accented.s, greaterThan(color.s));
      print('✓ accented increases saturation');
    });
  });
}
