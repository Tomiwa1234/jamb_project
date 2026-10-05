import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jamb_project/main.dart';
import 'package:jamb_project/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('register, practise a year, see high score on profile', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final auth = await AuthService.create();
    await tester.pumpWidget(JambApp(auth: auth));

    await tester.tap(find.text('New here? Create an account'));
    await tester.pump();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Ada Obi');
    await tester.enterText(fields.at(1), 'ada');
    await tester.enterText(fields.at(3), 'secret1');
    await tester.enterText(fields.at(4), 'secret1');
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Ada'), findsOneWidget);

    await tester.tap(find.text('Start practice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plentiful'));
    await tester.pump();
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('high score'), findsOneWidget);
    expect(auth.currentUser!.attempts.length, 1);

    await auth.logout();
    await tester.pumpAndSettle();
    expect(await auth.login('ada', 'wrong'), isNotNull);
    expect(await auth.login('ADA', 'secret1'), isNull);
  });

  testWidgets('continue with Google creates a passwordless account', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final auth = await AuthService.create();
    await tester.pumpWidget(JambApp(auth: auth));
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find
          .descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextFormField),
          )
          .at(0),
      'Ada Obi',
    );
    await tester.enterText(
      find
          .descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextFormField),
          )
          .at(1),
      'ada@mail.com',
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Ada'), findsOneWidget);

    final username = auth.currentUser!.username;
    await auth.logout();
    expect(await auth.login(username, ''), isNotNull);
  });
}
