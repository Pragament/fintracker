
import 'package:flutter_test/flutter_test.dart';

/// Usage: the Flutter binding is initialized
Future<void> theFlutterBindingIsInitialized(WidgetTester tester) async {
  TestWidgetsFlutterBinding.ensureInitialized();
}
