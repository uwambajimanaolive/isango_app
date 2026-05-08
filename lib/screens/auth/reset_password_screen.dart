import 'package:flutter/material.dart';
import 'package:isango_app/screens/shared/placeholder_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IsangoPlaceholderScreen(
      title: 'Reset your password',
      message: 'Password reset will be implemented in a dedicated auth issue.',
    );
  }
}
