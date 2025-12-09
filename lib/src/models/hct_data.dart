// 1. A pure data class (Const capable!)
// Create a custom class that holds the HCT values as simple
// double primitives. This gives you the immutability you want
// and allows for a more efficient pre-computation strategy.
// This class is "dumb." It doesn't know how to calculate HCT;
// it just holds the result of a calculation. This allows it to be const.

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/hct.dart';

class HctData {
  final double hue;
  final double chroma;
  final double tone;

  const HctData(this.hue, this.chroma, this.tone)
      : assert(hue >= 0.0 && hue <= 360.0,
            'Hue must be between 0 and 360, was $hue'),
        assert(chroma >= 0.0 && chroma <= kMaxChroma,
            'Chroma must be positive and below $kMaxChroma, was $chroma'),
        // Note: Chroma technically has no hard cap, but >200 is usually outside visible gamut.
        // We leave it uncapped or capped high (e.g. 200) to allow for theoretical intermediate values.

        assert(tone >= 0.0 && tone <= 100.0,
            'Tone must be between 0 and 100, was $tone');

  static HctData fromInt(final int colorId) {
    // Use the heavy library ONCE to do the math
    final Hct heavyObject = Hct.fromInt(colorId);

    // Discard the heavy object, keep only the 3 doubles
    return HctData(heavyObject.hue, heavyObject.chroma, heavyObject.tone);
  }

  @override
  String toString() => 'HctData(h: ${hue.toStrTrimZeros(2)}, ' //
      'c: ${chroma.toStrTrimZeros(2)}, ' //
      't: ${tone.toStrTrimZeros(2)})';

  // Equality operator is vital if you plan to compare colors logically
  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is HctData &&
          runtimeType == other.runtimeType &&
          hue == other.hue &&
          chroma == other.chroma &&
          tone == other.tone;

  @override
  int get hashCode => hue.hashCode ^ chroma.hashCode ^ tone.hashCode;
}

// This extension operates on your immutable HctData wrapper.
// It returns a new HctData instance with the modified values.
// The math layer: Operates on pure data
extension HctManipulation on HctData {
  /// Returns a new HctData with the Tone adjusted.
  /// @param amount: The amount to add (0-100 scale). e.g., 10.0 adds 10% lightness.
  HctData lighten(final double amount) {
    // Clamp to ensure we don't exceed 100 (Absolute White)
    final double newTone = (tone + amount).clamp(0.0, 100.0);
    return HctData(hue, chroma, newTone);
  }

  /// Returns a new HctData with the Tone reduced.
  HctData darken(final double amount) {
    // Clamp to ensure we don't go below 0 (Absolute Black)
    final double newTone = (tone - amount).clamp(0.0, 100.0);
    return HctData(hue, chroma, newTone);
  }

  /// Returns a new HctData with Chroma increased (more vivid).
  HctData saturate(final double amount) {
    // HCT Chroma theoretically goes higher, but ~150 is a safe practical cap for checks
    // The solver will handle gamut mapping if it's too high.
    final double newChroma = chroma + amount;
    return HctData(hue, newChroma, tone);
  }

  /// Returns a new HctData with Chroma decreased (more gray).
  HctData desaturate(final double amount) {
    final double newChroma = (chroma - amount).clamp(0.0, 200.0);
    return HctData(hue, newChroma, tone);
  }

  String createStr([final int precision = 4]) =>
      'HctData(h: ${hue.toStrTrimZeros(precision)}, ' //
      'c: ${chroma.toStrTrimZeros(precision)}, ' //
      't: ${tone.toStrTrimZeros(precision)})';
}
