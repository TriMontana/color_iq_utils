import 'package:color_iq_utils/src/models/hsluv.dart';

class Contrast {
  static double contrastRatio(final double lighterL, final double darkerL) {
    // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-procedure
    final double lighterY = Hsluv.lToY(lighterL);
    final double darkerY = Hsluv.lToY(darkerL);
    return (lighterY + 0.05) / (darkerY + 0.05);
  }

  static double lighterMinL(final double r) {
    return Hsluv.yToL((r - 1) / 20);
  }

  static double darkerMaxL(final double r, final double lighterL) {
    final double lighterY = Hsluv.lToY(lighterL);
    final double maxY = (20 * lighterY - r + 1) / (20 * r);
    return Hsluv.yToL(maxY);
  }
}
