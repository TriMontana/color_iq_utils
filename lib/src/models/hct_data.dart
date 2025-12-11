import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/hct/hct.dart';
import 'package:material_color_utilities/hct/src/hct_solver.dart';

// 1. A pure data class (Const capable!)
// Create a custom class that holds the HCT values as simple
// double primitives. This gives you the immutability you want
// and allows for a more efficient pre-computation strategy.
// This class is "dumb." It doesn't know how to calculate HCT;
// it just holds the result of a calculation. This allows it to be const.
/// A pure data class that holds HCT (Hue, Chroma, Tone) values as simple double primitives.
///
/// This class is immutable and capable of being `const`, allowing for efficient
/// storage and pre-computation strategies. It acts as a lightweight wrapper
/// around HCT values, decoupling data storage from the heavy calculations
/// performed by the underlying library.
class HctData implements ColorWheelInf {
  /// The hue component of the color, in degrees (0.0 - 360.0).
  final double hue;

  /// The chroma component of the color, representing colorfulness.
  ///
  /// While technically unbounded, values > 200 are usually outside the visible gamut.
  final double chroma;

  /// The tone component of the color, representing lightness (0.0 - 100.0).
  final double tone;

  /// The optional integer representation of the color (e.g., typically 0xAABBGGRR).
  ///
  /// If provided, this avoids recalculating the integer value from HCT components.
  final int? colorId;

  /// Creates a CONST constant [HctData] instance.
  ///
  /// [hue] must be between 0.0 and 360.0.
  /// [chroma] must be non-negative and typically below [kMaxChroma].
  /// [tone] must be between 0.0 and 100.0.
  const HctData(this.hue, this.chroma, this.tone, {this.colorId})
      : assert(hue >= 0.0 && hue <= 360.0,
            'Hue must be between 0 and 360, was $hue'),
        assert(chroma >= 0.0 && chroma <= kMaxChroma,
            'Chroma must be positive and below $kMaxChroma, was $chroma'),
        assert(tone >= 0.0 && tone <= 100.0,
            'Tone must be between 0 and 100, was $tone');

  /// Creates an [HctData] instance from an integer color value [colorId].
  ///
  /// This method uses the underlying HCT library to perform the expensive
  /// conversion from integer to HCT components once, then stores the result
  /// in a lightweight [HctData] object.
  static HctData fromInt(final int colorId) {
    // Use the heavy library ONCE to do the math
    final Hct heavyObject = Hct.fromInt(colorId);

    // Discard the heavy object, keep only the 3 doubles
    return HctData(heavyObject.hue, heavyObject.chroma, heavyObject.tone,
        colorId: colorId);
  }

  /// Returns the integer representation of this color.
  ///
  /// If [colorId] is stored, it is returned directly. Otherwise, the value
  /// is calculated from [hue], [chroma], and [tone] using the underlying HCT library.
  @override
  int get hexId {
    if (colorId != null) {
      return colorId!;
    }
    // Use the heavy library ONCE to do the math
    final Hct heavyObject = Hct.from(hue, chroma, tone);
    // Discard the heavy object, keep only the 3 doubles
    return heavyObject.toInt();
  }

  /// Converts this [HctData] to its integer representation.
  int toInt() => hexId;

  @override
  String toString() => 'HctData(h: ${hue.toStrTrimZeros(3)}, ' //
      'c: ${chroma.toStrTrimZeros(2)}, ' //
      't: ${tone.toStrTrimZeros(2)})';

  /// Calculates the integer color ID from [hue], [chroma], and [tone].
  ///
  /// This is a static helper that performs the conversion without creating
  /// an [HctData] instance.
  static int calculateColorID(
      final double hue, final double chroma, final double tone) {
    // Use the heavy library ONCE to do the math
    final Hct heavyObject = Hct.from(hue, chroma, tone);
    // Discard the heavy object, keep only the 3 doubles
    return heavyObject.toInt();
  }

  /// Checks for equality with another object.
  ///
  /// Two [HctData] objects are considered equal if they have the same runtime type
  /// and identical [hue], [chroma], and [tone] values.
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

  @override
  Cam16 get cam16 => Cam16.fromInt(hexId);

  @override
  ColorSlice closestColorSlice() => hexId.closestColorSlice();

  @override
  String get hexStr => hexId.toHexStr;

  @override
  HctData get hct => this;

  @override
  double toneDifference(final ColorWheelInf other) {
    return tone - other.hct.tone;
  }
}

