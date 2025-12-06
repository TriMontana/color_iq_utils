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
      final ColorIQ color1 =
          ColorIQ.fromARGB(255, 255, 0, 0, names: <String>[kRed[0], 'Ruby']);
      final ColorIQ color2 =
          ColorIQ.fromARGB(255, 0, 255, 0, names: <String>[kGreen[0]]);
      final ColorIQ color3 = ColorIQ.fromARGB(255, 0, 0, 255); // No names

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
