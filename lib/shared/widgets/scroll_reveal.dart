import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Reusable scroll reveal widget that triggers smooth viewport entry animations
/// every time the user scrolls into view (with re-entry replay support).
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;
  final bool replayOnReentry;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.delay = Duration.zero,
    this.slideOffset = 0.1,
    this.replayOnReentry = true,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _visible = false;
  int _renderKey = 0;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }

    final uniqueKey = Key('scroll_reveal_${identityHashCode(this)}');

    return VisibilityDetector(
      key: uniqueKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.12) {
          if (!_visible && mounted) {
            setState(() {
              _visible = true;
              _renderKey++;
            });
          }
        } else if (info.visibleFraction == 0.0 && widget.replayOnReentry) {
          if (_visible && mounted) {
            setState(() {
              _visible = false;
            });
          }
        }
      },
      child: _visible
          ? KeyedSubtree(
              key: ValueKey('reveal_anim_$_renderKey'),
              child: widget.child
                  .animate(delay: widget.delay)
                  .fadeIn(
                    duration: widget.duration,
                    curve: Curves.easeOutCubic,
                  )
                  .slideY(
                    begin: widget.slideOffset,
                    end: 0,
                    duration: widget.duration,
                    curve: const Cubic(0.16, 1.0, 0.3, 1.0),
                  ),
            )
          : Opacity(
              opacity: 0,
              child: widget.child,
            ),
    );
  }
}
