import 'dart:math';

import 'package:color_iq_utils/src/colors/html.dart';
import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/argb_color.dart';
import 'package:color_iq_utils/src/models/cmyk_color.dart';
import 'package:color_iq_utils/src/models/color_models_mixin.dart';
import 'package:color_iq_utils/src/models/display_p3_color.dart';
import 'package:color_iq_utils/src/models/hct_color.dart';
import 'package:color_iq_utils/src/models/hct_data.dart';
import 'package:color_iq_utils/src/models/hsb_color.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/hsluv_color.dart';
import 'package:color_iq_utils/src/models/hsp_color.dart';
import 'package:color_iq_utils/src/models/ipt_color.dart';
import 'package:color_iq_utils/src/models/jab_color.dart';
import 'package:color_iq_utils/src/models/jch_color.dart';
import 'package:color_iq_utils/src/models/hsv_color.dart';
import 'package:color_iq_utils/src/models/hunter_lab_color.dart';
import 'package:color_iq_utils/src/models/hwb_color.dart';
import 'package:color_iq_utils/src/models/lab_color.dart';
import 'package:color_iq_utils/src/models/lms_color.dart';
import 'package:color_iq_utils/src/models/lch_color.dart';
import 'package:color_iq_utils/src/models/luv_color.dart';
import 'package:color_iq_utils/src/models/munsell_color.dart';
import 'package:color_iq_utils/src/models/ok_hsl_color.dart';
import 'package:color_iq_utils/src/models/ok_hsv_color.dart';
import 'package:color_iq_utils/src/models/prophoto_color.dart';
import 'package:color_iq_utils/src/models/rec2020_color.dart';
import 'package:color_iq_utils/src/models/xyz_color.dart';
import 'package:color_iq_utils/src/models/ycbcr_color.dart';
import 'package:color_iq_utils/src/models/yiq_color.dart';
import 'package:color_iq_utils/src/models/yuv_color.dart';
import 'package:color_iq_utils/src/ops/color_manipulator.dart';
import 'package:color_iq_utils/src/utils_lib.dart';
import 'package:material_color_utilities/hct/cam16.dart';

/// A versatile color representation class, `ColorIQ`, designed for advanced color
/// manipulation and conversion.
///
/// `ColorIQ` serves as the primary entry point for working with colors in the
/// sRGB space. It stores color information as a 32-bit integer, similar to
/// Flutter's `Color` class, but extends functionality significantly. It provides
/// direct access to ARGB components, both as 8-bit integers (0-255) and as
/// normalized `double` values (0.0-1.0).
///
/// Through the `ColorModelsMixin` and `ColorSpacesIQ` interface, this class
/// offers a rich set of methods for:
/// - Converting to and from a wide array of color models (e.g., HSL, HSV, LAB, HCT, CMYK).
/// - Performing color manipulations like lightening, darkening, saturation adjustments,
///   and hue shifting.
/// - Generating color palettes (monochromatic, analogous, etc.).
/// - Simulating color blindness.
/// - Calculating color properties like luminance, contrast, and perceptual
///   distance.
class ColorIQ extends CommonIQ implements ColorSpacesIQ, ColorWheelInf {
  /// The 32-bit integer representation of the color, in `0xAARRGGBB` format.
  /// This is the canonical value for the color instance.
  @override
  final int hexId;

  /// An optional, pre-computed [HctData] instance.
  /// Used for optimization to avoid re-calculating HCT values if they are already known.
  /// Otherwise, this is lazily computed for performance reasons.
  final HctData? _hct;

  /// An optional, pre-computed [AppColor] instance.
  /// Used for optimization to avoid re-parsing the `hexId` if components are known.
  final AppColor? _argb;

  /// The color space in which the color is defined.
  /// Defaults to [ColorSpace.sRGB].
  final ColorSpace colorSpace;

  /// An optional, pre-computed Light Reflectance Value (LRV).
  /// Used for optimization to avoid re-calculating luminance.
  final Percent? _lrv;

  /// An optional, pre-computed brightness ([Brightness.light] or [Brightness.dark]).
  /// Used for optimization to avoid re-calculating brightness.
  final Brightness? _brightness;

  /// An optional, pre-computed red channel value (0-255).
  /// Used for optimization to avoid re-extracting the red component from `hexId`.
  final Iq255 _red;

  /// An optional, pre-computed green channel value (0-255).
  /// Used for optimization to avoid re-extracting the green component from `hexId`.
  final Iq255 _green;

  /// An optional, pre-computed blue channel value (0-255).
  /// Used for optimization to avoid re-extracting the blue component from `hexId`.
  final Iq255 _blue;

  /// An optional, pre-computed alpha channel value (0-255).
  /// Used for optimization to avoid re-extracting the alpha component from `hexId`.
  final Iq255 _alpha;

  final HSV? _hsv;
  final Cam16? _cam16;

  final XYZ? _xyz;

  /// Creates a [ColorIQ] instance from a 32-bit integer [hexId].
  ///
  /// Optional parameters can be provided to pre-compute and cache values like
  /// [hct], [argbColor], [lrv], and [brightness], which can improve
  /// performance if these values are already available.
  ColorIQ(
    this.hexId, {
    this.colorSpace = ColorSpace.sRGB,
    final HctData? hct,
    final Cam16? cam16,
    final HSV? hsv,
    final XYZ? xyz,
    final AppColor? argbColor,
    final List<String> names = kEmptyNames,
    final Percent? lrv,
    final Brightness? brightness,
    final Iq255? red,
    final Iq255? green,
    final Iq255? blue,
    final Iq255? alphaInt,
    final Percent? a,
    final Percent? r,
    final Percent? g,
    final Percent? b,
  })  : _hct = hct,
        _hsv = hsv,
        _cam16 = cam16,
        assert(a == null || a >= 0.0 && a <= 1.0,
            'invalid Opacity $errorMsgFloat0to1 -- $a'),
        _red = red ?? Iq255.getIq255((hexId >> 16) & 0xFF),
        _green = green ?? Iq255.getIq255((hexId >> 8) & 0xFF),
        _blue = blue ?? Iq255.getIq255(hexId & 0xFF),
        _alpha = alphaInt ?? Iq255.getIq255((hexId >> 24) & 0xFF),
        _argb = argbColor ?? AppColor(hexId),
        _lrv = lrv ?? argbColor?.lrv,
        _brightness = brightness ?? argbColor?.brightness,
        _xyz = xyz,
        super(hexId,
            names: names,
            alpha: a ?? Percent.clamped(((hexId >> 24) & 0xFF) / 255.0));

