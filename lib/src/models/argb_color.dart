import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/lab_color.dart';
import 'package:color_iq_utils/src/utils_lib.dart';

/// An immutable color value in ARGB format.
///
/// NOTE-CREDIT: This is adapted almost 100% from the Dart.ui Color class.
/// The Dart.ui Color class was not used directly so that package could
/// remain a pure Dart package.
///
/// Here are some ways it could be constructed:
///
/// ```dart
/// const ARGBColor c1 = ARGBColor.from(alpha: 1.0, red: 0.2588, green: 0.6471, blue: 0.9608);
/// const ARGBColor c2 = ARGBColor(0xFF42A5F5);
/// const ARGBColor c3 = ARGBColor.fromARGB(0xFF, 0x42, 0xA5, 0xF5);
/// const ARGBColor c4 = ARGBColor.fromARGB(255, 66, 165, 245);
/// const ARGBColor c5 = ARGBColor.fromRGBO(66, 165, 245, 1.0);
/// ```
///
/// If you are having a problem with [ARGBColor.new] wherein it seems your color is
/// just not painting, check to make sure you are specifying the full 8
/// hexadecimal digits. If you only specify six, then the leading two digits are
/// assumed to be zero, which means fully-transparent:
///
/// ```dart
/// const ARGBColor c1 = ARGBColor(0xFFFFFF); // fully transparent white (invisible)
/// const ARGBColor c2 = ARGBColor(0xFFFFFFFF); // fully opaque white (visible)
///
/// // Or use double-based channel values:
/// const ARGBColor c3 = Color.from(alpha: 1.0, red: 1.0, green: 1.0, blue: 1.0);
/// ```
///
/// [AppColor]'s color components are stored as floating-point values. Care should
/// be taken if one does not want the literal equality provided by `operator==`.
/// To test equality inside of Flutter tests consider using [`isSameColorAs`][].
///
///  What are the values kept as primitives?   This is a fundamental design decision when balancing performance
/// guarantees against type safety and convenience.
/// Given that the value is calculated in the constructor using bitwise operations, the best practice is to
/// store the value as a primitive (final int) and provide an extension type wrapper via a getter.
/// This strategy allows you to gain the performance benefit of compile-time constants for the underlying
/// data structure while still leveraging the clean interface of the extension type for the public API.
class AppColor {
  /// The alpha channel of this color.
  final double _a;
  Percent get a => Percent(_a);

  /// The red channel of this color.
  final double _r;
  Percent get r => Percent(_r);

  /// The green channel of this color.
  final double _g;
  Percent get g => Percent(_g);

  /// The blue channel of this color.
  final double _b;
  Percent get b => Percent(_b);

  /// The color space of this color.
  final ColorSpace colorSpace;

  /// The 32-bit colorID
  final int _colorId;

  /// Luminance
  final double? _lrv;

  /// Construct an [ColorSpace.sRGB] color from the lower 32 bits of an [int].
  ///
  /// The bits are interpreted as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  ///
  /// In other words, if AA is the alpha value in hex, RR the red value in hex,
  /// GG the green value in hex, and BB the blue value in hex, a color can be
  /// expressed as `ARGBColor(0xAARRGGBB)`.
  ///
  /// For example, to get a fully opaque orange, you would use `const
  /// ARGBColor(0xFFFF9000)` (`FF` for the alpha, `FF` for the red, `90` for the
  /// green, and `00` for the blue).
  ///
  const AppColor(final int value,
      {final ColorSpace colorSpace = ColorSpace.sRGB, final double? lrv})
      : this._fromARGBC((value >> 24) & 0xFF, (value >> 16) & 0xFF,
            (value >> 8) & 0xFF, (value) & 0xFF, colorSpace,
            colorId: value, lrv: lrv);

  const AppColor.iq(final int value,
      {final ColorSpace colorSpace = ColorSpace.sRGB, final double? lrv})
      : this._fromARGBC((value >> 24) & 0xFF, (value >> 16) & 0xFF,
            (value >> 8) & 0xFF, (value) & 0xFF, colorSpace,
            colorId: value, lrv: lrv);

