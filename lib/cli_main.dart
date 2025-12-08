import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:material_color_utilities/hct/hct.dart';

void main() {
  final ColorIQ c = ColorIQ.fromHexStr('#BED3E5');
  print('Name: ${c.descriptiveName}');
  print('L*: ${c.lab.l}');
  print('a*: ${c.lab.a}');
  print('b*: ${c.lab.b}');
  print('H*: ${c.hsl.h}');
  print('S*: ${c.hsl.s}');

  // final ColorIQ color = ColorIQ(id);
  // const HSV hsv = color.asHSV; // HSVColor.fromColor(color);
  // const HSL hsl = color.asHSL; // mapHSL.getOrCreate(id);
  // print('color: ${color.hex}');
  // print('lrv: ${color.lrv.toStrTrimZeros(6)},');
  // // print('lrv2: ${mapLRV.getOrCreateFromColor(color).toStrTrimZeros(6)},');
  // print('brightness: ${ThemeData.estimateBrightnessForColor(color)},');
  // print('brightness2: ${mapBrightness.getOrCreate(id).name},');
  // print(
  //   'hsv: const HSVColor.fromAHSV(${hsv.toAlphaStr()}, ' //
  //   '${hsv.hue.toStrTrimZeros(3)}, ' //
  //   '${toPercentStr(hsv.saturation, 4)}, ${toPercentStr(hsv.value, 4)}),',
  // );
  // final HSV hsv2 = mapHSV.getOrCreate(id);
  // print(
  //   'hsv2: HSVColor.fromAHSV(${hsv2.alpha}, ' //
  //   '${hsv2.hue.toStrTrimZeros(3)}, ' //
  //   '${hsv2.saturation.toStrTrimZeros(4)}, '
  //   '${toPercentStr(hsv2.value, 4)})',
  // );
  // final CMYK cmyk = mapCMYK.getOrCreate(id);
  // print(
  //   'cmyk: const CMYK(${toPercentStr(cmyk.c, 4)}, ' //
  //   '${cmyk.m.toStrTrimZeros(4)}, ' //
  //   '${toPercentStr(cmyk.y, 4)}, ' //
  //   '${toPercentStr(cmyk.k, 4)}),',
  // );
  // print(hsl.createStr());
  final Hct hct = c.hct;
  // final Hct hct2 = Hct.fromInt(id);
  print('hct: $hct');
  // print('hct2: $hct2');
  // print(hct.createStr());
  // final OkLCH okLCH = mapOkLCH.getOrCreate(id);
  // print(okLCH.createStr(5));
  // final Hcl hcl = mapHCL.getOrCreate(id);
  // print(
  //   'hcl: const Hcl(${hcl.h.toStrTrimZeros(5)}, ${hcl.c.toStrTrimZeros(5)}, ' //
  //   '${hcl.l.toStrTrimZeros(5)}),',
  // );
  // final XYZColor xyzColor = mapXYZColor.getOrCreate(id);
  // print(
  //   'xyz: const XYZColor(${xyzColor.x.toStrTrimZeros(5)}, ' //
  //   '${xyzColor.y.toStrTrimZeros(5)}, ' //
  //   '${xyzColor.z.toStrTrimZeros(5)}),',
  // );
  // final HSP hsp = mapHSP.getOrCreate(id);
  // print(
  //   'hsp: const HSP(${hsp.h.toStrTrimZeros(5)}, ' //
  //   '${hsp.s.toStrTrimZeros(5)}, ' //
  //   '${hsp.p.toStrTrimZeros(5)}),',
  // );
  // final RYB ryb = mapRYB.getOrCreate(id);
  // final RYB ryb2 = RYB.colorToRYB(color);
  // print(ryb.createStr());
  // print(ryb2.createStr());
  // final Triad<TdColorFN> xFn = generateTriadicFNsWithFilter(cGreen);
  // for (final TdColorFN xz in xFn.toList) {
  //   print(xz().nameAndHex);
  // }
  // print('${generateTriadicFNsWithFilter(cGreen)}');
}
