import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('OkLchColor Tests', () {
    test('grayscale sets chroma to 0', () {
      const OkLchColor color = OkLchColor(0.5, 0.2, 180.0);
      final OkLchColor gray = color.grayscale;
      expect(gray.l, equals(color.l));
      expect(gray.c, equals(0.0));
      expect(gray.h, equals(color.h));
    });

    test('whiten moves towards white', () {
      const OkLchColor color = OkLchColor(0.0, 0.0, 0.0); // Black
      final OkLchColor whitened = color.whiten(50);
      // White is approx L=1.0, C=0.0, H=0.0 (or undefined)
      // Lerp 50% from Black (L=0) to White (L=1) -> L=0.5
      expect(whitened.l, closeTo(0.5, 0.01));
    });

    test('blacken moves towards black', () {
      const OkLchColor color = OkLchColor(1.0, 0.0, 0.0); // White
      final OkLchColor blackened = color.blacken(50);
      // Lerp 50% from White (L=1) to Black (L=0) -> L=0.5
      expect(blackened.l, closeTo(0.5, 0.01));
    });

    test('lerp interpolates correctly', () {
      const OkLchColor color1 = OkLchColor(0.0, 0.0, 0.0);
      const OkLchColor color2 = OkLchColor(1.0, 0.2, 100.0);
      final OkLchColor lerped = color1.lerp(color2, 0.5);
      expect(lerped.l, closeTo(0.5, 0.001));
      expect(lerped.c, closeTo(0.1, 0.001));
      expect(lerped.h, closeTo(50.0, 0.001));
    });
  });
}
