import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Names Property Tests', () {
    const List<String> testNames = <String>['Alias1', 'Alias2'];

    test('ColorIQ stores names', () {
      final ColorIQ color =
          ColorIQ.fromArgbInts(255, 255, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(ColorIQ(0xFFFF0000).names, isEmpty);
    });

    test('CmykColor stores names', () {
      const CMYK color = CMYK(0, 1, 1, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const CMYK(0, 1, 1, 0).names, isEmpty);
    });

    test('HslColor stores names', () {
      const HSL color = HSL(0, 1.0, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HSL(0, 1.0, 0.5).names, isEmpty);
    });

    test('HsvColor stores names', () {
      const HSV color = HSV(0, 1.0, Percent.max, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HSV(0, 1.0, Percent.max).names, isEmpty);
    });

    test('HsbColor stores names', () {
      const HsbColor color = HsbColor(0, 1.0, Percent.max, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HsbColor(0, 1.0, Percent.max).names, isEmpty);
    });

    test('HwbColor stores names', () {
      const HwbColor color = HwbColor(0, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HwbColor(0, 0, 0).names, isEmpty);
    });

    test('HctColor stores names', () {
      const HctColor color = HctColor(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HctColor(0, 100, 50).names, isEmpty);
    });

    test('LabColor stores names', () {
      final LabColor color = LabColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(LabColor(50, 0, 0).names, isEmpty);
    });

    test('XyzColor stores names', () {
      const XYZ color = XYZ(0.5, 0.5, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(const XYZ(0.5, 0.5, 0.5).names, isEmpty);
    });

    test('LchColor stores names', () {
      const LchColor color = LchColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const LchColor(50, 0, 0).names, isEmpty);
    });

    test('OkLabColor stores names', () {
      const OkLabColor color = OkLabColor(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const OkLabColor(0.5, 0, 0).names, isEmpty);
    });

    test('OkLchColor stores names', () {
      const OkLCH color = OkLCH(Percent.mid, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const OkLCH(Percent.mid, 0, 0).names, isEmpty);
    });

    test('OkHslColor stores names', () {
      const OkHslColor color = OkHslColor(0, 1, 0.5, names: testNames);
      expect(color.names, equals(testNames));
      expect(const OkHslColor(0, 1, 0.5).names, isEmpty);
    });

    test('OkHsvColor stores names', () {
      const OkHsvColor color = OkHsvColor(0, 1, 1, names: testNames);
      expect(color.names, equals(testNames));
      expect(const OkHsvColor(0, 1, 1).names, isEmpty);
    });

    test('DisplayP3Color stores names', () {
      const DisplayP3Color color = DisplayP3Color(
          Percent.max, Percent.zero, Percent.zero,
          names: testNames);
      expect(color.names, equals(testNames));
      expect(
          const DisplayP3Color(Percent.max, Percent.zero, Percent.zero).names,
          isEmpty);
    });

    test('HsluvColor stores names', () {
      const HsluvColor color = HsluvColor(0, 100, 50, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HsluvColor(0, 100, 50).names, isEmpty);
    });

    test('HspColor stores names', () {
      const HSP color = HSP(0, 1, 1, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HSP(0, 1, 1).names, isEmpty);
    });

    test('HunterLabColor stores names', () {
      const HunterLabColor color = HunterLabColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const HunterLabColor(50, 0, 0).names, isEmpty);
    });

    test('LuvColor stores names', () {
      const LuvColor color = LuvColor(50, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const LuvColor(50, 0, 0).names, isEmpty);
    });

    test('MunsellColor stores names', () {
      const MunsellColor color = MunsellColor('5R', 5, 10, names: testNames);
      expect(color.names, equals(testNames));
      expect(const MunsellColor('5R', 5, 10).names, isEmpty);
    });

    test('Rec2020Color stores names', () {
      const Rec2020Color color = Rec2020Color(
          Percent.max, Percent.zero, Percent.zero,
          names: testNames);
      expect(color.names, equals(testNames));
      expect(const Rec2020Color(Percent.max, Percent.zero, Percent.zero).names,
          isEmpty);
    });

    test('YiqColor stores names', () {
      const YiqColor color = YiqColor(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const YiqColor(0.5, 0, 0).names, isEmpty);
    });

    test('YuvColor stores names', () {
      const YuvColor color = YuvColor(0.5, 0, 0, names: testNames);
      expect(color.names, equals(testNames));
      expect(const YuvColor(0.5, 0, 0).names, isEmpty);
    });
  });
}
