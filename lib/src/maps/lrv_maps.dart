import 'package:color_iq_utils/src/extensions/float_ext_type.dart';
import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

Map<int, Percent> mapLRVs = <int, Percent>{
  //
};

extension LRVExtension on Map<int, Percent> {
  Percent getOrCreate(final int key) {
    if (containsKey(key)) {
      return this[key]!;
    }
    final Percent lrv = computeLuminanceViaLinearized(
        key.redLinearized, key.greenLinearized, key.blueLinearized);
    return putIfAbsent(key, () => lrv);
  }
}
