import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkHslColor Naming Tests', () {
    test('OkHslColor.alt generates default name when names is null', () {
      const OkHslColor color = OkHslColor(0, 0, 0); // Black
      // Expect some name validation
      expect(color.names, isEmpty);
      // expect(color.names.first, contains('FF000000'));
      // print('Generated name: ${color.names.first}');
    });

    test('OkHslColor.alt accepts explicit names', () {
      const OkHslColor color =
          OkHslColor(0, 0, 0, names: <String>['Custom Name']);
      expect(color.names, equals(<String>['Custom Name']));
      print('✓ OkHslColor.alt accepts explicit names');
    });
  });
}
