import 'dart:math';
import '../color_interfaces.dart';
import 'color.dart';

class DisplayP3Color implements ColorSpacesIQ {
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
  DisplayP3Color darken([double amount = 20]) {
    return toColor().darken(amount).toDisplayP3();
  }

  @override
  DisplayP3Color lighten([double amount = 20]) {
    return toColor().lighten(amount).toDisplayP3();
  }

  @override
  String toString() => 'DisplayP3Color(r: ${r.toStringAsFixed(2)}, g: ${g.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