  /// Constructs a [ColorIQ] color from four integer channel values.
  ///
  /// The [alpha], [red], [green], and [blue] parameters should be in the
  /// range 0-255, where 0 represents the minimum intensity (or full transparency
  /// for alpha) and 255 represents maximum intensity (or full opacity for alpha).
  ///
  /// Optional parameters can be provided to pre-compute and cache values like
  /// [hctColor], [lrv], and [brightness], which can improve performance if
  /// these values are already available.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ red = ColorIQ.fromArgbInts(
  ///   alpha: 255,
  ///   red: 255,
  ///   green: 0,
  ///   blue: 0,
  /// );
  /// ```
  factory ColorIQ.fromArgbInts({
    final Iq255 alpha = Iq255.max,
    required final Iq255 red,
    required final Iq255 green,
    required final Iq255 blue,
    final ColorSpace colorSpace = ColorSpace.sRGB,
    final List<String>? names,
    final Percent? lrv,
    final Brightness? brightness,
    final HctData? hctColor,
    final XYZ? xyz,
  }) {
    final AppColor argbColor = AppColor.fromARGB(
        alpha.intVal, red.intVal, green.intVal, blue.intVal,
        a: alpha.norm, r: red.norm, g: green.norm, b: blue.norm);

    return ColorIQ(
      argbColor.value,
      argbColor: argbColor,
      names: names ?? kEmptyNames,
      colorSpace: colorSpace,
      lrv: lrv,
      hct: hctColor,
      red: red,
      green: green,
      blue: blue,
      alphaInt: alpha,
      brightness: brightness,
      xyz: xyz,
    );
  }

  /// Constructs a [ColorIQ] color from an existing [AppColor] instance.
  ///
  /// This factory is useful when you already have an [AppColor] object and
  /// want to convert it to a [ColorIQ] instance, optionally providing
  /// additional pre-computed values like [hctColor] or [lrv] for performance
  /// optimization.
  ///
  /// Example:
  /// ```dart
  /// final AppColor appColor = AppColor(0xFFFF0000);
  /// final ColorIQ color = ColorIQ.fromArgbColor(appColor);
  /// ```
  factory ColorIQ.fromArgbColor(
    final AppColor argbColor, {
    final ColorSpace colorSpace = ColorSpace.sRGB,
    final List<String>? names,
    final Percent? lrv,
    final HctData? hctColor,
    final XYZ? xyz,
  }) {
    return ColorIQ(
      argbColor.value,
      argbColor: argbColor,
      names: names ?? kEmptyNames,
      colorSpace: colorSpace,
      lrv: lrv ?? argbColor.lrv,
      hct: hctColor,
      brightness: argbColor.brightness,
      xyz: xyz,
    );
  }

  /// Constructs a [ColorIQ] color from sRGB channel values in the range 0.0 to 1.0.
  ///
  /// The [r], [g], and [b] parameters represent the red, green, and blue
  /// channels as normalized floating-point values (0.0 to 1.0). The [a]
  /// parameter represents alpha/opacity (defaults to 1.0 for fully opaque).
  ///
  /// These values should be delinearized (gamma-encoded) sRGB values, which is
  /// the standard representation for most color inputs.
  ///
  /// Optional parameters can be provided to pre-compute and cache values like
  /// [luminance], [hctColor], or [argbColor] for performance optimization.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ red = ColorIQ.fromSrgb(
  ///   r: 1.0,
  ///   g: 0.0,
  ///   b: 0.0,
  ///   a: 1.0,
  /// );
  /// ```
  factory ColorIQ.fromSrgb({
    required final Percent r,
    required final Percent g,
    required final double b,
    final Percent a = Percent.max,
    Percent? luminance,
    final ColorSpace colorSpace = ColorSpace.sRGB,
    final List<String>? names,
    final HctData? hctColor,
    AppColor? argbColor,
    final XYZ? xyz,
  }) {
    argbColor ??= AppColor.from(a: a, r: r, g: g, b: b);
    luminance = luminance ?? argbColor.lrv;
    return ColorIQ(argbColor.value,
        colorSpace: colorSpace,
        lrv: luminance,
        hct: hctColor,
        names: names ?? kEmptyNames,
        xyz: xyz);
  }

  /// Constructs a [ColorIQ] color from a hexadecimal string representation.
  ///
  /// Accepts hex strings in the following formats:
  /// - `"#RRGGBB"` or `"RRGGBB"` - RGB format (alpha defaults to FF/fully opaque)
  /// - `"#AARRGGBB"` or `"AARRGGBB"` - ARGB format
  /// - `"#RGB"` or `"RGB"` - Short format (each digit is doubled, e.g., "F00" becomes "FF0000")
  ///
  /// The `#` prefix is optional and will be stripped automatically.
  /// The hex string is case-insensitive.
  ///
  /// Note: For 8-character hex strings, the format is expected to be `RRGGBBAA`
  /// (CSS-style), which will be automatically converted to Dart's `AARRGGBB` format.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ red1 = ColorIQ.fromHexStr('#FF0000');
  /// final ColorIQ red2 = ColorIQ.fromHexStr('FF0000');
  /// final ColorIQ red3 = ColorIQ.fromHexStr('#F00');
  /// final ColorIQ semiTransparent = ColorIQ.fromHexStr('#80FF0000');
  /// ```
  ///
  /// Throws [FormatException] if the hex string is invalid.
  factory ColorIQ.fromHexStr(final String hexStr,
      {final List<String> names = kEmptyNames, final XYZ? xyz}) {
    String hex = hexStr.replaceAll('#', '').toUpperCase();
    // hex = hex.substring(1);
    if (hex.length == 3) {
      hex = hex.split('').map((final String c) => '$c$c').join('');
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
      return ColorIQ(int.parse(hex, radix: 16), names: names);
    }

    if (hex.length == 8) {
      // CSS hex is RRGGBBAA, Dart Color is AARRGGBB
      // So we need to move AA to the front.
      // Input: RRGGBBAA
      // Output: AARRGGBB
      final String r = hex.substring(0, 2);
      final String g = hex.substring(2, 4);
      final String b = hex.substring(4, 6);
      final String a = hex.substring(6, 8);
      hex = '$a$r$g$b';
      return ColorIQ(int.parse(hex, radix: 16), names: names, xyz: xyz);
    }

    throw FormatException('Invalid hex color: #$hex');
  }

