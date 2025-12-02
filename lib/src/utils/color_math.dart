import 'package:color_iq_utils/src/extensions/double_helpers.dart';

/// Linearly interpolates between two hues.
///
/// This function takes the shortest path around the color wheel.
/// [a] is the starting hue, in degrees.
/// [b] is the ending hue, in degrees.
/// [t] is the interpolation factor, in the range [0, 1].
double lerpHue(double a, double b, final double t) {
  t.assertRange0to1('lerpHue');
  final double delta = b - a;
  if (delta.abs() > 180.0) {
    if (delta > 0.0) {
      a += 360.0;
    } else {
      b += 360.0;
    }
  }
  return (a + (b - a) * t) % 360.0;
}
