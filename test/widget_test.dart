import 'package:flutter_test/flutter_test.dart';
import 'package:it_startup_web/main.dart';

void main() {
  testWidgets('App loads home screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodStartupApp());
  });
}
