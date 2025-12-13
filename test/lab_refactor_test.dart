import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('LabColor Refactor Tests', () {
    test('whiten increases lightness', () {
      final CIELab color = CIELab(50.0, 0.0, 0.0); // Gray
      final CIELab whitened = color.whiten(50);
      expect(whitened.l, greaterThan(color.l));
      print('✓ LabColor Refactor Tests');
    });

    test('blacken decreases lightness', () {
      final CIELab color = CIELab(50.0, 0.0, 0.0); // Gray
      final CIELab blackened = color.blacken(50);
      expect(blackened.l, lessThan(color.l));
      print('✓ LabColor Refactor Tests');
    });

    // const int hxDarkSlateBlue = 0xFF483D8B;
    // https://apps.colorjs.io/convert/?color=%23483D8B&precision=4
    test('Lab RAW test', () {
      final ColorIQ testColor = cDarkSlateBlue;
       final CIELab lab = testColor.lab;
      expect(lab.l, closeTo(30.828, 0.01));
      expect(lab.aLab, closeTo(26.051, 0.01));
      expect(lab.bLab, closeTo(-42.083, 0.01));
      print('✓ LabColor RAW Tests, ${lab.toString()}');
    });

    test('lerp interpolates correctly', () {
      final CIELab start = CIELab(0.0, 0.0, 0.0); // Black
      final CIELab end = CIELab(100.0, 0.0, 0.0); // White
      final CIELab mid = start.lerp(end, 0.5);
      expect(mid.l, closeTo(50.0, 0.01));
      expect(mid.aLab, closeTo(0.0, 0.01));
      expect(mid.bLab, closeTo(0.0, 0.01));
      print('✓ LabColor Refactor Tests');
    });
  });
}
