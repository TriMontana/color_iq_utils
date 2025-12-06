import 'package:color_iq_utils/src/foundation_lib.dart';
import 'package:color_iq_utils/src/models/coloriq.dart';
import 'package:color_iq_utils/src/models/hsl_color.dart';
import 'package:color_iq_utils/src/models/ok_lab_color.dart';
import 'package:color_iq_utils/src/models/ok_lch_color.dart';

/// Supported CSS color spaces.
enum CssColorSpace {
  hex,
  rgb,
  hsl,
  oklab,
  oklch,
}

/// Extension for CSS string conversion.
extension CssExtensions on ColorSpacesIQ {
  /// Converts the color to a CSS string in the specified [space].
  String toCssString({final CssColorSpace space = CssColorSpace.hex}) {
    switch (space) {
      case CssColorSpace.hex:
        return _toHex();
      case CssColorSpace.rgb:
        return _toRgb();
      case CssColorSpace.hsl:
        return _toHsl();
      case CssColorSpace.oklab:
        return _toOklab();
      case CssColorSpace.oklch:
        return _toOklch();
    }
  }

  String _toHex() {
    final ColorIQ c = toColor();
    final int a = c.alpha;
    final String r = c.red.toRadixString(16).padLeft(2, '0');
    final String g = c.green.toRadixString(16).padLeft(2, '0');
    final String b = c.blue.toRadixString(16).padLeft(2, '0');

    if (a == 255) {
      return '#$r$g$b';
    } else {
      final String alphaHex = a.toRadixString(16).padLeft(2, '0');
      return '#$r$g$b$alphaHex';
    }
  }

  String _toRgb() {
    final ColorIQ c = toColor();
    if (c.alpha == 255) {
      return 'rgb(${c.red}, ${c.green}, ${c.blue})';
    } else {
      final String a = (c.alpha / 255.0)
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'\.?0+$'), '');
      return 'rgba(${c.red}, ${c.green}, ${c.blue}, $a)';
    }
  }

  String _toHsl() {
    final HslColor hsl;
    if (this is HslColor) {
      hsl = this as HslColor;
    } else {
      hsl = toColor().toHsl();
    }

    final String h = hsl.h.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    final String s =
        '${(hsl.s * 100).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}%';
    final String l =
        '${(hsl.l * 100).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}%';

    if (hsl.alpha >= 0.99) {
      return 'hsl($h, $s, $l)';
    } else {
      final String a =
          hsl.alpha.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
      return 'hsla($h, $s, $l, $a)';
    }
  }

  String _toOklab() {
    final OkLabColor oklab;
    if (this is OkLabColor) {
      oklab = this as OkLabColor;
    } else {
      oklab = toColor().toOkLab();
    }

    final String l =
        oklab.l.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');
    final String a =
        oklab.aLab.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');
    final String b =
        oklab.bLab.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');

    if (oklab.alpha >= 0.99) {
      return 'oklab($l $a $b)';
    } else {
      final String alpha =
          oklab.alpha.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
      return 'oklab($l $a $b / $alpha)';
    }
  }

  String _toOklch() {
    final OkLchColor oklch;
    if (this is OkLchColor) {
      oklch = this as OkLchColor;
    } else {
      oklch = toColor().toOkLch();
    }

    final String l =
        oklch.l.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');
    final String c =
        oklch.c.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');
    final String h =
        oklch.h.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');

    if (oklch.alpha >= 0.99) {
      return 'oklch($l $c $h)';
    } else {
      final String alpha =
          oklch.alpha.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
      return 'oklch($l $c $h / $alpha)';
    }
  }
}

/// Utility for parsing CSS strings.
class CssColor {
  /// Parses a CSS string into a [ColorSpacesIQ].
  /// Supports Hex, RGB, HSL, OKLAB, OKLCH.
  static ColorSpacesIQ fromCssString(final String cssString) {
    final String s = cssString.trim().toLowerCase();

    if (s.startsWith('#')) {
      return ColorIQ.fromHexStr(s);
    } else if (s.startsWith('rgb')) {
      return _parseRgb(s);
    } else if (s.startsWith('hsl')) {
      return _parseHsl(s);
    } else if (s.startsWith('oklab')) {
      return _parseOklab(s);
    } else if (s.startsWith('oklch')) {
      return _parseOklch(s);
    }

    throw FormatException('Unsupported CSS color format: $cssString');
  }

