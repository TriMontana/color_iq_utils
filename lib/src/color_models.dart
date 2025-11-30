import 'dart:math';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import 'color_interfaces.dart';

/// A color represented by red, green, blue, and alpha components.
class Color implements ColorSpace {
  /// The 32-bit alpha-red-green-blue integer value.
  @override
  final int value;

  /// Construct a color from the lower 32 bits of an [int].
  const Color(this.value);

  /// Construct a color from 4 integers, a, r, g, b.
  const Color.fromARGB(int a, int r, int g, int b)
      : value = (((a & 0xff) << 24) |
                ((r & 0xff) << 16) |
                ((g & 0xff) << 8) |
                ((b & 0xff) << 0)) &
            0xFFFFFFFF;

  /// The alpha channel of this color in an 8-bit value.
  int get alpha => (value >> 24) & 0xFF;

  /// The red channel of this color in an 8-bit value.
  int get red => (value >> 16) & 0xFF;

  /// The green channel of this color in an 8-bit value.
  int get green => (value >> 8) & 0xFF;

  /// The blue channel of this color in an 8-bit value.
  int get blue => value & 0xFF;

  /// Converts this color to CMYK.
  CmykColor toCmyk() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CmykColor(0, 0, 0, 1);
    }

    double c = (1.0 - r - k) / (1.0 - k);
    double m = (1.0 - g - k) / (1.0 - k);
    double y = (1.0 - b - k) / (1.0 - k);

    return CmykColor(c, m, y, k);
  }

  /// Converts this color to XYZ.
  XyzColor toXyz() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    r *= 100;
    g *= 100;
    b *= 100;

    double x = r * 0.4124 + g * 0.3576 + b * 0.1805;
    double y = r * 0.2126 + g * 0.7152 + b * 0.0722;
    double z = r * 0.0193 + g * 0.1192 + b * 0.9505;

    return XyzColor(x, y, z);
  }

  /// Converts this color to CIELab.
  LabColor toLab() => toXyz().toLab();

  /// Converts this color to CIELuv.
  LuvColor toLuv() => toXyz().toLuv();

  /// Converts this color to CIELCH.
  LchColor toLch() => toLab().toLch();

  /// Converts this color to HSP.
  HspColor toHsp() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double p = sqrt(0.299 * r * r + 0.587 * g * g + 0.114 * b * b);
    
    double minVal = min(r, min(g, b));
    double maxVal = max(r, max(g, b));
    double delta = maxVal - minVal;
    
    double h = 0;
    if (delta != 0) {
      if (maxVal == r) {
        h = (g - b) / delta;
      } else if (maxVal == g) {
        h = 2 + (b - r) / delta;
      } else {
        h = 4 + (r - g) / delta;
      }
      h *= 60;
      if (h < 0) h += 360;
    }
    
    double s = (maxVal == 0) ? 0 : delta / maxVal;

    return HspColor(h, s, p);
  }

  /// Converts this color to YIQ.
  YiqColor toYiq() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double y = 0.299 * r + 0.587 * g + 0.114 * b;
    double i = 0.596 * r - 0.274 * g - 0.322 * b;
    double q = 0.211 * r - 0.523 * g + 0.312 * b;

    return YiqColor(y, i, q);
  }

  /// Converts this color to YUV.
  YuvColor toYuv() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double y = 0.299 * r + 0.587 * g + 0.114 * b;
    double u = -0.14713 * r - 0.28886 * g + 0.436 * b;
    double v = 0.615 * r - 0.51499 * g - 0.10001 * b;

    return YuvColor(y, u, v);
  }

  /// Converts this color to OkLab.
  OkLabColor toOkLab() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    double l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
    double m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
    double s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;

    double l_ = pow(l, 1/3).toDouble();
    double m_ = pow(m, 1/3).toDouble();
    double s_ = pow(s, 1/3).toDouble();

    double L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_;
    double a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_;
    double b_val = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_;

    return OkLabColor(L, a, b_val);
  }

  /// Converts this color to OkLch.
  OkLchColor toOkLch() => toOkLab().toOkLch();

  /// Converts this color to OkHSL.
  OkHslColor toOkHsl() => toOkLab().toOkHsl();

  /// Converts this color to OkHSV.
  OkHsvColor toOkHsv() => toOkLab().toOkHsv();

  /// Converts this color to Hunter Lab.
  HunterLabColor toHunterLab() {
    XyzColor xyz = toXyz();
    double x = xyz.x;
    double y = xyz.y;
    double z = xyz.z;

    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    double lOut = 100.0 * sqrt(y / yn);
    double aOut = 175.0 * (x / xn - y / yn) / sqrt(y / yn);
    double bOut = 70.0 * (y / yn - z / zn) / sqrt(y / yn);
    
    if (y == 0) {
        aOut = 0;
        bOut = 0;
    }

    return HunterLabColor(lOut, aOut, bOut);
  }

  /// Converts this color to HSLuv.
  HsluvColor toHsluv() {
     LuvColor luv = toLuv();
     double c = sqrt(luv.u * luv.u + luv.v * luv.v);
     double h = atan2(luv.v, luv.u) * 180 / pi;
     if (h < 0) h += 360;
     return HsluvColor(h, c, luv.l);
  }
  
  /// Converts this color to Munsell.
  MunsellColor toMunsell() {
      return MunsellColor("N", 0, 0); 
  }

  /// Converts this color to HSL.
  HslColor toHsl() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double h, s, l = (maxVal + minVal) / 2;

    if (maxVal == minVal) {
      h = s = 0; // achromatic
    } else {
      double d = maxVal - minVal;
      s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal);
      if (maxVal == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    return HslColor(h * 360, s, l);
  }

  /// Converts this color to HSV.
  HsvColor toHsv() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double h, s, v = maxVal;

    double d = maxVal - minVal;
    s = maxVal == 0 ? 0 : d / maxVal;

    if (maxVal == minVal) {
      h = 0; // achromatic
    } else {
      if (maxVal == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    return HsvColor(h * 360, s, v);
  }

  /// Converts this color to HSB (Alias for HSV).
  HsbColor toHsb() {
      HsvColor hsv = toHsv();
      return HsbColor(hsv.h, hsv.s, hsv.v);
  }

  /// Converts this color to HWB.
  HwbColor toHwb() {
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    double maxVal = max(r, max(g, b));
    double minVal = min(r, min(g, b));
    double h = 0;
    
    if (maxVal == minVal) {
        h = 0;
    } else {
        double d = maxVal - minVal;
        if (maxVal == r) {
            h = (g - b) / d + (g < b ? 6 : 0);
        } else if (maxVal == g) {
            h = (b - r) / d + 2;
        } else {
            h = (r - g) / d + 4;
        }
        h /= 6;
    }
    
    double w = minVal;
    double bl = 1 - maxVal;

    return HwbColor(h * 360, w, bl);
  }

  /// Converts this color to Hct (Material Color Utilities).
  HctColor toHct() {
      int argb = value;
      mcu.Hct hct = mcu.Hct.fromInt(argb);
      return HctColor(hct.hue, hct.chroma, hct.tone);
  }

  /// Converts this color to Cam16 (Material Color Utilities).
  Cam16Color toCam16() {
      int argb = value;
      mcu.Cam16 cam = mcu.Cam16.fromInt(argb);
      return Cam16Color(cam.hue, cam.chroma, cam.j, cam.m, cam.s, cam.q);
  }
  
  /// Converts this color to Display P3.
  DisplayP3Color toDisplayP3() {
      // Linearize sRGB
      double r = red / 255.0;
      double g = green / 255.0;
      double b = blue / 255.0;
      
      r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
      g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
      b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);
      
      // sRGB Linear to XYZ (D65)
      double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
      double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
      double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;
      
      // XYZ (D65) to Display P3 Linear
      // Matrix from http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
      // or Apple's specs.
      // Using standard P3 D65 matrix.
      
      double rP3 = x * 2.4934969 + y * -0.9313836 + z * -0.4027107;
      double gP3 = x * -0.8294889 + y * 1.7626640 + z * 0.0236246;
      double bP3 = x * 0.0358458 + y * -0.0761723 + z * 0.9568845;
      
      // Gamma correction (Transfer function) for Display P3 is sRGB curve.
      rP3 = (rP3 > 0.0031308) ? (1.055 * pow(rP3, 1 / 2.4) - 0.055) : (12.92 * rP3);
      gP3 = (gP3 > 0.0031308) ? (1.055 * pow(gP3, 1 / 2.4) - 0.055) : (12.92 * gP3);
      bP3 = (bP3 > 0.0031308) ? (1.055 * pow(bP3, 1 / 2.4) - 0.055) : (12.92 * bP3);
      
      return DisplayP3Color(rP3, gP3, bP3);
  }
  
  /// Converts this color to Rec. 2020.
  Rec2020Color toRec2020() {
      // Linearize sRGB
      double r = red / 255.0;
      double g = green / 255.0;
      double b = blue / 255.0;
      
      r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
      g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
      b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);
      
      // sRGB Linear to XYZ (D65)
      double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
      double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
      double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;
      
      // XYZ (D65) to Rec. 2020 Linear
      double r2020 = x * 1.7166511 + y * -0.3556707 + z * -0.2533662;
      double g2020 = x * -0.6666843 + y * 1.6164812 + z * 0.0157685;
      double b2020 = x * 0.0176398 + y * -0.0427706 + z * 0.9421031;
      
      // Gamma correction for Rec. 2020
      // alpha = 1.099, beta = 0.018 for 10-bit system, but often 2.4 or 2.2 is used in practice for display.
      // Official Rec. 2020 transfer function:
      // if E < beta * delta: 4.5 * E
      // else: alpha * E^(0.45) - (alpha - 1)
      // alpha = 1.099, beta = 0.018, delta = ? 
      // Actually: if L < 0.018: 4.5 * L, else 1.099 * L^0.45 - 0.099
      
      double transfer(double v) {
          if (v < 0.018) return 4.5 * v;
          return 1.099 * pow(v, 0.45) - 0.099;
      }
      
      return Rec2020Color(transfer(r2020), transfer(g2020), transfer(b2020));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Color && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Color(0x${value.toRadixString(16).padLeft(8, '0')})';
}

