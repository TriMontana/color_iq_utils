# Color IQ Utils

A comprehensive Dart package for advanced color manipulation, conversion, and analysis. This package supports over 24 color models, including standard spaces like RGB, HSL, and HSV, as well as perceptually uniform spaces like HCT, CAM16, OKLab, and OKLCH.

## Features

*   **Extensive Color Models**: Support for RGB, HSL, HSV, HSB, HSI, HWB, CMYK, XYZ, Lab, Luv, Lch, HCT (Material), CAM16, OKLab, OKLch, OKHsl, OKHsv, HSLuv, Hsp, YIQ, YUV, HunterLab, DisplayP3, Rec2020, and Munsell.
*   **Seamless Conversions**: Convert easily between any supported color models (e.g., `color.toHsl()`, `color.toOkLab()`).
*   **Color Manipulation**: Intuitive methods for `lighten`, `darken`, `saturate`, `desaturate`, `whiten`, `blacken`, `blend`, `opaquer`, `adjustHue`, `warmer`, `cooler`, and `invert`.
*   **Palette Generation**: Generate harmonious palettes including `analogous`, `monochromatic`, `complementary`, `splitComplementary` (via tetrad), `triadic` (via square/tetrad), `square`, and `tetradic`.
*   **Color Description**: Get human-readable descriptions of colors (e.g., "Vivid Red", "Pastel Blue") using `ColorDescriptor`.
*   **Perceptual Utilities**: Calculate contrast ratios, perceptual distance (Cam16-UCS approximation), and find the closest named color slice.
*   **Color Wheels**: Generate and map colors to 60-section color wheels (aligned with HSV or HCT).
*   **Gamut & WhitePoint**: Check if colors are within sRGB gamut and access white point data.
*   **Serialization**: Full JSON `toJson`/`fromJson` support for all color models.

## Installation

You can use this package in your Flutter or Dart app by pulling it directly from GitHub or using a local path.

### Option 1: Git Dependency (Recommended)

Add the following to your `pubspec.yaml` file under `dependencies`:

```yaml
dependencies:
  color_iq_utils:
    git:
      url: https://github.com/YOUR_USERNAME/color_iq_utils.git
      ref: main
```

*Replace `YOUR_USERNAME` with the actual GitHub username or organization where this repository is hosted.*

### Option 2: Local Path

If you have the package downloaded locally on your machine:

```yaml
dependencies:
  color_iq_utils:
    path: /path/to/local/color_iq_utils
```

## Usage

Import the package in your Dart code:

```dart
import 'package:color_iq_utils/color_iq_utils.dart';
```

### Basic Conversions

```dart
// Create a color from Hex (ARGB)
var color = Color(0xFFFF0000); // Red

// Convert to HSL
var hsl = color.toHsl();
print('HSL: H:${hsl.h}, S:${hsl.s}, L:${hsl.l}');

// Convert to OKLab (Perceptually uniform)
var oklab = color.toOkLab();
print('OKLab: L:${oklab.l}, A:${oklab.a}, B:${oklab.b}');
```

### Color Manipulation

```dart
var blue = Color(0xFF0000FF);

// Lighten by 20%
var lighterBlue = blue.lighten(20);

// Desaturate by 10%
var mutedBlue = blue.desaturate(10);

// Make it warmer (shift hue towards red/orange)
var warmerBlue = blue.warmer(15);

// Blend with another color
var purple = blue.blend(Color(0xFFFF0000), 50); // Blend 50% with Red
```

### Color Description

Get a human-readable name and description for any color:

```dart
var myColor = Color(0xFFD3D3D3); // Light Gray
print(ColorDescriptor.describe(myColor)); // Output: "Very Light Gray"

var vividRed = HslColor(0, 1.0, 0.5);
print(ColorDescriptor.describe(vividRed)); // Output: "Vivid Red"
```

### Palette Generation

```dart
var base = Color(0xFF008000); // Green

// Generate an analogous palette (5 colors)
var analogous = base.analogous();

// Generate a monochromatic palette
var mono = base.monochromatic;

// Get the complementary color
var comp = base.complementary;
```

### Color Wheels & Slices

```dart
// Get the closest named slice on the color wheel
var slice = base.closestColorSlice();
print('Closest Color Name: ${slice.name}'); // e.g., "Green" or "Forest Green"

// Generate a full HSV color wheel
var wheel = generateHsvWheel();
```

## Testing

To run the tests included in this package:

```bash
flutter test
```
