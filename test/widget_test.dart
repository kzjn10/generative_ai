import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_convenience/main.dart';

void main() {
  testWidgets('App renders chat screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartConvenienceApp());

    // Verify the app bar shows the app name
    expect(find.text('Smart Convenience'), findsOneWidget);
    // Verify the input field is present
    expect(find.byType(TextField), findsOneWidget);
  });
}
