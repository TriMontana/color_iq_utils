import 'package:color_iq_utils/src/extensions/int_helpers.dart';
import 'package:color_iq_utils/src/utils/color_math.dart';

Map<int, double> mapLRVs = <int, double>{
  //
};

extension LRVExtension on Map<int, double> {
  double getOrCreate(final int key) {
    if (containsKey(key)) {
      return this[key]!;
    }
    final double lrv = computeLuminanceViaLinearized(
        key.redLinearized, key.greenLinearized, key.blueLinearized);
    return putIfAbsent(key, () => lrv);
  }
}
