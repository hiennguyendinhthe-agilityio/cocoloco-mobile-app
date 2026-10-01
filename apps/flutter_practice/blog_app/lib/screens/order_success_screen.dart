import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  final VoidCallback? onDone;

  const OrderSuccessScreen({
    super.key,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            topPadding + AppSpacing.lg,
            AppSpacing.xxl,
            bottomInset > 0 ? bottomInset + AppSpacing.sm : AppSpacing.xxl,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Large Circular Hero Image
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.hero,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/latte_art_pour.jpg',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              const SizedBox(height: 38),

              // Title: "Ordered!"
              Text(
                context.l10n.orderedTitle,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: context.colorScheme.primary,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtitle: "Everything will be ready in 3 minutes."
              Text(
                context.l10n.orderedSubtitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 4),

              // Bottom Button: "Okay, got it!"
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    onDone?.call();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    context.l10n.okayGotIt,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
