import 'package:edugalaxy/pages/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edugalaxy/local_cache.dart';
import 'package:edugalaxy/pages/home.dart';
import 'package:edugalaxy/pages/session.dart';

void main() {
  testWidgets('Empty Fields results in Required markers',
      (WidgetTester tester) async {
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

  testWidgets('Valid Input results in submission', (WidgetTester tester) async {
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
    expect(find.text('Submit'), findsNothing);
  });

  testWidgets('Create Task button pops up task modal',
      (WidgetTester tester) async {
    // Renders the HomePage widget for testing.
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Tap the "Create Task" button, then check if the modal shows up.
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('Create Session button pops up session modal',
      (WidgetTester tester) async {
    // Renders the HomePage widget for testing.
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Tap the "Create Session" button, then check if the modal shows up.
    await tester.tap(find.text('Create Session'));
    await tester.pumpAndSettle();
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('Submission of session modal redirects to session page',
      (WidgetTester tester) async {
    // Renders the HomePage widget for testing.
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Tap the "Create Session" button, then submit to start a session.
    await tester.tap(find.text('Create Session'));
    await tester.pumpAndSettle();
    final submitButton = find.text('Submit');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Session should be created
    expect(find.text('Study Session Ongoing'), findsOneWidget);
  });

  testWidgets('Application exits should lead to broken session',
      (WidgetTester tester) async {
    // Renders the SessionPage widget for testing.
    await tester.pumpWidget(const MaterialApp(
        home: SessionPage(
      sessionDuration: 4,
    )));

    // Check if the session is ongoing.
    expect(find.text('Study Session Ongoing'), findsOneWidget);

    // Obtain the state of the SessionPage, pause and resume the app.
    final SessionPageState state = tester.state(find.byType(SessionPage));
    state.didChangeAppLifecycleState(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    state.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    // Check if the broken session page is displayed.
    expect(find.text("You broke your session!"), findsOneWidget);
  });
}
