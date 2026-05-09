import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('renders users home page controls', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Users App'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Create User'), findsOneWidget);
    expect(find.text('Fetch Users'), findsOneWidget);
  });
}
