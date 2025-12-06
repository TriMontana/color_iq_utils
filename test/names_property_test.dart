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
      final CmykColor color = CmykColor.alt(0, 1, 1, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(CmykColor.alt(0, 1, 1, 0).names, isEmpty);
    });

    test('HslColor stores names', () {
      final HslColor color = HslColor.alt(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(HslColor.alt(0, 100, 50).names, isEmpty);
    });

    test('HsvColor stores names', () {
      final HsvColor color = HsvColor.alt(0, 100, 100, names: testNames);
      expect(color.names, equals(testNames));
      expect(HsvColor.alt(0, 100, 100).names, isEmpty);
    });

    test('HsbColor stores names', () {
      final HsbColor color = HsbColor.alt(0, 100, 100, names: testNames);
      expect(color.names, equals(testNames));
      expect(HsbColor.alt(0, 100, 100).names, isEmpty);
    });

    test('HwbColor stores names', () {
      final HwbColor color = HwbColor.alt(0, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(HwbColor.alt(0, 0, 0).names, isEmpty);
    });

    test('HctColor stores names', () {
      final HctColor color = HctColor.alt(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(HctColor.alt(0, 100, 50).names, isEmpty);
    });

    test('LabColor stores names', () {
      final LabColor color = LabColor.alt(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LabColor.alt(50, 0, 0).names, isEmpty);
    });

    test('XyzColor stores names', () {
      final XyzColor color = XyzColor.alt(0.5, 0.5, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(XyzColor.alt(0.5, 0.5, 0.5).names, isEmpty);
    });

    test('LchColor stores names', () {
      final LchColor color = LchColor.alt(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LchColor.alt(50, 0, 0).names, isEmpty);
    });

    test('OkLabColor stores names', () {
      final OkLabColor color = OkLabColor.alt(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkLabColor.alt(0.5, 0, 0).names, isEmpty);
    });

    test('OkLchColor stores names', () {
      final OkLchColor color =
          OkLchColor.alt(const Percent(0.5), 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkLchColor.alt(const Percent(0.5), 0, 0).names, isEmpty);
    });

    test('OkHslColor stores names', () {
      final OkHslColor color = OkHslColor.alt(0, 1, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkHslColor.alt(0, 1, 0.5).names, isEmpty);
    });

    test('OkHsvColor stores names', () {
      final OkHsvColor color = OkHsvColor.alt(0, 1, 1, names: testNames);
      expect(color.names, equals(testNames));
      expect(OkHsvColor.alt(0, 1, 1).names, isEmpty);
    });

    test('Cam16Color stores names', () {
      final Cam16Color color =
          Cam16Color.alt(0, 0, 50, 0, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(Cam16Color.alt(0, 0, 50, 0, 0, 0).names, isEmpty);
    });

    test('DisplayP3Color stores names', () {
      final DisplayP3Color color =
          DisplayP3Color.alt(1, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(DisplayP3Color.alt(1, 0, 0).names, isEmpty);
    });

    test('HsluvColor stores names', () {
      final HsluvColor color = HsluvColor.alt(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(HsluvColor.alt(0, 100, 50).names, isEmpty);
    });

    test('HspColor stores names', () {
      final HspColor color = HspColor.alt(0, 1, 1, names: testNames);
      expect(color.names, equals(testNames));
      expect(HspColor.alt(0, 1, 1).names, isEmpty);
    });

    test('HunterLabColor stores names', () {
      final HunterLabColor color =
          HunterLabColor.alt(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(HunterLabColor.alt(50, 0, 0).names, isEmpty);
    });

    test('LuvColor stores names', () {
      final LuvColor color = LuvColor.alt(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LuvColor.alt(50, 0, 0).names, isEmpty);
    });

    test('MunsellColor stores names', () {
      final MunsellColor color =
          MunsellColor.alt('5R', 5, 10, names: testNames);
      expect(color.names, equals(testNames));
      expect(MunsellColor.alt('5R', 5, 10).names, isEmpty);
    });

    test('Rec2020Color stores names', () {
      final Rec2020Color color = Rec2020Color.alt(1, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(Rec2020Color.alt(1, 0, 0).names, isEmpty);
    });

    test('YiqColor stores names', () {
      final YiqColor color = YiqColor.alt(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(YiqColor.alt(0.5, 0, 0).names, isEmpty);
    });

    test('YuvColor stores names', () {
      final YuvColor color = YuvColor.alt(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(YuvColor.alt(0.5, 0, 0).names, isEmpty);
    });
  });
}
