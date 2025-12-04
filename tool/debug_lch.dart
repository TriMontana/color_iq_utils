import 'package:color_iq_utils/color_iq_utils.dart';
import 'package:color_iq_utils/src/constants.dart';

void main() {
  final LchColor whiteLch = cWhite.toLch();
  print('White LCH: L=${whiteLch.l}, C=${whiteLch.c}, H=${whiteLch.h}');

  final LchColor red = LchColor.alt(50, 100, 0);
  final LchColor whitened = red.whiten(50);
  print('Whitened LCH: L=${whitened.l}, C=${whitened.c}, H=${whitened.h}');
}