  /// The 32-bit integer value of the color in `0xAARRGGBB` format.
  @override
  int get value => hexId;

  /// An [AppColor] instance representing the ARGB components of the color.
  /// This is lazily initialized, either from a provided `argbColor` during
  /// construction or by creating a new `ARGBColor` from the `hexId`. It provides
  /// access to individual color components (alpha, red, green, blue).
  late final AppColor argb = _argb ?? AppColor(hexId);

  /// The relative luminance of the color, calculated according to WCAG standards.
  ///
  /// This value is lazily computed and cached. It is a crucial component for
  /// determining color contrast and accessibility. The value ranges from 0.0
  /// (black) to 1.0 (white).
  late final Percent lrv = _lrv ?? argb.lrv;

  /// The brightness of the color, determined as either [Brightness.light] or
  /// [Brightness.dark].
  ///
  /// This property is lazily computed based on the color's luminance. It's
  /// useful for determining an appropriate foreground color (e.g., text)
  /// that would be readable on this color as a background.
  @override
  late final Brightness brightness = _brightness ?? argb.brightness;

  /// The red channel value as an integer from 0 to 255.
  ///
  /// This value is lazily computed and cached. It can be pre-computed during
  /// construction for performance optimization.
  @override
  late final Iq255 redIQ = _red; //  ?? Iq255.getIq255((hexId >> 16) & 0xFF);

  /// The green channel value as an integer from 0 to 255.
  ///
  /// This value is lazily computed and cached. It can be pre-computed during
  /// construction for performance optimization.
  @override
  late final Iq255 greenIQ = _green;

  /// The blue channel value as an integer from 0 to 255.
  ///
  /// This value is lazily computed and cached. It can be pre-computed during
  /// construction for performance optimization.
  late final Iq255 blueIQ = _blue;

  /// The alpha channel value as an integer from 0 to 255.
  ///
  /// 0 represents fully transparent, and 255 represents fully opaque.
  /// This value is lazily computed and cached. It can be pre-computed during
  /// construction for performance optimization.
  late final Iq255 alphaIQ = _alpha; // ?? argb.alphaInt;

  /// Returns this color as a [ColorIQ] instance.
  ///
  /// Since this class is already a [ColorIQ], this method simply returns itself.
  @override
  ColorIQ toColor() => this;

  /// The CIELAB color space representation of this color.
  ///
  /// This is lazily computed and cached. LAB is a perceptually uniform color
  /// space, making it useful for measuring color differences.
  late final CIELab lab = mapLAB.getOrCreate(value);

  /// The HCT (Hue, Chroma, Tone) color space representation of this color.
  ///
  /// HCT is a perceptually uniform color space developed by Google's Material
  /// Design team. This value is lazily computed unless pre-computed during
  /// construction.
  @override
  late final HctData hct = _hct ?? HctData.fromInt(value);

  /// The CAM16 color appearance model representation of this color.
  ///
  /// CAM16 is used for perceptual color distance calculations and is lazily
  /// computed and cached.
  @override
  late final Cam16 cam16 = _cam16 ?? Cam16.fromInt(value);

  /// The XYZ color space representation of this color (CIE 1931).
  ///
  /// XYZ is an intermediate color space often used for conversions between
  /// different color models. This is lazily computed and cached.
  late final XYZ xyz = _xyz ?? XYZ.xyxFromRgb(_red, _green, _blue);

  /// The HSV (Hue, Saturation, Value) color space representation of this color.
  ///
  /// HSV is a cylindrical color model that describes colors in terms of their
  /// hue, saturation, and brightness. This is lazily computed and cached.
  late final HSV hsv = _hsv ?? HSV.fromARGB(argb);

  /// The HSL (Hue, Saturation, Lightness) color space representation of this color.
  ///
  /// HSL is a cylindrical color model similar to HSV but uses lightness instead
  /// of value. This is lazily computed and cached.
  late final HSL hsl = HSL.fromARGB(argb);

  /// The CMYK (Cyan, Magenta, Yellow, Key/Black) color space representation of this color.
  ///
  /// CMYK is primarily used for color printing. This is lazily computed and cached.
  late final CMYK cmyk = CMYK.fromInt(value);

  /// Converts this color to CIELCH (Lightness, Chroma, Hue).
  ///
  /// LCH is a cylindrical representation of the LAB color space, providing
  /// a more intuitive way to work with colors in terms of lightness, chroma
  /// (saturation), and hue.
  LchColor toLch() => lab.toLch();

  /// The HSP (Hue, Saturation, Perceived brightness) color space representation.
  ///
  /// HSP is a color model designed to more accurately represent perceived
  /// brightness than HSL or HSV. This is lazily computed and cached.
  late final HSP hsp = HSP.fromInt(value);

  /// The CAM16-UCS J'a'b' (JAB) color space representation of this color.
  ///
  /// JAB is a perceptually uniform color space derived from CAM16 using
  /// rectangular coordinates. It's useful for calculating perceptual color
  /// differences and creating uniform gradients. This is lazily computed and cached.
  late final JabColor jab = JabColor.fromInt(value);

  /// The CAM16-UCS J'C'h (JCH) color space representation of this color.
  ///
  /// JCH is the cylindrical form of CAM16-UCS, providing an intuitive hue,
  /// chroma, and lightness interface. This is lazily computed and cached.
  late final JchColor jch = JchColor.fromInt(value);

  /// The LMS color space representation of this color.
  ///
  /// LMS represents the response of the three cone photoreceptors in the human
  /// eye (Long, Medium, Short wavelengths). It's fundamental to color blindness
  /// simulation and chromatic adaptation. This is lazily computed and cached.
  late final LmsColor lms = LmsColor.fromInt(value);

