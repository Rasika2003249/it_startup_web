import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'order_modal.dart';

/// Full-bleed Hero Section with Lottie fallback, custom rising steam particle animation,
/// staggered headline entrance, continuous floating dish with glowing shadow,
/// flying ingredient particles, and hover CTA buttons.
class HeroSection extends StatefulWidget {
  final VoidCallback onExploreTap;

  const HeroSection({
    super.key,
    required this.onExploreTap,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // Video Player Controller (Placeholder Video Support)
  VideoPlayerController? _videoController;
  bool _useVideoBackground = false; // Toggle to true when video asset is provided

  // Entrance Staggered Animation Controllers
  late AnimationController _entranceController;
  late Animation<double> _eyebrowFade;
  late Animation<Offset> _eyebrowSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtextFade;
  late Animation<Offset> _subtextSlide;
  late Animation<double> _buttonsFade;
  late Animation<Offset> _buttonsSlide;

  // Floating Hero Dish & Shadow Animation
  late AnimationController _floatingDishController;

  // Flying Ingredients Animations
  late AnimationController _ingredientsController;
  late Animation<Offset> _tomatoFly;
  late Animation<Offset> _basilFly;
  late Animation<Offset> _cheeseFly;
  late Animation<Offset> _chiliFly;

  // Steam Particle Rising Controller
  late AnimationController _steamController;

  bool _isPrimaryBtnHovered = false;
  bool _isSecondaryBtnHovered = false;

  @override
  void initState() {
    super.initState();

    // Initialize Placeholder Video Player
    _initVideoPlayer();

    // 1. Entrance Controller (Staggered Text Load)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _eyebrowFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _eyebrowSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_eyebrowFade);

    _titleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_titleFade);

    _subtextFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );
    _subtextSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_subtextFade);