  /// Construct a color with floating-point color components.
  ///
  /// Color components allows arbitrary bit depths for color components to be be
  /// supported. The values are interpreted relative to the [ColorSpace]
  /// argument.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Fully opaque maximum red color
  /// const ARGBColor c1 = ARGBColor.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 0.0);
  ///
  /// // Partially transparent moderately blue and green color
  /// const ARGBColor c2 = ARGBColor.from(alpha: 0.5, red: 0.0, green: 0.5, blue: 0.5);
  ///
  /// // Fully transparent color
  /// const ARGBColor c3 = ARGBColor.from(alpha: 0.0, red: 0.0, green: 0.0, blue: 0.0);
  /// ```
  const AppColor.from({
    required final double a,
    required final double r,
    required final double g,
    required final double b,
    this.colorSpace = ColorSpace.sRGB,
    final int? colorId,
    final double? lrv,
  })  : assert(
            a >= 0.0 && a <= 1.0, 'invalid Opacity $errorMsgFloat0to1 -- $a'),
        assert(r >= 0.0 && r <= 1.0, 'invalid Red $errorMsgFloat0to1 -- $r'),
        assert(g >= 0.0 && g <= 1.0, 'invalid Green $errorMsgFloat0to1 -- $g'),
        assert(b >= 0.0 && b <= 1.0, 'invalid Blue $errorMsgFloat0to1 -- $b'),
        assert(lrv == null || lrv >= 0.0 && lrv <= 1.0,
            'invalid lrv $errorMsgFloat0to1 -- $lrv'),
        // see discussion at bottom.  There is a very rare possibility of an edge case
        // where double.round() might be different than bitwise, but that is extremely rare.
        // double.round() goes to the nearest even number, where as truncate goes to the nearest whole.
        // recommendation: pass in the colorID if possible.
        _colorId = colorId ??
            (((a * 255 + 0.5) ~/ 1) << 24 |
                ((r * 255 + 0.5) ~/ 1) << 16 |
                ((g * 255 + 0.5) ~/ 1) << 8 |
                ((b * 255 + 0.5) ~/ 1) << 0),
        _a = a,
        _r = r,
        _g = g,
        _b = b,
        _lrv = lrv;

  /// Construct an sRGB color from the lower 8 bits of four integers.
  ///
  /// * `a` is the alpha value, with 0 being transparent and 255 being fully
  ///   opaque.
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
  ///
  /// Out of range values are brought into range using modulo 255.
  const AppColor.fromARGB(
    final int alphaInt,
    final int redInt,
    final int greenInt,
    final int blueInt, {
    final int? colorId,
    final ColorSpace colorSpace = ColorSpace.sRGB,
    final double? a,
    final double? r,
    final double? g,
    final double? b,
    final double? lrv,
  }) : this._fromARGBC(alphaInt, redInt, greenInt, blueInt, colorSpace,
            colorId: colorId, a: a, r: r, g: g, b: b, lrv: lrv);

  const AppColor._fromARGBC(
    final int alpha,
    final int red,
    final int green,
    final int blue,
    final ColorSpace colorSpace, {
    required final int? colorId,
    final double? a,
    final double? r,
    final double? g,
    final double? b,
    final double? lrv,
  }) : this._fromRGBOC(red, green, blue, colorSpace,
            opacity: alpha, colorId: colorId, r: r, g: g, b: b, a: a, lrv: lrv);

  /// Create an sRGB color from red, green, blue, and opacity, similar to
  /// `rgba()` in CSS.
  ///
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
  /// * `opacity` is alpha channel of this color as a double, with 0.0 being
  ///   transparent and 1.0 being fully opaque.
  ///
  /// Out of range values are brought into range using modulo 255.
  const AppColor.fromRGBO(final int redInt, final int greenInt,
      final int blueInt, final int opacity,
      {final int? colorId,
      final ColorSpace colorSpace = ColorSpace.sRGB,
      final double? lrv})
      : this._fromRGBOC(redInt, greenInt, blueInt, colorSpace,
            opacity: opacity, colorId: colorId, lrv: lrv);

