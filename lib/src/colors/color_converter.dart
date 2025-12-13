// import 'package:coloriq_app/src/common/color_extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:material_color_utilities/hct/hct.dart';
//
// /// A pair of [MaterialColor] and [MaterialAccentColor] swatches.
// class SwatchPair {
//   final MaterialColor materialColor;
//   final MaterialAccentColor materialAccentColor;
//
//   SwatchPair(this.materialColor, this.materialAccentColor);
// }
//
// /// A generator for [SwatchPair] based on HCT color values.
// class SwatchPairGenerator {
//   /// Generates a [SwatchPair] from a given HCT color.
//   ///
//   /// The generation follows the guidelines for Tone (T) and Chroma (C) to create
//   /// aesthetically pleasing swatches.
//   static SwatchPair generate(final Hct hct) {
//     final double hue = hct.hue;
//     final double chroma = hct.chroma;
//
//     // MaterialColor generation based on HCT guidelines
//     final Map<int, Color> shades = <int, Color>{
//       50: Color(Hct.from(hue, chroma.clamp(40.0, 80.0), 96.5).toInt()),
//       100: Color(Hct.from(hue, chroma.clamp(40.0, 80.0), 92.5).toInt()),
//       200: Color(Hct.from(hue, chroma.clamp(40.0, 80.0), 85.0).toInt()),
//       300: Color(Hct.from(hue, chroma.clamp(40.0, 80.0), 75.0).toInt()),
//       400: Color(Hct.from(hue, chroma.clamp(50.0, 90.0), 65.0).toInt()),
//       500: Color(Hct.from(hue, chroma.clamp(60.0, 120.0), 55.0).toInt()),
//       600: Color(Hct.from(hue, chroma.clamp(60.0, 120.0), 45.0).toInt()),
//       700: Color(Hct.from(hue, chroma.clamp(50.0, 90.0), 35.0).toInt()),
//       800: Color(Hct.from(hue, chroma.clamp(30.0, 60.0), 25.0).toInt()),
//       900: Color(Hct.from(hue, chroma.clamp(20.0, 40.0), 15.0).toInt()),
//     };
//
//     final Color primary = shades[500]!;
//     final MaterialColor materialColor = MaterialColor(primary.intValue, shades);
//
//     // MaterialAccentColor generation with maximal chroma
//     const double accentChroma = 150.0; // Aim for maximal chroma
//     final Map<int, Color> accentShades = <int, Color>{
//       100: Color(Hct.from(hue, accentChroma, 85.0).toInt()),
//       200: Color(Hct.from(hue, accentChroma, 70.0).toInt()),
//       400: Color(Hct.from(hue, accentChroma, 50.0).toInt()),
//       700: Color(Hct.from(hue, accentChroma, 35.0).toInt()),
//     };
//
//     final Color accentPrimary = accentShades[200]!;
//     final MaterialAccentColor materialAccentColor = MaterialAccentColor(
//       accentPrimary.intValue,
//       accentShades,
//     );
//
//     return SwatchPair(materialColor, materialAccentColor);
//   }
// }
