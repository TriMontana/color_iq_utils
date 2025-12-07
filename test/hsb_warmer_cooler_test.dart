import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HsbColor Warmer/Cooler Tests', () {
    test('warmer shifts hue towards 30 degrees', () {
      final HsbColor color = HsbColor(180, 1.0, Percent.max); // Cyan
      final HsbColor warmed = color.warmer(20);

      // Target is 30. 180 -> 30 shortest path is via 0/360? No, 180-30 = 150.
      // 180 + 150 = 330? No.
      // differenceDegrees(30, 180) = 150.
      // diff = 30 - 180 = -150.
      // newHue = 180 + (-150 * 0.2) = 180 - 30 = 150.
      // Wait, 150 is closer to 30 than 180? Yes.

      expect(warmed.h, closeTo(150, 0.1));
    });

    test('cooler shifts hue towards 210 degrees', () {
      final HsbColor color = HsbColor(30, 1.0, Percent.max); // Orange
      color.cooler(20);

      // Target is 210. 30 -> 210. Diff = 180.
      // 30 + (180 * 0.2) = 30 + 36 = 66.
      // Wait, 180 degrees apart means either direction is fine.
      // Let's try 0 (Red). Target 210.
      // Diff = 210 - 0 = 210. > 180 -> 210 - 360 = -150.
      // NewHue = 0 + (-150 * 0.2) = -30 -> 330.

      final HsbColor red = HsbColor(0, 1.0, Percent.max);
      final HsbColor cooledRed = red.cooler(20);
      expect(cooledRed.h, closeTo(330, 0.1));
    });
  });
}
