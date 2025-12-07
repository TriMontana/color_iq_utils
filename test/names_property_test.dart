import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Names Property Tests', () {
    const List<String> testNames = <String>['Alias1', 'Alias2'];

    test('ColorIQ stores names', () {
      final ColorIQ color = ColorIQ.fromARGB(255, 255, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(ColorIQ(0xFFFF0000).names, isEmpty);
    });

    test('CmykColor stores names', () {
      final CmykColor color = CmykColor(0, 1, 1, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(CmykColor(0, 1, 1, 0).names, isEmpty);
    });

    test('HslColor stores names', () {
      final HslColor color = HslColor(0, 1.0, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(HslColor(0, 1.0, 0.5).names, isEmpty);
    });

    test('HsvColor stores names', () {
      final HsvColor color = HsvColor(0, 1.0, 1.0, names: testNames);
      expect(color.names, equals(testNames));
      expect(HsvColor(0, 1.0, 1.0).names, isEmpty);
    });

    test('HsbColor stores names', () {
      final HsbColor color = HsbColor(0, 1.0, 1.0, names: testNames);
      expect(color.names, equals(testNames));
      expect(HsbColor(0, 1.0, 1.0).names, isEmpty);
    });

    test('HwbColor stores names', () {
      final HwbColor color = HwbColor(0, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(HwbColor(0, 0, 0).names, isEmpty);
    });

    test('HctColor stores names', () {
      final HctColor color = HctColor(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(HctColor(0, 100, 50).names, isEmpty);
    });

    test('LabColor stores names', () {
      final LabColor color = LabColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LabColor(50, 0, 0).names, isEmpty);
    });

    test('XyzColor stores names', () {
      final XYZ color = XYZ(0.5, 0.5, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(XYZ(0.5, 0.5, 0.5).names, isEmpty);
    });

    test('LchColor stores names', () {
      final LchColor color = LchColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LchColor(50, 0, 0).names, isEmpty);
    });

    test('OkLabColor stores names', () {
      final OkLabColor color = OkLabColor(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkLabColor(0.5, 0, 0).names, isEmpty);
    });

    test('OkLchColor stores names', () {
      final OkLCH color = OkLCH(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkLCH(0.5, 0, 0).names, isEmpty);
    });

    test('OkHslColor stores names', () {
      final OkHslColor color = OkHslColor(0, 1, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkHslColor(0, 1, 0.5).names, isEmpty);
    });

    test('OkHsvColor stores names', () {
      final OkHsvColor color = OkHsvColor(0, 1, 1, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkHsvColor(0, 1, 1).names, isEmpty);
    });

    test('Cam16Color stores names', () {
      final Cam16Color color = Cam16Color(0, 0, 50, 0, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(Cam16Color(0, 0, 50, 0, 0, 0).names, isEmpty);
    });

    test('DisplayP3Color stores names', () {
      final DisplayP3Color color = DisplayP3Color(1, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(DisplayP3Color(1, 0, 0).names, isEmpty);
    });

    test('HsluvColor stores names', () {
      final HsluvColor color = HsluvColor(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(HsluvColor(0, 100, 50).names, isEmpty);
    });

    test('HspColor stores names', () {
      final HspColor color = HspColor(0, 1, 1, names: testNames);
      expect(color.names, equals(testNames));
      expect(HspColor(0, 1, 1).names, isEmpty);
    });

    test('HunterLabColor stores names', () {
      final HunterLabColor color = HunterLabColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(HunterLabColor(50, 0, 0).names, isEmpty);
    });

    test('LuvColor stores names', () {
      final LuvColor color = LuvColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LuvColor(50, 0, 0).names, isEmpty);
    });

    test('MunsellColor stores names', () {
      final MunsellColor color = MunsellColor('5R', 5, 10, names: testNames);
      expect(color.names, equals(testNames));
      expect(MunsellColor('5R', 5, 10).names, isEmpty);
    });

    test('Rec2020Color stores names', () {
      final Rec2020Color color =
          Rec2020Color(Percent.max, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(
          Rec2020Color(Percent.max, Percent.zero, Percent.zero).names, isEmpty);
    });

    test('YiqColor stores names', () {
      final YiqColor color = YiqColor(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(YiqColor(0.5, 0, 0).names, isEmpty);
    });

    test('YuvColor stores names', () {
      final YuvColor color = YuvColor(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(YuvColor(0.5, 0, 0).names, isEmpty);
    });
  });
}
