/// Enum to indicate how to convert a [Color] object, from one Color Space
/// to another
enum ChannelAdjustMode {
  // percent of difference between the current RGB value and the target,
  // but with no overflow. This typically has the least visual impact.
  // basic interpolation = c = a + ((b - a) * t)
  // adjustment  = (color.blue - val) * percentage
  // result = color.blue + adjustment
  //
  interpolate,

  // Same as Dart Lerp
  // return a * (1.0 - t) + b * t;
  lerp,

  /// Adjustment amount by percent of current value
  ///     c.alpha,
  //         (c.red * percent).round(),
  //         (c.green  * percent).round(),
  //         (c.blue * percent).round()
  byPercentOfCurrentValue,

  /// Uses the raw percentage of whole (e.g. 255) and applies it to the current
  /// value and bounds it if necessary. Computations are not based on the
  /// current value.
  ///
  /// color.blue + (255 * percentage), clamped.
  /// [same] color.blue * percentage, clamped
  byPercentOfWhole,
}

enum PrefixOrSuffix { prefix, suffix }

enum RotationDirection { clockwise, counterclockwise }

enum SwatchType { materialColor, materialAccentColor }
