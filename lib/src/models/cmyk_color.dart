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
/// This class provides methods to convert CMYK colors to other color spaces (like RGB via `ColorIQ`),
/// and to perform various color manipulations such as lightening, darkening, and generating palettes.
/// It implements the `ColorSpacesIQ` interface, ensuring a consistent API for color operations
/// across different color models in this library.
///
class CmykColor extends ColorSpacesIQ with ColorModelsMixin {
  final double c;
  final double m;
  final double y;
  final double k;

  /// Constructs a CMYK color from normalized cyan, magenta, yellow, and black values.
  ///
  /// [c], [m], [y], and [k] must be between 0.0 and 1.0.
  const CmykColor(this.c, this.m, this.y, this.k,
      {required final int value,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : assert(c >= 0 && c <= 1, 'Invalid C value: $c'),
        assert(m >= 0 && m <= 1, 'Invalid M value: $m'),
        assert(y >= 0 && y <= 1, 'Invalid Y value: $y'),
        assert(k >= 0 && k <= 1, 'Invalid K value: $k'),
        super(value, a: alpha, names: names ?? const <String>[]);

  /// Alternative constructor for creating a CMYK color, optionally calculating the hex ID if not provided.
  ///
  /// [c], [m], [y], and [k] must be between 0.0 and 1.0.
  CmykColor.alt(this.c, this.m, this.y, this.k,
      {final int? value,
      final Percent alpha = Percent.max,
      final List<String>? names})
      : assert(c >= 0 && c <= 1, 'Invalid C value: $c'),
        assert(m >= 0 && m <= 1, 'Invalid M value: $m'),
        assert(y >= 0 && y <= 1, 'Invalid Y value: $y'),
        assert(k >= 0 && k <= 1, 'Invalid K value: $k'),
        super(value ?? CmykColor.hexFromCmyk(c, m, y, k),
            a: alpha, names: names ?? const <String>[]);

  /// Converts this CMYK color to the sRGB color space.
  @override
  ColorIQ toColor() {
    final double r = 255 * (1 - c) * (1 - k);
    final double g = 255 * (1 - m) * (1 - k);
    final double b = 255 * (1 - y) * (1 - k);
    return ColorIQ.fromARGB(
      255,
      r.round().clamp(0, 255),
      g.round().clamp(0, 255),
      b.round().clamp(0, 255),
    );
  }

  /// Creates a [CmykColor] instance from a 32-bit integer ARGB `hexID`.
  ///
  /// The `hexID` is a 32-bit integer in the format `0xAARRGGBB`.
  /// The alpha component is ignored in the CMYK conversion.
  factory CmykColor.fromInt(final int hexID) {
    final double r = (hexID >> 16 & 0xFF) / 255.0;
    final double g = (hexID >> 8 & 0xFF) / 255.0;
    final double b = (hexID & 0xFF) / 255.0;

    final double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CmykColor.alt(0, 0, 0, 1, value: hexID);
    }
    final double c = (1.0 - r - k) / (1.0 - k);
    final double m = (1.0 - g - k) / (1.0 - k);
    final double y = (1.0 - b - k) / (1.0 - k);

    return CmykColor.alt(c, m, y, k, value: hexID);
  }

  /// Converts this color to CMYK.
  static CmykColor fromColorSpacesIQ(final ColorSpacesIQ clr) {
    final double r = clr.r;
    final double g = clr.g;
    final double b = clr.b;

    final double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CmykColor.alt(0, 0, 0, 1);
    }

    final double c = (1.0 - r - k) / (1.0 - k);
    final double m = (1.0 - g - k) / (1.0 - k);
    final double y = (1.0 - b - k) / (1.0 - k);

    return CmykColor.alt(c, m, y, k);
  }

  /// Converts this color to CMYK.
  CmykColor fromColor() {
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double k = 1.0 - max(r, max(g, b));
    if (k == 1.0) {
      return CmykColor.alt(0, 0, 0, 1);
    }

    final double c = (1.0 - r - k) / (1.0 - k);
    final double m = (1.0 - g - k) / (1.0 - k);
    final double y = (1.0 - b - k) / (1.0 - k);

    return CmykColor.alt(c, m, y, k);
  }

  @override
  int get value => toColor().value;

  @override
  bool operator ==(final Object other) =>
      other is CmykColor &&
      other.c == c &&
      other.m == m &&
      other.y == y &&
      other.k == k;

  @override
  CmykColor lighten([final double amount = 20]) {
    return whiten(amount);
  }

  @override
  CmykColor darken([final double amount = 20]) {
    return blacken(amount);
  }

  @override
  CmykColor brighten([final double amount = 20]) {
    // Brighten by reducing the black component
    final double newK = (k * (1 - amount / 100)).clamp(0.0, 1.0);
    return copyWith(k: newK);
  }

  @override
  CmykColor saturate([final double amount = 25]) {
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
  CmykColor desaturate([final double amount = 25]) {
    return lerp(grayscale, amount / 100);
  }

  @override
  CmykColor intensify([final double amount = 10]) {
    return saturate(amount);
  }

  @override
  CmykColor deintensify([final double amount = 10]) {
    return desaturate(amount);
  }

  @override
  CmykColor accented([final double amount = 15]) {
    return saturate(amount);
  }

  @override
  CmykColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  CmykColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  CmykColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final CmykColor otherCmyk =
        other is CmykColor ? other : CmykColor.fromColorSpacesIQ(other);
    if (t == 1.0) return otherCmyk;

    return CmykColor.alt(
      lerpDouble(c, otherCmyk.c, t),
      lerpDouble(m, otherCmyk.m, t),
      lerpDouble(y, otherCmyk.y, t),
      lerpDouble(k, otherCmyk.k, t),
    );
  }

