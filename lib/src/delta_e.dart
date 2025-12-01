import 'dart:math';
import 'color_interfaces.dart';
import 'models/lab_color.dart';

/// Algorithms for calculating color difference (Delta E).
enum DeltaEAlgorithm {
  /// CIE76: Simple Euclidean distance in Lab space.
  /// Fast but less perceptually uniform.
  cie76,

  /// CIE94: Improves on CIE76 by weighting lightness, chroma, and hue.
  /// Better for graphic arts.
  cie94,

  /// CIEDE2000: The most accurate standard for perceptual difference.
  /// Complex calculation correcting for blue nonlinearity and other factors.
  ciede2000,
}

/// Extension for calculating Delta E between colors.
extension DeltaEExtension on ColorSpacesIQ {
  /// Calculates the Delta E (perceptual difference) to another color.
  /// 
  /// [other] The color to compare to.
  /// [algorithm] The algorithm to use. Default is [DeltaEAlgorithm.ciede2000].
  /// 
  /// Returns a value where:
  /// - <= 1.0: Not perceptible by human eyes.
  /// - 1-2: Perceptible through close observation.
  /// - 2-10: Perceptible at a glance.
  /// - 11-49: Colors are more similar than opposite.
  /// - 100: Colors are exact opposite.
  double deltaE(ColorSpacesIQ other, {DeltaEAlgorithm algorithm = DeltaEAlgorithm.ciede2000}) {
    final LabColor lab1;
    if (this is LabColor) {
      lab1 = this as LabColor;
    } else {
      lab1 = toColor().toLab();
    }

    final LabColor lab2;
    if (other is LabColor) {
      lab2 = other as LabColor;
    } else {
      lab2 = other.toColor().toLab();
    }

    switch (algorithm) {
      case DeltaEAlgorithm.cie76:
        return _deltaECie76(lab1, lab2);
      case DeltaEAlgorithm.cie94:
        return _deltaECie94(lab1, lab2);
      case DeltaEAlgorithm.ciede2000:
        return _deltaECiede2000(lab1, lab2);
    }
  }

  double _deltaECie76(LabColor lab1, LabColor lab2) {
    return sqrt(
      pow(lab1.l - lab2.l, 2) +
      pow(lab1.a - lab2.a, 2) +
      pow(lab1.b - lab2.b, 2)
    );
  }

  double _deltaECie94(LabColor lab1, LabColor lab2) {
    final L1 = lab1.l;
    final a1 = lab1.a;
    final b1 = lab1.b;
    final L2 = lab2.l;
    final a2 = lab2.a;
    final b2 = lab2.b;

    final C1 = sqrt(a1 * a1 + b1 * b1);
    final C2 = sqrt(a2 * a2 + b2 * b2);
    final dL = L1 - L2;
    final dC = C1 - C2;
    final da = a1 - a2;
    final db = b1 - b2;
    
    // dH^2 = dE^2 - dL^2 - dC^2 = da^2 + db^2 - dC^2
    double dH2 = da * da + db * db - dC * dC;
    // Handle floating point errors making it slightly negative
    if (dH2 < 0) dH2 = 0;
    final dH = sqrt(dH2);

    // Weighting factors (Graphic Arts)
    const kL = 1.0;
    const kC = 1.0;
    const kH = 1.0;
    const K1 = 0.045;
    const K2 = 0.015;

    final sL = 1.0;
    final sC = 1.0 + K1 * C1;
    final sH = 1.0 + K2 * C1;

    return sqrt(
      pow(dL / (kL * sL), 2) +
      pow(dC / (kC * sC), 2) +
      pow(dH / (kH * sH), 2)
    );
  }