class CmykColor implements ColorSpace {
  final double c;
  final double m;
  final double y;
  final double k;

  const CmykColor(this.c, this.m, this.y, this.k);

  Color toColor() {
    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);
    return Color.fromARGB(255, r.round(), g.round(), b.round());
  }
  
  @override
  int get value => toColor().value;

  @override
  bool operator ==(Object other) => other is CmykColor && other.c == c && other.m == m && other.y == y && other.k == k;
  
  @override
  int get hashCode => Object.hash(c, m, y, k);
  
  @override
  String toString() => 'CmykColor(c: ${c.toStringAsFixed(2)}, m: ${m.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';
}

class XyzColor implements ColorSpace {
  final double x;
  final double y;
  final double z;

  const XyzColor(this.x, this.y, this.z);

  Color toColor() {
    double xTemp = x / 100;
    double yTemp = y / 100;
    double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double b = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    b = (b > 0.0031308) ? (1.055 * pow(b, 1 / 2.4) - 0.055) : (12.92 * b);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  LabColor toLab() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    double xTemp = x / refX;
    double yTemp = y / refY;
    double zTemp = z / refZ;

    xTemp = (xTemp > 0.008856) ? pow(xTemp, 1 / 3).toDouble() : (7.787 * xTemp) + (16 / 116);
    yTemp = (yTemp > 0.008856) ? pow(yTemp, 1 / 3).toDouble() : (7.787 * yTemp) + (16 / 116);
    zTemp = (zTemp > 0.008856) ? pow(zTemp, 1 / 3).toDouble() : (7.787 * zTemp) + (16 / 116);

    double l = (116 * yTemp) - 16;
    double a = 500 * (xTemp - yTemp);
    double b = 200 * (yTemp - zTemp);

    return LabColor(l, a, b);
  }

