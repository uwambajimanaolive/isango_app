import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isango_app/core/theme/app_theme.dart';
import 'package:isango_app/screens/auth/verify_email_screen.dart';

void main() {
  testWidgets('renders verify email content and button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const VerifyEmailScreen(),
      ),
    );

    expect(find.text('Verification Pending'), findsOneWidget);
    expect(find.text('Resend Verification Email'), findsOneWidget);
    expect(find.byIcon(Icons.mark_email_read_outlined), findsOneWidget);
  });
}