  static ColorIQ _parseRgb(final String s) {
    // rgb(r, g, b) or rgba(r, g, b, a) or rgb(r g b / a)
    final String content = s.substring(s.indexOf('(') + 1, s.lastIndexOf(')'));
    final List<String> parts = content
        .split(RegExp(r'[,\s/]+'))
        .where((final String p) => p.isNotEmpty)
        .toList();

    if (parts.length < 3) {
      throw const FormatException('Invalid RGB string');
    }

    final int r = int.parse(parts[0]);
    final int g = int.parse(parts[1]);
    final int b = int.parse(parts[2]);
    double a = 1.0;

    if (parts.length >= 4) {
      a = double.parse(parts[3]);
    }

    return ColorIQ.fromARGB((a * 255).round(), r, g, b);
  }

  static HslColor _parseHsl(final String s) {
    // hsl(h, s%, l%)
    final String content = s.substring(s.indexOf('(') + 1, s.lastIndexOf(')'));
    final List<String> parts = content
        .split(RegExp(r'[,\s/]+'))
        .where((final String p) => p.isNotEmpty)
        .toList();

    if (parts.length < 3) {
      throw const FormatException('Invalid HSL string');
    }

    final double h = double.parse(parts[0].replaceAll('deg', ''));
    final double sVal = double.parse(parts[1].replaceAll('%', '')) / 100.0;
    final double l = double.parse(parts[2].replaceAll('%', '')) / 100.0;
    Percent a = Percent.max;

    if (parts.length >= 4) {
      a = Percent(double.parse(parts[3]
          .replaceAll('%', ''))); // Alpha can be percentage? Usually 0-1.
      // If it has %, divide by 100.
      if (parts[3].contains('%')) {
        a = Percent(a.val / 100.0);
      }
    }

    return HslColor.alt(h, sVal, l, alpha: a);
  }

  static OkLabColor _parseOklab(final String s) {
    // oklab(l a b / alpha)
    final String content = s.substring(s.indexOf('(') + 1, s.lastIndexOf(')'));
    final List<String> parts = content
        .split(RegExp(r'[,\s/]+'))
        .where((final String p) => p.isNotEmpty)
        .toList();

    if (parts.length < 3) {
      throw const FormatException('Invalid OKLAB string');
    }

    double l = double.parse(parts[0].replaceAll('%', ''));
    if (parts[0].contains('%')) l /= 100.0; // L can be percentage

    final double aVal = double.parse(parts[1]);
    final double b = double.parse(parts[2]);
    Percent alpha = Percent.max;

    if (parts.length >= 4) {
      alpha = Percent(double.parse(parts[3]));
      if (parts[3].contains('%')) {
        final double la = alpha.val / 100.0;
        alpha = Percent(la);
      }
    }

    return OkLabColor.alt(l, aVal, b, alpha: alpha);
  }

  static OkLchColor _parseOklch(final String s) {
    // oklch(l c h / alpha)
    final String content = s.substring(s.indexOf('(') + 1, s.lastIndexOf(')'));
    final List<String> parts = content
        .split(RegExp(r'[,\s/]+'))
        .where((final String p) => p.isNotEmpty)
        .toList();

    if (parts.length < 3) {
      throw const FormatException('Invalid OKLCH string');
    }

    double l = double.parse(parts[0].replaceAll('%', ''));
    if (parts[0].contains('%')) l /= 100.0;

    final double c = double.parse(parts[1]);
    final double h = double.parse(parts[2].replaceAll('deg', ''));
    Percent alpha = Percent.max;

    if (parts.length >= 4) {
      alpha = Percent(double.parse(parts[3]));
      if (parts[3].contains('%')) {
        final double la = alpha.val / 100.0;
        alpha = Percent(la);
      }
    }

    return OkLchColor.alt(Percent(l), c, h, alpha: alpha);
  }
}
