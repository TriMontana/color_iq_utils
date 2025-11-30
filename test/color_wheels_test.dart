import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Color Wheels Tests', () {
    test('generateHsvWheel returns 60 slices', () {
      final wheel = generateHsvWheel();
      expect(wheel.length, 60);
      expect(wheel.first.color, isA<HsvColor>());
      expect(wheel.first.name, equals('Red'));
      expect(wheel.last.name, equals('Ruby'));
      
      // Check angles
      expect(wheel[0].startAngle, 0);
      expect(wheel[0].endAngle, 6);
      expect(wheel[59].startAngle, 354);
      expect(wheel[59].endAngle, 360);
    });

    test('generateHctWheel returns 60 slices', () {
      final wheel = generateHctWheel();
      expect(wheel.length, 60);
      expect(wheel.first.color, isA<HctColor>());
      // HCT Red is at ~27 degrees (Index 4). Index 0 is shifted to ~336 degrees (Raspberry).
      expect(wheel.first.name, equals('Raspberry'));
      
      // Check angles
      expect(wheel[0].startAngle, 0);
      expect(wheel[0].endAngle, 6);
    });

    test('Color names are populated', () {
      final wheel = generateHsvWheel();
      for (final slice in wheel) {
        expect(slice.name, isNotEmpty);
        expect(slice.name, isNot(equals('Unknown')));
      }
    });

    test('Custom parameters work', () {
      final hsvWheel = generateHsvWheel(saturation: 50, value: 50);
      final firstHsv = hsvWheel.first.color as HsvColor;
      expect(firstHsv.s, closeTo(0.5, 0.01));
      expect(firstHsv.v, closeTo(0.5, 0.01));

      final hctWheel = generateHctWheel(chroma: 80, tone: 60);
      final firstHct = hctWheel.first.color as HctColor;
      expect(firstHct.chroma, closeTo(80, 0.01));
      expect(firstHct.tone, closeTo(60, 0.01));
    });

    test('getHsvWheelMap returns map with correct keys', () {
      final map = getHsvWheelMap();
      expect(map.length, 60);
      expect(map.containsKey('Red'), isTrue);
      expect(map.containsKey('Scarlet'), isTrue);
      expect(map['Red']!.color, isA<HsvColor>());
    });

    test('getHctWheelMap returns map with correct keys', () {
      final map = getHctWheelMap();
      expect(map.length, 60);
      expect(map.containsKey('Red'), isTrue);
      expect(map['Red']!.color, isA<HctColor>());
    });
  });
}
