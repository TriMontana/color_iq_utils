import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HslColor Refactor Tests', () {
    test('whiten increases lightness and desaturates', () {
      const HSL color = HSL(0, 1.0, Percent.mid); // Red
      final HSL whitened = color.whiten(Percent.mid);

      expect(whitened.l, greaterThan(color.l));
      expect(whitened.s, lessThan(color.s));
      //
    });

    test('blacken decreases lightness and desaturates', () {
      const HSL color = HSL(0, 1.0, Percent.mid); // Red
      final HSL blackened = color.blacken(Percent.mid);

      expect(blackened.l, lessThan(color.l));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HSL start = HSL(0, 1.0, Percent.mid); // Red
      const HSL end = HSL(120, 1.0, Percent.mid); // Green
      final HSL mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.l, closeTo(0.5, 0.01));
    });

    test('intensify increases saturation', () {
      const HSL color = HSL(0, Percent.mid, Percent.mid);
      final HSL intensified = color.intensify(20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HSL color = HSL(0, Percent.mid, Percent.mid);
      final HSL deintensified = color.deintensify(20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
