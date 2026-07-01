import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

/// A card widget styled with the NES container look.
/// Replaces the old glassmorphism card with a pixel-art NesContainer.
Widget glassCard({
  required Widget child,
  EdgeInsets? padding,
  BorderRadius? borderRadius,
}) {
  return _NesCard(
    padding: padding,
    child: child,
  );
}

class _NesCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _NesCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return NesContainer(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}
