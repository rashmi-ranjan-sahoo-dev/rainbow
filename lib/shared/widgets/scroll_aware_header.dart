import 'package:flutter/material.dart';
import '../../core/utils/responsive_helper.dart';

/// Enum defining the distinct states of the dynamic header.
enum HeaderState {
  /// Screenshot 1: Floating pill/card header with margin over hero section.
  expanded,

  /// Screenshot 3: Attached edge-to-edge sticky header when scrolling upwards.
  compact,

  /// Screenshot 2: Completely hidden upwards when scrolling downwards.
  hidden,
}

/// A dedicated, high-performance scroll-aware header container.
///
/// Features:
/// - Isolated scroll listener: Does NOT trigger parent page rebuilds.
/// - Scroll direction detection: Hides on scroll down, reveals on scroll up.
/// - Smooth cinematic transitions: Slower, gentle easing curve (~460ms).
/// - Positioned cleanly over the hero banner without any extra white background gap.
class ScrollAwareHeader extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function(BuildContext context, HeaderState state) builder;
  final double topOffset;
  final double headerHeight;

  const ScrollAwareHeader({
    super.key,
    required this.scrollController,
    required this.builder,
    this.topOffset = 36.0,
    this.headerHeight = 74.0,
  });

  @override
  State<ScrollAwareHeader> createState() => _ScrollAwareHeaderState();
}

class _ScrollAwareHeaderState extends State<ScrollAwareHeader> {
  HeaderState _headerState = HeaderState.expanded;
  double _lastOffset = 0.0;
  double _scrollVelocityAccumulator = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    final offset = widget.scrollController.offset;
    final delta = offset - _lastOffset;

    // Accumulate scroll direction to prevent micro-jitter toggles
    _scrollVelocityAccumulator = (_scrollVelocityAccumulator + delta).clamp(-100.0, 100.0);

    HeaderState nextState;

    if (offset <= 20.0) {
      // ── Floating Header at Top / Hero ──
      nextState = HeaderState.expanded;
      _scrollVelocityAccumulator = 0;
    } else if (delta > 4.0 && offset > 80.0) {
      // ── Scrolling DOWN -> Smoothly glide upwards ──
      nextState = HeaderState.hidden;
    } else if (delta < -4.0 && offset > 25.0) {
      // ── Scrolling UP -> Show Attached Sticky Header ──
      nextState = HeaderState.compact;
    } else {
      nextState = _headerState;
    }

    if (nextState != _headerState) {
      setState(() {
        _headerState = nextState;
      });
    }

    _lastOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    // Dynamic top coordinate:
    // - Expanded (Top): Sits right below utility bar with margin
    // - Compact (Sticky): Pinned at 0.0 (attached to top edge)
    // - Hidden (Scroll Down): Slides gently above viewport
    double targetTop;
    double targetOpacity;

    switch (_headerState) {
      case HeaderState.expanded:
        targetTop = isMobile ? 8.0 : (widget.topOffset + 4.0);
        targetOpacity = 1.0;
        break;
      case HeaderState.compact:
        targetTop = 0.0;
        targetOpacity = 1.0;
        break;
      case HeaderState.hidden:
        targetTop = -widget.headerHeight - 50.0;
        targetOpacity = 0.0;
        break;
    }

    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 550);

    return AnimatedPositioned(
      duration: duration,
      curve: Curves.easeInOutCubic,
      top: targetTop,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: duration,
        curve: Curves.easeInOutCubic,
        opacity: targetOpacity,
        child: widget.builder(context, _headerState),
      ),
    );
  }
}
