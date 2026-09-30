import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            topPadding + 20,
            24,
            bottomInset > 0 ? bottomInset + 10 : 24,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Large Circular Hero Image (Barista Latte Art Pour) - Exact Figma Spec
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
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

              // Title: "Ordered!" (Font: Chap, Weight: 900, Color: #5B1921)
              const Text(
                'Ordered!',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle: "Everything will be ready in 3 minutes."
              const Text(
                'Everything will be ready in 3 minutes.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A443E),
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
                    // Smoothly pop back to the root browse screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Okay, got it!',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
