import 'package:color_iq_utils/src/color_interfaces.dart';

/// A utility class for handling color names.
class ColorNames {
  /// Generates a default name for a color based on its closest color family and hex value.
  ///
  /// The format is "[FamilyName][HexString]".
  /// Example: "RedFFFF0000"
  static String generateDefaultName(final ColorSpacesIQ color) {
    final ColorSlice slice = color.closestColorSlice();
    final String hex =
        color.value.toRadixString(16).toUpperCase().padLeft(8, '0');
    return '${slice.name}$hex';
  }

  /// Groups a list of colors by their names.
  ///
  /// If a color has multiple names, it will appear under each name key.
  /// If a color has no names, it will be indexed under its generated default name.
  static Map<String, List<ColorSpacesIQ>> indexByNames(
      final List<ColorSpacesIQ> colors) {
    final Map<String, List<ColorSpacesIQ>> map =
        <String, List<ColorSpacesIQ>>{};
    for (final ColorSpacesIQ color in colors) {
      List<String> keys = color.names;
      if (keys.isEmpty) {
        keys = <String>[generateDefaultName(color)];
      }
      for (final String key in keys) {
        map.putIfAbsent(key, () => <ColorSpacesIQ>[]).add(color);
      }
    }
    return map;
  }
}