    _buttonsFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_buttonsFade);

    // 2. Floating Dish Loop Animation
    _floatingDishController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // 3. Flying Ingredients Controller
    _ingredientsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _tomatoFly = Tween<Offset>(
      begin: const Offset(-1.5, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ingredientsController,
      curve: Curves.easeOutCubic,
    ));

    _basilFly = Tween<Offset>(
      begin: const Offset(1.5, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ingredientsController,
      curve: Curves.easeOutCubic,
    ));

    _cheeseFly = Tween<Offset>(
      begin: const Offset(-1.2, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ingredientsController,
      curve: Curves.easeOutCubic,
    ));

    _chiliFly = Tween<Offset>(
      begin: const Offset(1.4, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ingredientsController,
      curve: Curves.easeOutCubic,
    ));

    // 4. Steam Particle Loop Animation
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Start Entrance Animations
    _entranceController.forward();
    _ingredientsController.forward();
  }

  void _initVideoPlayer() {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/food_prep_hero.mp4')
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _useVideoBackground = true;
            });
            _videoController?.setLooping(true);
            _videoController?.setVolume(0.0);
            _videoController?.play();
          }
        }).catchError((_) {
          // Graceful fallback to Lottie / Graphic background
        });
    } catch (_) {}
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _entranceController.dispose();
    _floatingDishController.dispose();
    _ingredientsController.dispose();
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isMobile = width < 900;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: math.max(820, height * 0.95)),
      color: AppColors.bgCream,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Background Video OR Lottie Animation Fallback
          Positioned.fill(
            child: _useVideoBackground && (_videoController?.value.isInitialized ?? false)
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.width,
                      height: _videoController!.value.size.height,
                      child: VideoPlayer(_videoController!),
                    ),
                  )
                : Opacity(
                    opacity: 0.15,
                    child: Lottie.asset(
                      'assets/lottie/food_hero.json',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.heroGlowGradient,
                          ),
                        );
                      },
                    ),
                  ),
          ),

          // Overlay Warm Soft Tint for Readability
          Positioned.fill(
            child: Container(
              color: AppColors.bgCream.withValues(alpha: 0.88),
            ),
          ),

          // 2. Rising Steam Particle Canvas Animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _steamController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SteamParticlePainter(progress: _steamController.value),
                );
              },
            ),
          ),

          // 3. Main Hero Content Layout
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 80,
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column: Staggered Headline & CTAs
                Expanded(
                  flex: isMobile ? 0 : 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isMobile
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      // Eyebrow Tagline
                      SlideTransition(
                        position: _eyebrowSlide,
                        child: FadeTransition(
                          opacity: _eyebrowFade,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFlame.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.primaryFlame.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.secondaryGold,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'MICHELIN-CRAFTED CULINARY ATELIER',
                                  style: AppTextStyles.eyebrow(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Staggered Serif Headline
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: RichText(
                            textAlign: isMobile ? TextAlign.center : TextAlign.left,
                            text: TextSpan(
                              style: AppTextStyles.heroHeading(context),
                              children: [
                                const TextSpan(text: 'Artisanal Culinary '),
                                WidgetSpan(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        AppColors.primaryGradient.createShader(bounds),
                                    child: Text(
                                      'Mastery',
                                      style: AppTextStyles.heroHeading(context).copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' Freshly Delivered.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Subtext Description
                      SlideTransition(
                        position: _subtextSlide,
                        child: FadeTransition(
                          opacity: _subtextFade,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 580),
                            child: Text(
                              'Experience fine-dining culinary craftsmanship. Hand-kneaded 72-hr sourdough, organic farm produce, and white truffle glazes delivered to your door in thermal pods.',
                              textAlign: isMobile ? TextAlign.center : TextAlign.left,
                              style: AppTextStyles.leadBody(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // CTA Buttons with Hover Scale & Warm Glow
                      SlideTransition(
                        position: _buttonsSlide,
                        child: FadeTransition(
                          opacity: _buttonsFade,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: isMobile
                                ? WrapAlignment.center
                                : WrapAlignment.start,
                            children: [
                              // Primary Button (Order Now)
                              MouseRegion(
                                onEnter: (_) => setState(() => _isPrimaryBtnHovered = true),
                                onExit: (_) => setState(() => _isPrimaryBtnHovered = false),
                                child: AnimatedScale(
                                  scale: _isPrimaryBtnHovered ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: GestureDetector(
                                    onTap: () => OrderModal.show(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 34,
                                        vertical: 18,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryFlame.withValues(
                                              alpha: _isPrimaryBtnHovered ? 0.5 : 0.28,
                                            ),
                                            blurRadius: _isPrimaryBtnHovered ? 24 : 14,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Order Instant Feast',
                                            style: AppTextStyles.buttonLabel(context),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Secondary Button (Explore Menu)
                              MouseRegion(
                                onEnter: (_) => setState(() => _isSecondaryBtnHovered = true),
                                onExit: (_) => setState(() => _isSecondaryBtnHovered = false),
                                child: AnimatedScale(
                                  scale: _isSecondaryBtnHovered ? 1.05 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: GestureDetector(
                                    onTap: widget.onExploreTap,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 18,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.bgCard,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: _isSecondaryBtnHovered
                                              ? AppColors.primaryFlame
                                              : AppColors.borderLight,
                                          width: 1.5,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x0C000000),
                                            blurRadius: 12,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.restaurant_menu_rounded,
                                            color: AppColors.primaryFlame,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Explore Menu',
                                            style: AppTextStyles.buttonLabel(context).copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isMobile) const SizedBox(height: 50),

                // Right Column: Continuous Floating Hero Dish + Flying Ingredients
                Expanded(
                  flex: isMobile ? 0 : 5,
                  child: Center(
                    child: SizedBox(
                      width: isMobile ? 320 : 480,
                      height: isMobile ? 320 : 480,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Soft Glowing Warm Shadow beneath dish
                          AnimatedBuilder(
                            animation: _floatingDishController,
                            builder: (context, child) {
                              final val = _floatingDishController.value;
                              return Transform.scale(
                                scale: 0.9 + (val * 0.1),
                                child: Container(
                                  width: isMobile ? 220 : 320,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryFlame.withValues(
                                          alpha: 0.25 - (val * 0.08),
                                        ),
                                        blurRadius: 36,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // 2. Main Continuous Floating Hero Dish Graphic
                          AnimatedBuilder(
                            animation: _floatingDishController,
                            builder: (context, child) {
                              final floatOffset = math.sin(_floatingDishController.value * math.pi * 2) * 14;
                              final rotateAngle = math.sin(_floatingDishController.value * math.pi) * 0.04;

                              return Transform.translate(
                                offset: Offset(0, floatOffset),
                                child: Transform.rotate(
                                  angle: rotateAngle,
                                  child: Container(
                                    width: isMobile ? 280 : 420,
                                    height: isMobile ? 280 : 420,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const RadialGradient(
                                        colors: [
                                          Color(0xFFFFF5EA),
                                          AppColors.bgCard,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.12),
                                          blurRadius: 30,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_pizza_rounded,
                                            size: isMobile ? 140 : 210,
                                            color: AppColors.primaryFlame,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.forestGreen,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              '🍕 Truffle Burrata Sourdough',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // 3. Flying Ingredient Particles (Tomato, Basil, Cheese, Chili)
                          SlideTransition(
                            position: _tomatoFly,
                            child: const Align(
                              alignment: Alignment(-0.85, -0.85),
                              child: _IngredientChip(label: '🍅 Tomato', color: Colors.redAccent),
                            ),
                          ),
                          SlideTransition(
                            position: _basilFly,
                            child: const Align(
                              alignment: Alignment(0.85, -0.75),
                              child: _IngredientChip(label: '🌿 Fresh Basil', color: AppColors.forestGreen),
                            ),
                          ),
                          SlideTransition(
                            position: _cheeseFly,
                            child: const Align(
                              alignment: Alignment(-0.80, 0.85),
                              child: _IngredientChip(label: '🧀 Burrata', color: AppColors.secondaryGold),
                            ),
                          ),
                          SlideTransition(
                            position: _chiliFly,
                            child: const Align(
                              alignment: Alignment(0.85, 0.80),
                              child: _IngredientChip(label: '🌶️ Chili Crisp', color: AppColors.primaryFlame),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating ingredient pill widget
class _IngredientChip extends StatelessWidget {
  final String label;
  final Color color;

  const _IngredientChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// CustomPainter for rising subtle steam particles in the background
class SteamParticlePainter extends CustomPainter {
  final double progress;

  SteamParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final rand = math.Random(42);

    for (int i = 0; i < 15; i++) {
      final startX = (rand.nextDouble() * size.width);
      final speed = 0.5 + rand.nextDouble() * 0.5;
      final yPos = (size.height - ((progress * speed * size.height) % size.height));
      final radius = 10.0 + (rand.nextDouble() * 20.0);
      final opacity = ((1.0 - (yPos / size.height)) * 0.4).clamp(0.0, 0.4);

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(startX, yPos), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SteamParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
