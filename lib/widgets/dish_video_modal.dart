import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'cart_drawer.dart';
import 'order_modal.dart';

/// Modal dialog providing a simulated 4K HD chef preparation video
/// for the chosen menu dish with animated timeline stages and instant order C
class DishVideoModal extends StatefulWidget { 
  final Map<String, dynamic> dish;

  const DishVideoModal({super.key, required this.dish});

  static void show(BuildContext context, Map<String, dynamic> dish) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => DishVideoModal(dish: dish),
    );
  }

  @override
  State<DishVideoModal> createState() => _DishVideoModalState();
}

class _DishVideoModalState extends State<DishVideoModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isMuted = true;
  int _currentStep = 0;
  bool _isPlaying = true;
  Timer? _stepTimer;

  late List<Map<String, String>> _cookingSteps;

  @override
  void initState() {
    super.initState();
    final title = widget.dish['title'] as String;
    final videoPath = widget.dish['videoAssetPath'] as String? ?? 'assets/videos/hero/pizza.mp4';

    // Initialize Video Player
    _initVideo(videoPath);

    // Generate dish-specific live video cooking steps
    if (title.contains('Pizza')) {
      _cookingSteps = [
        {'title': '1. 72-Hr Sourdough Kneading', 'desc': 'Master chef hand-stretches 72-hour fermented organic sourdough.'},
        {'title': '2. San Marzano Sauce Spread', 'desc': 'Spreading sun-ripened DOP San Marzano tomato reduction with fresh basil.'},
        {'title': '3. Burrata & Mushroom Plating', 'desc': 'Arranging creamy Puglia burrata cheese and wild chanterelle mushrooms.'},
        {'title': '4. 900°F Wood-Fired Oven Bake', 'desc': 'Baking in a traditional stone oven for 90 seconds until crust blisters.'},
        {'title': '5. White Truffle Drizzle & Serve', 'desc': 'Finished with cold-pressed Italian white truffle oil and fresh oregano.'},
      ];
    } else if (title.contains('Burger')) {
      _cookingSteps = [
        {'title': '1. Gourmet Patty Sear', 'desc': 'Double smash patty seared on 500°F cast iron grill.'},
        {'title': '2. Melt Sharp Cheddar', 'desc': 'Covered with dome to melt sharp cheddar cheese.'},
        {'title': '3. Sliced Avocado Layering', 'desc': 'Layering freshly sliced organic Hass avocado and crispy lettuce.'},
        {'title': '4. Truffle Mayo & Oat Bun', 'desc': 'Spreading house-made truffle mayo on toasted oat brioche bun.'},
        {'title': '5. Thermal Express Pod Seal', 'desc': 'Sealed inside induction pod to lock in 165°F sizzle.'},
      ];
    } else if (title.contains('Sandwich') || title.contains('Tacos')) {
      _cookingSteps = [
        {'title': '1. Artisan Bread Toasting', 'desc': 'Char-grilling organic sourdough focaccia with rosemary and garlic oil.'},
        {'title': '2. Tandoori Paneer Filling', 'desc': 'Layering tandoori-marinated organic paneer and roasted bell peppers.'},
        {'title': '3. Mint Chutney Spread', 'desc': 'Spreading stone-ground mint-coriander chutney and fresh microgreens.'},
        {'title': '4. Grilled Mozzarella Melt', 'desc': 'Melting creamy mozzarella cheese between toasted focaccia slices.'},
        {'title': '5. Thermal Express Pod Seal', 'desc': 'Packed in temperature-controlled transport pod for 15-min delivery.'},
      ];
    } else {
      _cookingSteps = [
        {'title': '1. Organic Ingredient Selection', 'desc': 'Selecting 100% organic, non-GMO produce fresh from partner farms.'},
        {'title': '2. Master Chef Precision Prep', 'desc': 'Precision cutting, roasting, and seasoning with organic herbs.'},
        {'title': '3. Ceremonial Glaze Infusion', 'desc': 'Dipping in organic ceremonial matcha glaze and crushing Sicilian pistachios.'},
        {'title': '4. Culinary Presentation', 'desc': 'Artistically plating with edible flowers and organic cocoa nibs.'},
        {'title': '5. Thermal Lock Pod Packaging', 'desc': 'Sealed in temperature-controlled transport pods for 15-min delivery.'},
      ];
    }

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _stepTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _isPlaying) {
        setState(() {
          _currentStep = (_currentStep + 1) % _cookingSteps.length;
        });
      }
    });
  }

  void _initVideo(String videoAssetPath) {
    try {
      _videoController = VideoPlayerController.asset(videoAssetPath)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
            _videoController?.setLooping(true);
            _videoController?.setVolume(0.0); // Muted by default
            _videoController?.play();
          }
        }).catchError((_) {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _progressController.dispose();
    _stepTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _videoController?.play();
        _progressController.repeat(reverse: false);
      } else {
        _videoController?.pause();
        _progressController.stop();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650;
    final d = widget.dish;
    final title = d['title'] as String;
    final price = d['price'] as String;
    final priceRaw = d['priceRaw'] as double;
    final prepTime = d['prepTime'] as String;
    final calories = d['calories'] as String;
    final icon = d['icon'] as IconData;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 12 : 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.glassBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryFlame.withValues(alpha: 0.3),
                  blurRadius: 36,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Viewport Screen
                  Container(
                    height: isMobile ? 260 : 340,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Real Embedded Video Stream OR Animated Fallback Graphic
                        if (_isVideoInitialized && _videoController != null)
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                          )
                        else
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primaryFlame.withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    radius: 0.8 + (_progressController.value * 0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(icon, size: 72, color: Colors.white),
                                ),
                              );
                            },
                          ),

                        // Top Badges
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFlame,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              '🟢 100% ARTISANAL HD STREAM',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        // Bottom Player Overlay Bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            color: Colors.black.withValues(alpha: 0.75),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                                        color: AppColors.primaryFlame,
                                        size: 32,
                                      ),
                                      onPressed: _togglePlay,
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: Icon(
                                        _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                        color: _isMuted ? Colors.white70 : AppColors.secondaryGold,
                                        size: 24,
                                      ),
                                      onPressed: _toggleMute,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _cookingSteps[_currentStep]['title']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            _cookingSteps[_currentStep]['desc']!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (context, child) {
                                    return LinearProgressIndicator(
                                      value: _progressController.value,
                                      backgroundColor: Colors.white24,
                                      color: AppColors.primaryFlame,
                                      minHeight: 4,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dish Details & Order Options
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: AppTextStyles.cardTitle(context).copyWith(fontSize: 22),
                              ),
                            ),
                            Text(
                              price,
                              style: AppTextStyles.heroHeading(context).copyWith(
                                fontSize: 24,
                                color: AppColors.primaryFlame,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: AppColors.secondaryGold, size: 16),
                            const SizedBox(width: 4),
                            Text('Prep: $prepTime', style: AppTextStyles.body(context).copyWith(fontSize: 13)),
                            const SizedBox(width: 16),
                            const Icon(Icons.local_fire_department_outlined, color: AppColors.primaryFlame, size: 16),
                            const SizedBox(width: 4),
                            Text(calories, style: AppTextStyles.body(context).copyWith(fontSize: 13)),
                            const SizedBox(width: 16),
                            const Icon(Icons.star_rounded, color: AppColors.secondaryGold, size: 16),
                            const SizedBox(width: 4),
                            Text('4.9 Michelin Rating', style: AppTextStyles.body(context).copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Timeline Step Indicators
                        Text(
                          'Master Chef Preparation Steps:',
                          style: AppTextStyles.body(context).copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(_cookingSteps.length, (idx) {
                            final isActive = _currentStep == idx;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.primaryFlame.withValues(alpha: 0.12) : AppColors.bgCream,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isActive ? AppColors.primaryFlame : AppColors.borderLight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isActive ? Icons.play_arrow_rounded : Icons.check_circle_outline_rounded,
                                    color: isActive ? AppColors.primaryFlame : AppColors.textMuted,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _cookingSteps[idx]['title']!,
                                      style: TextStyle(
                                        color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 28),

                        // Action CTAs
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryFlame,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  CartManager.addItem(title, priceRaw, icon);
                                  Navigator.pop(context);
                                  CartDrawer.show(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Add to Cart ($price)',
                                      style: AppTextStyles.buttonLabel(context).copyWith(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                side: const BorderSide(color: AppColors.primaryFlame, width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                OrderModal.show(context, initialDish: title);
                              },
                              child: Text(
                                'Order Instant',
                                style: AppTextStyles.buttonLabel(context).copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
