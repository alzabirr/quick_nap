import 'dart:math';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class AmbientBackground extends StatefulWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _stars = List.generate(35, (_) => _Star.random(_random));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgLight,
      child: Stack(
        children: [
          // Aurora gradient glow at top
          Positioned(
            top: -80,
            left: -40,
            right: -40,
            height: 350,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(
                        -0.3 + sin(t * 2 * pi) * 0.4,
                        -0.6 + cos(t * 2 * pi) * 0.15,
                      ),
                      radius: 1.2,
                      colors: [
                        primary.withValues(alpha: 0.08 + sin(t * pi) * 0.04),
                        const Color(0xFF2E5BFF).withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Second aurora layer (right side, offset phase)
          Positioned(
            top: -40,
            left: 0,
            right: -60,
            height: 280,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(
                        0.5 + cos(t * 2 * pi + 1.5) * 0.3,
                        -0.4 + sin(t * 2 * pi + 1.0) * 0.1,
                      ),
                      radius: 1.0,
                      colors: [
                        accent.withValues(alpha: 0.05 + cos(t * pi) * 0.03),
                        const Color(0xFF34D399).withValues(alpha: 0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating star particles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _StarfieldPainter(
                  stars: _stars,
                  time: _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Content
          widget.child,
        ],
      ),
    );
  }
}

class _Star {
  final double x; // 0-1 normalized position
  final double y;
  final double size;
  final double speed; // twinkle speed factor
  final double phase; // twinkle phase offset
  final double opacity;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.opacity,
  });

  factory _Star.random(Random r) {
    return _Star(
      x: r.nextDouble(),
      y: r.nextDouble(),
      size: 0.5 + r.nextDouble() * 2.0,
      speed: 0.5 + r.nextDouble() * 2.0,
      phase: r.nextDouble() * 2 * pi,
      opacity: 0.15 + r.nextDouble() * 0.5,
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double time;

  _StarfieldPainter({required this.stars, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = (sin(time * star.speed * 2 * pi + star.phase) + 1) / 2;
      final alpha = star.opacity * (0.3 + twinkle * 0.7);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.8);

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );

      // Bright core
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.8);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * 0.4,
        corePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}
