import 'dart:math';

import 'package:color_iq_utils/src/color_models_lib.dart';
import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';

/// A color model representing color in the CMYK (Cyan, Magenta, Yellow, Key/Black) color space.
///
/// CMYK is a subtractive color model, used in color printing, and is also used to describe
/// the printing process itself. It is based on mixing pigments of the following colors:
/// - **C**yan: a shade of blue
/// - **M**agenta: a shade of red
/// - **Y**ellow
/// - **K**ey (Black)
///
/// The values for C, M, Y, and K are represented as doubles ranging from 0.0 to 1.0,
/// where 0.0 indicates no ink and 1.0 indicates full ink coverage.
///
/// This class provides methods to ops CMYK colors to other color spaces (like RGB via `ColorIQ`),
/// and to perform various color manipulations such as lightening, darkening, and generating palettes.
/// It implements the `ColorSpacesIQ` interface, ensuring a consistent API for color operations
/// across different color models in this library.
///
class CMYK extends CommonIQ implements ColorSpacesIQ {
  final double c;
  final double m;
  final double y;
  final double k;

  /// Constructor for creating a CMYK color, optionally calculating the hex ID if not provided.
  ///
  /// [c], [m], [y], and [k] must be between 0.0 and 1.0.
  const CMYK(this.c, this.m, this.y, this.k,
      {final int? value,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : assert(c >= 0 && c <= 1, 'Invalid C value: $c'),
        assert(m >= 0 && m <= 1, 'Invalid M value: $m'),
        assert(y >= 0 && y <= 1, 'Invalid Y value: $y'),
        assert(k >= 0 && k <= 1, 'Invalid K value: $k'),
        super(value, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? hexFromCmyk(c, m, y, k);

  /// Converts this CMYK color to the sRGB color space.
  @override
  ColorIQ toColor() {
    final double r = 255 * (1 - c) * (1 - k);
    final double g = 255 * (1 - m) * (1 - k);
    final double b = 255 * (1 - y) * (1 - k);
    return ColorIQ.fromArgbInts(

      red: Iq255.getIq255(r.round().clamp(0, 255)),
      green: Iq255.getIq255(g.round().clamp(0, 255)),
      blue: Iq255.getIq255(b.round().clamp0to255),
    );
  }

  /// Creates a [CMYK] instance from a 32-bit integer ARGB `hexID`.
  ///
  /// The `hexID` is a 32-bit integer in the format `0xAARRGGBB`.
  /// The alpha component is ignored in the CMYK conversion.
  factory CMYK.fromInt(final int hexID) {
    final double r = hexID.r;
    final double g = (hexID >> 8 & 0xFF) / 255.0;
    final double b = (hexID & 0xFF) / 255.0;

    final double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CMYK(0, 0, 0, 1, value: hexID);
    }
    final double c = (1.0 - r - k) / (1.0 - k);
    final double m = (1.0 - g - k) / (1.0 - k);
    final double y = (1.0 - b - k) / (1.0 - k);

    return CMYK(c, m, y, k, value: hexID);
  }

  /// Converts this color to CMYK.
  static CMYK fromColorSpacesIQ(final CommonIQ clr) {
    final double r = clr.r;
    final double g = clr.g;
    final double b = clr.b;

    final double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return const CMYK(0, 0, 0, 1);
    }

    final double c = (1.0 - r - k) / (1.0 - k);
    final double m = (1.0 - g - k) / (1.0 - k);
    final double y = (1.0 - b - k) / (1.0 - k);

    return CMYK(c, m, y, k);
  }

  /// Converts this color to CMYK.
  CMYK fromColor() {
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return const CMYK(0, 0, 0, 1);
    }

    final double c = (1.0 - r - k) / (1.0 - k);
    final double m = (1.0 - g - k) / (1.0 - k);
    final double y = (1.0 - b - k) / (1.0 - k);

    return CMYK(c, m, y, k);
  }

  @override
  bool operator ==(final Object other) =>
      other is CMYK &&
      other.c == c &&
      other.m == m &&
      other.y == y &&
      other.k == k;