  double _deltaECiede2000(LabColor lab1, LabColor lab2) {
    // Implementation of CIEDE2000
    // Based on: http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CIE2000.html
    
    final L1 = lab1.l;
    final a1 = lab1.a;
    final b1 = lab1.b;
    final L2 = lab2.l;
    final a2 = lab2.a;
    final b2 = lab2.b;

    final L_bar = (L1 + L2) / 2.0;
    final C1 = sqrt(a1 * a1 + b1 * b1);
    final C2 = sqrt(a2 * a2 + b2 * b2);
    final C_bar = (C1 + C2) / 2.0;

    final G = 0.5 * (1.0 - sqrt(pow(C_bar, 7) / (pow(C_bar, 7) + pow(25, 7))));
    
    final a1_prime = a1 * (1.0 + G);
    final a2_prime = a2 * (1.0 + G);

    final C1_prime = sqrt(a1_prime * a1_prime + b1 * b1);
    final C2_prime = sqrt(a2_prime * a2_prime + b2 * b2);
    final C_bar_prime = (C1_prime + C2_prime) / 2.0;

    double h1_prime = atan2(b1, a1_prime) * 180.0 / pi;
    if (h1_prime < 0) h1_prime += 360.0;
    
    double h2_prime = atan2(b2, a2_prime) * 180.0 / pi;
    if (h2_prime < 0) h2_prime += 360.0;

    double h_bar_prime;
    if ((C1_prime * C2_prime) == 0) {
        h_bar_prime = h1_prime + h2_prime;
    } else {
        if ((h1_prime - h2_prime).abs() <= 180.0) {
            h_bar_prime = (h1_prime + h2_prime) / 2.0;
        } else {
            if ((h1_prime + h2_prime) < 360.0) {
                h_bar_prime = (h1_prime + h2_prime + 360.0) / 2.0;
            } else {
                h_bar_prime = (h1_prime + h2_prime - 360.0) / 2.0;
            }
        }
    }

    final T = 1.0 - 0.17 * cos((h_bar_prime - 30.0) * pi / 180.0) +
              0.24 * cos((2.0 * h_bar_prime) * pi / 180.0) +
              0.32 * cos((3.0 * h_bar_prime + 6.0) * pi / 180.0) -
              0.20 * cos((4.0 * h_bar_prime - 63.0) * pi / 180.0);

    double dh_prime;
    if ((C1_prime * C2_prime) == 0) {
        dh_prime = 0;
    } else {
        if ((h2_prime - h1_prime).abs() <= 180.0) {
            dh_prime = h2_prime - h1_prime;
        } else {
            if (h2_prime <= h1_prime) {
                dh_prime = h2_prime - h1_prime + 360.0;
            } else {
                dh_prime = h2_prime - h1_prime - 360.0;
            }
        }
    }
    
    final dL_prime = L2 - L1;
    final dC_prime = C2_prime - C1_prime;
    final dH_prime = 2.0 * sqrt(C1_prime * C2_prime) * sin((dh_prime / 2.0) * pi / 180.0);

    final S_L = 1.0 + (0.015 * pow(L_bar - 50.0, 2)) / sqrt(20.0 + pow(L_bar - 50.0, 2));
    final S_C = 1.0 + 0.045 * C_bar_prime;
    final S_H = 1.0 + 0.015 * C_bar_prime * T;

    final dTheta = 30.0 * exp(-pow((h_bar_prime - 275.0) / 25.0, 2));
    final R_C = 2.0 * sqrt(pow(C_bar_prime, 7) / (pow(C_bar_prime, 7) + pow(25, 7)));
    final R_T = -sin(2.0 * dTheta * pi / 180.0) * R_C;

    final kL = 1.0;
    final kC = 1.0;
    final kH = 1.0;

    final DE2000 = sqrt(
        pow(dL_prime / (kL * S_L), 2) +
        pow(dC_prime / (kC * S_C), 2) +
        pow(dH_prime / (kH * S_H), 2) +
        R_T * (dC_prime / (kC * S_C)) * (dH_prime / (kH * S_H))
    );

    return DE2000;
  }
}