  LuvColor toLuv() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    double u = (4 * x) / (x + (15 * y) + (3 * z));
    double v = (9 * y) / (x + (15 * y) + (3 * z));

    double yTemp = y / 100.0;
    yTemp = (yTemp > 0.008856) ? pow(yTemp, 1 / 3).toDouble() : (7.787 * yTemp) + (16 / 116);

    double l = (116 * yTemp) - 16;
    double uOut = 13 * l * (u - refU);
    double vOut = 13 * l * (v - refV);
    
    if (x + 15 * y + 3 * z == 0) {
      uOut = 0;
      vOut = 0;
    }

    return LuvColor(l, uOut, vOut);
  }
  
  @override
  String toString() => 'XyzColor(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';
}

class LabColor implements ColorSpace {
  final double l;
  final double a;
  final double b;

  const LabColor(this.l, this.a, this.b);

  XyzColor toXyz() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;

    double yTemp = (l + 16) / 116;
    double xTemp = a / 500 + yTemp;
    double zTemp = yTemp - b / 200;

    double x3 = pow(xTemp, 3).toDouble();
    double y3 = pow(yTemp, 3).toDouble();
    double z3 = pow(zTemp, 3).toDouble();

    double xOut = (x3 > 0.008856) ? x3 : (xTemp - 16 / 116) / 7.787;
    double yOut = (y3 > 0.008856) ? y3 : (yTemp - 16 / 116) / 7.787;
    double zOut = (z3 > 0.008856) ? z3 : (zTemp - 16 / 116) / 7.787;

