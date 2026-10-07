import 'package:flutter/material.dart';

import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';
import '../models/user_profile.dart';

class ClerkAuthModal extends StatefulWidget {
  final VoidCallback? onAuthSuccess;

  const ClerkAuthModal({super.key, this.onAuthSuccess});

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onAuthSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ClerkAuthModal(onAuthSuccess: onAuthSuccess),
    );
  }

  @override
  State<ClerkAuthModal> createState() => _ClerkAuthModalState();
}

class _ClerkAuthModalState extends State<ClerkAuthModal> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      SessionService.instance.loginAs(AppRole.user);
      setState(() => _isLoading = false);
      Navigator.pop(context);
      widget.onAuthSuccess?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Signed in with Google successfully via Clerk!'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  Future<void> _handleEmailSignIn() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      final role = email.toLowerCase().contains('admin')
          ? AppRole.admin
          : AppRole.user;
      SessionService.instance.loginAs(role);
      setState(() => _isLoading = false);
      Navigator.pop(context);
      widget.onAuthSuccess?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome! Authenticated with Clerk successfully ($email)',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: context.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Header with Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'CLERK AUTHENTICATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: context.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Sign in to Cocoloco',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Welcome back! Please sign in to continue your order',
            style: TextStyle(
              fontSize: 13.5,
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Continue with Google Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: context.colorScheme.outlineVariant,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.cardLg),
                ),
                backgroundColor: context.colorScheme.surface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoogleIcon(),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Divider with "or"
          Row(
            children: [
              Expanded(
                child: Divider(color: context.colorScheme.outlineVariant),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'or',
                  style: TextStyle(
                    color: context.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: context.colorScheme.outlineVariant),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Email input field
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email address',
              labelStyle: TextStyle(
                color: context.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              hintText: 'name@example.com',
              errorText: _errorMessage,
              filled: true,
              fillColor: context.colorScheme.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.xl),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.colorScheme.primary,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleEmailSignIn,
              child: _isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: context.colorScheme.onPrimary,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Quick Demo Shortcuts
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    SessionService.instance.loginAs(AppRole.user);
                    Navigator.pop(context);
                    widget.onAuthSuccess?.call();
                  },
                  icon: Icon(
                    Icons.flash_on_rounded,
                    size: 16,
                    color: context.colorScheme.primary,
                  ),
                  label: Text(
                    'Demo User',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: context.colorScheme.outlineVariant,
                ),
                TextButton.icon(
                  onPressed: () {
                    SessionService.instance.loginAs(AppRole.admin);
                    Navigator.pop(context);
                    widget.onAuthSuccess?.call();
                  },
                  icon: Icon(
                    Icons.shield_rounded,
                    size: 16,
                    color: context.colorScheme.error,
                  ),
                  label: Text(
                    'Demo Admin',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Secured by Clerk
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Secured by ',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.verified_user_rounded,
                size: 15,
                color: AppPalette.clerkPurple,
              ),
              const SizedBox(width: AppSpacing.xs),
              const Text(
                'clerk',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: AppPalette.clerkPurple,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }
}
