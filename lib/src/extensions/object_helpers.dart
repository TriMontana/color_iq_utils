import 'dart:developer' as developer;
import 'dart:io';

import 'package:color_iq_utils/src/extensions/string_helpers.dart';

extension NullableObjectExtension on Object? {
  Object orThrowException([final String? msg]) {
    if (this != null) {
      return this!;
    }
    final StackTrace st = StackTrace.current;
    final String er = '${msg.orEmpty}--${st.toString()}--${st.toString()}';
    stderr.writeln(er);
    developer.log(er);

    throw Exception(msg ?? 'exceptionThrown at NullableObjectExtension\n$er');
  }
}

extension ObjectExtension on Object {
  bool isTypeOf<X extends Object>() => this is X;

  // i.e. is CHILD of
  bool isSubtypeOf<X extends Object>() {
    if (this is X || runtimeType == X) {
      // debugPrint('returning early from is "isSubtypeOf"--${X.runtimeType}');
      return true;
    }
    // if (this is! Iterable<X>) {
    //   return false;
    // }
    if (this is List) {
      return this is List<X>;
    }
    if (this is Set) {
      return this is Set<X>;
    }
    return false;
  }
}
