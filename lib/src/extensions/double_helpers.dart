/// Extension for doubles
extension DoubleHelpersIQ on double {
  double assertRange0to100([final String? msg]) {
    if (this < 0.0 || this > 100.0) {
      throw RangeError(
        'Value must be between 0 and 100. ${msg ?? 'assertRange0to100'}',
      );
    }
    return this;
  }
}
