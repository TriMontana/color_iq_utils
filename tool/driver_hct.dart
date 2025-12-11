import 'dart:io';

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/maps/registry.dart';

/// A simple driver that accepts a 32-bit color ID and produces output for:
/// - ARGB integers (0-255 for each channel)
/// - Normalized sRGB values (0.0-1.0)
/// - HSV values
/// - HCT values from Material Color Utilities
///
/// Usage:
///   dart tool/driver_hct.dart 0xFF00CED1
///   dart tool/driver_hct.dart 0x00CED1
///   dart tool/driver_hct.dart 13520657
void main(final List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart tool/driver_hct.dart <color_id>');
    print('  color_id can be:');
    print('    - Hex format: 0xFF00CED1 or 0x00CED1');
    print('    - Decimal format: 13520657');
    exit(1);
  }

  // Parse the color ID
  final int colorId = _parseColorId(args[0]);

  // Create ColorIQ instance
  final ColorIQ color = ColorIQ(colorId);

  // Extract ARGB integers
  final ArgbInts argbInts = colorId.rgbaInts;

  // Extract normalized sRGB values
  final ArgbDoubles argbDoubles = colorId.rgbaDoubles;

  // Get HSV values
  final HSV hsv = color.hsv;

  // Get HCT values
  final HctData hct = color.hct;

  // Print output
  final String separator = '=' * 70;
  print(separator);
  print('Color Analysis for: ${colorId.toHexStr}');
  print(separator);
  print('');

  // ARGB Integers (0-255)
  print('ARGB Integers (0-255):');
  print('  aphaInt: ${argbInts.alpha}');
  print('  red: Uint8IQ(${argbInts.red}),');
  print('  geen: Uint8IQ(${argbInts.green})');
  print('  blue: Uint8IQ(${argbInts.blue}),');
  print('');

  // Normalized sRGB (0.0-1.0)
  print('Normalized sRGB (0.0-1.0):');
  print('  a: const Percent(${argbDoubles.a.toStringAsFixed(6)}),');
  print('  r: const Percent(${argbDoubles.r.toStringAsFixed(6)})');
  print('  g: const Percent(${argbDoubles.g.toStringAsFixed(6)}),');
  print('  b: const Percent(${argbDoubles.b.toStringAsFixed(6)})');
  print('');

  // HSV values
  print('HSV (Hue, Saturation, Value):');
  print('  Hue:        ${hsv.h.toStringAsFixed(3)}°');
  print(
      '  Saturation: ${hsv.saturation.toStringAsFixed(6)} (${(hsv.saturation.val * 100).toStringAsFixed(2)}%)');
  print(
      '  Value:      ${hsv.valueHsv.toStringAsFixed(6)} (${(hsv.valueHsv.val * 100).toStringAsFixed(2)}%)');
  print(
      '  Alpha:      ${hsv.alpha.toStringAsFixed(6)} (${(hsv.alpha.val * 100).toStringAsFixed(2)}%)');
  print('');

  // HCT values (Material Color Utilities)
  print('HCT (Hue, Chroma, Tone) - Material Color Utilities:');
  print('  Hue:    ${hct.hue.toStringAsFixed(3)}°');
  print('  Chroma: ${hct.chroma.toStringAsFixed(6)}');
  print('  Tone:   ${hct.tone.toStringAsFixed(6)}');
  print('');
  print('hct: ${hct.createStr(5)}, ');
  print('lrv: const Percent(${color.lrv.toStrTrimZeros(6)}),');
  print('brightness: Brightness.${color.brightness.name},');
  print('Color: ${color.hexStr}');

  // Additional info
  print('Additional Information:');
  print('  Hex String: ${color.hexStr}');
  final ColorIQ? color2 = colorRegistry[colorId];
  if (color2 != null) {
    print('  Descriptive Name: ${color2.names}');
  }
  print('  Descriptive Name: ${color.descriptiveName}');
  print(separator);
}

/// Parses a color ID from various input formats.
///
/// Supports:
/// - Hex format: 0xFF00CED1, 0x00CED1, #00CED1, #FF00CED1
/// - Decimal format: 13520657
int _parseColorId(String input) {
  input = input.trim();

  // Handle hex formats
  if (input.startsWith('0x') || input.startsWith('0X')) {
    return int.parse(input.substring(2), radix: 16);
  } else if (input.startsWith('#')) {
    final String hex = input.substring(1);
    // If 6 digits, assume fully opaque (add FF prefix)
    if (hex.length == 6) {
      return int.parse('FF$hex', radix: 16);
    } else if (hex.length == 8) {
      return int.parse(hex, radix: 16);
    } else {
      throw FormatException(
          'Invalid hex format: $input (expected 6 or 8 hex digits)');
    }
  }

  // Try decimal format
  try {
    return int.parse(input);
  } catch (e) {
    throw FormatException('Invalid color ID format: $input\n'
        'Expected: hex (0xFF00CED1, #00CED1) or decimal (13520657)');
  }
}