  ///
  const AppColor._fromRGBOC(
    final int redInt,
    final int greenInt,
    final int blueInt,
    this.colorSpace, {
    required final int opacity,
    final int? colorId,
    final double? a,
    final double? r,
    final double? g,
    final double? b,
    final double? lrv,
  })  : assert(opacity >= 0.0 && opacity <= 255,
            'invalid Opacity $opacity-$errorMsg0to255'),
        assert(redInt >= 0 && redInt <= 255,
            'invalid Red "$redInt"-$errorMsg0to255'),
        assert(greenInt >= 0 && greenInt <= 255,
            'invalid Green $greenInt-$errorMsg0to255'),
        assert(blueInt >= 0 && blueInt <= 255,
            'invalid Blue $blueInt-$errorMsg0to255'),
        assert(a == null || a >= 0.0 && a <= 1.0,
            'invalid Opacity $errorMsgFloat0to1 -- $a'),
        assert(r == null || r >= 0.0 && r <= 1.0,
            'invalid Red $errorMsgFloat0to1 -- $r'),
        assert(g == null || g >= 0.0 && g <= 1.0,
            'invalid Green $errorMsgFloat0to1 -- $g'),
        assert(b == null || b >= 0.0 && b <= 1.0,
            'invalid Blue $errorMsgFloat0to1 -- $b'),
        assert(lrv == null || lrv >= 0.0 && lrv <= 1.0,
            'invalid lrv $errorMsgFloat0to1 -- $lrv'),
        _colorId = colorId ??
            (((opacity << 24) | (redInt << 16) | (greenInt << 8) | blueInt) &
                0xFFFFFFFF),
        _a = a ?? (opacity & 0xFF) / 255,
        _r = r ?? (redInt & 0xff) / 255,
        _g = g ?? (greenInt & 0xff) / 255,
        _b = b ?? (blueInt & 0xff) / 255,
        _lrv = lrv;

  /// A 32 bit value representing this color.
  ///
  /// This getter is a _stub_. It is recommended instead to use the explicit
  /// [toARGB32] method.
  int get value => _colorId; //  ?? toARGB32();

  /// Returns a 32-bit value representing this color.
  ///
  /// The returned value is compatible with the default constructor
  /// ([ARGBColor.new]) but does _not_ guarantee to result in the same color due to

  ///
  /// Unlike accessing the floating point equivalent channels individually
  /// ([a], [r], [g], [b]), this method is intentionally _lossy_, and scales
  /// each channel using `(channel * 255.0).round().clamp(0, 255)`.
  ///
  /// While useful for storing a 32-bit integer value, prefer accessing the
  /// individual channels (and storing the double equivalent) where higher
  /// precision is required.
  ///
  /// The bits are assigned as follows:
  ///
  /// * Bits 24-31 represents the [a] channel as an 8-bit unsigned integer.
  /// * Bits 16-23 represents the [r] channel as an 8-bit unsigned integer.
  /// * Bits 8-15 represents the [g] channel as an 8-bit unsigned integer.
  /// * Bits 0-7 represents the [b] channel as an 8-bit unsigned integer.
  ///
  /// > [!WARNING]
  /// > The value returned by this getter implicitly converts floating-point
  /// > component values (such as `0.5`) into their 8-bit equivalent by using
  /// > the [toARGB32] method; the returned value is not guaranteed to be stable
  /// > across different platforms or executions due to the complexity of
  /// > floating-point math.
  int toARGB32() =>
      floatToInt8(_a) << 24 |
      floatToInt8(_r) << 16 |
      floatToInt8(_g) << 8 |
      floatToInt8(_b) << 0;

  /// The alpha channel of this color in an 8-bit value.
  /// based on technique: (*.a * 255.0).round().clamp(0, 255)')
  /// A value of 0 means this color is fully transparent. A value of 255 means
  /// this color is fully opaque.
  int get alphaInt => (0xff000000 & value) >> 24;
  int get alpha => _a.toInt0to255;

  /// The alpha channel of this color as a double.
  ///
  /// A value of 0.0 means this color is fully transparent. A value of 1.0 means
  /// this color is fully opaque.
  double get opacity => _a;

  /// The red channel of this color in an 8 bit value.
  int get redInt => (0x00ff0000 & value) >> 16;
  int get red => (_r * 255.0).round().clamp(0, 255);


  /// The green channel of this color in an 8 bit value.
  int get greenInt => (0x0000ff00 & value) >> 8;
  int get green => _g.toInt0to255;

  /// The blue channel of this color in an 8 bit value.
  int get blueInt => (0x000000ff & value) >> 0;
  int get blue => _b.toInt0to255;