    return XyzColor(xOut * refX, yOut * refY, zOut * refZ);
  }

  Color toColor() => toXyz().toColor();
  
  @override
  int get value => toColor().value;

  LchColor toLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi;
    if (h < 0) h += 360;
    return LchColor(l, c, h);
  }
  
  @override
  String toString() => 'LabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

class LuvColor implements ColorSpace {
  final double l;
  final double u;
  final double v;

  const LuvColor(this.l, this.u, this.v);

  XyzColor toXyz() {
    const double refX = 95.047;
    const double refY = 100.000;
    const double refZ = 108.883;
    
    const double refU = (4 * refX) / (refX + (15 * refY) + (3 * refZ));
    const double refV = (9 * refY) / (refX + (15 * refY) + (3 * refZ));

    double yOut = (l + 16) / 116;
    if (pow(yOut, 3) > 0.008856) {
      yOut = pow(yOut, 3).toDouble();
    } else {
      yOut = (yOut - 16 / 116) / 7.787;
    }

    double uTemp = u / (13 * l) + refU;
    double vTemp = v / (13 * l) + refV;
    
    if (l == 0) {
        uTemp = 0;
        vTemp = 0;
    }

    double yFinal = yOut * 100;
    double xFinal = -(9 * yFinal * uTemp) / ((uTemp - 4) * vTemp - uTemp * vTemp);
    double zFinal = (9 * yFinal - (15 * vTemp * yFinal) - (vTemp * xFinal)) / (3 * vTemp);

    return XyzColor(xFinal, yFinal, zFinal);
  }
  
  Color toColor() => toXyz().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'LuvColor(l: ${l.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}

class LchColor implements ColorSpace {
  final double l;
  final double c;
  final double h;

  const LchColor(this.l, this.c, this.h);

  LabColor toLab() {
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);
    return LabColor(l, a, b);
  }

  Color toColor() => toLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'LchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}

class HspColor implements ColorSpace {
  final double h;
  final double s;
  final double p;

  const HspColor(this.h, this.s, this.p);

  Color toColor() {
    return Color.fromARGB(255, 0, 0, 0); 
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HspColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, p: ${p.toStringAsFixed(2)})';
}

class YiqColor implements ColorSpace {
  final double y;
  final double i;
  final double q;

  const YiqColor(this.y, this.i, this.q);

