import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';

/// A representation of a color in the ProPhoto RGB color space (ROMM RGB).
///
/// ProPhoto RGB (also known as ROMM RGB - Reference Output Medium Metric) is
/// a wide-gamut color space developed by Kodak for photography. It covers:
/// - **~90% of visible colors** (much wider than sRGB's ~35%)
/// - **87% of Pointer's Gamut** (all real surface colors)
///
/// Key characteristics:
/// - **D50 white point** (differs from sRGB's D65)
/// - **Wide gamut:** Can represent colors outside sRGB
/// - **Photography standard:** Used in Lightroom, Photoshop for editing
/// - **Imaginary colors:** Some coordinates represent colors outside human vision
///
/// Components:
/// - **r:** Red component (0.0 to 1.0, can exceed for out-of-gamut)
/// - **g:** Green component (0.0 to 1.0, can exceed for out-of-gamut)
/// - **b:** Blue component (0.0 to 1.0, can exceed for out-of-gamut)
///
/// > **Warning:** ProPhoto RGB values outside 0-1 represent colors that cannot
/// > be displayed on typical monitors. Clamp or gamut-map before display.
class ProPhotoRgbColor extends CommonIQ implements ColorSpacesIQ {
  /// The red component, typically 0.0 to 1.0 (can exceed for wide gamut).
  final double rPro;

  /// The green component, typically 0.0 to 1.0 (can exceed for wide gamut).
  final double gPro;

  /// The blue component, typically 0.0 to 1.0 (can exceed for wide gamut).
  final double bPro;

  /// Creates a [ProPhotoRgbColor] from R, G, B components.
  const ProPhotoRgbColor(
    this.rPro,
    this.gPro,
    this.bPro, {
    final int? hexId,
    final Percent alpha = Percent.max,
    final List<String>? names,
  }) : super(hexId, alpha: alpha, names: names ?? kEmptyNames);

  @override
  int get value => super.colorId ?? _computeHexId();

  // ProPhoto RGB to XYZ D50 matrix
  static const List<List<double>> _proPhotoToXyzD50 = <List<double>>[
    <double>[0.7976749, 0.1351917, 0.0313534],
    <double>[0.2880402, 0.7118741, 0.0000857],
    <double>[0.0000000, 0.0000000, 0.8252100],
  ];

  // XYZ D50 to ProPhoto RGB matrix (inverse of above)
  static const List<List<double>> _xyzD50ToProPhoto = <List<double>>[
    <double>[1.3459433, -0.2556075, -0.0511118],
    <double>[-0.5445989, 1.5081673, 0.0205351],
    <double>[0.0000000, 0.0000000, 1.2118128],
  ];

  // Bradford chromatic adaptation D50 to D65
  static const List<List<double>> _bradfordD50ToD65 = <List<double>>[
    <double>[0.9555766, -0.0230393, 0.0631636],
    <double>[-0.0282895, 1.0099416, 0.0210077],
    <double>[0.0122982, -0.0204830, 1.3299098],
  ];

  // Bradford chromatic adaptation D65 to D50
  static const List<List<double>> _bradfordD65ToD50 = <List<double>>[
    <double>[1.0478112, 0.0228866, -0.0501270],
    <double>[0.0295424, 0.9904844, -0.0170491],
    <double>[-0.0092345, 0.0150436, 0.7521316],
  ];

  // ProPhoto RGB transfer function exponent
  static const double _gamma = 1.8;
  static const double _gammaInv = 1.0 / 1.8;

