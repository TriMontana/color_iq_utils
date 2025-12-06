import 'package:color_iq_utils/color_iq_utils.dart';

// =========================================================
// SEE: ColorNames.generateDefaultName(color):
class ColorNamerSuperSimple {
  ColorNamerSuperSimple._();
  static final ColorNamerSuperSimple instance = ColorNamerSuperSimple._();

  /// Simple stub; you’d replace with real logic or table lookup.
  String name(final ColorIQ color) {
    final double l = color.lab.l;
    final double a = color.lab.a;
    final double b = color.lab.b;

    // Very rough example, just to show structure.
    if (l < 20) return 'deep dark';
    if (l > 80 && a.abs() < 5 && b.abs() < 5) return 'bright white';

    if (a > 20 && b < 20) {
      return 'warm red';
    }
    if (a < -10 && b < -10) return 'cool blue';
    if (a < -5 && b > 15) return 'greenish yellow';
    if (a.abs() < 8 && b.abs() < 8) return 'soft neutral';

    return 'vivid color';
  }
}