// This extension operates on your immutable HctData wrapper.
// It returns a new HctData instance with the modified values.
// The math layer: Operates on pure data
extension HctManipulation on HctData {
  /// Returns a new HctData with the Tone adjusted.
  /// @param amount: The amount to add (0-100 scale). e.g., 10.0 adds 10% lightness.
  HctData lighten(final double amount) {
    // Clamp to ensure we don't exceed 100 (Absolute White)
    final double newTone = (tone + amount).clampToneHct;
    return HctData(hue, chroma, newTone);
  }

  /// Returns a new HctData with the Tone reduced.
  HctData darken(final double amount) {
    // Clamp to ensure we don't go below 0 (Absolute Black)
    final double newTone = (tone - amount).clampToneHct;
    return HctData(hue, chroma, newTone);
  }

  /// Returns a new HctData with Chroma increased (more vivid).
  HctData saturate(final double amount) {
    // HCT Chroma theoretically goes higher, but ~150 is a safe practical cap for checks
    // The solver will handle gamut mapping if it's too high.
    final double newChroma = chroma + amount;
    return HctData(hue, newChroma.clampChromaHct, tone);
  }

  /// Returns a new HctData with Chroma decreased (more gray).
  HctData desaturate(final double amount) {
    final double newChroma = (chroma - amount).clampChromaHct;
    return HctData(hue, newChroma, tone);
  }

  HctData withHue(final double newHue) {
    wrapHue(newHue);
    return HctData(wrapHue(newHue), chroma, tone);
  }

  HctData whiten([final double amount = 20]) => lerp(cWhite.hct, amount / 100);

  HctData blacken([final double amount = 20]) => lerp(cBlack.hct, amount / 100);

  HctData lerp(final HctData other, final double t) {
    final double newHue = lerpHue(hue, other.hue, t);
    final double newChroma =
        (chroma + (other.chroma - chroma) * t).clampChromaHct;
    final double newTone = (tone + (other.tone - tone) * t).clampToneHct;
    final int hexID = HctSolver.solveToInt(newHue, newChroma, newTone);
    return HctData(newHue, newChroma, newTone, colorId: hexID);
  }

  String createStr([final int precision = 5]) =>
      'const HctData(${hue.toStrTrimZeros(precision)}, ' //
      ' ${chroma.toStrTrimZeros(precision)}, ' //
      ' ${tone.toStrTrimZeros(precision)})';
}

// --- HCT Strategy ---
class HctStrategy extends ManipulationStrategy {
  const HctStrategy();

  @override
  int lighten(final int argb, final double amount, {HctData? hct}) {
    // 1. Convert Int -> HctData
    hct ??= HctData.fromInt(argb);
    // 2. Use your existing Extension logic
    final HctData modified = hct.lighten(amount);
    // 3. Convert HctData -> Int
    return modified.hexId;
  }

  // ... implement darken, saturate, etc. using HCT math
  @override
  int darken(final int argb, final double amount) =>
      HctData.fromInt(argb).darken(amount).hexId;

  @override
  int saturate(final int argb, final double amount) =>
      HctData.fromInt(argb).saturate(amount).hexId;

  @override
  int desaturate(final int argb, final double amount) =>
      HctData.fromInt(argb).desaturate(amount).hexId;

  @override
  int rotateHue(final int argb, final double amount) => HctData.fromInt(argb)
      .withHue((HctData.fromInt(argb).hue + amount) % 360)
      .hexId;

  /// Intensifies the color by increasing chroma and slightly decreasing tone (half of factor).
  @override
  int intensify(final int argb,
      {final Percent amount = Percent.v15, HctData? hct}) {
    hct ??= HctData.fromInt(argb);

    final double newChroma = (hct.chroma + amount).clampChromaHct;
    final double newTone = (hct.tone - (amount.val / 2)).clampToneHct;

    return HctData(hct.hue, newChroma, newTone).hexId;
  }

  /// De-intensifies (mutes) the color by decreasing chroma and
  /// slightly increasing tone (half of factor).
  @override
  int deintensify(final int argb,
      {final Percent amount = Percent.v15, HctData? hct}) {
    hct ??= HctData.fromInt(argb);

    final double newChroma = (hct.chroma - amount).clampChromaHct;
    final double newTone = (hct.tone + (amount.val / 2)).clampToneHct;

    return HctData(hct.hue, newChroma, newTone).hexId;
  }
}
