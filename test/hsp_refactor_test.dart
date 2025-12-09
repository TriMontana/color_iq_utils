import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('HspColor Refactor Tests', () {
    test('whiten increases brightness and desaturates', () {
      const HSP color = HSP(0, 1.0, Percent.mid); // Dark Red
      final HSP whitened = color.whiten(Percent.mid);

      expect(whitened.p, greaterThan(color.p));
      expect(whitened.s, lessThan(color.s));
    });

    test('blacken decreases brightness and desaturates', () {
      const HSP color = HSP(0, 1.0, Percent.max); // Red
      final HSP blackened = color.blacken(Percent.mid);

      expect(blackened.p, lessThan(color.p));
      expect(blackened.s, lessThan(color.s));
    });

    test('lerp interpolates correctly', () {
      const HSP start = HSP(0, 1.0, Percent.max); // Red
      const HSP end = HSP(120, 1.0, Percent.max); // Green
      final HSP mid = start.lerp(end, 0.5);

      expect(mid.h, closeTo(60, 0.1)); // Yellow
      expect(mid.s, closeTo(1.0, 0.01));
      expect(mid.p, closeTo(1.0, 0.01));
    });

    test('intensify increases saturation', () {
      const HSP color = HSP(0, Percent.mid, Percent.max);
      final HSP intensified = color.intensify(Percent.v20);

      expect(intensified.s, closeTo(0.7, 0.01));
    });

    test('deintensify decreases saturation', () {
      const HSP color = HSP(0, Percent.mid, Percent.max);
      final HSP deintensified = color.deintensify(Percent.v20);

      expect(deintensified.s, closeTo(0.3, 0.01));
    });
  });
}
