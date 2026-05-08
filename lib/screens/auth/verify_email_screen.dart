import 'package:flutter/material.dart';
import 'package:isango_app/core/theme/app_colors.dart';
import 'package:isango_app/core/theme/app_radii.dart';
import 'package:isango_app/core/theme/app_spacing.dart';
import 'package:isango_app/core/theme/app_text_styles.dart';

typedef ResendVerificationEmailHandler = Future<void> Function();

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
    this.onResendEmail,
  });

  final ResendVerificationEmailHandler? onResendEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mistBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
              return;
            }
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        title: const Text('Verify Email'),
      ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.paleSignalBlue,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(18),
                          child: const Icon(
                            Icons.mark_email_read_outlined,
                            color: AppColors.commandBlue,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Verification Pending',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          color: AppColors.logisticsNavy,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        "We've sent a verification link to your student email. Please check your inbox to activate your account.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mistBackground,
                          borderRadius: BorderRadius.circular(AppRadii.input),
                          border: Border.all(color: AppColors.softBorder),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.help_outline,
                                  color: AppColors.commandBlue,
                                  size: 20,
                                ),
                                SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'Why verify your email?',
                                    style: AppTextStyles.title,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Verification helps unlock trusted account capabilities like RSVPing to exclusive events and receiving priority notifications. Please note that event publishing is reserved for approved roles such as staff, club executives, and class representatives.',
                              style: AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                        key: const Key('resendVerificationButton'),
                        onPressed: onResendEmail == null
                            ? null
                            : () async {
                                await onResendEmail?.call();
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.commandBlue,
                          foregroundColor: AppColors.cardWhite,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.button),
                          ),
                        ),
                        child: const Text('Resend Verification Email'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        "Can't find the email? Check your spam folder or try resending in 2 minutes.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
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
