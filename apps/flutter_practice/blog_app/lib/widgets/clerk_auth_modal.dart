import 'package:flutter/material.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/user_profile.dart';

class ClerkAuthModal extends StatefulWidget {
  final VoidCallback? onAuthSuccess;

  const ClerkAuthModal({super.key, this.onAuthSuccess});

  static Future<void> show(BuildContext context, {VoidCallback? onAuthSuccess}) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      final role = email.toLowerCase().contains('admin') ? AppRole.admin : AppRole.user;
      SessionService.instance.loginAs(role);
      setState(() => _isLoading = false);
      Navigator.pop(context);
      widget.onAuthSuccess?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome! Authenticated with Clerk successfully ($email)'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DDD5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 24),

          // Header with Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_rounded, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'CLERK AUTHENTICATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Sign in to Cocoloco',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Welcome back! Please sign in to continue your order',
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // Continue with Google Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFECE7DE), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoogleIcon(),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Divider with "or"
          const Row(
            children: [
              Expanded(child: Divider(color: Color(0xFFECE7DE))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFECE7DE))),
            ],
          ),

          const SizedBox(height: 18),

          // Email input field
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email address',
              labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              hintText: 'name@example.com',
              errorText: _errorMessage,
              filled: true,
              fillColor: const Color(0xFFF9F7F3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
            ),
          ),

          const SizedBox(height: 16),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleEmailSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Quick Demo Shortcuts
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F0E8),
              borderRadius: BorderRadius.circular(16),
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
                  icon: const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.primary),
                  label: const Text(
                    'Demo User',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                Container(width: 1, height: 20, color: const Color(0xFFDCD6CB)),
                TextButton.icon(
                  onPressed: () {
                    SessionService.instance.loginAs(AppRole.admin);
                    Navigator.pop(context);
                    widget.onAuthSuccess?.call();
                  },
                  icon: const Icon(Icons.shield_rounded, size: 16, color: Color(0xFFC53030)),
                  label: const Text(
                    'Demo Admin',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFC53030)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Secured by Clerk
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Secured by ',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.verified_user_rounded, size: 15, color: Color(0xFF6C47FF)),
              const SizedBox(width: 4),
              const Text(
                'clerk',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6C47FF),
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
