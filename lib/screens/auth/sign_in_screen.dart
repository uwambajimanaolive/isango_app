import 'package:flutter/material.dart';
import 'package:isango_app/core/constants/app_routes.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

typedef SignInHandler = Future<void> Function(String email, String password);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.onSignIn, this.initiallyLoading = false});

  final SignInHandler? onSignIn;
  final bool initiallyLoading;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _submissionError;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.initiallyLoading;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid university email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Please enter your password';
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
      final handler = widget.onSignIn;
      if (handler != null) {
        await handler(_emailController.text.trim(), _passwordController.text);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _submissionError =
            'We could not sign you in. Check your details and try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              child: DecoratedBox(
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Isango',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline.copyWith(
                            color: AppColors.logisticsNavy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Welcome back!',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Sign in to access your personalized campus events feed.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMuted,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Signing in gives you access to your saved events, RSVPs, and reminders.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.label,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Email Address', style: AppTextStyles.label),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          key: const Key('signInEmailField'),
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: 'student@gmail.com',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Text('Password', style: AppTextStyles.label),
                            const Spacer(),
                            TextButton(
                              key: const Key('forgotPasswordLink'),
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.resetPassword,
                                    ),
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        TextFormField(
                          key: const Key('signInPasswordField'),
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) =>
                              _isLoading ? null : _submit(),
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
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        if (_submissionError != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _SubmissionError(message: _submissionError!),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          key: const Key('signInButton'),
                          onPressed: _isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.logisticsNavy,
                            disabledBackgroundColor: AppColors.commandBlue
                                .withValues(alpha: 0.48),
                            foregroundColor: AppColors.cardWhite,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadii.button,
                              ),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            child: _isLoading
                                ? const SizedBox(
                                    key: Key('signInLoadingIndicator'),
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.cardWhite,
                                    ),
                                  )
                                : const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: AppTextStyles.label,
                            ),
                            TextButton(
                              key: const Key('signUpLink'),
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.signUp,
                                    ),
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmissionError extends StatelessWidget {
  const _SubmissionError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('signInSubmissionError'),
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
