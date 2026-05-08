import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_theme.dart';
import 'package:isango_app/screens/auth/sign_up_screen.dart';

void main() {
  Widget buildSubject({
    CreateAccountHandler? onCreateAccount,
    bool initiallyLoading = false,
  }) {
    return MaterialApp(
      theme: AppTheme.light(),
      routes: {
        AppRoutes.signUp: (_) => SignUpScreen(
          onCreateAccount: onCreateAccount,
          initiallyLoading: initiallyLoading,
        ),
        AppRoutes.login: (_) =>
            const Scaffold(body: Center(child: Text('Sign in destination'))),
      },
      initialRoute: AppRoutes.signUp,
    );
  }

  testWidgets('shows required-field validation errors', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.byKey(const Key('createAccountButton')));
    await tester.pump();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('University email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Confirm password is required'), findsOneWidget);
  });

  testWidgets('shows password confirmation mismatch error', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.enterText(
      find.byKey(const Key('signUpDisplayNameField')),
      'John Doe',
    );
    await tester.enterText(
      find.byKey(const Key('signUpEmailField')),
      'student@domain.edu',
    );
    await tester.enterText(
      find.byKey(const Key('signUpPasswordField')),
      'campus-pass',
    );
    await tester.enterText(
      find.byKey(const Key('signUpConfirmPasswordField')),
      'different-pass',
    );
    await tester.tap(find.byKey(const Key('createAccountButton')));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('navigates to /login from the secondary link', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.ensureVisible(find.byKey(const Key('signInLink')));
    await tester.tap(find.byKey(const Key('signInLink')));
    await tester.pumpAndSettle();

    expect(find.text('Sign in destination'), findsOneWidget);
  });
}
