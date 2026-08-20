import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'dish_video_modal.dart';
import 'cart_drawer.dart';
import 'inline_dish_video_player.dart';

/// Menu Showcase Bento Grid featuring 3D mouse parallax tilt effect via Transform + Matrix4,
/// category background gradient shifts, play button overlays, and inline 4K video playback.
class MenuShowcaseSection extends StatefulWidget {
  const MenuShowcaseSection({super.key});

  @override
  State<MenuShowcaseSection> createState() => _MenuShowcaseSectionState();
}

class _MenuShowcaseSectionState extends State<MenuShowcaseSection> {
  String _activeCategory = '🔥 All Signature';

  final List<String> _categories = [
    '🔥 All Signature',
    '🍕 Artisan Pizzas',
    '🍔 Plant Burgers',
    '🥪 Gourmet Sandwiches',
    '🍩 Artisanal Desserts',
    '🥤 Fresh Juices & Smoothies',
  ];

  final List<Map<String, dynamic>> _bentoDishes = const [
    {
      'title': 'Truffle Burrata Sourdough Pizza',
      'category': '🍕 Artisan Pizzas',
      'price': '\$19.99',
      'priceRaw': 19.99,
      'rating': '4.9 ★',
      'prepTime': '14 Mins',
      'calories': '780 kcal',
      'icon': Icons.local_pizza_rounded,
      'videoAssetPath': 'assets/videos/hero/pizza.mp4',
      'badge': '🔥 BENTO STAR',
      'gradient': [Color(0xFFFFF0EB), Color(0xFFFFF8F0)],
      'hoverGradient': [Color(0xFFFFE0D6), Color(0xFFFFF2E8)],
      'accentColor': AppColors.primaryFlame,
      'description': '72-hr fermented sourdough crust, creamy Puglia burrata, wild chanterelle mushrooms, white truffle oil.',
      'isWide': true,
    },
    {
      'title': 'Avocado Truffle Plant Smash Burger',
      'category': '🍔 Gourmet Burgers',
      'price': '\$18.99',
      'priceRaw': 18.99,
      'rating': '4.9 ★',
      'prepTime': '10 Mins',
      'calories': '650 kcal',
      'icon': Icons.lunch_dining_rounded,
      'videoAssetPath': 'assets/videos/hero/avocado_truffle_burger.mp4',
      'badge': '🟢 100% ARTISANAL',
      'gradient': [Color(0xFFFEF9C3), Color(0xFFFFF8F0)],
      'hoverGradient': [Color(0xFFFEF08A), Color(0xFFFFF4D6)],
      'accentColor': AppColors.secondaryGold,
      'description': 'Double smash patty, melted cheddar, Hass avocado, house truffle mayo.',
      'isWide': false,
    },
    {
      'title': 'Artisan Gourmet Focaccia Sandwich',
      'category': '🥪 Gourmet Sandwiches',
      'price': '\$15.99',
      'priceRaw': 15.99,
      'rating': '4.9 ★',
      'prepTime': '9 Mins',
      'calories': '520 kcal',
      'icon': Icons.bakery_dining_rounded,
      'videoAssetPath': 'assets/videos/hero/sandwich.mp4',
      'badge': '🟢 FRESH BREAD',
      'gradient': [Color(0xFFECFDF5), Color(0xFFFFF8F0)],
      'hoverGradient': [Color(0xFFA7F3D0), Color(0xFFE6F4EA)],
      'accentColor': AppColors.forestGreen,
      'description': 'Tandoori-spiced organic paneer, fresh mint chutney, roasted bell peppers on rosemary sourdough focaccia.',
      'isWide': false,
    },
    {
      'title': 'Matcha Pistachio Glazed Donuts',
      'category': '🍩 Artisanal Desserts',
      'price': '\$12.00',
      'priceRaw': 12.00,
      'rating': '5.0 ★',
      'prepTime': '8 Mins',
      'calories': '340 kcal',
      'icon': Icons.cake_rounded,
      'videoAssetPath': 'assets/videos/hero/matcha_pistachio_donut.mp4',
      'badge': '🟢 ZERO REFINED SUGAR',
      'gradient': [Color(0xFFFFF0EB), Color(0xFFFFF8F0)],
      'hoverGradient': [Color(0xFFFFE0D6), Color(0xFFFFF2E8)],
      'accentColor': AppColors.primaryFlame,
      'description': 'Organic ceremonial matcha glaze, crushed Sicilian pistachios, almond flour baked fresh hourly.',
      'isWide': false,
    },
    {
      'title': 'Almond Pesto Quinoa Power Bowl',
      'category': '🥗 Quinoa Bowls',
      'price': '\$16.50',
      'priceRaw': 16.50,
      'rating': '5.0 ★',
      'prepTime': '8 Mins',
      'calories': '480 kcal',
      'icon': Icons.rice_bowl_rounded,
      'videoAssetPath': 'assets/videos/hero/pizza.mp4',
      'badge': '🟢 SUPERFOOD',
      'gradient': [Color(0xFFECFDF5), Color(0xFFFFF8F0)],
      'hoverGradient': [Color(0xFFA7F3D0), Color(0xFFE6F4EA)],
      'accentColor': AppColors.forestGreen,
      'description': 'Organic tri-color quinoa, roasted spiced chickpeas, Hass avocado, Sicilian pesto dressing.',
      'isWide': false,
    },
    {
      'title': 'Cold-Pressed Organic Glow Elixir',
      'category': '🥤 Fresh Juices & Smoothies',
      'price': '\$9.50',
      'priceRaw': 9.50,
      'rating': '5.0 ★',
      'prepTime': '5 Mins',
      'calories': '180 kcal',
      'icon': Icons.local_bar_rounded,
      'videoAssetPath': 'assets/videos/hero/dessert.mp4',
      'badge': '🟢 IMMUNITY BOOST',
      'gradient': [Color(0xFFFEF9C3), Color(0xFFFFF8F0)],
      'hoverGradient': [Color(0xFFFEF08A), Color(0xFFFFF4D6)],
      'accentColor': AppColors.secondaryGold,
      'description': 'Raw wild sea buckthorn, organic Hawaiian turmeric, Valencia orange, ginger root, coconut water.',
      'isWide': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    final filteredDishes = _activeCategory == '🔥 All Signature'
        ? _bentoDishes
        : _bentoDishes.where((d) => d['category'] == _activeCategory).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 20 : 80,
      ),
      color: AppColors.bgCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Header
          ScrollReveal(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFlame.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'GOURMET BENTO SHOWCASE',
                    style: AppTextStyles.eyebrow(context),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Explore Culinary Masterpieces',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    'Hover for 3D tilt, tap to play inline HD videos (Pizza, Burger, Sandwich, Dessert), or add directly to your cart.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.leadBody(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Category Chips
          ScrollReveal(
            delay: const Duration(milliseconds: 100),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _categories.map((cat) {
                  final isSelected = _activeCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _activeCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryFlame : AppColors.borderLight,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.primaryFlame.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Text(
                        cat,
                        style: AppTextStyles.body(context).copyWith(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Bento Layout Grid with 3D Mouse Parallax Tilt & Inline Video Switcher
          if (isMobile)
            Column(
              children: List.generate(filteredDishes.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: (index % 3) * 120),
                    child: _BentoTiltCard(dish: filteredDishes[index]),
                  ),
                );
              }),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: List.generate(filteredDishes.length, (index) {
                    final dish = filteredDishes[index];
                    final isWide = (dish['isWide'] as bool? ?? false) && filteredDishes.length > 2;
                    final cardWidth = isWide
                        ? constraints.maxWidth * 0.64
                        : (constraints.maxWidth - 48) / 3;

                    return SizedBox(
                      width: cardWidth,
                      child: ScrollReveal(
                        delay: Duration(milliseconds: (index % 3) * 120),
                        child: _BentoTiltCard(dish: dish),
                      ),
                    );
                  }),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// 3D Mouse Parallax Tilt Card with Inline Video Player Switcher
class _BentoTiltCard extends StatefulWidget {
  final Map<String, dynamic> dish;

  const _BentoTiltCard({required this.dish});

  @override
  State<_BentoTiltCard> createState() => _BentoTiltCardState();
}

class _BentoTiltCardState extends State<_BentoTiltCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isHovered = false;
  bool _isPlayingInlineVideo = false;

  void _onHover(PointerEvent details, Size size) {
    if (size.width == 0 || size.height == 0 || _isPlayingInlineVideo) return;
    final x = details.localPosition.dx;
    final y = details.localPosition.dy;

    final px = (x / size.width) - 0.5;
    final py = (y / size.height) - 0.5;

    setState(() {
      _rotateX = -py * 0.22;
      _rotateY = px * 0.22;
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dish;
    final title = d['title'] as String;
    final description = d['description'] as String;
    final price = d['price'] as String;
    final priceRaw = d['priceRaw'] as double;
    final rating = d['rating'] as String;
    final prepTime = d['prepTime'] as String;
    final icon = d['icon'] as IconData;
    final videoAssetPath = d['videoAssetPath'] as String;
    final badge = d['badge'] as String?;
    final gradientColors = (d['gradient'] as List<Color>);
    final hoverGradientColors = (d['hoverGradient'] as List<Color>);
    final accentColor = (d['accentColor'] as Color);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, 360);

        return MouseRegion(
          onHover: (e) => _onHover(e, size),
          onExit: _onExit,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotateX)
              ..rotateY(_rotateY),
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: const BoxConstraints(minHeight: 350),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isHovered ? hoverGradientColors : gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: _isHovered ? accentColor : AppColors.borderLight,
                  width: _isHovered ? 1.8 : 1.0,
                ),
                boxShadow: [
                  if (_isHovered)
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    )
                  else
                    const BoxShadow(
                      color: Color(0x0C000000),
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
                child: _isPlayingInlineVideo
                    ? InlineDishVideoPlayer(
                        key: ValueKey<String>('bento_video_$title'),
                        videoAssetPath: videoAssetPath,
                        title: title,
                        onClose: () => setState(() => _isPlayingInlineVideo = false),
                      )
                    : Column(
                        key: ValueKey<String>('bento_static_$title'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: accentColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      icon,
                                      color: accentColor,
                                      size: 28,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (badge != null)
                                        Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: accentColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: accentColor),
                                          ),
                                          child: Text(
                                            badge,
                                            style: TextStyle(
                                              color: accentColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: accentColor,
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
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Play Button Banner Button & Full Video Modal Option
                              GestureDetector(
                                onTap: () => setState(() => _isPlayingInlineVideo = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF1A1410), Color(0xFF332921)],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.play_circle_fill_rounded, color: accentColor, size: 20),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Play Inline HD Video',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => DishVideoModal.show(context, d),
                                        child: const Icon(
                                          Icons.open_in_full_rounded,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: AppTextStyles.cardTitle(context).copyWith(fontSize: 18),
                                    ),
                                  ),
                                  Text(
                                    rating,
                                    style: TextStyle(
                                      color: AppColors.secondaryGold,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                description,
                                style: AppTextStyles.body(context).copyWith(fontSize: 13),
                              ),
                            ],
                          ),

                          // Bottom Action Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 14),
                                  const SizedBox(width: 4),
                                  Text(prepTime, style: AppTextStyles.body(context).copyWith(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                child: Row(
                                  children: const [
                                    Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 16),
                                    SizedBox(width: 6),
                                    Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