  /// Returns a new color with the provided components updated.
  ///
  /// Each component ([alpha], [red], [green], [blue]) represents a
  /// floating-point value; see [ARGBColor.from] for details and examples.
  ///
  /// If [colorSpace] is provided, and is different than the current color
  /// space, the component values are updated before transforming them to the
  /// provided [ColorSpace].
  ///
  /// Example:
  /// ```dart
  /// import 'dart:ui';
  /// /// Create a color with 50% opacity.
  /// ARGBColor makeTransparent(ARGBColor color) => color.withValues(alpha: 0.5);
  /// ```
  AppColor withValues({
    final double? aVal,
    final double? red,
    final double? green,
    final double? blue,
    final ColorSpace? colorSpace,
  }) {
    AppColor? updatedComponents;
    if (red != null || green != null || blue != null) {
      updatedComponents = AppColor.from(
        a: aVal ?? _a,
        r: red ?? _r,
        g: green ?? _g,
        b: blue ?? _b,
        colorSpace: this.colorSpace,
      );
    }
    if (colorSpace != null && colorSpace != this.colorSpace) {
      final ColorTransform transform =
          getColorTransform(this.colorSpace, colorSpace);
      return transform.transform(updatedComponents ?? this, colorSpace);
    }
    return updatedComponents ?? this;
  }

  /// Returns a new color that matches this color with the alpha channel
  /// replaced with `a` (which ranges from 0 to 255).
  ///
  /// Out of range values will have unexpected effects.
  AppColor withAlpha(final int nuAlpha) {
    return AppColor.fromARGB(nuAlpha, red, green, blue);
  }

  /// Returns a new color that matches this color with the red channel replaced
  /// with `r` (which ranges from 0 to 255).
  ///
  /// Out of range values will have unexpected effects.
  AppColor withRed(final int redVal) =>
      AppColor.fromARGB(alpha, redVal.assertRange0to255(), green, blue);

  /// Returns a new color that matches this color with the green channel
  /// replaced with `g` (which ranges from 0 to 255).
  ///
  /// Out of range values will have unexpected effects.
  AppColor withGreen(final int greenVal) {
    return AppColor.fromARGB(alpha, red, greenVal, blue);
  }

  /// Returns a new color that matches this color with the blue channel replaced
  /// with `b` (which ranges from 0 to 255).
  ///
  /// Out of range values will have unexpected effects.
  AppColor withBlue(final int nuBlue) =>
      AppColor.fromARGB(alpha, red, green, nuBlue.assertRange0to255());

  /// Get the luminance
  Percent get lrv => _lrv != null ? Percent(_lrv) : computeLuminance(r, g, b);

  /// Get the brightness
  Brightness get brightness => calculateBrightness(lrv);

