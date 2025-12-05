import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Delta E Tests', () {
    test('Self distance is 0', () {
      final ColorIQ c1 = ColorIQ(0xFFFF0000);
      expect(c1.deltaE(c1, algorithm: DeltaEAlgorithm.cie76), equals(0.0));
      expect(c1.deltaE(c1, algorithm: DeltaEAlgorithm.cie94), equals(0.0));
      expect(c1.deltaE(c1, algorithm: DeltaEAlgorithm.ciede2000), equals(0.0));
    });

    test('CIE76 Calculation', () {
      // Lab(50, 10, 10) vs Lab(50, 20, 20)
      // dL=0, da=10, db=10. dE = sqrt(100+100) = 14.14
      final LabColor c1 = LabColor.alt(50, 10, 10);
      final LabColor c2 = LabColor.alt(50, 20, 20);
      expect(
        c1.deltaE(c2, algorithm: DeltaEAlgorithm.cie76),
        closeTo(14.14, 0.01),
      );
    });

    test('CIEDE2000 L-only difference', () {
      // Lab1: 50, 0, 0
      // Lab2: 60, 0, 0
      // dE76 = 10
      // S_L = 1 + (0.015 * (55-50)^2) / sqrt(20 + (55-50)^2)
      // S_L = 1 + (0.015 * 25) / sqrt(45) = 1 + 0.375 / 6.708 = 1.0559
      // dE2000 = 10 / 1.0559 = 9.47

      final LabColor c1 = LabColor.alt(50, 0, 0);
      final LabColor c2 = LabColor.alt(60, 0, 0);
      expect(
        c1.deltaE(c2, algorithm: DeltaEAlgorithm.ciede2000),
        closeTo(9.47, 0.1),
      );
    });

    test('CIEDE2000 a-only difference', () {
      // Lab1: 50, 0, 0
      // Lab2: 50, 10, 0
      // G factor affects a.
      // C1=0, C2=10. C_bar=5.
      // G = 0.5. a1'=0, a2'=15.
      // C1'=0, C2'=15. dC'=15.
      // S_C = 1 + 0.045 * 7.5 = 1.3375.
      // dE = 15 / 1.3375 = 11.21.

      final LabColor c1 = LabColor.alt(50, 0, 0);
      final LabColor c2 = LabColor.alt(50, 10, 0);
      expect(
        c1.deltaE(c2, algorithm: DeltaEAlgorithm.ciede2000),
        closeTo(11.2, 0.5),
      );
    });

    test('CIEDE2000 b-only difference', () {
      // Lab1: 50, 0, 0
      // Lab2: 50, 0, 10
      // b is not affected by G.
      // C1=0, C2=10. C_bar=5.
      // C1'=0, C2'=10. dC'=10.
      // S_C = 1 + 0.045 * 5 = 1.225.
      // dE = 10 / 1.225 = 8.16.

      final LabColor c1 = LabColor.alt(50, 0, 0);
      final LabColor c2 = LabColor.alt(50, 0, 10);
      expect(
        c1.deltaE(c2, algorithm: DeltaEAlgorithm.ciede2000),
        closeTo(8.16, 0.1),
      );
    });

    test('Extension works on other models', () {
      final ColorIQ red = cRed;
      final ColorIQ green = ColorIQ(0xFF00FF00);

      // Red vs Green is a huge difference
      final double dist = red.deltaE(green);
      expect(dist, greaterThan(40.0));
    });
  });
}