  Color toColor() {
    double r = y + 0.956 * i + 0.621 * q;
    double g = y - 0.272 * i - 0.647 * q;
    double b = y - 1.106 * i + 1.703 * q;
    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'YiqColor(y: ${y.toStringAsFixed(2)}, i: ${i.toStringAsFixed(2)}, q: ${q.toStringAsFixed(2)})';
}

class YuvColor implements ColorSpace {
  final double y;
  final double u;
  final double v;

  const YuvColor(this.y, this.u, this.v);

  Color toColor() {
    double r = y + 1.13983 * v;
    double g = y - 0.39465 * u - 0.58060 * v;
    double b = y + 2.03211 * u;
    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (b * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'YuvColor(y: ${y.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}

class OkLabColor implements ColorSpace {
  final double l;
  final double a;
  final double b;

  const OkLabColor(this.l, this.a, this.b);

  Color toColor() {
    double l_ = l + 0.3963377774 * a + 0.2158037573 * b;
    double m_ = l - 0.1055613458 * a - 0.0638541728 * b;
    double s_ = l - 0.0894841775 * a - 1.2914855480 * b;

    double l3 = l_ * l_ * l_;
    double m3 = m_ * m_ * m_;
    double s3 = s_ * s_ * s_;

    double r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    double g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    double bVal = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308) ? (1.055 * pow(bVal, 1 / 2.4) - 0.055) : (12.92 * bVal);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (bVal * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;

  OkLchColor toOkLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi;
    if (h < 0) h += 360;
    return OkLchColor(l, c, h);
  }
  
  OkHslColor toOkHsl() {
      OkLchColor lch = toOkLch();
      double s = (lch.l == 0 || lch.l == 1) ? 0 : lch.c / 0.4; 
      if (s > 1) s = 1;
      return OkHslColor(lch.h, s, lch.l);
  }
  
  OkHsvColor toOkHsv() {
      OkLchColor lch = toOkLch();
      double v = lch.l + lch.c / 0.4;
      if (v > 1) v = 1;
      double s = (v == 0) ? 0 : (lch.c / 0.4) / v;
      if (s > 1) s = 1;
      return OkHsvColor(lch.h, s, v);
  }

  @override
  String toString() => 'OkLabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

class OkLchColor implements ColorSpace {
  final double l;
  final double c;
  final double h;

  const OkLchColor(this.l, this.c, this.h);

  OkLabColor toOkLab() {
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);
    return OkLabColor(l, a, b);
  }

  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'OkLchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}

class OkHslColor implements ColorSpace {
  final double h;
  final double s;
  final double l;

  const OkHslColor(this.h, this.s, this.l);

  OkLabColor toOkLab() {
    double c = s * 0.4; 
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);
    return OkLabColor(l, a, b);
  }

  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'OkHslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}

class OkHsvColor implements ColorSpace {
  final double h;
  final double s;
  final double v;

  const OkHsvColor(this.h, this.s, this.v);

  OkLabColor toOkLab() {
     double l = v * (1 - s / 2);
     double c = v * s * 0.4;
     double hRad = h * pi / 180;
     double a = c * cos(hRad);
     double b = c * sin(hRad);
     return OkLabColor(l, a, b);
  }

  Color toColor() => toOkLab().toColor();
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'OkHsvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}

class HunterLabColor implements ColorSpace {
  final double l;
  final double a;
  final double b;

  const HunterLabColor(this.l, this.a, this.b);

  Color toColor() {
    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    double y = pow(l / 100.0, 2) * yn;
    double x = (a / 175.0 * (l / 100.0) + y / yn) * xn;
    double z = (y / yn - b / 70.0 * (l / 100.0)) * zn;

    double xTemp = x / 100;
    double yTemp = y / 100;
    double zTemp = z / 100;

    double r = xTemp * 3.2406 + yTemp * -1.5372 + zTemp * -0.4986;
    double g = xTemp * -0.9689 + yTemp * 1.8758 + zTemp * 0.0415;
    double bVal = xTemp * 0.0557 + yTemp * -0.2040 + zTemp * 1.0570;

    r = (r > 0.0031308) ? (1.055 * pow(r, 1 / 2.4) - 0.055) : (12.92 * r);
    g = (g > 0.0031308) ? (1.055 * pow(g, 1 / 2.4) - 0.055) : (12.92 * g);
    bVal = (bVal > 0.0031308) ? (1.055 * pow(bVal, 1 / 2.4) - 0.055) : (12.92 * bVal);

    return Color.fromARGB(255, (r * 255).round().clamp(0, 255), (g * 255).round().clamp(0, 255), (bVal * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HunterLabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

class HsluvColor implements ColorSpace {
  final double h;
  final double s;
  final double l;

  const HsluvColor(this.h, this.s, this.l);

  Color toColor() {
      double c = s; 
      double hRad = h * pi / 180;
      double u = c * cos(hRad);
      double v = c * sin(hRad);
      return LuvColor(l, u, v).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HsluvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}

class MunsellColor implements ColorSpace {
  final String hue;
  final double munsellValue;
  final double chroma;

  const MunsellColor(this.hue, this.munsellValue, this.chroma);

  Color toColor() {
      return Color.fromARGB(255, 0, 0, 0);
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'MunsellColor(hue: $hue, value: ${munsellValue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)})';
}

class HslColor implements ColorSpace {
  final double h;
  final double s;
  final double l;

  const HslColor(this.h, this.s, this.l);

  Color toColor() {
      double c = (1 - (2 * l - 1).abs()) * s;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = l - c / 2;
      
      double r = 0, g = 0, b = 0;
      if (h < 60) { r = c; g = x; b = 0; }
      else if (h < 120) { r = x; g = c; b = 0; }
      else if (h < 180) { r = 0; g = c; b = x; }
      else if (h < 240) { r = 0; g = x; b = c; }
      else if (h < 300) { r = x; g = 0; b = c; }
      else { r = c; g = 0; b = x; }
      
      return Color.fromARGB(255, ((r + m) * 255).round(), ((g + m) * 255).round(), ((b + m) * 255).round());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HslColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, l: ${l.toStringAsFixed(2)})';
}

class HsvColor implements ColorSpace {
  final double h;
  final double s;
  final double v;

  const HsvColor(this.h, this.s, this.v);

  Color toColor() {
      double c = v * s;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = v - c;
      
      double r = 0, g = 0, b = 0;
      if (h < 60) { r = c; g = x; b = 0; }
      else if (h < 120) { r = x; g = c; b = 0; }
      else if (h < 180) { r = 0; g = c; b = x; }
      else if (h < 240) { r = 0; g = x; b = c; }
      else if (h < 300) { r = x; g = 0; b = c; }
      else { r = c; g = 0; b = x; }
      
      return Color.fromARGB(255, ((r + m) * 255).round(), ((g + m) * 255).round(), ((b + m) * 255).round());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HsvColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}

class HsbColor implements ColorSpace {
  final double h;
  final double s;
  final double b;

  const HsbColor(this.h, this.s, this.b);

  Color toColor() {
      return HsvColor(h, s, b).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HsbColor(h: ${h.toStringAsFixed(2)}, s: ${s.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

class HwbColor implements ColorSpace {
  final double h;
  final double w;
  final double b;

  const HwbColor(this.h, this.w, this.b);

  Color toColor() {
      double ratio = w + b;
      double wNorm = w;
      double bNorm = b;
      if (ratio > 1) {
          wNorm /= ratio;
          bNorm /= ratio;
      }
      
      double v = 1 - bNorm;
      double s = (v == 0) ? 0 : 1 - wNorm / v;
      
      return HsvColor(h, s, v).toColor();
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HwbColor(h: ${h.toStringAsFixed(2)}, w: ${w.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

class HctColor implements ColorSpace {
  final double hue;
  final double chroma;
  final double tone;

  const HctColor(this.hue, this.chroma, this.tone);

  Color toColor() {
      return Color(mcu.Hct.from(hue, chroma, tone).toInt());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'HctColor(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, tone: ${tone.toStringAsFixed(2)})';
}

class Cam16Color implements ColorSpace {
  final double hue;
  final double chroma;
  final double j;
  final double m;
  final double s;
  final double q;

  const Cam16Color(this.hue, this.chroma, this.j, this.m, this.s, this.q);

  Color toColor() {
      return Color(mcu.Cam16.fromJch(j, chroma, hue).toInt());
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'Cam16Color(hue: ${hue.toStringAsFixed(2)}, chroma: ${chroma.toStringAsFixed(2)}, j: ${j.toStringAsFixed(2)})';
}

class DisplayP3Color implements ColorSpace {
  final double r;
  final double g;
  final double b;

  const DisplayP3Color(this.r, this.g, this.b);

  Color toColor() {
      // Gamma decoding (P3 to Linear)
      double rLin = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
      double gLin = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
      double bLin = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);
      
      // Display P3 Linear to XYZ (D65)
      // Matrix inverse of the one used in conversion
      double x = rLin * 0.4865709 + gLin * 0.2656677 + bLin * 0.1982173;
      double y = rLin * 0.2289746 + gLin * 0.6917385 + bLin * 0.0792869;
      double z = rLin * 0.0000000 + gLin * 0.0451134 + bLin * 1.0439444;
      
      // XYZ (D65) to sRGB Linear
      double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
      double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
      double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;
      
      // sRGB Linear to sRGB (Gamma encoded)
      rS = (rS > 0.0031308) ? (1.055 * pow(rS, 1 / 2.4) - 0.055) : (12.92 * rS);
      gS = (gS > 0.0031308) ? (1.055 * pow(gS, 1 / 2.4) - 0.055) : (12.92 * gS);
      bS = (bS > 0.0031308) ? (1.055 * pow(bS, 1 / 2.4) - 0.055) : (12.92 * bS);
      
      return Color.fromARGB(255, (rS * 255).round().clamp(0, 255), (gS * 255).round().clamp(0, 255), (bS * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'DisplayP3Color(r: ${r.toStringAsFixed(2)}, g: ${g.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

class Rec2020Color implements ColorSpace {
  final double r;
  final double g;
  final double b;

  const Rec2020Color(this.r, this.g, this.b);

  Color toColor() {
      // Rec. 2020 decoding (Gamma to Linear)
      double transferInv(double v) {
          if (v < 0.018 * 4.5) return v / 4.5;
          return pow((v + 0.099) / 1.099, 1 / 0.45).toDouble();
      }
      
      double rLin = transferInv(r);
      double gLin = transferInv(g);
      double bLin = transferInv(b);
      
      // Rec. 2020 Linear to XYZ (D65)
      double x = rLin * 0.6369580 + gLin * 0.1446169 + bLin * 0.1688810;
      double y = rLin * 0.2627002 + gLin * 0.6779981 + bLin * 0.0593017;
      double z = rLin * 0.0000000 + gLin * 0.0280727 + bLin * 1.0609851;
      
      // XYZ (D65) to sRGB Linear
      double rS = x * 3.2404542 + y * -1.5371385 + z * -0.4985314;
      double gS = x * -0.9692660 + y * 1.8760108 + z * 0.0415560;
      double bS = x * 0.0556434 + y * -0.2040259 + z * 1.0572252;
      
      // sRGB Linear to sRGB (Gamma encoded)
      rS = (rS > 0.0031308) ? (1.055 * pow(rS, 1 / 2.4) - 0.055) : (12.92 * rS);
      gS = (gS > 0.0031308) ? (1.055 * pow(gS, 1 / 2.4) - 0.055) : (12.92 * gS);
      bS = (bS > 0.0031308) ? (1.055 * pow(bS, 1 / 2.4) - 0.055) : (12.92 * bS);
      
      return Color.fromARGB(255, (rS * 255).round().clamp(0, 255), (gS * 255).round().clamp(0, 255), (bS * 255).round().clamp(0, 255));
  }
  
  @override
  int get value => toColor().value;
  
  @override
  String toString() => 'Rec2020Color(r: ${r.toStringAsFixed(2)}, g: ${g.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
