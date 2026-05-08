import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/app.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_theme.dart';
import 'package:isango_app/screens/auth/sign_in_screen.dart';

void main() {
  Widget buildSubject({
    SignInHandler? onSignIn,
    bool initiallyLoading = false,
  }) {
    return MaterialApp(
      theme: AppTheme.light(),
      routes: {
        AppRoutes.login: (_) => SignInScreen(
              onSignIn: onSignIn,
              initiallyLoading: initiallyLoading,
            ),
        AppRoutes.signUp: (_) => const Scaffold(
              body: Center(child: Text('Sign up destination')),
            ),
        AppRoutes.resetPassword: (_) => const Scaffold(
              body: Center(child: Text('Reset password destination')),
            ),
      },
      initialRoute: AppRoutes.login,
    );
  }

  testWidgets('shows inline validation errors', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(
      find.text('Please enter a valid university email address'),
      findsOneWidget,
    );
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('navigates to /signup from the secondary link', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.ensureVisible(find.byKey(const Key('signUpLink')));
    await tester.tap(find.byKey(const Key('signUpLink')));
    await tester.pumpAndSettle();

    expect(find.text('Sign up destination'), findsOneWidget);
  });

  testWidgets('keeps layout visible while sign in is loading', (tester) async {
    final completer = Completer<void>();

    await tester.pumpWidget(
      buildSubject(onSignIn: (_, _) => completer.future),
    );

    await tester.enterText(
      find.byKey(const Key('signInEmailField')),
      'student@domain.edu',
    );
    await tester.enterText(
      find.byKey(const Key('signInPasswordField')),
      'campus-pass',
    );
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(find.byKey(const Key('signInLoadingIndicator')), findsOneWidget);
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byKey(const Key('signInButton'))).onPressed,
      isNull,
    );

    completer.complete();
    await tester.pumpAndSettle();
  });
}
