import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'cart_drawer.dart';
import 'inline_dish_video_player.dart';

/// Featured Dishes Section featuring inline 4K video playback directly inside cards,
/// animated play button overlays, mute/unmute controls, bounce price tags, and favorite heart animation.
class FeaturedDishesSection extends StatefulWidget {
  const FeaturedDishesSection({super.key});

  @override
  State<FeaturedDishesSection> createState() => _FeaturedDishesSectionState();
}

class _FeaturedDishesSectionState extends State<FeaturedDishesSection> {
  final List<Map<String, dynamic>> _featuredDishes = const [
    {
      'title': 'Artisan Truffle Burrata Pizza',
      'category': '🍕 Wood-Fired Sourdough',
      'price': '\$19.99',
      'priceRaw': 19.99,
      'rating': '4.9 ★',
      'prepTime': '14 Mins',
      'calories': '780 kcal',
      'icon': Icons.local_pizza_rounded,
      'videoAssetPath': 'assets/videos/hero/pizza.mp4',
      'description': '72-hr sourdough crust, creamy Puglia burrata, wild chanterelle mushrooms, white truffle oil.',
    },
    {
      'title': 'Avocado Truffle Plant Burger',
      'category': '🍔 Plant Smash Burger',
      'price': '\$18.99',
      'priceRaw': 18.99,
      'rating': '4.9 ★',
      'prepTime': '10 Mins',
      'calories': '650 kcal',
      'icon': Icons.lunch_dining_rounded,
      'videoAssetPath': 'assets/videos/hero/avocado_truffle_burger.mp4',
      'description': 'Double smash patty, melted cheddar, Hass avocado, house truffle mayo.',
    },
    {
      'title': 'Artisan Gourmet Sandwich',
      'category': '🥪 Focaccia Sandwich',
      'price': '\$15.99',
      'priceRaw': 15.99,
      'rating': '4.9 ★',
      'prepTime': '9 Mins',
      'calories': '520 kcal',
      'icon': Icons.bakery_dining_rounded,
      'videoAssetPath': 'assets/videos/hero/sandwich.mp4',
      'description': 'Tandoori organic paneer, mint chutney, roasted bell peppers on rosemary sourdough focaccia.',
    },
    {
      'title': 'Matcha Pistachio Glazed Donuts',
      'category': '🍩 Artisanal Dessert',
      'price': '\$12.00',
      'priceRaw': 12.00,
      'rating': '5.0 ★',
      'prepTime': '8 Mins',
      'calories': '340 kcal',
      'icon': Icons.cake_rounded,
      'videoAssetPath': 'assets/videos/hero/matcha_pistachio_donut.mp4',
      'description': 'Organic ceremonial matcha glaze, crushed Sicilian pistachios, baked fresh hourly.',
    },
    {
      'title': 'Almond Pesto Quinoa Power Bowl',
      'category': '🥗 Superfood Quinoa',
      'price': '\$16.50',
      'priceRaw': 16.50,
      'rating': '5.0 ★',
      'prepTime': '8 Mins',
      'calories': '480 kcal',
      'icon': Icons.rice_bowl_rounded,
      'videoAssetPath': 'assets/videos/hero/pizza.mp4',
      'description': 'Tri-color organic quinoa, roasted spiced chickpeas, Hass avocado, Sicilian pesto dressing.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 90,
        horizontal: isMobile ? 20 : 60,
      ),
      color: AppColors.bgCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          ScrollReveal(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFlame.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CHEF\'S SIGNATURE SELECTION',
                        style: AppTextStyles.eyebrow(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Trending Featured Dishes',
                      style: AppTextStyles.sectionHeading(context),
                    ),
                  ],
                ),
                if (!isMobile)
                  Text(
                    'Tap dish image to play inline HD video 🎥',
                    style: AppTextStyles.body(context).copyWith(
                      color: AppColors.primaryFlame,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Horizontal Scrollable Cards
          ScrollReveal(
            delay: const Duration(milliseconds: 150),
            child: SizedBox(
              height: 460,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _featuredDishes.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: isMobile ? 300 : 350,
                    margin: const EdgeInsets.only(right: 24),
                    child: _FeaturedDishCard(dish: _featuredDishes[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive Card with inline video player toggle, smooth animated transition,
/// play overlay, and favorite micro-animation.
class _FeaturedDishCard extends StatefulWidget {
  final Map<String, dynamic> dish;

  const _FeaturedDishCard({required this.dish});

  @override
  State<_FeaturedDishCard> createState() => _FeaturedDishCardState();
}

class _FeaturedDishCardState extends State<_FeaturedDishCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isFavorite = false;
  bool _isPlayingVideo = false;

  late AnimationController _heartAnimationController;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.3,
    );
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    _heartAnimationController.forward().then((_) {
      _heartAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dish;
    final title = d['title'] as String;
    final category = d['category'] as String;
    final price = d['price'] as String;
    final priceRaw = d['priceRaw'] as double;
    final rating = d['rating'] as String;
    final prepTime = d['prepTime'] as String;
    final icon = d['icon'] as IconData;
    final videoAssetPath = d['videoAssetPath'] as String;
    final description = d['description'] as String;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.bgCard : AppColors.bgCardSoft,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isHovered ? AppColors.primaryFlame : AppColors.borderLight,
            width: _isHovered ? 1.8 : 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.primaryFlame.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 10),
              )
            else
              const BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: _isPlayingVideo
              ? InlineDishVideoPlayer(
                  key: ValueKey<String>('video_$title'),
                  videoAssetPath: videoAssetPath,
                  title: title,
                  onClose: () => setState(() => _isPlayingVideo = false),
                )
              : Column(
                  key: ValueKey<String>('static_$title'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Header Row with Bouncing Price Tag & Heart Pop Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.8, end: 1.0),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.elasticOut,
                              builder: (context, val, child) {
                                return Transform.scale(
                                  scale: val,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      price,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            GestureDetector(
                              onTap: _toggleFavorite,
                              child: ScaleTransition(
                                scale: _heartAnimationController,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _isFavorite
                                        ? AppColors.primaryFlame.withValues(alpha: 0.15)
                                        : AppColors.bgCream,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    color: _isFavorite ? AppColors.primaryFlame : AppColors.textMuted,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Center Dish Image Viewport with Play Button Icon Overlay
                        GestureDetector(
                          onTap: () => setState(() => _isPlayingVideo = true),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedTransform(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                transform: Matrix4.identity()
                                  ..scale(_isHovered ? 1.08 : 1.0)
                                  ..rotateZ(_isHovered ? (math.pi / 36) : 0),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryFlame.withValues(alpha: 0.1),
                                    boxShadow: [
                                      if (_isHovered)
                                        BoxShadow(
                                          color: AppColors.primaryFlame.withValues(alpha: 0.3),
                                          blurRadius: 20,
                                        ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 64,
                                    color: AppColors.primaryFlame,
                                  ),
                                ),
                              ),

                              // Play Button Icon Overlay to indicate video enabled
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Tap To Play Video Banner Hint
                        GestureDetector(
                          onTap: () => setState(() => _isPlayingVideo = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFlame.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primaryFlame.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.play_circle_fill_rounded, color: AppColors.primaryFlame, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Play Inline HD Video 🎥',
                                  style: TextStyle(
                                    color: AppColors.primaryFlame,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          category,
                          style: AppTextStyles.eyebrow(context).copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title,
                          style: AppTextStyles.cardTitle(context).copyWith(fontSize: 17),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: AppTextStyles.body(context).copyWith(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Bottom Actions Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.secondaryGold, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: AppTextStyles.body(context).copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              prepTime,
                              style: AppTextStyles.body(context).copyWith(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryFlame,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          onPressed: () {
                            CartManager.addItem(title, priceRaw, icon);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added "$title" to your cart! 🛒'),
                                backgroundColor: AppColors.textPrimary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text('Add +', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Helper widget to animate Transform
class AnimatedTransform extends StatelessWidget {
  final Matrix4 transform;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const AnimatedTransform({
    super.key,
    required this.transform,
    required this.duration,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Matrix4>(
      tween: Matrix4Tween(begin: Matrix4.identity(), end: transform),
      duration: duration,
      curve: curve,
      builder: (context, matrix, childWidget) {
        return Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: childWidget,
        );
      },
      child: child,
    );
  }
}
