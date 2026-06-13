import 'package:flutter/material.dart';
import 'dart:ui';
import '../themes/app_theme.dart';

/// Premium glassmorphic card with inner glow, refined border, and optional press animation.
Widget glassCard({
  required Widget child,
  double opacity = 0.15,
  EdgeInsets? padding,
  BorderRadius? borderRadius,
  bool interactive = false,
  VoidCallback? onTap,
}) {
  final radius = borderRadius ?? BorderRadius.circular(cardRadius);

  Widget card = ClipRRect(
    borderRadius: radius,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          // Layered gradient for depth
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: opacity * 0.6),
              Colors.white.withValues(alpha: opacity * 0.15),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1.0,
          ),
          boxShadow: [
            // Outer subtle shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            // Inner glow effect (top-left highlight)
            BoxShadow(
              color: primary.withValues(alpha: 0.03),
              blurRadius: 20,
              spreadRadius: -2,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle top shine
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: radius.topLeft,
                    topRight: radius.topRight,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            padding != null
                ? Padding(padding: padding, child: child)
                : child,
          ],
        ),
      ),
    ),
  );

  if (interactive || onTap != null) {
    return _PressableCard(onTap: onTap, child: card);
  }

  return card;
}

/// Adds a subtle scale-down press animation to cards.
class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PressableCard({required this.child, this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
