import 'dart:math';

/// A color represented by red, green, blue, and alpha components.
class Color {
  /// The 32-bit alpha-red-green-blue integer value.
  final int value;

  /// Construct a color from the lower 32 bits of an [int].
  ///
  /// The bits are interpreted as follows:
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  const Color(this.value);

  /// Construct a color from 4 integers, a, r, g, b.
  ///
  /// [a], [r], [g], [b] must be in the range 0-255.
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

/// A color represented by cyan, magenta, yellow, and black components.
class CmykColor {
  /// Cyan component (0.0 to 1.0).
  final double c;

  /// Magenta component (0.0 to 1.0).
  final double m;

  /// Yellow component (0.0 to 1.0).
  final double y;

  /// Black component (0.0 to 1.0).
  final double k;

  const CmykColor(this.c, this.m, this.y, this.k);

  /// Converts this CMYK color to RGB [Color].
  Color toColor() {
    double r = 255 * (1 - c) * (1 - k);
    double g = 255 * (1 - m) * (1 - k);
    double b = 255 * (1 - y) * (1 - k);

    return Color.fromARGB(255, r.round(), g.round(), b.round());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CmykColor &&
        other.c == c &&
        other.m == m &&
        other.y == y &&
        other.k == k;
  }

  @override
  int get hashCode => Object.hash(c, m, y, k);

  @override
  String toString() =>
      'CmykColor(c: ${c.toStringAsFixed(2)}, m: ${m.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';
}

/// A color represented by X, Y, and Z components.
class XyzColor {
  final double x;
  final double y;
  final double z;

  const XyzColor(this.x, this.y, this.z);

  /// Converts this XYZ color to RGB [Color].
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

    return Color.fromARGB(
      255,
      (r * 255).round().clamp(0, 255),
      (g * 255).round().clamp(0, 255),
      (b * 255).round().clamp(0, 255),
    );
  }

  /// Converts this XYZ color to CIELab.
  LabColor toLab() {
    // Reference white point (D65)
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

  /// Converts this XYZ color to CIELuv.
  LuvColor toLuv() {
    // Reference white point (D65)
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
    
    // Handle case where denominator is 0 (black)
    if (x + 15 * y + 3 * z == 0) {
      uOut = 0;
      vOut = 0;
    }

    return LuvColor(l, uOut, vOut);
  }
  
  @override
  String toString() => 'XyzColor(x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, z: ${z.toStringAsFixed(2)})';
}

/// A color represented by Lightness, a, and b components.
class LabColor {
  final double l;
  final double a;
  final double b;

  const LabColor(this.l, this.a, this.b);

  /// Converts this Lab color to XYZ.
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

  /// Converts this Lab color to RGB [Color].
  Color toColor() => toXyz().toColor();

  /// Converts this Lab color to CIELCH.
  LchColor toLch() {
    double c = sqrt(a * a + b * b);
    double h = atan2(b, a);
    h = h * 180 / pi; // Convert to degrees

    if (h < 0) {
      h += 360;
    }

    return LchColor(l, c, h);
  }
  
  @override
  String toString() => 'LabColor(l: ${l.toStringAsFixed(2)}, a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}

/// A color represented by Lightness, u, and v components.
class LuvColor {
  final double l;
  final double u;
  final double v;

  const LuvColor(this.l, this.u, this.v);

  /// Converts this Luv color to XYZ.
  XyzColor toXyz() {
    // Reference white point (D65)
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
        uTemp = 0; // Avoid division by zero
        vTemp = 0;
    }

    double yFinal = yOut * 100;
    double xFinal = -(9 * yFinal * uTemp) / ((uTemp - 4) * vTemp - uTemp * vTemp);
    double zFinal = (9 * yFinal - (15 * vTemp * yFinal) - (vTemp * xFinal)) / (3 * vTemp);

    return XyzColor(xFinal, yFinal, zFinal);
  }
  
  /// Converts this Luv color to RGB [Color].
  Color toColor() => toXyz().toColor();
  
  @override
  String toString() => 'LuvColor(l: ${l.toStringAsFixed(2)}, u: ${u.toStringAsFixed(2)}, v: ${v.toStringAsFixed(2)})';
}

/// A color represented by Lightness, Chroma, and Hue components.
class LchColor {
  final double l;
  final double c;
  final double h;

  const LchColor(this.l, this.c, this.h);

  /// Converts this LCH color to Lab.
  LabColor toLab() {
    double hRad = h * pi / 180;
    double a = c * cos(hRad);
    double b = c * sin(hRad);

    return LabColor(l, a, b);
  }

  /// Converts this LCH color to RGB [Color].
  Color toColor() => toLab().toColor();
  
  @override
  String toString() => 'LchColor(l: ${l.toStringAsFixed(2)}, c: ${c.toStringAsFixed(2)}, h: ${h.toStringAsFixed(2)})';
}
