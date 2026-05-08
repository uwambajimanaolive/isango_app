import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

typedef CreateAccountHandler = Future<void> Function(
  String displayName,
  String email,
  String password,
);

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    this.onCreateAccount,
    this.initiallyLoading = false,
  });

  final CreateAccountHandler? onCreateAccount;
  final bool initiallyLoading;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _submissionError;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.initiallyLoading;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String label) {
    if ((value ?? '').trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'University email is required';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid university email address';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final error = _validateRequired(value, 'Confirm password');
    if (error != null) {
      return error;
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submissionError = null);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final handler = widget.onCreateAccount;
      if (handler != null) {
        await handler(
          _displayNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _submissionError =
            'We could not create your account. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mistBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      key: const Key('signUpBackButton'),
                      tooltip: 'Back',
                      onPressed: _isLoading ? null : _goBack,
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.commandBlue,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      border: Border.all(color: AppColors.softBorder),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F00236F),
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headline.copyWith(
                                color: AppColors.logisticsNavy,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Join your campus community to never miss an event.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMuted,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _FieldLabel('Full Name'),
                            TextFormField(
                              key: const Key('signUpDisplayNameField'),
                              controller: _displayNameController,
                              enabled: !_isLoading,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              decoration: const InputDecoration(
                                hintText: 'John Doe',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) =>
                                  _validateRequired(value, 'Full name'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _FieldLabel('University Email'),
                            TextFormField(
                              key: const Key('signUpEmailField'),
                              controller: _emailController,
                              enabled: !_isLoading,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                hintText: 'student@gmail.com',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _FieldLabel('Password'),
                            TextFormField(
                              key: const Key('signUpPasswordField'),
                              controller: _passwordController,
                              enabled: !_isLoading,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  _validateRequired(value, 'Password'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _FieldLabel('Confirm Password'),
                            TextFormField(
                              key: const Key('signUpConfirmPasswordField'),
                              controller: _confirmPasswordController,
                              enabled: !_isLoading,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              onFieldSubmitted: (_) =>
                                  _isLoading ? null : _submit(),
                              decoration: InputDecoration(
                                hintText: 'Confirm password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscureConfirmPassword
                                      ? 'Show confirm password'
                                      : 'Hide confirm password',
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword;
                                          });
                                        },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                            if (_submissionError != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              _SubmissionError(message: _submissionError!),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            FilledButton.icon(
                              key: const Key('createAccountButton'),
                              onPressed: _isLoading ? null : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.commandBlue,
                                disabledBackgroundColor: AppColors.commandBlue
                                    .withValues(alpha: 0.48),
                                foregroundColor: AppColors.cardWhite,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.button),
                                ),
                              ),
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: _isLoading
                                    ? const SizedBox(
                                        key: Key('signUpLoadingIndicator'),
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.25,
                                          color: AppColors.cardWhite,
                                        ),
                                      )
                                    : const Icon(Icons.arrow_forward, size: 18),
                              ),
                              label: const Text('Create Account'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Next, we will send a verification email so you can confirm your campus account.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.mutedOperationalInk,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: AppTextStyles.label,
                                ),
                                TextButton(
                                  key: const Key('signInLink'),
                                  onPressed: _isLoading
                                      ? null
                                      : () => Navigator.pushReplacementNamed(
                                            context,
                                            AppRoutes.login,
                                          ),
                                  child: const Text('Sign In'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: AppTextStyles.label),
    );
  }
}

class _SubmissionError extends StatelessWidget {
  const _SubmissionError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('signUpSubmissionError'),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.safetyOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.input),
        border: Border.all(color: AppColors.safetyOrange),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.criticalRed,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.label.copyWith(
                color: AppColors.criticalRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
