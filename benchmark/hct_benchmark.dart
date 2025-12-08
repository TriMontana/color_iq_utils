import 'package:color_iq_utils/color_iq_utils.dart';

void main() {
  final ColorIQ color = ColorIQ(0xFFFF0000); // Red
  final Stopwatch stopwatch = Stopwatch()..start();

  const int iterations = 100000;

  for (int i = 0; i < iterations; i++) {
    color.toHctColor();
  }

  stopwatch.stop();
  print('HCT Conversion x $iterations: ${stopwatch.elapsedMilliseconds} ms');
  print('Average: ${stopwatch.elapsedMicroseconds / iterations} us');

  // Benchmark simple HSL for comparison
  stopwatch.reset();
  stopwatch.start();
  for (int i = 0; i < iterations; i++) {
    color.hsl;
  }
  stopwatch.stop();
  print('HSL Conversion x $iterations: ${stopwatch.elapsedMilliseconds} ms');
  print('Average: ${stopwatch.elapsedMicroseconds / iterations} us');
}
