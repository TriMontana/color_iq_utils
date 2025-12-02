
enum ColorBlindnessType {
  none,
  protanopia,
  deuteranopia,
  tritanopia,
  achromatopsia,
}

class ColorBlindness {
  /// Simulates color blindness on a given linear sRGB color (r, g, b in 0..1).
  /// Returns a list [r, g, b] of the simulated color in linear sRGB.
  static List<double> simulate(final double r, final double g, final double b, final ColorBlindnessType type) {
    if (type == ColorBlindnessType.none) return <double>[r, g, b];
    if (type == ColorBlindnessType.achromatopsia) {
      // Monochromacy / Achromatopsia
      // Using luminance formula
      final double gray = 0.2126 * r + 0.7152 * g + 0.0722 * b;
      return <double>[gray, gray, gray];
    }

    // Convert Linear RGB to LMS
    // Hunt-Pointer-Estevez transformation matrix
    final double l = 0.31399022 * r + 0.63951294 * g + 0.04649755 * b;
    final double m = 0.15537241 * r + 0.75789446 * g + 0.08670142 * b;
    final double s = 0.01775239 * r + 0.10944209 * g + 0.87256922 * b;

    double lSim = l;
    double mSim = m;
    double sSim = s;

    switch (type) {
      case ColorBlindnessType.protanopia:
        // Simulate Protanopia (L-cone missing)
        // L = 1.05118294 * M - 0.05116099 * S
        lSim = 1.05118294 * m - 0.05116099 * s;
        break;
      case ColorBlindnessType.deuteranopia:
        // Simulate Deuteranopia (M-cone missing)
        // M = 0.9513092 * L + 0.04866992 * S
        mSim = 0.9513092 * l + 0.04866992 * s;
        break;
      case ColorBlindnessType.tritanopia:
        // Simulate Tritanopia (S-cone missing)
        // S = -0.86744736 * L + 1.86727089 * M
        sSim = -0.86744736 * l + 1.86727089 * m;
        break;
      default:
        break;
    }

    // Convert LMS back to Linear RGB
    // Inverse of Hunt-Pointer-Estevez
    final double rSim = 5.47221206 * lSim - 4.6419601 * mSim + 0.16963564 * sSim;
    final double gSim = -1.1252419 * lSim + 2.29317094 * mSim - 0.1678952 * sSim;
    final double bSim = 0.02980165 * lSim - 0.19318073 * mSim + 1.16364789 * sSim;

    // Clamp results
    return <double>[
      rSim.clamp(0.0, 1.0),
      gSim.clamp(0.0, 1.0),
      bSim.clamp(0.0, 1.0),
    ];
  }
}