  /// Linearly interpolate between two colors.
  ///
  /// This is intended to be fast but as a result may be ugly. Consider
  /// [HSVColor] or writing custom logic for interpolating colors.
  ///
  /// If either color is null, this function linearly interpolates from a
  /// transparent instance of the other color. This is usually preferable to
  /// interpolating from [material.Colors.transparent] (`const
  /// ARGBColor(0x00000000)`), which is specifically transparent _black_.
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as [Curves.elasticInOut]). Each channel
  /// will be clamped to the range 0 to 255.
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an [AnimationController].
  static AppColor? lerp(final AppColor x, final AppColor y, final double t) {
    assert(x.colorSpace != ColorSpace.extendedSRGB);
    assert(y.colorSpace != ColorSpace.extendedSRGB);
    assert(x.colorSpace == y.colorSpace);
    return AppColor.from(
      a: clampDoubleDart(lerpDoubleDart(x.a.value, y.a.value, t), 0, 1),
      r: clampDoubleDart(lerpDoubleDart(x.r.value, y.r.value, t), 0, 1),
      g: clampDoubleDart(lerpDoubleDart(x.g.value, y.g.value, t), 0, 1),
      b: clampDoubleDart(lerpDoubleDart(x.b.value, y.b.value, t), 0, 1),
      colorSpace: x.colorSpace,
    );
  }

  /// Combine the foreground color as a transparent color over top
  /// of a background color, and return the resulting combined color.
  ///
  /// This uses standard alpha blending ("SRC over DST") rules to produce a
  /// blended color from two colors. This can be used as a performance
  /// enhancement when trying to avoid needless alpha blending compositing
  /// operations for two things that are solid colors with the same shape, but
  /// overlay each other: instead, just paint one with the combined color.
  static AppColor alphaBlend(
      final AppColor foreground, final AppColor background) {
    assert(foreground.colorSpace == background.colorSpace);
    assert(foreground.colorSpace != ColorSpace.extendedSRGB);
    final double alpha = foreground.a;
    if (alpha == 0) {
      // Foreground completely transparent.
      return background;
    }
    final double invAlpha = 1 - alpha;
    double backAlpha = background.a;
    if (backAlpha == 1) {
      // Opaque background case
      return AppColor.from(
        a: Percent.max,
        r: alpha * foreground.r.val + invAlpha * background.r.val,
        g: alpha * foreground.g.val + invAlpha * background.g.val,
        b: alpha * foreground.b.val + invAlpha * background.b.val,
        colorSpace: foreground.colorSpace,
      );
    } else {
      // General case
      backAlpha = backAlpha * invAlpha;
      final double outAlpha = alpha + backAlpha;
      assert(outAlpha != 0);
      return AppColor.from(
        a: Percent(outAlpha),
        r: (foreground.r.value * alpha + background.r.value * backAlpha) /
            outAlpha,
        g: (foreground.g.value * alpha + background.g.value * backAlpha) /
            outAlpha,
        b: (foreground.b.value * alpha + background.b.value * backAlpha) /
            outAlpha,
        colorSpace: foreground.colorSpace,
      );
    }
  }

  /// Returns an alpha value representative of the provided [opacity] value.
  ///
  /// The [opacity] value may not be null.
  static int getAlphaFromOpacity(final double opacity) {
    return (clampDoubleDart(opacity, 0.0, 1.0) * 255).round();
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (other is AppColor &&
        other._colorId == _colorId &&
        other.colorSpace == colorSpace) {
      return true;
    }
    return other is AppColor &&
        other._a == _a &&
        other._r == _r &&
        other._g == _g &&
        other._b == _b &&
        other.colorSpace == colorSpace;
  }

  @override
  int get hashCode => Object.hash(a, r, g, b, colorSpace);

  @override
  String toString() =>
      'Color(alpha: ${a.toStringAsFixed(4)}, red: ${r.toStringAsFixed(4)}, '
      'green: ${g.toStrTrimZeros(4)}, blue: ${b.toStringAsFixed(4)}, colorSpace: $colorSpace)';

  CIELab toLabColor() => CIELab.fromInt(_colorId);

  ColorIQ toColor() =>
      ColorIQ(_colorId, colorSpace: colorSpace, argbColor: this);
}

/// Color Transform class, courtesy of Dart library
abstract class ColorTransform {
  AppColor transform(final AppColor color, final ColorSpace resultColorSpace);
}

class _IdentityColorTransform implements ColorTransform {
  const _IdentityColorTransform();
  @override
  AppColor transform(final AppColor color, final ColorSpace resultColorSpace) =>
      color;
}

class _ClampTransform implements ColorTransform {
  const _ClampTransform(this.child);
  final ColorTransform child;
  @override
  AppColor transform(final AppColor color, final ColorSpace resultColorSpace) {
    return AppColor.from(
      a: Percent(clampDoubleDart(color.a.value, 0, 1)),
      r: clampDoubleDart(color.r.value, 0, 1),
      g: clampDoubleDart(color.g.value, 0, 1),
      b: clampDoubleDart(color.b, 0, 1),
      colorSpace: resultColorSpace,
    );
  }
}

class _MatrixColorTransform implements ColorTransform {
  /// Row-major.
  const _MatrixColorTransform(this.values);

  final List<double> values;

  @override
  AppColor transform(final AppColor color, final ColorSpace resultColorSpace) {
    return AppColor.from(
      a: color.a,
      r: values[0] * color.r +
          values[1] * color.g +
          values[2] * color.b +
          values[3],
      g: values[4] * color.r +
          values[5] * color.g +
          values[6] * color.b +
          values[7],
      b: values[8] * color.r +
          values[9] * color.g +
          values[10] * color.b +
          values[11],
      colorSpace: resultColorSpace,
    );
  }
}

