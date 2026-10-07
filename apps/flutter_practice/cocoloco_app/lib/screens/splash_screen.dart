import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens/app_primitives.dart';
import '../core/theme/tokens/app_semantics.dart';
import '../data/providers/products_provider.dart';
import 'main_navigation_screen.dart';

/// A modern, luxurious, animated Splash Screen for Cocoloco Mobile App.
/// Features choreographed elastic logo scale, golden glow breathing pulse,
/// staggered typography slide-ins, and background catalog pre-warming.
class SplashScreen extends ConsumerStatefulWidget {
  final Duration duration;
  final Widget? targetScreen;

  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 2300),
    this.targetScreen,
  });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _loaderOpacity;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 1. Logo animations (0% - 65%)
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    // 2. Brand Name "COCOLOCO" stagger (30% - 75%)
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.75, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Subtitle / Tagline stagger (55% - 90%)
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.90, curve: Curves.easeOut),
      ),
    );

    // 4. Subtle loader indicator at footer (75% - 100%)
    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Kick off background catalog preloading to minimize home screen latency
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadProducts();
      _scheduleNavigation();
    });
  }

  void _scheduleNavigation() {
    _navigationTimer = Timer(widget.duration, () {
      if (!mounted) return;
      final destination = widget.targetScreen ?? const MainNavigationScreen();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (_, animation, secondaryAnimation) => destination,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Luxurious Deep Roasted Ambient Gradient Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [
                    Color(0xFF4A141D), // Warm roasted inner amber-burgundy
                    AppPalette.burgundy900,
                    AppPalette.espresso900, // Deep dark roast edge
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // 2. Center Brand Presentation
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // A. Animated App Icon with Amber Halo Glow
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.amberOrange.withValues(alpha: 0.25),
                                blurRadius: 40,
                                spreadRadius: 4,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.asset(
                              'assets/images/cocoloco_app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppPalette.burgundy800,
                                child: const Icon(
                                  Icons.coffee_rounded,
                                  size: 64,
                                  color: AppPalette.honeyAmber,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // B. Brand Title with Slide & Fade Transition
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: Text(
                          'COCOLOCO',
                          style: TextStyle(
                            fontFamily: AppSemanticTypography.fontFamily,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4.5,
                            color: AppPalette.cream50,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // C. Elegant Tagline & Decorative Accents
                    FadeTransition(
                      opacity: _taglineOpacity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 1,
                            color: AppPalette.honeyAmber.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'ARTISANAL COFFEE & BAKERY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.2,
                              color: AppPalette.cream200,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 24,
                            height: 1,
                            color: AppPalette.honeyAmber.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3. Bottom Minimal Progress & Edition Footnote
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _loaderOpacity,
              child: Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppPalette.honeyAmber.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Crafted with Passion • AgilityIO',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.8,
                      color: AppPalette.cream200.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