  /// Generates a 32-bit hex value from CMYK components.
  ///
  /// This is a stand-alone static utility function to convert CMYK values
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

  @override
  CmykColor fromHct(final HctColor hct) => CmykColor.fromColorSpacesIQ(hct);

  @override
  CmykColor adjustTransparency([final double amount = 20]) {
    return CmykColor.fromColorSpacesIQ(toColor().adjustTransparency(amount));
  }

  @override
  double get transparency => toColor().transparency;

  @override
  ColorTemperature get temperature => toColor().temperature;

  /// Creates a copy of this color with the given fields replaced with the new values.
  CmykColor copyWith({
    final double? c,
    final double? m,
    final double? y,
    final double? k,
  }) {
    return CmykColor.alt(c ?? this.c, m ?? this.m, y ?? this.y, k ?? this.k);
  }

  @override
  List<ColorSpacesIQ> get monochromatic {
    // Generate a simple monochromatic set by varying K while keeping C/M/Y fixed
    final List<double> kValues = <double>[
      k,
      0.75,
      0.5,
      0.25,
      0.0,
    ].map((final double v) => v.clamp(0.0, 1.0)).toList();

    return kValues
        .map((final double kVal) => CmykColor.alt(c, m, y, kVal))
        .toList();
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    final List<CmykColor> results = <CmykColor>[];
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
    final List<CmykColor> results = <CmykColor>[];
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
    return CmykColor.alt(
      random.nextDouble(),
      random.nextDouble(),
      random.nextDouble(),
      random.nextDouble(),
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) =>
      other is CmykColor &&
      other.c == c &&
      other.m == m &&
      other.y == y &&
      other.k == k;

  @override
  Brightness get brightness =>
      luminance > 0.5 ? Brightness.light : Brightness.dark;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  /// Blends this color with another color.
  /// The `amount` parameter specifies the percentage of the `other` color to blend.
  /// It defaults to 50, which is an equal mix.
  @override
  CmykColor blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100);
  }

  @override
  CmykColor opaquer([final double amount = 20]) {
    // In CMYK, "opaquer" is not directly applicable as it's a subtractive model
    // for reflective surfaces, not a light-emitting one. This is a no-op.
    return this;
  }

  @override
  CmykColor adjustHue([final double amount = 20]) {
    final HctColor hct = toHctColor();
    return hct.copyWith(hue: (hct.hue + amount) % 360).toCMYK();
  }

  @override
  CmykColor get complementary {
    return CmykColor.fromColorSpacesIQ(toHctColor().flipHue());
  }

  @override
  CmykColor warmer([final double amount = 20]) {
    // Increase yellow and magenta, decrease cyan
    final double change = amount / 100.0;
    return copyWith(
      y: (y + change).clamp(0.0, 1.0),
      m: (m + (change * 0.5)).clamp(0.0, 1.0),
      c: (c - (change * 0.5)).clamp(0.0, 1.0),
    );
  }

  @override
  CmykColor cooler([final double amount = 20]) {
    // Increase cyan, decrease yellow and magenta
    final double change = amount / 100.0;
    return copyWith(
      c: (c + change).clamp(0.0, 1.0),
      y: (y - (change * 0.5)).clamp(0.0, 1.0),
      m: (m - (change * 0.5)).clamp(0.0, 1.0),
    );
  }

  @override
  List<CmykColor> generateBasicPalette() {
    return <CmykColor>[
      lighten(40),
      lighten(20),
      this,
      darken(20),
      darken(40),
    ];
  }

  @override
  List<CmykColor> tonesPalette() {
    return List<CmykColor>.generate(9, (final int i) => blacken(10.0 * i));
  }

  @override
  List<CmykColor> analogous({final int count = 5, final double offset = 30}) {
    final HctColor hct = toHctColor();
    return List<CmykColor>.generate(count, (final int i) {
      final double hueShift = (i - (count ~/ 2)) * offset;
      return hct.copyWith(hue: (hct.hue + hueShift) % 360).toCMYK();
    });
  }

  @override
  List<CmykColor> square() {
    final HctColor hct = toHctColor();
    return <double>[0, 90, 180, 270]
        .map(
          (final double hue) =>
              hct.copyWith(hue: (hct.hue + hue) % 360).toCMYK(),
        )
        .toList();
  }

  @override
  List<CmykColor> tetrad({final double offset = 60}) {
    final HctColor hct = toHctColor();
    const double second = 180;
    return <double>[0, offset, second, (second + offset) % 360]
        .map(
          (final double hue) =>
              hct.copyWith(hue: (hct.hue + hue) % 360).toCMYK(),
        )
        .toList();
  }

  @override
  CmykColor get inverted => CmykColor.fromColorSpacesIQ(toColor().inverted);

  @override
  CmykColor get grayscale {
    // Using a weighted average of C, M, Y to determine the gray value for K
    final double gray = c * 0.3 + m * 0.59 + y * 0.11;
    return CmykColor.alt(0, 0, 0, (gray + k).clamp(0.0, 1.0));
  }

  @override
  CmykColor simulate(final ColorBlindnessType type) {
    final ColorIQ simulatedColor = toColor().simulate(type);
    return CmykColor.fromColorSpacesIQ(simulatedColor);
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
