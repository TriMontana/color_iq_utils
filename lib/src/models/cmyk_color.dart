import 'package:color_iq_utils/src/color_interfaces.dart';
import 'package:color_iq_utils/src/color_temperature.dart';

import 'package:color_iq_utils/src/constants.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:material_color_utilities/hct/cam16.dart';

class CmykColor with ColorModelsMixin implements ColorSpacesIQ {
  final double c;
  final double m;
  final double y;
  final double k;

  const CmykColor(this.c, this.m, this.y, this.k);

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
    return toColor().lighten(amount).toCmyk();
  }

  @override
  CmykColor darken([final double amount = 20]) {
    return toColor().darken(amount).toCmyk();
  }

  @override
  CmykColor brighten([final double amount = 20]) {
    return toColor().brighten(amount).toCmyk();
  }

  @override
  CmykColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).toCmyk();
  }

  @override
  CmykColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).toCmyk();
  }

  @override
  CmykColor intensify([final double amount = 10]) {
    return toColor().intensify(amount).toCmyk();
  }

  @override
  CmykColor deintensify([final double amount = 10]) {
    return toColor().deintensify(amount).toCmyk();
  }

  @override
  CmykColor accented([final double amount = 15]) {
    return toColor().accented(amount).toCmyk();
  }

  @override
  CmykColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).toCmyk();
  }

  @override
  List<int> get srgb => toColor().srgb;

  @override
  List<double> get linearSrgb => toColor().linearSrgb;

  @override
  CmykColor get inverted => toColor().inverted.toCmyk();

  @override
  CmykColor get grayscale => toColor().grayscale.toCmyk();

  @override
  CmykColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  CmykColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  CmykColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final CmykColor otherCmyk =
        other is CmykColor ? other : other.toColor().toCmyk();
    if (t == 1.0) return otherCmyk;

    return CmykColor(
      lerpDouble(c, otherCmyk.c, t),
      lerpDouble(m, otherCmyk.m, t),
      lerpDouble(y, otherCmyk.y, t),
      lerpDouble(k, otherCmyk.k, t),
    );
  }

  @override
  HctColor toHct() => HctColor.fromInt(value);

  @override
  CmykColor fromHct(final HctColor hct) => hct.toColor().toCmyk();

  @override
  CmykColor adjustTransparency([final double amount = 20]) {
    return toColor().adjustTransparency(amount).toCmyk();
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
    return CmykColor(c ?? this.c, m ?? this.m, y ?? this.y, k ?? this.k);
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
        .map((final double kVal) => CmykColor(c, m, y, kVal))
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
  ColorSpacesIQ get random => (toColor().random as ColorIQ).toCmyk();

  @override
  bool isEqual(final ColorSpacesIQ other) => toColor().isEqual(other);

  @override
  double get luminance => toColor().luminance;

  @override
  Brightness get brightness => toColor().brightness;

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  CmykColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      toColor().blend(other, amount).toCmyk();

  @override
  CmykColor opaquer([final double amount = 20]) =>
      toColor().opaquer(amount).toCmyk();

  @override
  CmykColor adjustHue([final double amount = 20]) =>
      toColor().adjustHue(amount).toCmyk();

  @override
  CmykColor get complementary => toColor().complementary.toCmyk();

  @override
  CmykColor warmer([final double amount = 20]) =>
      toColor().warmer(amount).toCmyk();

  @override
  CmykColor cooler([final double amount = 20]) =>
      toColor().cooler(amount).toCmyk();

  @override
  List<CmykColor> generateBasicPalette() => toColor()
      .generateBasicPalette()
      .map((final ColorIQ c) => c.toCmyk())
      .toList();

  @override
  List<CmykColor> tonesPalette() =>
      toColor().tonesPalette().map((final ColorIQ c) => c.toCmyk()).toList();

  @override
  List<CmykColor> analogous({final int count = 5, final double offset = 30}) =>
      toColor()
          .analogous(count: count, offset: offset)
          .map((final ColorIQ c) => c.toCmyk())
          .toList();

  @override
  List<CmykColor> square() {
    final HctColor hct = toHct();
    return <double>[0, 90, 180, 270]
        .map(
          (final double hue) =>
              hct.copyWith(hue: (hct.hue + hue) % 360).toColor().toCmyk(),
        )
        .toList();
  }

  @override
  List<CmykColor> tetrad({final double offset = 60}) {
    final HctColor hct = toHct();
    const double second = 180;
    return <double>[0, offset, second, (second + offset) % 360]
        .map(
          (final double hue) =>
              hct.copyWith(hue: (hct.hue + hue) % 360).toColor().toCmyk(),
        )
        .toList();
  }

  @override
  double distanceTo(final ColorSpacesIQ other) =>
      toCam16().distance(other.toCam16());

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  List<double> get whitePoint => <double>[95.047, 100.0, 108.883];

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
  String toString() => 'CmykColor(c: ${c.toStringAsFixed(2)}, ' //
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

  @override
  Cam16 toCam16() => Cam16.fromInt(value);
}