  /// Computes ARGB (sRGB) from ProPhoto RGB values.
  int _computeHexId() {
    // Apply ProPhoto gamma (linearize)
    double linearize(final double v) {
      if (v <= 16 / 512) {
        return v / 16;
      }
      return pow(v, _gamma).toDouble();
    }

    final double rLin = linearize(rPro.clamp(0.0, 1.0));
    final double gLin = linearize(gPro.clamp(0.0, 1.0));
    final double bLin = linearize(bPro.clamp(0.0, 1.0));

    // ProPhoto linear to XYZ D50
    final double xD50 = _proPhotoToXyzD50[0][0] * rLin +
        _proPhotoToXyzD50[0][1] * gLin +
        _proPhotoToXyzD50[0][2] * bLin;
    final double yD50 = _proPhotoToXyzD50[1][0] * rLin +
        _proPhotoToXyzD50[1][1] * gLin +
        _proPhotoToXyzD50[1][2] * bLin;
    final double zD50 = _proPhotoToXyzD50[2][0] * rLin +
        _proPhotoToXyzD50[2][1] * gLin +
        _proPhotoToXyzD50[2][2] * bLin;

    // Chromatic adaptation D50 to D65 (Bradford)
    final double xD65 = _bradfordD50ToD65[0][0] * xD50 +
        _bradfordD50ToD65[0][1] * yD50 +
        _bradfordD50ToD65[0][2] * zD50;
    final double yD65 = _bradfordD50ToD65[1][0] * xD50 +
        _bradfordD50ToD65[1][1] * yD50 +
        _bradfordD50ToD65[1][2] * zD50;
    final double zD65 = _bradfordD50ToD65[2][0] * xD50 +
        _bradfordD50ToD65[2][1] * yD50 +
        _bradfordD50ToD65[2][2] * zD50;

    // XYZ D65 to linear sRGB
    final double rSrgbLin =
        3.2404541621 * xD65 - 1.5371385940 * yD65 - 0.4985314095 * zD65;
    final double gSrgbLin =
        -0.9692660305 * xD65 + 1.8760108454 * yD65 + 0.0415560175 * zD65;
    final double bSrgbLin =
        0.0556434309 * xD65 - 0.2040259135 * yD65 + 1.0572251882 * zD65;

    // Linear sRGB to sRGB (gamma correction)
    int gammaCorrect(double linear) {
      linear = linear.clamp(0.0, 1.0);
      final double srgb = linear <= 0.0031308
          ? 12.92 * linear
          : 1.055 * pow(linear, 1.0 / 2.4) - 0.055;
      return (srgb.clamp(0.0, 1.0) * 255).round();
    }

    final int r = gammaCorrect(rSrgbLin);
    final int g = gammaCorrect(gSrgbLin);
    final int b = gammaCorrect(bSrgbLin);
    final int a = (alpha.val * 255).round();

    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  /// Creates a [ProPhotoRgbColor] from an ARGB integer.
  factory ProPhotoRgbColor.fromInt(final int argb) {
    // sRGB to linear sRGB
    double linearize(final double srgb) {
      return srgb <= 0.04045
          ? srgb / 12.92
          : pow((srgb + 0.055) / 1.055, 2.4).toDouble();
    }

    final double rLin = linearize(((argb >> 16) & 0xFF) / 255.0);
    final double gLin = linearize(((argb >> 8) & 0xFF) / 255.0);
    final double bLin = linearize((argb & 0xFF) / 255.0);

    // Linear sRGB to XYZ D65
    final double xD65 = 0.4124564 * rLin + 0.3575761 * gLin + 0.1804375 * bLin;
    final double yD65 = 0.2126729 * rLin + 0.7151522 * gLin + 0.0721750 * bLin;
    final double zD65 = 0.0193339 * rLin + 0.1191920 * gLin + 0.9503041 * bLin;

    // Chromatic adaptation D65 to D50 (Bradford)
    final double xD50 = _bradfordD65ToD50[0][0] * xD65 +
        _bradfordD65ToD50[0][1] * yD65 +
        _bradfordD65ToD50[0][2] * zD65;
    final double yD50 = _bradfordD65ToD50[1][0] * xD65 +
        _bradfordD65ToD50[1][1] * yD65 +
        _bradfordD65ToD50[1][2] * zD65;
    final double zD50 = _bradfordD65ToD50[2][0] * xD65 +
        _bradfordD65ToD50[2][1] * yD65 +
        _bradfordD65ToD50[2][2] * zD65;

    // XYZ D50 to linear ProPhoto RGB
    final double rProLin = _xyzD50ToProPhoto[0][0] * xD50 +
        _xyzD50ToProPhoto[0][1] * yD50 +
        _xyzD50ToProPhoto[0][2] * zD50;
    final double gProLin = _xyzD50ToProPhoto[1][0] * xD50 +
        _xyzD50ToProPhoto[1][1] * yD50 +
        _xyzD50ToProPhoto[1][2] * zD50;
    final double bProLin = _xyzD50ToProPhoto[2][0] * xD50 +
        _xyzD50ToProPhoto[2][1] * yD50 +
        _xyzD50ToProPhoto[2][2] * zD50;

    // Apply ProPhoto gamma (delinearize)
    double delinearize(final double v) {
      if (v <= 1 / 512) {
        return 16 * v;
      }
      return pow(v.clamp(0.0, double.infinity), _gammaInv).toDouble();
    }

    return ProPhotoRgbColor(
      delinearize(rProLin),
      delinearize(gProLin),
      delinearize(bProLin),
      hexId: argb,
      alpha: Percent(((argb >> 24) & 0xFF) / 255.0),
    );
  }

  /// Creates a [ProPhotoRgbColor] from another [ColorSpacesIQ] instance.
  factory ProPhotoRgbColor.from(final ColorSpacesIQ color) =>
      ProPhotoRgbColor.fromInt(color.value);

  /// Creates a [ProPhotoRgbColor] from XYZ D50 coordinates.
  factory ProPhotoRgbColor.fromXyzD50(final XYZ xyz) {
    final double x = xyz.x / 100;
    final double y = xyz.y / 100;
    final double z = xyz.z / 100;

    final double rProLin = _xyzD50ToProPhoto[0][0] * x +
        _xyzD50ToProPhoto[0][1] * y +
        _xyzD50ToProPhoto[0][2] * z;
    final double gProLin = _xyzD50ToProPhoto[1][0] * x +
        _xyzD50ToProPhoto[1][1] * y +
        _xyzD50ToProPhoto[1][2] * z;
    final double bProLin = _xyzD50ToProPhoto[2][0] * x +
        _xyzD50ToProPhoto[2][1] * y +
        _xyzD50ToProPhoto[2][2] * z;

    double delinearize(final double v) {
      if (v <= 1 / 512) {
        return 16 * v;
      }
      return pow(v.clamp(0.0, double.infinity), _gammaInv).toDouble();
    }

    return ProPhotoRgbColor(
      delinearize(rProLin),
      delinearize(gProLin),
      delinearize(bProLin),
    );
  }

  @override
  ColorIQ toColor() => ColorIQ(value);

  /// Converts to XYZ D50 color space.
  XYZ toXyzD50() {
    double linearize(final double v) {
      if (v <= 16 / 512) {
        return v / 16;
      }
      return pow(v, _gamma).toDouble();
    }

    final double rLin = linearize(rPro);
    final double gLin = linearize(gPro);
    final double bLin = linearize(bPro);

    final double x = _proPhotoToXyzD50[0][0] * rLin +
        _proPhotoToXyzD50[0][1] * gLin +
        _proPhotoToXyzD50[0][2] * bLin;
    final double y = _proPhotoToXyzD50[1][0] * rLin +
        _proPhotoToXyzD50[1][1] * gLin +
        _proPhotoToXyzD50[1][2] * bLin;
    final double z = _proPhotoToXyzD50[2][0] * rLin +
        _proPhotoToXyzD50[2][1] * gLin +
        _proPhotoToXyzD50[2][2] * bLin;

    return XYZ(x * 100, y * 100, z * 100);
  }

  /// Whether this color is within the sRGB gamut.
  bool get isInSrgbGamut {
    return rPro >= 0 &&
        rPro <= 1 &&
        gPro >= 0 &&
        gPro <= 1 &&
        bPro >= 0 &&
        bPro <= 1;
  }

  @override
  ProPhotoRgbColor whiten([final double amount = 20]) =>
      lerp(cWhite, amount / 100);

  @override
  ProPhotoRgbColor blacken([final double amount = 20]) =>
      lerp(cBlack, amount / 100);

  @override
  ProPhotoRgbColor lerp(final ColorSpacesIQ other, final double t) {
    if (t == 0.0) return this;
    final ProPhotoRgbColor otherPro =
        other is ProPhotoRgbColor ? other : ProPhotoRgbColor.from(other);
    if (t == 1.0) return otherPro;

    return ProPhotoRgbColor(
      lerpDouble(rPro, otherPro.rPro, t),
      lerpDouble(gPro, otherPro.gPro, t),
      lerpDouble(bPro, otherPro.bPro, t),
    );
  }

  @override
  ProPhotoRgbColor lighten([final double amount = 20]) {
    final double factor = 1 + amount / 100;
    return ProPhotoRgbColor(
      (rPro * factor).clamp(0.0, 1.0),
      (gPro * factor).clamp(0.0, 1.0),
      (bPro * factor).clamp(0.0, 1.0),
    );
  }

  @override
  ProPhotoRgbColor darken([final double amount = 20]) {
    final double factor = 1 - amount / 100;
    return ProPhotoRgbColor(
      (rPro * factor).clamp(0.0, 1.0),
      (gPro * factor).clamp(0.0, 1.0),
      (bPro * factor).clamp(0.0, 1.0),
    );
  }

  @override
  ProPhotoRgbColor saturate([final double amount = 25]) {
    return toColor().saturate(amount).proPhoto;
  }

  @override
  ProPhotoRgbColor desaturate([final double amount = 25]) {
    return toColor().desaturate(amount).proPhoto;
  }

  @override
  ProPhotoRgbColor accented([final double amount = 15]) {
    return toColor().accented(amount).proPhoto;
  }

  @override
  ProPhotoRgbColor simulate(final ColorBlindnessType type) {
    return toColor().simulate(type).proPhoto;
  }

  /// Creates a copy with the given fields replaced.
  @override
  ProPhotoRgbColor copyWith({
    final double? rPro,
    final double? gPro,
    final double? bPro,
    final Percent? alpha,
  }) {
    return ProPhotoRgbColor(
      rPro ?? this.rPro,
      gPro ?? this.gPro,
      bPro ?? this.bPro,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  List<ProPhotoRgbColor> get monochromatic => <ProPhotoRgbColor>[
        darken(20),
        darken(10),
        this,
        lighten(10),
        lighten(20),
      ];

  @override
  List<ProPhotoRgbColor> lighterPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <ProPhotoRgbColor>[
      lighten(s),
      lighten(s * 2),
      lighten(s * 3),
      lighten(s * 4),
      lighten(s * 5),
    ];
  }

  @override
  List<ProPhotoRgbColor> darkerPalette([final double? step]) {
    final double s = step ?? 10.0;
    return <ProPhotoRgbColor>[
      darken(s),
      darken(s * 2),
      darken(s * 3),
      darken(s * 4),
      darken(s * 5),
    ];
  }

  @override
  ProPhotoRgbColor get random {
    final Random rng = Random();
    return ProPhotoRgbColor(
        rng.nextDouble(), rng.nextDouble(), rng.nextDouble());
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    if (other is ProPhotoRgbColor) {
      const double epsilon = 0.001;
      return (rPro - other.rPro).abs() < epsilon &&
          (gPro - other.gPro).abs() < epsilon &&
          (bPro - other.bPro).abs() < epsilon;
    }
    return value == other.value;
  }

  @override
  bool get isDark => brightness == Brightness.dark;

  @override
  bool get isLight => brightness == Brightness.light;

  @override
  ProPhotoRgbColor blend(final ColorSpacesIQ other,
          [final double amount = 50]) =>
      lerp(other, amount / 100);

  @override
  ProPhotoRgbColor opaquer([final double amount = 20]) {
    return copyWith(alpha: Percent((alpha.val + amount / 100).clamp(0.0, 1.0)));
  }

  @override
  ProPhotoRgbColor adjustHue([final double amount = 20]) {
    return toColor().adjustHue(amount).proPhoto;
  }

  @override
  ProPhotoRgbColor get complementary => adjustHue(180);

  @override
  ProPhotoRgbColor warmer([final double amount = 20]) {
    return toColor().warmer(amount).proPhoto;
  }

  @override
  ProPhotoRgbColor cooler([final double amount = 20]) {
    return toColor().cooler(amount).proPhoto;
  }

  @override
  List<ProPhotoRgbColor> generateBasicPalette() => <ProPhotoRgbColor>[
        darken(40),
        darken(20),
        this,
        lighten(20),
        lighten(40),
      ];

  @override
  List<ProPhotoRgbColor> tonesPalette() => toColor()
      .tonesPalette()
      .map((final ColorIQ c) => ProPhotoRgbColor.fromInt(c.value))
      .toList();

  @override
  List<ProPhotoRgbColor> analogous(
      {final int count = 5, final double offset = 30}) {
    return toColor()
        .hsl
        .analogous(count: count, offset: offset)
        .map((final HSL c) => c.toColor().proPhoto)
        .toList();
  }

  @override
  List<ProPhotoRgbColor> square() {
    return toColor()
        .hsl
        .square()
        .map((final HSL c) => c.toColor().proPhoto)
        .toList();
  }

  @override
  List<ProPhotoRgbColor> tetrad({final double offset = 60}) {
    return toColor()
        .hsl
        .tetrad(offset: offset)
        .map((final ColorSpacesIQ c) => c.toColor().proPhoto)
        .toList();
  }

  @override
  List<ProPhotoRgbColor> split({final double offset = 30}) =>
      <ProPhotoRgbColor>[
        this,
        adjustHue(180 - offset),
        adjustHue(180 + offset),
      ];

  @override
  List<ProPhotoRgbColor> triad({final double offset = 120}) =>
      <ProPhotoRgbColor>[
        this,
        adjustHue(offset),
        adjustHue(-offset),
      ];

  @override
  List<ProPhotoRgbColor> twoTone({final double offset = 60}) =>
      <ProPhotoRgbColor>[
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
        'type': 'ProPhotoRgbColor',
        'r': rPro,
        'g': gPro,
        'b': bPro,
        'alpha': alpha.val,
      };

  @override
  String toString() => 'ProPhotoRgb(r: ${rPro.toStringAsFixed(4)}, '
      'g: ${gPro.toStringAsFixed(4)}, b: ${bPro.toStringAsFixed(4)})';
}
