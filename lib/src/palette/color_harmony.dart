import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';

class ColorHarmony {
  static List<ColorIQ> triad(final ColorIQ base) {
    // Stub: your real implementation could work in HSL, LCH, etc.
    // For now just a silly example that shifts channels.
    final ColorIQ c1 = base.withRgb(
      red: ((base.red + 85) % 256).toIq255,
      green: ((base.green + 170) % 256).toIq255,
      blue: base.blue.toIq255,
    );
    final ColorIQ c2 = base.withRgb(
      red: base.redIQ,
      green: ((base.green + 85) % 256).toIq255,
      blue: ((base.blue + 170) % 256).toIq255,
    );
    return <ColorIQ>[base, c1, c2];
  }

  static List<ColorIQ> splitComplementary(final ColorIQ base) {
    // Same idea – use your real math here.
    final ColorIQ c1 = base.withRgb(
      red: ((255 - base.red + 30) % 256).toIq255,
      green: ((255 - base.green) % 256).toIq255,
      blue: ((base.blue + 30) % 256).toIq255,
    );
    final ColorIQ c2 = base.withRgb(
      red: ((255 - base.red - 30) % 256).toIq255,
      green: ((255 - base.green) % 256).toIq255,
      blue: ((base.blue - 30) % 256).toIq255,
    );
    return <ColorIQ>[base, c1, c2];
  }
}
