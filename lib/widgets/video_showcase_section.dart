import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'cart_drawer.dart';
import 'order_modal.dart';

enum ShowcaseLayout {
  fullBackground,
  videoLeft,
  videoRight,
}

/// A flagship 100% responsive viewport-aware video showcase section.
/// Plays video automatically when in viewport, features multi-candidate asset loading,
/// muted autoplay by default, looping, unobtrusive non-overlapping mute/unmute icon,
/// and smooth responsive layouts across Mobile (<600px), Tablet (600-1100px), and Desktop (>1100px).
class VideoShowcaseSection extends StatefulWidget {
  final String videoAssetPath;
  final String category;
  final String title;
  final String description;
  final String price;
  final double priceRaw;
  final IconData icon;
  final ShowcaseLayout layoutStyle;
  final bool isFirstSection;

  const VideoShowcaseSection({
    super.key,
    required this.videoAssetPath,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.priceRaw,
    required this.icon,
    required this.layoutStyle,
    this.isFirstSection = false,
  });

  @override
  State<VideoShowcaseSection> createState() => _VideoShowcaseSectionState();
}

class _VideoShowcaseSectionState extends State<VideoShowcaseSection> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isMuted = true;
  bool _isPlaying = true;
  bool _isInViewport = true;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    final candidatePaths = <String>[];

    if (widget.title.contains('Pizza')) {
      candidatePaths.addAll([
        'hero/3752508-hd_1920_1080_24fps.mp4',
        'assets/videos/hero/3752508-hd_1920_1080_24fps.mp4',
        'assets/videos/hero/pizza.mp4',
        widget.videoAssetPath,
      ]);
    } else if (widget.title.contains('Burger')) {
      candidatePaths.addAll([
        'hero/8879537-uhd_4096_2160_25fps.mp4',
        'assets/videos/hero/8879537-uhd_4096_2160_25fps.mp4',
        'hero/13723467_1920_1080_25fps.mp4',
        'assets/videos/hero/avocado_truffle_burger.mp4',
        'assets/videos/hero/burger.mp4',
        widget.videoAssetPath,
      ]);
    } else if (widget.title.contains('Sandwich')) {
      candidatePaths.addAll([
        'hero/12220110_1080_1920_30fps.mp4',
        'assets/videos/hero/12220110_1080_1920_30fps.mp4',
        'assets/videos/hero/sandwich.mp4',
        widget.videoAssetPath,
      ]);
    } else if (widget.title.contains('Dessert') || widget.title.contains('Donut')) {
      candidatePaths.addAll([
        'hero/19999346-hd_1920_1080_30fps.mp4',
        'assets/videos/hero/19999346-hd_1920_1080_30fps.mp4',
        'assets/videos/hero/matcha_pistachio_donut.mp4',
        'assets/videos/hero/dessert.mp4',
        widget.videoAssetPath,
      ]);
    } else {
      candidatePaths.add(widget.videoAssetPath);
    }

    _tryNextCandidate(candidatePaths, 0);
  }

  void _tryNextCandidate(List<String> candidates, int index) {
    if (index >= candidates.length || !mounted) return;
    final path = candidates[index];

    _controller?.dispose();
    _controller = VideoPlayerController.asset(path)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _isPlaying = true;
          });
          _controller?.setLooping(true);
          _controller?.setVolume(0.0); // Muted by default for web autoplay compatibility
          _controller?.play(); // Start playback immediately so video frame renders instantly!
        }
      }).catchError((e) {
        // Try next candidate path seamlessly
        _tryNextCandidate(candidates, index + 1);
      });
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
          _scrollPosition?.removeListener(_checkViewportVisibility);
          _scrollPosition = position;
          _scrollPosition?.addListener(_checkViewportVisibility);
        }
      }
    } catch (_) {}

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkViewportVisibility();
    });
  }

  void _checkViewportVisibility() {
    if (!mounted || _controller == null || !_isInitialized) return;

    try {
      final renderObject = context.findRenderObject() as RenderBox?;
      if (renderObject == null || !renderObject.attached || !renderObject.hasSize) {
        return;
      }

      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      final sectionHeight = renderObject.size.height;

      final inView = position.dy < (screenHeight * 0.90) && (position.dy + sectionHeight) > (screenHeight * 0.10);

      if (inView != _isInViewport) {
        _isInViewport = inView;
        if (inView) {
          if (_isPlaying) _controller?.play();
        } else {
          _controller?.pause();
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkViewportVisibility);
    _controller?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      if (_isPlaying) {
        _controller?.pause();
        _isPlaying = false;
      } else {
        _controller?.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isCompact = width < 1050; // Responsive threshold for mobile & tablet
    final isSmallMobile = width < 600;

    final double sectionHeight = isSmallMobile
        ? height * 0.85
        : (isCompact ? height * 0.88 : height * 0.92);

    return Container(
      width: double.infinity,
      height: widget.layoutStyle == ShowcaseLayout.fullBackground ? sectionHeight : (isCompact ? null : sectionHeight),
      constraints: isCompact && widget.layoutStyle != ShowcaseLayout.fullBackground
          ? BoxConstraints(minHeight: height * 0.85)
          : null,
      color: AppColors.bgDarkCharcoal,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Render Layout according to ShowcaseLayout and screen size
          if (widget.layoutStyle == ShowcaseLayout.fullBackground || isSmallMobile)
            _buildFullBackgroundLayout(context, width)
          else if (widget.layoutStyle == ShowcaseLayout.videoLeft)
            _buildResponsiveSplitLayout(context, isVideoOnLeft: true, width: width)
          else
            _buildResponsiveSplitLayout(context, isVideoOnLeft: false, width: width),

          // Unobtrusive Mute / Unmute Button (Positioned SAFELY below the 80px Navbar!)
          Positioned(
            top: 92, // Safely below 80px Navbar to prevent ANY collision with cart button!
            right: width < 600 ? 16 : 40,
            child: GestureDetector(
              onTap: _toggleMute,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white30, width: 1),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 12),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      color: _isMuted ? Colors.white70 : AppColors.secondaryGold,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isMuted ? 'Muted' : 'Sound On',
                      style: TextStyle(
                        color: _isMuted ? Colors.white70 : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Layout 1: Full-Screen Background Video with Centered Responsive Typography
  Widget _buildFullBackgroundLayout(BuildContext context, double width) {
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1050;

    return Stack(
      children: [
        // Video Stream or Fallback Card
        Positioned.fill(
          child: _isInitialized && _controller != null
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : _buildFallbackCard(context),
        ),

        // Dark Gradient Overlay for Readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.80),
                  Colors.black.withValues(alpha: 0.50),
                  Colors.black.withValues(alpha: 0.80),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Centered Content with Responsive Spacing
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : (isTablet ? 40 : 80)),
            child: ScrollReveal(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFlame.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.primaryFlame),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.icon, color: AppColors.secondaryGold, size: isMobile ? 14 : 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.category,
                            style: AppTextStyles.eyebrow(context).copyWith(
                              color: Colors.white,
                              fontSize: isMobile ? 10 : 12,
                              letterSpacing: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 20),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heroHeading(context).copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : (isTablet ? 42 : 58),
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: isMobile ? 10 : 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 650),
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.leadBody(context).copyWith(
                        color: Colors.white70,
                        fontSize: isMobile ? 13 : 16,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),

                  // Actions with Wrap for Responsiveness
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 12,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryFlame,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 22 : 32,
                            vertical: isMobile ? 12 : 16,
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          CartManager.addItem(widget.title, widget.priceRaw, widget.icon);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added "${widget.title}" to cart! 🛒'),
                              backgroundColor: AppColors.textPrimary,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'Add to Cart (${widget.price})',
                          style: AppTextStyles.buttonLabel(context).copyWith(
                            color: Colors.white,
                            fontSize: isMobile ? 13 : 15,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 26,
                            vertical: isMobile ? 12 : 16,
                          ),
                        ),
                        onPressed: () => OrderModal.show(context, initialDish: widget.title),
                        child: Text(
                          'Order Instant',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 13 : 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Layout 2 & 3: 100% Responsive Split Layout (Side-by-side on Desktop, Vertical Stack on Tablet & Mobile)
  Widget _buildResponsiveSplitLayout(BuildContext context, {required bool isVideoOnLeft, required double width}) {
    final isDesktop = width >= 1050;
    final isMobile = width < 600;

    final videoContent = GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        height: isDesktop ? double.infinity : (isMobile ? 250 : 340),
        margin: EdgeInsets.all(isDesktop ? 32 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryFlame.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_isInitialized && _controller != null)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                )
              else
                _buildFallbackCard(context),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              if (!_isPlaying)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    final textContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 50 : 24,
        vertical: isDesktop ? 0 : 20,
      ),
      child: ScrollReveal(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryFlame.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: AppColors.secondaryGold, size: isMobile ? 14 : 16),
                  const SizedBox(width: 8),
                  Text(
                    widget.category,
                    style: AppTextStyles.eyebrow(context).copyWith(
                      color: AppColors.primaryFlame,
                      fontSize: isMobile ? 10 : 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              style: AppTextStyles.heroHeading(context).copyWith(
                color: Colors.white,
                fontSize: isMobile ? 26 : (isDesktop ? 44 : 34),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              style: AppTextStyles.leadBody(context).copyWith(
                color: AppColors.textMuted,
                fontSize: isMobile ? 13 : 15,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              spacing: 14,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFlame,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32,
                      vertical: isMobile ? 14 : 18,
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    CartManager.addItem(widget.title, widget.priceRaw, widget.icon);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added "${widget.title}" to cart! 🛒'),
                        backgroundColor: AppColors.textPrimary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    'Add to Cart (${widget.price})',
                    style: AppTextStyles.buttonLabel(context).copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: const BorderSide(color: AppColors.secondaryGold, width: 1.5),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 26,
                      vertical: isMobile ? 14 : 18,
                    ),
                  ),
                  onPressed: () => OrderModal.show(context, initialDish: widget.title),
                  child: Text(
                    'Order Instant',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return Row(
        children: isVideoOnLeft
            ? [Expanded(flex: 6, child: videoContent), Expanded(flex: 5, child: textContent)]
            : [Expanded(flex: 5, child: textContent), Expanded(flex: 6, child: videoContent)],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80), // Padding below navbar
          videoContent,
          textContent,
          SizedBox(height: 20),
        ],
      );
    }
  }

  Widget _buildFallbackCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF261D17), Color(0xFF1A1410)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryFlame.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: 48, color: AppColors.primaryFlame),
            ),
            const SizedBox(height: 14),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(color: AppColors.primaryFlame, strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
