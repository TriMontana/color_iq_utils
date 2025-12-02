import 'package:test/test.dart';

class Awesome {
  bool get isAwesome => true;
} 

void main() {
  group('A group of tests', () {
    final Awesome awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });
}
