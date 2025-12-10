import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/hct_data.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';

// This is a "Generator-type class" that holds the registry of color transformation strategies
// and exposes a clean API.
class ColorManipulator {
  // 1. The Registry (Const Map)
  // This maps the Enum to the actual Logic Class.
  static const Map<ColorModel, ManipulationStrategy> _strategies =
      <ColorModel, ManipulationStrategy>{
    ColorModel.hct: HctStrategy(),
    ColorModel.hsv: HsvStrategy(),
    // ColorModel.hsl: HslStrategy(),
  };

  // 2. The Universal Method
  static int transform({
    required final int color,
    required final ColorModel model,
    required final TransformType type,
    required final Percent amount,
  }) {
    final ManipulationStrategy strategy = _strategies[model]!;

    switch (type) {
      case TransformType.lighten:
        return strategy.lighten(color, amount);
      case TransformType.darken:
        return strategy.darken(color, amount);
      case TransformType.saturate:
        return strategy.saturate(color, amount);
      case TransformType.desaturate:
        return strategy.desaturate(color, amount);
      case TransformType.rotate:
        return strategy.rotateHue(color, amount);
      case TransformType.intensify:
        return strategy.intensify(color, amount: amount);
      case TransformType.deintensify:
        return strategy.deintensify(color, amount: amount);
    }
  }
}

// Private enum to make the helper method cleaner
enum TransformType {
  lighten,
  darken,
  saturate,
  desaturate,
  rotate,
  intensify,
  deintensify
}
