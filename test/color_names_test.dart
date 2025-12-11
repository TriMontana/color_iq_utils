import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('ColorNames Utility', () {
    test('generateDefaultName returns correct format', () {
      final ColorIQ color = ColorIQ(0xFFFF0000); // Red
      final String name = ColorNames.generateDefaultName(color);
      // Expected: "Red" (from slice) + "FFFF0000" (hex)
      // Note: slice names depend on hue. 0 hue is "Red".
      expect(name, equals('RedFFFF0000'));
    });

    test('indexByNames handles multiple names', () {
      final ColorIQ color1 = ColorIQ.fromArgbInts(
          alpha: 255,
          red: 255,
          green: 0,
          blue: 0,
          names: <String>[kRed[0], 'Ruby']);
      final ColorIQ color2 = ColorIQ.fromArgbInts(
          alpha: 255, red: 0, green: 255, blue: 0, names: <String>[kGreen[0]]);
      final ColorIQ color3 = ColorIQ.fromArgbInts(
          alpha: 255, red: 0, green: 0, blue: 255); // No names

      final Map<String, List<ColorSpacesIQ>> index =
          ColorNames.indexByNames(<ColorSpacesIQ>[color1, color2, color3]);

      expect(index['Red'], contains(color1));
      expect(index['Ruby'], contains(color1));
      expect(index['Green'], contains(color2));

      // Check default name for color3
      final String defaultName = ColorNames.generateDefaultName(color3);
      expect(index[defaultName], contains(color3));
    });
  });
}