  /// The YCbCr color space representation of this color (BT.709 standard).
  ///
  /// YCbCr separates luminance (Y) from chrominance (Cb, Cr), commonly used in
  /// video compression and image processing. This is lazily computed and cached.
  late final YCbCrColor ycbcr = YCbCrColor.fromInt(value);

  /// The IPT color space representation of this color.
  ///
  /// IPT (Intensity, Protan, Tritan) is a perceptually uniform color space
  /// optimized for gamut mapping and hue uniformity. This is lazily computed and cached.
  late final IptColor ipt = IptColor.fromInt(value);

  /// The ProPhoto RGB (ROMM RGB) color space representation of this color.
  ///
  /// ProPhoto RGB is a wide-gamut color space covering ~90% of visible colors,
  /// commonly used in photography workflows. This is lazily computed and cached.
  late final ProPhotoRgbColor proPhoto = ProPhotoRgbColor.fromInt(value);

  /// Calculates the perceptual distance to another color using CAM16.
  ///
  /// Returns a distance value where smaller numbers indicate colors that are
  /// more perceptually similar. This is useful for finding similar colors or
  /// grouping colors by appearance.
  double distanceTo(final ColorWheelInf other) => cam16.distance(other.cam16);

  /// Returns a new color with the provided components updated.
  ///
  /// Each component ([alpha], [red], [green], [blue]) represents a
  /// floating-point value; see [Color.from] for details and examples.
  ///
  /// If [colorSpace] is provided, and is different than the current color
  /// space, the component values are updated before transforming them to the
  /// provided [ColorSpace].
  ///
  /// Example:
  /// ```dart
  /// /// Create a color with 50% opacity.
  /// Color makeTransparent(Color color) => color.withValues(alpha: 0.5);
  /// ```
  ColorIQ withValues({
    final Percent? aVal,
    final Percent? rVal,
    final Percent? gVal,
    final Percent? bVal,
    final ColorSpace? colorSpace,
  }) {
    AppColor? updatedComponents;
    if (aVal != null || rVal != null || gVal != null || bVal != null) {
      updatedComponents = AppColor.from(
        a: aVal ?? a,
        r: rVal ?? r,
        g: gVal ?? g,
        b: bVal ?? b,
        colorSpace: this.colorSpace,
      );
    }
    if (colorSpace != null && colorSpace != this.colorSpace) {
      final ColorTransform transform =
          getColorTransform(this.colorSpace, colorSpace);
      final AppColor argbComponents =
          transform.transform(updatedComponents ?? argb, colorSpace);

      return ColorIQ.fromArgbColor(argbComponents);
    } else {
      return ColorIQ.fromArgbColor(updatedComponents ?? argb);
    }
  }

  /// Converts this color to YIQ color space.
  ///
  /// YIQ is a color space used in NTSC television broadcasting. The Y component
  /// represents luminance (brightness), while I and Q represent chrominance
  /// information.
  ///
  /// Returns a [YiqColor] instance with Y, I, and Q components.
  YiqColor toYiq() {
    final double y = 0.299 * r + 0.587 * g + 0.114 * b;
    final double i = 0.596 * r - 0.274 * g - 0.322 * b;
    final double q = 0.211 * r - 0.523 * g + 0.312 * b;

    return YiqColor(y, i, q);
  }

  /// Converts this color to YUV color space.
  ///
  /// YUV is a color encoding system used in video and digital photography.
  /// The Y component represents luminance (brightness), while U and V represent
  /// chrominance (color information).
  ///
  /// Returns a [YuvColor] instance with Y, U, and V components.
  YuvColor toYuv() {
    final double y = 0.299 * r + 0.587 * g + 0.114 * b;
    final double u = -0.14713 * r - 0.28886 * g + 0.436 * b;
    final double v = 0.615 * r - 0.51499 * g - 0.10001 * b;

    return YuvColor(y, u, v);
  }

  /// Makes the color brighter and more vivid.
  ///
  /// Increases both the brightness and saturation of the color to create a
  /// more intense, vibrant appearance. The transformation is performed in the
  /// specified [model] color space (defaults to [ColorModel.hct] for
  /// perceptually uniform results).
  ///
  /// The [amount] parameter controls the intensity of the transformation,
  /// where [Percent.v20] represents a 20% increase (default).
  ///
  /// Returns an [AppColor] instance with the intensified color.
  AppColor intensify(
      {final Percent amount = Percent.v20,
      final ColorModel model = ColorModel.hct}) {
    return AppColor(ColorManipulator.transform(
      color: value,
      model: model,
      type: TransformType.intensify,
      amount: amount,
    ));
  }

  /// Makes the color darker and more muted.
  ///
  /// Decreases both the brightness and saturation of the color to create a
  /// more subdued, muted appearance. The transformation is performed in the
  /// specified [model] color space (defaults to [ColorModel.hct] for
  /// perceptually uniform results).
  ///
  /// The [amount] parameter controls the intensity of the transformation,
  /// where [Percent.v20] represents a 20% decrease (default).
  ///
  /// Returns an [AppColor] instance with the deintensified color.
  AppColor deintensify(
      {final Percent amount = Percent.v20,
      final ColorModel model = ColorModel.hct}) {
    return AppColor(ColorManipulator.transform(
      color: value,
      model: model,
      type: TransformType.deintensify,
      amount: amount,
    ));
  }

  /// Converts this color to OkHSL (Oklab-based HSL).
  ///
  /// OkHSL is a perceptually uniform color space based on Oklab that provides
  /// a more intuitive HSL-like interface while maintaining perceptual uniformity.
  ///
  /// Returns an [OkHslColor] instance.
  OkHslColor toOkHsl() => toOkLab().toOkHsl();

  /// Converts this color to OkHSV (Oklab-based HSV).
  ///
  /// OkHSV is a perceptually uniform color space based on Oklab that provides
  /// a more intuitive HSV-like interface while maintaining perceptual uniformity.
  ///
  /// Returns an [OkHsvColor] instance.
  OkHsvColor toOkHsv() => toOkLab().toOkHsv();

