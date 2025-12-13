import 'package:color_iq_utils/src/foundation_lib.dart';

Map<int, Percent> mapLRVs = <int, Percent>{
  //
};

extension LRVExtensionMap on Map<int, Percent> {
  Percent getOrCreateLRV(final int key) {
    if (containsKey(key)) {
      return this[key]!;
    }
    final Percent lrv = computeLuminanceViaLinearized(
        key.redLinearized, key.greenLinearized, key.blueLinearized);
    return putIfAbsent(key, () => lrv);
  }
}

Map<int, Brightness> mapBrightness = <int, Brightness>{
  //
};

extension MapBrightnessExtension on Map<int, Brightness> {
  Brightness getOrCreate(final int key, {Percent? lrv}) {
    if (containsKey(key)) {
      return this[key]!;
    }
    lrv ??= mapLRVs.getOrCreateLRV(key);
    final Brightness br = calculateBrightness(lrv);
    return putIfAbsent(key, () => br);
  }
}
