import 'package:edugalaxy/pages/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edugalaxy/local_cache.dart';

void main() {
  group('Form Validation Tests', () {
    testWidgets('Empty Fields', (WidgetTester tester) async {
      // Renders the TasksPage widget for testing.
      await tester.pumpWidget(const MaterialApp(home: TasksPage()));

      // Opens the task creation form.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Try to submit the form with empty fields
      final submitButton = find.text('Submit');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();

      // Ensure 1 "Required" text displayed for the 1 blank fields.
      expect(find.text("Required"), findsNWidgets(1));
    });

    testWidgets('Valid Input', (WidgetTester tester) async {
      // Renders the TasksPage widget for testing.
      await tester.pumpWidget(const MaterialApp(home: TasksPage()));

      // Opens the task creation form.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter valid input into the form fields.
      await tester.enterText(find.byKey(const Key('titleField')), 'Test');

      // Submit the form
      final submitButton = find.text('Submit');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Check the task is submitted and form is closed.
      expect(find.text('Create Task'), findsNothing);
    });
  });
}
