import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Intercepts mouse scroll wheel signals and animates the scroll position
/// smoothly with deceleration, providing a premium smooth scrolling experience
/// similar to modern web templates (e.g. Locomotive Scroll).
class SmoothScrollWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final double scrollSpeed;
  final int animationDuration;

  const SmoothScrollWrapper({
    super.key,
    required this.child,
    required this.controller,
    this.scrollSpeed = 160.0,
    this.animationDuration = 450,
  });

  @override
  State<SmoothScrollWrapper> createState() => _SmoothScrollWrapperState();
}

class _SmoothScrollWrapperState extends State<SmoothScrollWrapper> {
  double _scrollTarget = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize the scroll target based on current offset
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.hasClients) {
        _scrollTarget = widget.controller.offset;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          final double delta = pointerSignal.scrollDelta.dy;
          if (delta == 0) return;

          if (!widget.controller.hasClients) return;

          final maxScroll = widget.controller.position.maxScrollExtent;
          final currentOffset = widget.controller.offset;

          // If current offset diverged from target by too much (e.g. user dragged scrollbar),
          // sync the target back to the current offset.
          if ((_scrollTarget - currentOffset).abs() > 150) {
            _scrollTarget = currentOffset;
          }

          // Accumulate target offset with bounds checking
          _scrollTarget = (_scrollTarget + delta).clamp(0.0, maxScroll);

          // If user prefers reduced motion, jump directly without animation
          if (MediaQuery.of(context).disableAnimations) {
            widget.controller.jumpTo(_scrollTarget);
          } else {
            // Animate smoothly to target using a smooth cubic/deceleration curve
            widget.controller.animateTo(
              _scrollTarget,
              duration: Duration(milliseconds: widget.animationDuration),
              curve: Curves.easeOutCubic,
            );
          }
        }
      },
      child: ScrollConfiguration(
        behavior: const _PointerScrollBehavior(),
        child: widget.child,
      ),
    );
  }
}

/// Custom scroll behavior that enables drag-scrolling with mouse on web/desktop,
/// matching standard modern web navigation.
class _PointerScrollBehavior extends ScrollBehavior {
  const _PointerScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
