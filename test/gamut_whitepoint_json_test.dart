import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Gamut, WhitePoint, and JSON', () {
    test('isWithinGamut returns true for sRGB colors', () {
      final color = Color(0xFF00FF00);
      expect(color.isWithinGamut(Gamut.sRGB), isTrue);
      expect(color.isWithinGamut(Gamut.displayP3), isTrue);
    });

    test('whitePoint returns D65 default', () {
      final color = Color(0xFFFFFFFF);
      final wp = color.whitePoint;
      expect(wp.length, 3);
      expect(wp[0], closeTo(95.047, 0.001));
      expect(wp[1], closeTo(100.0, 0.001));
      expect(wp[2], closeTo(108.883, 0.001));
    });

    test('toJson and fromJson for Color', () {
      final color = Color(0xFF123456);
      final json = color.toJson();
      expect(json['type'], 'Color');
      expect(json['value'], 0xFF123456);

      final fromJson = Color.fromJson(json);
      expect(fromJson.toColor().value, color.value);
    });

    test('toJson and fromJson for HsvColor', () {
      final hsv = HsvColor(120, 0.5, 0.8);
      final json = hsv.toJson();
      expect(json['type'], 'HsvColor');
      expect(json['hue'], 120);
      expect(json['saturation'], 0.5);
      expect(json['value'], 0.8);

      final fromJson = Color.fromJson(json) as HsvColor;
      expect(fromJson.h, 120);
      expect(fromJson.s, 0.5);
      expect(fromJson.v, 0.8);
    });

    test('toJson and fromJson for HslColor', () {
      final hsl = HslColor(240, 0.6, 0.4);
      final json = hsl.toJson();
      expect(json['type'], 'HslColor');
      expect(json['hue'], 240);
      expect(json['saturation'], 0.6);
      expect(json['lightness'], 0.4);

      final fromJson = Color.fromJson(json) as HslColor;
      expect(fromJson.h, 240);
      expect(fromJson.s, 0.6);
      expect(fromJson.l, 0.4);
    });

    test('toJson and fromJson for LabColor', () {
      final lab = LabColor(50, 10, -20);
      final json = lab.toJson();
      expect(json['type'], 'LabColor');
      expect(json['l'], 50);
      expect(json['a'], 10);
      expect(json['b'], -20);

      final fromJson = Color.fromJson(json) as LabColor;
      expect(fromJson.l, 50);
      expect(fromJson.a, 10);
      expect(fromJson.b, -20);
    });

    test('toJson and fromJson for XyzColor', () {
      final xyz = XyzColor(20, 30, 40);
      final json = xyz.toJson();
      expect(json['type'], 'XyzColor');
      expect(json['x'], 20);
      expect(json['y'], 30);
      expect(json['z'], 40);

      final fromJson = Color.fromJson(json) as XyzColor;
      expect(fromJson.x, 20);
      expect(fromJson.y, 30);
      expect(fromJson.z, 40);
    });

    test('toJson and fromJson for CmykColor', () {
      final cmyk = CmykColor(0.1, 0.2, 0.3, 0.4);
      final json = cmyk.toJson();
      expect(json['type'], 'CmykColor');
      expect(json['c'], 0.1);
      expect(json['m'], 0.2);
      expect(json['y'], 0.3);
      expect(json['k'], 0.4);

      final fromJson = Color.fromJson(json) as CmykColor;
      expect(fromJson.c, 0.1);
      expect(fromJson.m, 0.2);
      expect(fromJson.y, 0.3);
      expect(fromJson.k, 0.4);
    });
    
    test('toJson and fromJson for LchColor', () {
      final lch = LchColor(60, 30, 180);
      final json = lch.toJson();
      expect(json['type'], 'LchColor');
      expect(json['l'], 60);
      expect(json['c'], 30);
      expect(json['h'], 180);

      final fromJson = Color.fromJson(json) as LchColor;
      expect(fromJson.l, 60);
      expect(fromJson.c, 30);
      expect(fromJson.h, 180);
    });

    test('Rec2020Color toJson', () {
      final rec2020 = Rec2020Color(0.1, 0.2, 0.3);
      final json = rec2020.toJson();
      expect(json['type'], 'Rec2020Color');
      expect(json['r'], 0.1);
      expect(json['g'], 0.2);
      expect(json['b'], 0.3);
    });

    test('DisplayP3Color toJson', () {
      final p3 = DisplayP3Color(0.4, 0.5, 0.6);
      final json = p3.toJson();
      expect(json['type'], 'DisplayP3Color');
      expect(json['r'], 0.4);
      expect(json['g'], 0.5);
      expect(json['b'], 0.6);
    });
  });
}
