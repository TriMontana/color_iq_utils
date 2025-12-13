import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';

/// A representation of a color in the IPT color space.
///
/// IPT (Intensity, Protan, Tritan) is a perceptually uniform color space
/// developed by Ebner and Fairchild (1998). It is optimized for:
/// - **Gamut mapping:** Excellent for compressing out-of-gamut colors
/// - **Hue uniformity:** Constant hue lines are more uniform than Lab
/// - **HDR applications:** Used in Apple's ColorSync and many HDR workflows
///
/// Components:
/// - **I (Intensity):** Achromatic/lightness dimension (0 = black, 1 = white)
/// - **P (Protan):** Red-green opponent dimension (named for protan color blindness)
/// - **T (Tritan):** Yellow-blue opponent dimension (named for tritan color blindness)
///
/// The space uses a D65 illuminant for conversions.
class IptColor extends CommonIQ implements ColorSpacesIQ {
  /// The intensity (lightness) component, typically 0.0 to 1.0.
  final double i;

  /// The protan (red-green) component, typically -0.5 to 0.5.
  final double p;

  /// The tritan (yellow-blue) component, typically -0.5 to 0.5.
  final double t;

  /// Creates an [IptColor] from I, P, T components.
  const IptColor(
    this.i,
    this.p,
    this.t, {
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? _computeHexId();

  // XYZ D65 to LMS matrix (Hunt-Pointer-Estevez adapted for D65)
  static const List<List<double>> _xyzToLms = <List<double>>[
    <double>[0.4002, 0.7076, -0.0808],
    <double>[-0.2263, 1.1653, 0.0457],
    <double>[0.0000, 0.0000, 0.9182],
  ];

  // LMS to XYZ matrix (inverse of above)
  static const List<List<double>> _lmsToXyz = <List<double>>[
    <double>[1.8502429449, -1.1383016378, 0.2384164551],
    <double>[0.3668307751, 0.6438845448, -0.0106647817],
    <double>[0.0000000000, 0.0000000000, 1.0890636230],
  ];

  // LMS' to IPT matrix
  static const List<List<double>> _lmsToIpt = <List<double>>[
    <double>[0.4000, 0.4000, 0.2000],
    <double>[4.4550, -4.8510, 0.3960],
    <double>[0.8056, 0.3572, -1.1628],
  ];

  // IPT to LMS' matrix (inverse of above)
  static const List<List<double>> _iptToLms = <List<double>>[
    <double>[1.0000, 0.0976, 0.2052],
    <double>[1.0000, -0.1139, 0.1332],
    <double>[1.0000, 0.0326, -0.6769],
  ];

  /// Computes ARGB from IPT values.
  int _computeHexId() {
    // IPT to LMS'
    final double lPrime =
        _iptToLms[0][0] * i + _iptToLms[0][1] * p + _iptToLms[0][2] * t;
    final double mPrime =
        _iptToLms[1][0] * i + _iptToLms[1][1] * p + _iptToLms[1][2] * t;
    final double sPrime =
        _iptToLms[2][0] * i + _iptToLms[2][1] * p + _iptToLms[2][2] * t;

    // LMS' to LMS (inverse of power function)
    double invPow(final double x) {
      final double sign = x < 0 ? -1.0 : 1.0;
      return sign * pow(x.abs(), 1.0 / 0.43).toDouble();
    }

    final double l = invPow(lPrime);
    final double m = invPow(mPrime);
    final double s = invPow(sPrime);

    // LMS to XYZ
    final double x =
        _lmsToXyz[0][0] * l + _lmsToXyz[0][1] * m + _lmsToXyz[0][2] * s;
    final double y =
        _lmsToXyz[1][0] * l + _lmsToXyz[1][1] * m + _lmsToXyz[1][2] * s;
    final double z =
        _lmsToXyz[2][0] * l + _lmsToXyz[2][1] * m + _lmsToXyz[2][2] * s;

    // XYZ to linear sRGB
    final double rLin = 3.2404541621 * x - 1.5371385940 * y - 0.4985314095 * z;
    final double gLin = -0.9692660305 * x + 1.8760108454 * y + 0.0415560175 * z;
    final double bLin = 0.0556434309 * x - 0.2040259135 * y + 1.0572251882 * z;

    // Linear to sRGB (gamma correction)
    int gammaCorrect(double linear) {
      linear = linear.clamp(0.0, 1.0);
      final double srgb = linear <= 0.0031308
          ? 12.92 * linear
          : 1.055 * pow(linear, 1.0 / 2.4) - 0.055;
      return (srgb.clamp(0.0, 1.0) * 255).round();
    }

    final int r = gammaCorrect(rLin);
    final int g = gammaCorrect(gLin);
    final int b = gammaCorrect(bLin);
    final int a = (alpha.val * 255).round();

    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  /// Creates an [IptColor] from an ARGB integer.
  factory IptColor.fromInt(final int argb) {
    // sRGB to linear
    double linearize(final double srgb) {
      return srgb <= 0.04045
          ? srgb / 12.92
          : pow((srgb + 0.055) / 1.055, 2.4).toDouble();
    }

    final double r = linearize(((argb >> 16) & 0xFF) / 255.0);
    final double g = linearize(((argb >> 8) & 0xFF) / 255.0);
    final double b = linearize((argb & 0xFF) / 255.0);

    // sRGB to XYZ (D65)
    final double x = 0.4124564 * r + 0.3575761 * g + 0.1804375 * b;
    final double y = 0.2126729 * r + 0.7151522 * g + 0.0721750 * b;
    final double z = 0.0193339 * r + 0.1191920 * g + 0.9503041 * b;

    // XYZ to LMS
    final double l =
        _xyzToLms[0][0] * x + _xyzToLms[0][1] * y + _xyzToLms[0][2] * z;
    final double m =
        _xyzToLms[1][0] * x + _xyzToLms[1][1] * y + _xyzToLms[1][2] * z;
    final double s =
        _xyzToLms[2][0] * x + _xyzToLms[2][1] * y + _xyzToLms[2][2] * z;

    // LMS to LMS' (power function with sign preservation)
    double applyPow(final double val) {
      final double sign = val < 0 ? -1.0 : 1.0;
      return sign * pow(val.abs(), 0.43).toDouble();
    }

    final double lPrime = applyPow(l);
    final double mPrime = applyPow(m);
    final double sPrime = applyPow(s);

    // LMS' to IPT
    final double iVal = _lmsToIpt[0][0] * lPrime +
        _lmsToIpt[0][1] * mPrime +
        _lmsToIpt[0][2] * sPrime;
    final double pVal = _lmsToIpt[1][0] * lPrime +
        _lmsToIpt[1][1] * mPrime +
        _lmsToIpt[1][2] * sPrime;
    final double tVal = _lmsToIpt[2][0] * lPrime +
        _lmsToIpt[2][1] * mPrime +
        _lmsToIpt[2][2] * sPrime;

    return IptColor(
      iVal,
      pVal,
      tVal,
      hexId: argb,
      alpha: Percent(((argb >> 24) & 0xFF) / 255.0),
    );
  }

  /// Creates an [IptColor] from another [ColorSpacesIQ] instance.
  factory IptColor.from(final ColorSpacesIQ color) =>
      IptColor.fromInt(color.value);

  /// Creates an [IptColor] from XYZ coordinates.
  factory IptColor.fromXyz(final XYZ xyz) {
    final double x = xyz.x / 100;
    final double y = xyz.y / 100;
    final double z = xyz.z / 100;

    final double l =
        _xyzToLms[0][0] * x + _xyzToLms[0][1] * y + _xyzToLms[0][2] * z;
    final double m =
        _xyzToLms[1][0] * x + _xyzToLms[1][1] * y + _xyzToLms[1][2] * z;
    final double s =
        _xyzToLms[2][0] * x + _xyzToLms[2][1] * y + _xyzToLms[2][2] * z;

    double applyPow(final double val) {
      final double sign = val < 0 ? -1.0 : 1.0;
      return sign * pow(val.abs(), 0.43).toDouble();
    }

    final double lPrime = applyPow(l);
    final double mPrime = applyPow(m);
    final double sPrime = applyPow(s);

    final double iVal = _lmsToIpt[0][0] * lPrime +
        _lmsToIpt[0][1] * mPrime +
        _lmsToIpt[0][2] * sPrime;
    final double pVal = _lmsToIpt[1][0] * lPrime +
        _lmsToIpt[1][1] * mPrime +
        _lmsToIpt[1][2] * sPrime;
    final double tVal = _lmsToIpt[2][0] * lPrime +
        _lmsToIpt[2][1] * mPrime +
        _lmsToIpt[2][2] * sPrime;

    return IptColor(iVal, pVal, tVal);
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Converts to XYZ color space.
  XYZ toXyz() {
    final double lPrime =
        _iptToLms[0][0] * i + _iptToLms[0][1] * p + _iptToLms[0][2] * t;
    final double mPrime =
        _iptToLms[1][0] * i + _iptToLms[1][1] * p + _iptToLms[1][2] * t;
    final double sPrime =
        _iptToLms[2][0] * i + _iptToLms[2][1] * p + _iptToLms[2][2] * t;

    double invPow(final double x) {
      final double sign = x < 0 ? -1.0 : 1.0;
      return sign * pow(x.abs(), 1.0 / 0.43).toDouble();
    }

    final double l = invPow(lPrime);
    final double m = invPow(mPrime);
    final double s = invPow(sPrime);

    final double x =
        _lmsToXyz[0][0] * l + _lmsToXyz[0][1] * m + _lmsToXyz[0][2] * s;
    final double y =
        _lmsToXyz[1][0] * l + _lmsToXyz[1][1] * m + _lmsToXyz[1][2] * s;
    final double z =
        _lmsToXyz[2][0] * l + _lmsToXyz[2][1] * m + _lmsToXyz[2][2] * s;

    return XYZ(x * 100, y * 100, z * 100);
  }

  /// Gets the chroma (colorfulness) of this color.
  double get chroma => sqrt(p * p + t * t);

  /// Gets the hue angle in degrees.
  double get hue {
    double h = atan2(t, p) * 180 / pi;
    if (h < 0) h += 360;
    return h;
  }

  @override
  IptColor whiten([final double amount = 20]) => lerp(cWhite, amount / 100);

  @override
  IptColor blacken([final double amount = 20]) => lerp(cBlack, amount / 100);

  @override
  IptColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final IptColor otherIpt = other is IptColor ? other : IptColor.from(other);
    if (t == 1.0) return otherIpt;

    return IptColor(
      lerpDouble(i, otherIpt.i, t),
      lerpDouble(p, otherIpt.p, t),
      lerpDouble(this.t, otherIpt.t, t),
    );
  }

  @override
  IptColor lighten([final double amount = 20]) {
    return copyWith(i: (i + amount / 100).clamp(0.0, 1.0));
  }

  @override
  IptColor darken([final double amount = 20]) {
    return copyWith(i: (i - amount / 100).clamp(0.0, 1.0));
  }

  @override
  IptColor saturate([final double amount = 25]) {
    final double factor = 1 + amount / 100;
    return copyWith(
      p: p * factor,
      t: t * factor,
    );
  }

  @override
  IptColor desaturate([final double amount = 25]) {
    final double factor = (1 - amount / 100).clamp(0.0, 1.0);
    return copyWith(
      p: p * factor,
      t: t * factor,
    );
  }

  @override
  IptColor accented([final double amount = 15]) {
    return toColor().accented(amount).ipt;
  }

  @override
  IptColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).ipt;
  }

  /// Creates a copy with the given fields replaced.
  @override
  IptColor copyWith({
    final double? i,
    final double? p,
    final double? t,
    final Percent? alpha,
  }) {
    return IptColor(
      i ?? this.i,
      p ?? this.p,
      t ?? this.t,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<IptColor> get monochromatic => <IptColor>[
        darken(20),
        darken(10),
        this,
        lighten(10),
        lighten(20),
      ];

  @override
  List<IptColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <IptColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<IptColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <IptColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  IptColor get random {
    final Random rng = Random();
    return IptColor(
      rng.nextDouble(),
      rng.nextDouble() - 0.5,
      rng.nextDouble() - 0.5,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is IptColor) {
      const double epsilon = 0.001;
      return (i - other.i).abs() < epsilon &&
          (p - other.p).abs() < epsilon &&
          (t - other.t).abs() < epsilon;
    }
    return value == other.value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  IptColor blend(final ColorSpacesIQ other, [final double amount = 50]) =>
      lerp(other, amount / 100);

  @override
  IptColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  IptColor adjustHue([final double amount = 20]) {
    final double currentHue = hue;
    final double currentChroma = chroma;
    double newHue = (currentHue + amount) % 360;
    if (newHue < 0) newHue += 360;

    final double hRad = newHue * pi / 180;
    return copyWith(
      p: currentChroma * cos(hRad),
      t: currentChroma * sin(hRad),
    );
  }

  @override
  IptColor get complementary => adjustHue(180);

  @override
  IptColor warmer([final double amount = 20]) {
    return toColor().warmer(amount).ipt;
  }

  @override
  IptColor cooler([final double amount = 20]) {
    return toColor().cooler(amount).ipt;
  }

  @override
  List<IptColor> generateBasicPalette() => <IptColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<IptColor> tonesPalette() => <IptColor>[
        this,
        desaturate(15),
        desaturate(30),
        desaturate(45),
        desaturate(60),
      ];

  @override
  List<IptColor> analogous({final int count = 5, final double offset = 30}) {
    final List<IptColor> palette = <IptColor>[];
    final double startHue = hue - ((count - 1) / 2) * offset;
    for (int idx = 0; idx < count; idx++) {
      double newHue = (startHue + idx * offset) % 360;
      if (newHue < 0) newHue += 360;
      final double hRad = newHue * pi / 180;
      palette.add(copyWith(
        p: chroma * cos(hRad),
        t: chroma * sin(hRad),
      ));
    }
    return palette;
  }

  @override
  List<IptColor> square() => <IptColor>[
        this,
        adjustHue(90),
        adjustHue(180),
        adjustHue(270),
      ];

  @override
  List<IptColor> tetrad({final double offset = 60}) => <IptColor>[
        this,
        adjustHue(offset),
        adjustHue(180),
        adjustHue(180 + offset),
      ];

  @override
  List<IptColor> split({final double offset = 30}) => <IptColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<IptColor> triad({final double offset = 120}) => <IptColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<IptColor> twoTone({final double offset = 60}) => <IptColor>[
        this,
        adjustHue(offset),
      ];

  @override
  double contrastWith(final ColorSpacesIQ other) =>
      toColor().contrastWith(other);

  @override
  ColorSlice closestColorSlice() => toColor().closestColorSlice();

  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) =>
      toColor().isWithinGamut(gamut);

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': 'IptColor',
        'i': i,
        'p': p,
        't': t,
        'alpha': alpha.val,
      };

  @override
  String toString() => 'IptColor(i: ${i.toStringAsFixed(4)}, '
      'p: ${p.toStringAsFixed(4)}, t: ${t.toStringAsFixed(4)})';
}
