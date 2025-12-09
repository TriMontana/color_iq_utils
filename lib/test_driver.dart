// ignore_for_file: avoid_print

import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/models/hct_data.dart';
import 'package:material_color_utilities/hct/hct.dart';

void main() {
  final ColorIQ color = cBurlyWood;
  final HSV hsv = color.hsv; // HSVColor.fromColor(color);
  final HSL hsl = color.hsl; // mapHSL.getOrCreate(id);
  print('color: ${color.hexStr}');
  print('lrv: ${color.lrv.toStrTrimZeros(6)},');

  // print('brightness: ${ThemeData.estimateBrightnessForColor(color)},');
  // print('brightness2: ${mapBrightness.getOrCreate(color.id).name},');
  print(hsv.toString());
  final HSP hsp = color.hsp; //
  print(hsp.toString());
  final CMYK cmyk = color.cmyk; // mapCMYK.getOrCreate(color.id);
  print(cmyk.toString());
  print(hsl.toString());
  final Hct hct = Hct.fromInt(color.value);
  final HctData hct2 = HctData.fromInt(color.value);
  print('hct: $hct');
  print('hct2: $hct2');
  print('lrv: ${color.lrv.toStrTrimZeros(6)},');
  // print(hct.createStr());
  // final OkLCH okLCH = color.oklch; // mapOkLCH.getOrCreate(color.id);
  // print(okLCH.createStr(5));
  // final Hcl hcl = color.hcl; // mapHCL.getOrCreate(color.id);
  // print(
  //   'hcl: const Hcl(${hcl.h.toStrTrimZeros(5)}, ${hcl.c.toStrTrimZeros(5)}, ' //
  //   '${hcl.l.toStrTrimZeros(5)}),',
  // );
  // final XYZ xyzColor = color.xyz; // mapXYZColor.getOrCreate(color.id);
  // print(
  //   'xyz: const XYZColor(${xyzColor.x.toStrTrimZeros(5)}, ' //
  //   '${xyzColor.y.toStrTrimZeros(5)}, ' //
  //   '${xyzColor.z.toStrTrimZeros(5)}),',
  // );
  // final HSP hsp = mapHSP.getOrCreate(color.id);
  // print(hsp.createStr(4));
  // final RYB ryb = color.ryb; // mapRYB.getOrCreate(color.id);
  // final RYB ryb2 = RYB.colorToRYB(color);
  // print(ryb.createStr());
  // print(ryb2.createStr());
  // final Triad<TdColorFN> xFn = generateTriadicFNsWithFilter(color);
  // for (final TdColorFN xz in xFn.toList) {
  //   print(xz().nameAndHex);
  // }
  // final String triadStr = xFn.toList
  //     .map((final TdColorFN x) => x().fnColor().nameCobble())
  //     .toList()
  //     .join(', ');
  // debugPrint('triad: const Triad<TdColorFN>($triadStr),');
  //
  // final SplitComp<TdColorFN> s = generateSplitComplementaryFNsWithFilter(color);
  // s.toList.assertUniqueCollection('SplitComp elements must be unique');
  // final String splitStr = s.toList
  //     .map((final TdColorFN x) => x().fnColor().nameCobble())
  //     .toList()
  //     .join(', ');
  // debugPrint('split: const SplitComp<TdColorFN>($splitStr),');
}