  @override
  CMYK lighten([final double amount = 20]) {
    return whiten(amount);
  }

  @override
  CMYK darken([final double amount = 20]) {
    return blacken(amount);
  }

  @override
  CMYK brighten([final double amount = 20]) {
    // Brighten by reducing the black component
    final double newK = (k * (1 - amount / 100)).clamp(0.0, 1.0);
    return copyWith(k: newK);
  }

  @override
  CMYK saturate([final double amount = 25]) {
    // Saturation in CMYK can be increased by increasing the dominant C, M, or Y.
    final double maxCmy = <double>[c, m, y].reduce(max);
    final double factor = 1 + amount / 100;
    return copyWith(
      c: (c == maxCmy ? (c * factor).clamp(0.0, 1.0) : c),
      m: (m == maxCmy ? (m * factor).clamp(0.0, 1.0) : m),
      y: (y == maxCmy ? (y * factor).clamp(0.0, 1.0) : y),
    );
  }

  @override
  CMYK accented([final double amount = 15]) {
    return saturate(amount);
  }

  @override
  CMYK whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  CMYK blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  CMYK lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) {
      return this;
    }
    final CMYK otherCmyk = other is CMYK ? other : CMYK.fromInt(other.value);
    if (t == 1.0) {
      return otherCmyk;
    }

    return CMYK(
      lerpDouble(c, otherCmyk.c, t),
      lerpDouble(m, otherCmyk.m, t),
      lerpDouble(y, otherCmyk.y, t),
      lerpDouble(k, otherCmyk.k, t),
    );
  }

  /// Generates a 32-bit hex value from CMYK components.
  ///
  /// This is a stand-alone static utility function to ops CMYK values
  /// directly to a 32-bit integer representation of the color, which is
  /// consistent with the `value` property of `Color` and `ColorIQ`.
  /// The alpha component is always set to 255 (fully opaque).
  static int hexFromCmyk(
      final double c, final double m, final double y, final double k) {
    final double r = 255 * (1 - c) * (1 - k);
    final double g = 255 * (1 - m) * (1 - k);
    final double b = 255 * (1 - y) * (1 - k);
    return (255 << 24) |
        (r.round().clamp(0, 255) << 16) |
        (g.round().clamp(0, 255) << 8) |
        b.round().clamp(0, 255);
  }

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  CMYK copyWith({
    final double? c,
    final double? m,
    final double? y,
    final double? k,
  }) {
    return CMYK(c ?? this.c, m ?? this.m, y ?? this.y, k ?? this.k);
  }

  @override
  List<CMYK> get monochromatic {
    // Generate a simple monochromatic set by varying K while keeping C/M/Y fixed
    final List<double> kValues = <double>[
      k,
      0.75,
      0.5,
      0.25,
      0.0,
    ].map((final double v) => v.clamp(0.0, 1.0)).toList();

    return kValues.map((final double kVal) => CMYK(c, m, y, kVal)).toList();
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<CMYK> results = <CMYK>[];
    double delta;
    if (step != null) {
      delta = step;
    } else {
      delta = 10.0; // Default step 10%
    }

    for (int i = 1; i <= 5; i++) {
      results.add(whiten(delta * i));
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    final List<CMYK> results = <CMYK>[];
    double delta;
    if (step != null) {
      delta = step;
    } else {
      delta = 10.0; // Default step 10%
    }

    for (int i = 1; i <= 5; i++) {
      results.add(blacken(delta * i));
    }
    return results;
  }

  @override
  ColorSpacesIQ get random {
    final Random random = Random();
    return CMYK(
      random.nextDouble(),
      random.nextDouble(),
      random.nextDouble(),
      random.nextDouble(),
    ) as ColorSpacesIQ;
  }

  @override
  bool isEqual(final ColorSpacesIQ other) =>
      other is CMYK &&
      other.c == c &&
      other.m == m &&
      other.y == y &&
      other.k == k;

  @override
  Brightness get brightness =>
      luminance > 0.5 ? Brightness.light : Brightness.dark;

  /// Blends this color with another color.
  /// The `amount` parameter specifies the percentage of the `other` color to blend.
  /// It defaults to 50, which is an equal mix.
  @override
  CMYK blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  CMYK opaquer([final double amount = 20]) {
    // In CMYK, "opaquer" is not directly applicable as it's a subtractive model
    // for reflective surfaces, not a light-emitting one. This is a no-op.
    return this;
  }

  @override
  CMYK adjustHue([final double amount = 20]) {
    final HctColor hct = toHctColor();
    return hct.copyWith(hue: (hct.hue + amount) % 360).toCMYK();
  }

  @override
  CMYK get complementary {
    return CMYK.fromColorSpacesIQ(toHctColor().flipHue());
  }

  @override
  CMYK warmer([final double amount = 20]) {
    // Increase yellow and magenta, decrease cyan
    final double change = amount / 100.0;
    return copyWith(
      y: (y + change).clamp(0.0, 1.0),
      m: (m + (change * 0.5)).clamp(0.0, 1.0),
      c: (c - (change * 0.5)).clamp(0.0, 1.0),
    );
  }

  @override
  CMYK cooler([final double amount = 20]) {
    // Increase cyan, decrease yellow and magenta
    final double change = amount / 100.0;
    return copyWith(
      c: (c + change).clamp(0.0, 1.0),
      y: (y - (change * 0.5)).clamp(0.0, 1.0),
      m: (m - (change * 0.5)).clamp(0.0, 1.0),
    );
  }

  @override
  List<CMYK> generateBasicPalette() {
    return <CMYK>[
      lighten(40),
      lighten(20),
      this,
      darken(20),
      darken(40),
    ];
  }

  @override
  List<CMYK> tonesPalette() {
    return List<CMYK>.generate(9, (final int i) => blacken(10.0 * i));
  }

  @override
  List<CMYK> analogous({final int count = 5, final double offset = 30}) {
    final HctColor hct = toHctColor();
    return List<CMYK>.generate(count, (final int i) {
      final double hueShift = (i - (count ~/ 2)) * offset;
      return hct.copyWith(hue: (hct.hue + hueShift) % 360).toCMYK();
    });
  }

  @override
  List<CMYK> square() {
    final HctColor hct = toHctColor();
    return <double>[0, 90, 180, 270]
        .map(
          (final double hue) =>
              hct.copyWith(hue: (hct.hue + hue) % 360).toCMYK(),
        )
        .toList();
  }

  @override
  List<CMYK> tetrad({final double offset = 60}) {
    final HctColor hct = toHctColor();
    const double second = 180;
    return <double>[0, offset, second, (second + offset) % 360]
        .map(
          (final double hue) =>
              hct.copyWith(hue: (hct.hue + hue) % 360).toCMYK(),
        )
        .toList();
  }

  CMYK get grayscale {
    // Using a weighted average of C, M, Y to determine the gray value for K
    final double gray = c * 0.3 + m * 0.59 + y * 0.11;
    return CMYK(0, 0, 0, (gray + k).clamp(0.0, 1.0));
  }

  @override
  CMYK simulate(final ColorBlindnessType type) {
    final ColorIQ simulatedColor = toColor().simulate(type);
    return CMYK.fromColorSpacesIQ(simulatedColor);
  }

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'CmykColor',
      'c': c,
      'm': m,
      'y': y,
      'k': k,
    };
  }

  @override
  String toString() => 'CmykColor(c: ${c.toStrTrimZeros(2)}, ' //
      'm: ${m.toStringAsFixed(2)}, ' //
      'y: ${y.toStringAsFixed(2)}, k: ${k.toStringAsFixed(2)})';

  @override
  int get hashCode {
    final int cHash = c.hashCode;
    final int mHash = m.hashCode;
    final int yHash = y.hashCode;
    final int kHash = k.hashCode;
    return cHash ^ (mHash << 7) ^ (yHash << 14) ^ (kHash << 21);
  }
}
