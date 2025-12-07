import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkLchColor Refactor Tests', () {
    test('whiten increases lightness', () {
      final OkLCH color = OkLCH(const Percent(0.5), 0.2, 0); // Red-ish
      final OkLCH whitened = color.whiten(50);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.c, lessThan(color.c));
    });

    test('blacken decreases lightness', () {
      final OkLCH color = OkLCH(const Percent(0.5), 0.2, 0); // Red-ish
      final OkLCH blackened = color.blacken(50);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.c, lessThan(color.c));
    });

    test('lerp interpolates correctly', () {
      final OkLCH start = OkLCH(const Percent(0.5), 0.2, 0); // Red-ish
      final OkLCH end = OkLCH(const Percent(0.5), 0.2, 120); // Green-ish
      final OkLCH mid = start.lerp(end, 0.5);

      expect(mid.l, closeTo(0.5, 0.01));
      expect(mid.c, closeTo(0.2, 0.01));
      expect(mid.h, closeTo(60, 0.1)); // Yellow-ish
    });

    test('lerp handles hue wrapping', () {
      final OkLCH start = OkLCH(Percent.mid, 0.2, 350);
      final OkLCH end = OkLCH(Percent.mid, 0.2, 10);
      final OkLCH mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(0, 0.1));
    });

    test('adjustHue works', () {
      final OkLCH color = OkLCH(Percent.mid, 0.2, 0);
      final OkLCH adjusted = color.adjustHue(90);
      expect(adjusted.h, closeTo(90, 0.1));
    });

    test('complementary works', () {
      final OkLCH color = OkLCH(Percent.mid, 0.2, 0);
      final OkLCH comp = color.complementary;
      expect(comp.h, closeTo(180, 0.1));
    });

    test('warmer shifts hue towards 30', () {
      final OkLCH color = OkLCH(Percent.mid, 0.2, 0);
      final OkLCH warmed = color.warmer(50);
      expect(warmed.h, closeTo(15, 0.1)); // Halfway to 30
    });

    test('cooler shifts hue towards 210', () {
      final OkLCH color = OkLCH(Percent.mid, 0.2, 180);
      final OkLCH cooled = color.cooler(50);
      expect(cooled.h, closeTo(195, 0.1)); // Halfway to 210
    });
  });
}
