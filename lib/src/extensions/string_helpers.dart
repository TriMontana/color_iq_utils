extension NullableStringExtensions on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  String orDefault(final String defaultValue) {
    return this ?? defaultValue;
  }
}
