import 'package:flutter/material.dart';

/// A robust viewport-aware ScrollReveal widget that detects when a child enters
/// the visible screen area during scrolling and triggers a staggered entrance
/// animation (Fade + Slide + Scale).
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;

  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.delay = Duration.zero,
    this.slideOffset = 40.0,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isVisible = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.slideOffset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollListener();
  }

  void _attachScrollListener() {
    try {
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable != null) {
        final position = scrollable.position;
        if (_scrollPosition != position) {
          _scrollPosition?.removeListener(_onScrollUpdate);
          _scrollPosition = position;
          _scrollPosition?.addListener(_onScrollUpdate);
        }
      }
    } catch (_) {}

    // Check visibility after initial layout frame load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _onScrollUpdate() {
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted || _isVisible) return;

    try {
      final renderObject = context.findRenderObject() as RenderBox?;
      if (renderObject == null || !renderObject.attached || !renderObject.hasSize) {
        return;
      }

      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      // Trigger reveal when top of widget enters 90% of viewport height
      if (position.dy < screenHeight * 0.90 &&
          position.dy + renderObject.size.height > 0) {
        _isVisible = true;
        _scrollPosition?.removeListener(_onScrollUpdate);

        if (widget.delay == Duration.zero) {
          if (mounted) _controller.forward();
        } else {
          Future.delayed(widget.delay, () {
            if (mounted) _controller.forward();
          });
        }
      }
    } catch (_) {
      if (mounted && !_isVisible) {
        _isVisible = true;
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScrollUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
