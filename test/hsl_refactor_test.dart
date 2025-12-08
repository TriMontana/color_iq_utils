import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HslColor Refactor Tests', () {
    test('whiten increases lightness and desaturates', () {
      const HslColor color = HslColor(0, 1.0, Percent.mid); // Red
      final HslColor whitened = color.whiten(Percent.mid);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases lightness and desaturates', () {
      const HslColor color = HslColor(0, 1.0, Percent.mid); // Red
      final HslColor blackened = color.blacken(Percent.mid);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HslColor start = HslColor(0, 1.0, Percent.mid); // Red
      const HslColor end = HslColor(120, 1.0, Percent.mid); // Green
      final HslColor mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.l, closeTo(0.5, 0.01));
    });

    test('intensify increases saturation', () {
      const HslColor color = HslColor(0, Percent.mid, Percent.mid);
      final HslColor intensified = color.intensify(Percent.v20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HslColor color = HslColor(0, Percent.mid, Percent.mid);
      final HslColor deintensified = color.deintensify(Percent.v20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