ColorTransform getColorTransform(
    final ColorSpace source, final ColorSpace destination) {
  // The transforms were calculated with the following octave script from known
  // conversions. These transforms have a white point that matches Apple's.
  //
  // p3Colors = [
  //   1, 0, 0, 0.25;
  //   0, 1, 0, 0.5;
  //   0, 0, 1, 0.75;
  //   1, 1, 1, 1;
  // ];
  // srgbColors = [
  //   1.0930908918380737,  -0.5116420984268188, -0.0003518527664709836, 0.12397786229848862;
  //   -0.22684034705162048, 1.0182716846466064,  0.00027732315356843174,  0.5073589086532593;
  //   -0.15007957816123962, -0.31062406301498413, 1.0420056581497192,  0.771118700504303;
  //   1,       1,       1,       1;
  // ];
  //
  // format long
  // p3ToSrgb = srgbColors * inv(p3Colors)
  // srgbToP3 = inv(p3ToSrgb)
  const _MatrixColorTransform srgbToP3 = _MatrixColorTransform(<double>[
    0.808052267214446, 0.220292047628890, -0.139648846160100,
    0.145738111193222, //
    0.096480880462996, 0.916386732581291, -0.086093928394828,
    0.089490172325882, //
    -0.127099563510240, -0.068983484963878, 0.735426667591299,
    0.233655661600230,
  ]);
  const ColorTransform p3ToSrgb = _MatrixColorTransform(<double>[
    1.306671048092539, -0.298061942172353, 0.213228303487995,
    -0.213580156254466, //
    -0.117390025596251, 1.127722006101976, 0.109727644608938,
    -0.109450321455370, //
    0.214813187718391, 0.054268702864647, 1.406898424029350, -0.364892765879631,
  ]);
  switch (source) {
    case ColorSpace.sRGB:
      switch (destination) {
        case ColorSpace.sRGB:
          return const _IdentityColorTransform();
        case ColorSpace.extendedSRGB:
          return const _IdentityColorTransform();
        case ColorSpace.displayP3:
          return srgbToP3;
      }
    case ColorSpace.extendedSRGB:
      switch (destination) {
        case ColorSpace.sRGB:
          return const _ClampTransform(_IdentityColorTransform());
        case ColorSpace.extendedSRGB:
          return const _IdentityColorTransform();
        case ColorSpace.displayP3:
          return const _ClampTransform(srgbToP3);
      }
    case ColorSpace.displayP3:
      switch (destination) {
        case ColorSpace.sRGB:
          return const _ClampTransform(p3ToSrgb);
        case ColorSpace.extendedSRGB:
          return p3ToSrgb;
        case ColorSpace.displayP3:
          return const _IdentityColorTransform();
      }
  }
}

// Why This approach is Recommended
// Enables const for the Data Model: The primary performance benefit of
// using a 32-bit integer is to represent a complex state (like a color or flags) as a single,
// immutable, memory-efficient primitive. If your class only stores primitives and its inputs are known at
// compile time, the entire class instance can be made const. This leads to canonicalization (memory reuse) and zero
// runtime initialization cost for the core data structure.
//
// Decouples Storage from API: By storing the int privately, you keep the memory
// footprint small and fast. The extension type is a zero-cost wrapper that is only present at
// compile time to define a cleaner API (methods, operators) for the primitive data.

// ### The Crucial Difference (and Why it Doesn't Matter Here)
//
// The only difference is how they handle the exact midpoint (e.g., $100.5$):
//
//   * **Expression 1 (`.round()`):** Rounds to the nearest **even** integer (e.g., $100.5 to 100$).
//   * **Expression 2 (Manual):** Rounds **up** (away from zero) (e.g., 100.5 to 101).
//
// However, for converting color values ($0$ to $255$), this specific difference is **negligible** in practice.
// The native `.round()` method is standard, slightly cleaner, and usually preferred in Dart for this task.
//
// Since both expressions correctly ops the four components ({a, red, green, blue}) from $0.0-1.0 to $0-255
// and combine them using bitwise shifts (`<< 24`, `<< 16`, etc.), the resulting 32-bit `_colorId` will be the same in the
// vast majority of cases.
