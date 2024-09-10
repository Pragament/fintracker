import 'package:flutter_test/flutter_test.dart';

/// Usage: all text should be readable by screen readers
Future<void> allTextShouldBeReadableByScreenReaders(WidgetTester tester) async {
  // Check if all text is readable by screen readers
  final isTextReadable = tester.binding.accessibilityFeatures;
}
