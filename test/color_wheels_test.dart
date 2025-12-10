import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Color Wheels Tests', () {
    test('generateHsvWheel returns 60 slices', () {
      final List<ColorSlice> wheel = generateHsvWheel();
      expect(wheel.length, 60);
      expect(wheel.first.color, isA<HSV>());
      expect(wheel[0].name.first, equals('Red'));
      expect(wheel.last.name.first, equals('Ruby'));

      // Check angles
      expect(wheel[0].startAngle, 0);
      expect(wheel[0].endAngle, 6);
      expect(wheel[59].startAngle, 354);
      expect(wheel[59].endAngle, 360);
      print('✓ generateHsvWheel returns 60 slices');
    });

    test('generateHctWheel returns 60 slices', () {
      final List<ColorSlice> wheel = generateHctWheel();
      expect(wheel.length, 60);
      expect(wheel.first.color, isA<HctData>());
      // HCT Red is at ~27 degrees (Index 4). Index 0 is shifted to ~336 degrees (Raspberry).
      expect(wheel[0].name.first, equals('Raspberry'));

      // Check angles
      expect(wheel[0].startAngle, 0);
      expect(wheel[0].endAngle, 6);
      print('✓ generateHctWheel returns 60 slices');
    });

    test('Color names are populated', () {
      final List<ColorSlice> wheel = generateHsvWheel();
      for (final ColorSlice slice in wheel) {
        expect(slice.name, isNotEmpty);
        expect(slice.name, isNot(equals('Unknown')));
      }
      print('✓ Color names are populated');
    });

    test('Custom parameters work', () {
      final List<ColorSlice> hsvWheel =
          generateHsvWheel(saturation: 50, value: 50);
      final HSV firstHsv = hsvWheel.first.color as HSV;
      expect(firstHsv.saturation, closeTo(0.5, 0.01));
      expect(firstHsv.valueHsv, closeTo(0.5, 0.01));

      final List<ColorSlice> hctWheel = generateHctWheel(chroma: 80, tone: 60);
      final HctData firstHct = hctWheel.first.color as HctData;
      expect(firstHct.chroma, closeTo(80, 0.01));
      expect(firstHct.tone, closeTo(60, 0.01));
      print('✓ Custom parameters work');
    });

    test('getHsvWheelMap returns map with correct keys', () {
      final Map<String, ColorSlice> map = getHsvWheelMap();
      expect(map.length, 60);
      expect(map.containsKey('Red'), isTrue);
      expect(map.containsKey('Scarlet'), isTrue);
      expect(map['Red']!.color, isA<HSV>());
      print('✓ getHsvWheelMap returns map with correct keys');
    });

    test('getHctWheelMap returns map with correct keys', () {
      final Map<String, ColorSlice> map = getHctWheelMap();
      expect(map.length, 60);
      expect(map.containsKey('Red'), isTrue);
      expect(map['Red']!.color, isA<HctData>());
    });
  });
}
