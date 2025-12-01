import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:test/test.dart';

void main() {
  group('ColorDescriptor', () {
    test('Achromatic colors', () {
      expect(ColorDescriptor.describe(ColorIQ(0xFFFFFFFF)), 'White');
      expect(ColorDescriptor.describe(ColorIQ(0xFF000000)), 'Black');
      expect(ColorDescriptor.describe(ColorIQ(0xFF808080)), 'Gray');
      expect(ColorDescriptor.describe(ColorIQ(0xFFD3D3D3)), 'Very Light Gray'); // LightGray is D3D3D3
      expect(ColorDescriptor.describe(ColorIQ(0xFF303030)), 'Very Dark Gray');
    });

    test('Chromatic colors', () {
      // Red
      expect(ColorDescriptor.describe(HslColor(0, 1.0, 0.5)), 'Vivid Red'); 
      // Wait, L=0.5, S=1.0 -> Vivid
      
      // Pastel Red (Pinkish)
      expect(ColorDescriptor.describe(HslColor(0, 0.3, 0.8)), 'Pastel Red'); 
      // L=0.8, S=0.3 -> Pastel
      
      // Deep Red
      expect(ColorDescriptor.describe(HslColor(0, 1.0, 0.3)), 'Deep Red');
      // L=0.3, S=1.0 -> Deep
      
      // Dark Red
      expect(ColorDescriptor.describe(HslColor(0, 0.5, 0.3)), 'Dark Red');
      // L=0.3, S=0.5 -> Dark
      
      // Very Light Blue
      expect(ColorDescriptor.describe(HslColor(240, 1.0, 0.9)), 'Very Light Blue');
      // L=0.9, S=1.0 -> Very Light
      
      // Grayish Blue
      expect(ColorDescriptor.describe(HslColor(240, 0.15, 0.5)), 'Grayish Blue');
      // L=0.5, S=0.15 -> Grayish
    });
    
    test('Hue mapping', () {
        // Cyan
        expect(ColorDescriptor.describe(HslColor(180, 1.0, 0.5)).contains('Cyan'), true);
        
        // Yellow
        expect(ColorDescriptor.describe(HslColor(60, 1.0, 0.5)).contains('Yellow'), true);
    });
  });
}
