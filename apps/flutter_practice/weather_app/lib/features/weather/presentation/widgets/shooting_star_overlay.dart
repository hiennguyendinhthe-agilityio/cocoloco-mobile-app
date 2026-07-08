import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShootingStarOverlay extends StatefulWidget {
  const ShootingStarOverlay({super.key});

  @override
  State<ShootingStarOverlay> createState() => _ShootingStarOverlayState();
}

class _ShootingStarOverlayState extends State<ShootingStarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  // Star properties
  double _startX = 0;
  double _startY = 0;
  double _angle = pi / 4; // Default 45 degrees
  double _length = 100;
  double _speed = 1.0;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = false;
        });
        _scheduleNextStar();
      }
    });

    _scheduleNextStar(isFirst: true);
  }

  void _scheduleNextStar({bool isFirst = false}) {
    // Wait between 2 and 8 seconds before showing the next star
    // If it's the first star, show it quickly (e.g., within 1 second)
    final delayMs = isFirst ? 500 : 2000 + _random.nextInt(6000);
    final delay = Duration(milliseconds: delayMs);
    Future.delayed(delay, () {
      if (mounted) {
        _startStarAnimation();
      }
    });
  }

  void _startStarAnimation() {
    // Randomize properties for the new star
    final size = MediaQuery.of(context).size;

    // Start somewhere in the top or right half
    _startX = _random.nextDouble() * size.width;
    _startY = _random.nextDouble() * (size.height * 0.3); // Top 30% of screen

    // Angle between 30 and 60 degrees (falling down-left)
    _angle = (pi / 6) + _random.nextDouble() * (pi / 6);

    _length = 50 + _random.nextDouble() * 100; // Length between 50 and 150
    _speed = 1.0 + _random.nextDouble() * 1.5; // Speed multiplier

    _controller.duration = Duration(milliseconds: (1500 / _speed).round());

    setState(() {
      _isVisible = true;
    });

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ShootingStarPainter(
            progress: _controller.value,
            startX: _startX,
            startY: _startY,
            angle: _angle,
            length: _length,
          ),
        );
      },
    );
  }
}

class _ShootingStarPainter extends CustomPainter {
  final double progress;
  final double startX;
  final double startY;
  final double angle;
  final double length;

  _ShootingStarPainter({
    required this.progress,
    required this.startX,
    required this.startY,
    required this.angle,
    required this.length,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate current position based on progress and angle
    final distance = progress * size.height; // Fall across the screen height
    final currentX = startX - distance * sin(angle);
    final currentY = startY + distance * cos(angle);

    // Fade out as it progresses
    final opacity = progress < 0.2
        ? progress *
              5 // Fade in quickly (0 to 0.2)
        : (1.0 - progress) * 1.25; // Fade out (0.2 to 1.0)

    final clampedOpacity = opacity.clamp(0.0, 1.0);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Tail of the star
    final tailX = currentX + length * sin(angle);
    final tailY = currentY - length * cos(angle);

    // Create a gradient for the tail (bright head, fading tail)
    paint.shader = ui.Gradient.linear(
      Offset(currentX, currentY),
      Offset(tailX, tailY),
      [
        Colors.white.withValues(alpha: clampedOpacity),
        Colors.white.withValues(alpha: clampedOpacity * 0.5),
        Colors.transparent,
      ],
      [0.0, 0.2, 1.0],
    );

    // Draw the star line
    canvas.drawLine(Offset(currentX, currentY), Offset(tailX, tailY), paint);

    // Optional: Draw a small glow at the head
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: clampedOpacity * 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    canvas.drawCircle(Offset(currentX, currentY), 1.5, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _ShootingStarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.startX != startX ||
        oldDelegate.startY != startY ||
        oldDelegate.angle != angle ||
        oldDelegate.length != length;
  }
}