  /// Converts this color to Hunter Lab color space.
  ///
  /// Hunter Lab is a color space designed to be more perceptually uniform than
  /// the original LAB color space. It uses D65 illuminant reference values to
  /// match sRGB/XYZ white point.
  ///
  /// Returns a [HunterLabColor] instance with L, a, and b components.
  HunterLabColor toHunterLab() {
    final XYZ xyz = XYZ.fromInt(value);
    final double x = xyz.x;
    final double y = xyz.y;
    final double z = xyz.z;

    // Using D65 reference values to match sRGB/XYZ white point
    const double xn = 95.047;
    const double yn = 100.0;
    const double zn = 108.883;

    final double lOut = 100.0 * sqrt(y / yn);
    double aOut = 175.0 * (x / xn - y / yn) / sqrt(y / yn);
    double bOut = 70.0 * (y / yn - z / zn) / sqrt(y / yn);

    if (y == 0) {
      aOut = 0;
      bOut = 0;
    }

    return HunterLabColor(lOut, aOut, bOut);
  }

  /// Converts this color to HSLuv color space.
  ///
  /// HSLuv is a perceptually uniform variant of HSL that ensures equal
  /// saturation steps correspond to equal perceptual changes in color.
  ///
  /// Returns an [HsluvColor] instance with hue, chroma, and lightness components.
  HsluvColor toHsluv() {
    final CIELuv luv = toLuv();
    final double c = sqrt(luv.u * luv.u + luv.v * luv.v);
    double h = atan2(luv.v, luv.u) * 180 / pi;
    if (h < 0) h += 360;
    return HsluvColor(h, c, luv.l);
  }

  /// Converts this color to Munsell color system.
  ///
  /// The Munsell color system is a color space that specifies colors based on
  /// three dimensions: hue, value (lightness), and chroma (saturation).
  ///
  /// Note: This is a placeholder implementation that returns a neutral color.
  /// Full Munsell conversion requires more complex calculations.
  ///
  /// Returns a [MunsellColor] instance.
  MunsellColor toMunsell() {
    return const MunsellColor("N", 0, 0);
  }

  /// Converts this color to HSB (Hue, Saturation, Brightness).
  ///
  /// HSB is functionally identical to HSV (Hue, Saturation, Value), where
  /// brightness corresponds to value. This is an alias for HSV conversion.
  ///
  /// Returns an [HsbColor] instance with hue, saturation, and brightness components.
  HsbColor toHsb() {
    return HsbColor(hsv.h, hsv.saturation, hsv.valueHsv);
  }

  /// Converts this color to HWB (Hue, Whiteness, Blackness) color space.
  ///
  /// HWB is an intuitive color model where colors are specified by their hue,
  /// along with how much white or black to mix with it. This makes it easier
  /// to create tints and shades than with HSL or HSV.
  ///
  /// Returns an [HwbColor] instance with hue (0-360°), whiteness (0.0-1.0),
  /// and blackness (0.0-1.0) components.
  HwbColor toHwb() {
    final double r = red / 255.0;
    final double g = green / 255.0;
    final double b = blue / 255.0;

    final double maxVal = max(r, max(g, b));
    final double minVal = min(r, min(g, b));
    double h = 0;

    if (maxVal == minVal) {
      h = 0;
    } else {
      final double d = maxVal - minVal;
      if (maxVal == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }
      h /= 6;
    }

    final double w = minVal;
    final double bl = 1 - maxVal;

    return HwbColor(h * 360, w, bl);
  }

  /// Converts this color to Display P3 color space.
  ///
  /// Display P3 is a wide-gamut color space used in Apple displays and devices.
  /// It has a larger color gamut than sRGB, allowing for more vibrant colors.
  ///
  /// The conversion process involves:
  /// 1. Linearizing the sRGB values
  /// 2. Converting to XYZ (D65)
  /// 3. Converting to Display P3 linear
  /// 4. Applying the sRGB gamma curve (Display P3 uses the same transfer function)
  ///
  /// Returns a [DisplayP3Color] instance with RGB components in Display P3 space.
  DisplayP3Color toDisplayP3() {
    // Linearize sRGB
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    // sRGB Linear to XYZ (D65)
    final double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
    final double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
    final double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;

    // XYZ (D65) to Display P3 Linear
    // Matrix from http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
    // or Apple's specs.
    // Using standard P3 D65 matrix.

    final double rP3 = x * 2.4934969 + y * -0.9313836 + z * -0.4027107;
    final double gP3 = x * -0.8294889 + y * 1.7626640 + z * 0.0236246;
    double bP3 = x * 0.0358458 + y * -0.0761723 + z * 0.9568845;

    // Gamma correction (Transfer function) for Display P3 is sRGB curve.
    bP3 =
        (bP3 > 0.0031308) ? (1.055 * pow(bP3, 1 / 2.4) - 0.055) : (12.92 * bP3);

    return DisplayP3Color(
        Percent(rP3.clamp(0.0, 1.0).gammaCorrect),
        Percent(gP3.clamp(0.0, 1.0).gammaCorrect),
        Percent(bP3.clamp(0.0, 1.0)));
  }

  /// Converts this color to Rec. 2020 (ITU-R Recommendation BT.2020) color space.
  ///
  /// Rec. 2020 is a wide-gamut color space used in UHDTV and HDR content. It
  /// has a significantly larger color gamut than sRGB, covering approximately
  /// 75.8% of the CIE 1931 color space.
  ///
  /// The conversion process involves:
  /// 1. Linearizing the sRGB values
  /// 2. Converting to XYZ (D65)
  /// 3. Converting to Rec. 2020 linear
  /// 4. Applying the Rec. 2020 transfer function (piecewise function with
  ///    alpha = 1.099 and beta = 0.018)
  ///
  /// Returns a [Rec2020Color] instance with RGB components in Rec. 2020 space.
  Rec2020Color toRec2020() {
    // Linearize sRGB
    double r = red / 255.0;
    double g = green / 255.0;
    double b = blue / 255.0;

    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4).toDouble() : (r / 12.92);
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4).toDouble() : (g / 12.92);
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4).toDouble() : (b / 12.92);

    // sRGB Linear to XYZ (D65)
    final double x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375;
    final double y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750;
    final double z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041;

    // XYZ (D65) to Rec. 2020 Linear
    final double r2020 = x * 1.7166511 + y * -0.3556707 + z * -0.2533662;
    final double g2020 = x * -0.6666843 + y * 1.6164812 + z * 0.0157685;
    final double b2020 = x * 0.0176398 + y * -0.0427706 + z * 0.9421031;

    // Gamma correction for Rec. 2020
    // alpha = 1.099, beta = 0.018 for 10-bit system, but often 2.4 or 2.2 is used in practice for display.
    // Official Rec. 2020 transfer function:
    // if E < beta * delta: 4.5 * E
    // else: alpha * E^(0.45) - (alpha - 1)
    // alpha = 1.099, beta = 0.018, delta = ?
    // Actually: if L < 0.018: 4.5 * L, else 1.099 * L^0.45 - 0.099

    Percent transfer(final double v) {
      if (v < 0.018) {
        return Percent((4.5 * v).clamp(0.0, 1.0));
      }
      return Percent((1.099 * pow(v, 0.45) - 0.099).clamp(0.0, 1.0));
    }

    return Rec2020Color(transfer(r2020), transfer(g2020), transfer(b2020));
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ColorIQ && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  ColorIQ lighten([final double amount = 20]) {
    return hsl.lighten(amount).toColor();
  }

  @override
  ColorIQ darken([final double amount = 20]) {
    return hsl.darken(amount).toColor();
  }

  @override
  ColorIQ brighten([final Percent amount = Percent.v20]) {
    return hsv.brighten(amount).toColor();
  }

  @override
  ColorIQ saturate([final double amount = 25]) {
    return hsl.saturate(amount).toColor();
  }

  @override
  ColorIQ desaturate([final double amount = 25]) {
    return hsl.desaturate(amount).toColor();
  }

  @override
  ColorIQ accented([final double amount = 15]) {
    return toHctColor().accented(amount).toColor();
  }

  @override
  ColorIQ simulate(final ColorBlindnessType type) {
    // 1. Convert to Linear sRGB (0-1)
    final List<double> lin = <double>[
      redLinearized,
      greenLinearized,
      blueLinearized
    ];
    // 2. Simulate
    final List<double> sim = ColorBlindness.simulate(
      lin[0],
      lin[1],
      lin[2],
      type,
    );

    return ColorIQ.fromSrgb(
        r: gammaCorrect(sim[0]),
        g: gammaCorrect(sim[1]),
        b: gammaCorrect(sim[2]),
        a: alpha);
  }

  ColorIQ get grayscale => desaturate(100);

  @override
  ColorIQ whiten([final double amount = 20]) {
    return lerp(cWhite, amount / 100) as ColorIQ;
  }

  @override
  ColorIQ blacken([final double amount = 20]) {
    return lerp(cBlack, amount / 100) as ColorIQ;
  }

  /// Linearly interpolates between this color and [other] by [t].
  ///
  /// The [t] parameter should be between 0.0 and 1.0. When [t] is 0.0, this
  /// color is returned. When [t] is 1.0, [other] is returned. Values in between
  /// produce intermediate colors.
  ///
  /// Interpolation is performed on each ARGB channel independently.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ middle = red.lerp(blue, 0.5); // A color halfway between red and blue
  /// ```
  ///
  /// Returns a new [ColorIQ] instance representing the interpolated color.
  @override
  ColorSpacesIQ lerp(final ColorSpacesIQ other, final double t) {
    if (other is! ColorIQ) {
      return lerp(ColorIQ(other.value), t);
    }

    final ColorIQ otherColor = other;
    return ColorIQ.fromArgbInts(
      alpha: (alphaInt + (otherColor.alphaInt - alphaInt) * t).round().toIq255,
      red: (red + (otherColor.red - red) * t).round().toIq255,
      green: (green + (otherColor.green - green) * t).round().toIq255,
      blue: (blue + (otherColor.blue - blue) * t).round().toIq255,
    );
  }

  /// Adjusts the transparency (alpha) of this color.
  ///
  /// Reduces the alpha channel by the specified [amount] percentage. The
  /// [amount] parameter should be between 0 and 100, where 100 would make
  /// the color fully transparent.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ semiTransparent = color.adjustTransparency(50); // 50% more transparent
  /// ```
  ///
  /// Returns a new [ColorIQ] instance with adjusted transparency.
  ColorIQ adjustTransparency([final double amount = 20]) {
    return ColorIQ.fromArgbInts(
      alpha: (alphaInt * (1 - amount / 100)).round().clamp(0, 255).toIq255,
      red: _red,
      green: _green,
      blue: _blue,
    );
  }

  /// Creates a copy of this color with a new alpha value.
  ///
  /// The [newA] parameter should be an integer from 0 (fully transparent)
  /// to 255 (fully opaque).
  ///
  /// Returns a new [ColorIQ] instance with the specified alpha value.
  ColorIQ withAlpha(final int newA) => ColorIQ.fromArgbInts(
      alpha: newA.clamp(0, 255).toIq255, red: _red, green: _green, blue: _blue);

  /// Creates a copy of this color with new RGB channel values.
  ///
  /// Only the specified channels are changed; others remain the same.
  /// Each channel value should be an integer from 0 to 255.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ darker = color.withRgb(
  ///   red: (color.red * 0.8).round(),
  ///   green: (color.green * 0.8).round(),
  ///   blue: (color.blue * 0.8).round(),
  /// );
  /// ```
  ///
  /// Returns a new [ColorIQ] instance with the specified RGB values.
  ColorIQ withRgb({final Iq255? red, final Iq255? green, final Iq255? blue}) =>
      ColorIQ.fromArgbInts(
          alpha: _alpha,
          red: red ?? _red,
          green: green ?? _green,
          blue: blue ?? _blue);

  /// Creates a copy of this color with the given fields replaced with the new values.
  @override
  ColorIQ copyWith(
      {final Iq255? alpha,
      final Iq255? red,
      final Iq255? green,
      final Iq255? blue}) {
    return ColorIQ.fromArgbInts(
        alpha: alpha ?? _alpha,
        red: red ?? _red,
        green: green ?? _green,
        blue: blue ?? _blue);
  }

  /// Generates a monochromatic color palette based on this color.
  ///
  /// A monochromatic palette consists of variations of the same hue with
  /// different lightness values. This method generates 5 colors by adjusting
  /// the lightness in steps of 10% around the current color's lightness.
  ///
  /// Returns a list of 5 [ColorIQ] colors ranging from darker to lighter
  /// variations of this color.
  @override
  List<ColorSpacesIQ> get monochromatic {
    // Generate 5 variations based on lightness/tone.
    // We can use Hct for perceptually accurate tone steps, or HSL for simple lightness.
    // Let's use HSL for simplicity and consistency with existing logic, or HCT for better quality?
    // The user asked for "at least five colors".
    // Let's generate a range of lightnesses around the current color.

    final List<ColorIQ> results = <ColorIQ>[];

    // We want 5 steps. Let's do: L-20, L-10, L, L+10, L+20, clamped.
    // Or just spread them out evenly?
    // Let's do a spread.
    for (int i = 0; i < 5; i++) {
      // -2, -1, 0, 1, 2
      final double delta = (i - 2) * 10.0;
      final double newL = (hsl.l * 100 + delta).clamp(0.0, 100.0);
      results.add(HSL(hsl.h, hsl.s, newL / 100).toColor());
    }
    return results;
  }

  @override
  List<ColorSpacesIQ> lighterPalette([final double? step]) {
    return hsl
        .lighterPalette(step)
        .map((final ColorSpacesIQ c) => (c as HSL).toColor())
        .toList();
  }

  @override
  List<ColorSpacesIQ> darkerPalette([final double? step]) {
    return hsl
        .darkerPalette(step)
        .map((final ColorSpacesIQ c) => (c as HSL).toColor())
        .toList();
  }

  @override
  ColorSpacesIQ get random {
    final Random rng = Random();
    return ColorIQ.fromArgbInts(
      red: rng.nextInt(256).toIq255,
      green: rng.nextInt(256).toIq255,
      blue: rng.nextInt(256).toIq255,
    );
  }

  @override
  bool isEqual(final ColorSpacesIQ other) {
    return value == other.toColor().value;
  }

  @override
  ColorIQ blend(final ColorSpacesIQ other, [final double amount = 50]) {
    return lerp(other, amount / 100) as ColorIQ;
  }

  @override
  ColorIQ opaquer([final double amount = 20]) {
    // Increase alpha by amount%
    final Iq255 newAlpha =
        (alphaInt + (255 * amount / 100)).round().clamp(0, 255).toIq255;
    return copyWith(alpha: newAlpha);
  }

  @override
  ColorIQ adjustHue([final double amount = 20]) {
    double newHue = (hsl.h + amount) % 360;
    if (newHue < 0) {
      newHue += 360;
    }
    return HSL(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  ColorIQ get complementary => adjustHue(180);

  @override
  ColorIQ warmer([final double amount = 20]) {
    // Warmest is around 30 degrees (Orange/Red)
    // We shift the hue towards 30 degrees by amount%
    final double currentHue = hsl.h;
    const double targetHue = 30.0;

    // Find shortest path
    double diff = targetHue - currentHue;
    if (diff > 180) {
      diff -= 360;
    }
    if (diff < -180) diff += 360;

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) {
      newHue += 360;
    }
    if (newHue >= 360) newHue -= 360;

    return HSL(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  ColorIQ cooler([final double amount = 20]) {
    // Coolest is around 210 degrees (Blue/Cyan)
    // We shift the hue towards 210 degrees by amount%
    final double currentHue = hsl.h;
    const double targetHue = 210.0;

    // Find shortest path
    double diff = targetHue - currentHue;
    if (diff > 180) diff -= 360;
    if (diff < -180) {
      diff += 360;
    }

    double newHue = currentHue + (diff * amount / 100);
    if (newHue < 0) newHue += 360;
    if (newHue >= 360) newHue -= 360;

    return HSL(newHue, hsl.s, hsl.l).toColor();
  }

  @override
  List<ColorIQ> generateBasicPalette() {
    return <ColorIQ>[
      darken(30),
      darken(20),
      darken(10),
      this,
      lighten(10),
      lighten(20),
      lighten(30),
    ];
  }

  /// Generates a tones palette by mixing this color with gray.
  ///
  /// Creates a palette of 5 colors by progressively mixing this color with
  /// medium gray (0xFF808080). This produces variations that maintain the
  /// original hue while reducing saturation and adjusting lightness.
  ///
  /// Returns a list of 5 [ColorIQ] colors, with the original color first,
  /// followed by increasingly grayed-out versions.
  @override
  List<ColorIQ> tonesPalette() {
    // Mix with gray (0xFF808080)
    final ColorIQ gray = ColorIQ(0xFF808080);
    return <ColorIQ>[
      this,
      lerp(gray, 0.15) as ColorIQ,
      lerp(gray, 0.30) as ColorIQ,
      lerp(gray, 0.45) as ColorIQ,
      lerp(gray, 0.60) as ColorIQ,
    ];
  }

  /// Generates an analogous color palette.
  ///
  /// An analogous palette consists of colors that are adjacent on the color
  /// wheel, creating harmonious color schemes. The [count] parameter specifies
  /// how many colors to generate (defaults to 5), and [offset] specifies the
  /// hue step in degrees (defaults to 30°).
  ///
  /// When [count] is 3, generates one color on each side of this color.
  /// Otherwise, generates [count] colors centered around this color.
  ///
  /// Example:
  /// ```dart
  /// final List<ColorIQ> palette = blue.analogous(count: 5, offset: 30);
  /// // Returns: cyan-ish, blue-cyan, blue, blue-purple, purple-ish
  /// ```
  ///
  /// Returns a list of [ColorIQ] colors with analogous hues.
  @override
  List<ColorIQ> analogous({final int count = 5, final double offset = 30}) {
    final List<ColorIQ> results = <ColorIQ>[];

    if (count == 3) {
      results.add(adjustHue(-offset));
      results.add(this);
      results.add(adjustHue(offset));
    } else {
      // Default to 5
      results.add(adjustHue(-offset * 2));
      results.add(adjustHue(-offset));
      results.add(this);
      results.add(adjustHue(offset));
      results.add(adjustHue(offset * 2));
    }

    return results;
  }

  /// Generates a square color scheme palette.
  ///
  /// A square color scheme uses four colors evenly spaced around the color
  /// wheel (90° apart). This creates vibrant, contrasting color combinations
  /// that are visually balanced.
  ///
  /// Returns a list of 4 [ColorIQ] colors, starting with this color followed
  /// by colors at 90°, 180°, and 270° hue shifts.
  @override
  List<ColorIQ> square() {
    return <ColorIQ>[this, adjustHue(90), adjustHue(180), adjustHue(270)];
  }

  /// Generates a tetradic (double complementary) color scheme palette.
  ///
  /// A tetradic color scheme uses four colors arranged in two complementary
  /// pairs. The [offset] parameter (defaults to 60°) controls the spacing
  /// between the complementary pairs.
  ///
  /// The palette consists of:
  /// - This color
  /// - A color offset by [offset] degrees
  /// - The complementary color (180° from this color)
  /// - The complementary of the offset color (180° + [offset])
  ///
  /// Returns a list of 4 [ColorIQ] colors forming a tetradic scheme.
  @override
  List<ColorIQ> tetrad({final double offset = 60}) {
    return <ColorIQ>[
      this,
      adjustHue(offset),
      adjustHue(180),
      adjustHue(180 + offset),
    ];
  }

  /// Calculates the contrast ratio between this color and [other].
  ///
  /// The contrast ratio is calculated according to WCAG (Web Content
  /// Accessibility Guidelines) standards using the formula:
  /// `(L1 + 0.05) / (L2 + 0.05)` where L1 is the lighter luminance and L2
  /// is the darker luminance.
  ///
  /// Contrast ratios range from 1:1 (no contrast, same color) to 21:1
  /// (maximum contrast, e.g., black on white). WCAG recommends:
  /// - 4.5:1 for normal text
  /// - 3:1 for large text
  /// - 7:1 for enhanced accessibility
  ///
  /// Returns the contrast ratio as a double.
  @override
  double contrastWith(final ColorSpacesIQ other) {
    final double l1 = luminance;
    final double l2 = other.luminance;
    final double lighter = max(l1, l2);
    final double darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Finds the closest color slice from the predefined HCT color slices.
  ///
  /// Color slices represent predefined regions in the HCT color space,
  /// useful for color organization and palette generation. This method uses
  /// perceptual distance (CAM16) to find the slice that best matches this color.
  ///
  /// Returns the [ColorSlice] that is perceptually closest to this color.
  @override
  ColorSlice closestColorSlice() {
    ColorSlice? closest;
    double minDistance = double.infinity;

    for (final ColorSlice slice in hctSlices) {
      final double dist = distanceTo(slice.color);
      if (dist < minDistance) {
        minDistance = dist;
        closest = slice;
      }
    }
    return closest!;
  }

  /// Checks whether this color is within the specified color gamut.
  ///
  /// Since [ColorIQ] represents colors as 8-bit clamped values in sRGB space,
  /// they are always within the sRGB gamut by definition. When checking
  /// against wider gamuts (like Display P3 or Rec. 2020), sRGB colors are
  /// also considered within those gamuts as sRGB is a subset of wider gamuts.
  ///
  /// The [gamut] parameter specifies which gamut to check against
  /// (defaults to [Gamut.sRGB]).
  ///
  /// Returns `true` as sRGB colors are always within any valid gamut.
  @override
  bool isWithinGamut([final Gamut gamut = Gamut.sRGB]) {
    // For standard sRGB Color objects, they are always within sRGB gamut
    // because they are 8-bit clamped.
    // If checking against wider gamuts, they are also within.
    return true;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': 'ColorIQ', 'value': value};
  }

  /// Creates a [ColorSpacesIQ] instance from a JSON map.
  ///
  /// This method supports deserializing various color types from JSON,
  /// including [ColorIQ], [HctColor], [HslColor], [HsvColor], [CmykColor],
  /// [CIELab], [XyzColor], and [LchColor].
  ///
  /// The JSON map must contain a `'type'` field indicating the color type,
  /// along with the appropriate fields for that color type.
  ///
  /// Example:
  /// ```dart
  /// final ColorIQ color = ColorIQ.fromJson({
  ///   'type': 'ColorIQ',
  ///   'value': 0xFFFF0000,
  /// });
  /// ```
  ///
  /// Throws [FormatException] if the color type is unknown or the JSON is invalid.
  static CommonIQ fromJson(final Map<String, dynamic> json) {
    final String type = json['type'] as String;
    switch (type) {
      case 'ColorIQ':
        return ColorIQ(json[kValue] as int);
      case 'HctColor':
        return HctColor(json['hue'], json[kChroma], json['tone']);

      case 'HslColor':
        return HSL(
          json['hue'],
          json['saturation'],
          json['lightness'],
          alpha: json['alpha'] ?? 1.0,
        );
      case 'HsvColor':
        return HSV.fromJson(json);
      case 'CmykColor':
        return CMYK(json['c'], json['m'], json['y'], json['k']);
      case 'LabColor':
        return CIELab(json['l'], json['a'], json['b']);
      case 'XyzColor':
        return XYZ(json['x'], json['y'], json['z']);
      case 'LchColor':
        return LchColor(json['l'], json['c'], json['h']);
      // Add other cases as needed, defaulting to Color if unknown
      default:
        if (json.containsKey('value')) {
          return ColorIQ(json['value'] as int);
        }
        throw FormatException('Unknown color type: $type, ${type.runtimeType}');
    }
  }

  /// Returns a string representation of this color.
  ///
  /// The string format is `ColorIQ(0xAARRGGBB)` where AARRGGBB is the
  /// hexadecimal representation of the color value.
  @override
  String toString() =>
      'ColorIQ(0x${value.toRadixString(16).toUpperCase().padLeft(8, '0')})';

  /// Calculates the tone difference between this color and [other] in HCT space.
  ///
  /// Tone in HCT represents the perceived lightness of a color. This method
  /// returns the absolute difference in tone values, which is useful for
  /// comparing color lightness in a perceptually uniform way.
  ///
  /// Returns the tone difference as a double.
  @override
  double toneDifference(final ColorWheelInf other) {
    return hct.toneDifference(other);
  }
}
