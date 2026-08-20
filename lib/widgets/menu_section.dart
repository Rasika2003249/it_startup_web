import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'cart_drawer.dart';
import 'dish_video_modal.dart';

/// Interactive Bento-Grid Menu Section featuring strictly our 4 Signature Special Dishes:
/// Pizza, Burger, Sandwich, and Donut.
class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  String _selectedCategory = '🔥 All Signature';

  final List<String> _categories = [
    '🔥 All Signature',
    '🍕 Pizza',
    '🍔 Burger',
    '🥪 Sandwich',
    '🍩 Donut',
  ];

  final List<Map<String, dynamic>> _signatureDishes = const [
    {
      'title': 'Pizza',
      'category': '🍕 Pizza',
      'description':
          '72-hr fermented organic sourdough crust, creamy Puglia burrata, wild chanterelle mushrooms, white truffle oil, and fresh Genovese basil.',
      'price': '\$19.99',
      'priceRaw': 19.99,
      'calories': '780 kcal',
      'prepTime': '14 Mins',
      'rating': '4.9 ★',
      'badge': '🟢 SIGNATURE SPECIAL',
      'icon': Icons.local_pizza_rounded,
      'videoAssetPath': 'assets/videos/hero/pizza.mp4',
      'tags': ['72-Hr Sourdough', 'Puglia Burrata', 'White Truffle'],
    },
    {
      'title': 'Burger',
      'category': '🍔 Burger',
      'description':
          'Double Beyond Meat smash patty seared on 500°F cast iron, melted sharp cheddar, Hass avocado slices, house truffle mayo, and toasted oat brioche bun.',
      'price': '\$18.99',
      'priceRaw': 18.99,
      'calories': '650 kcal',
      'prepTime': '10 Mins',
      'rating': '4.9 ★',
      'badge': '🟢 SIGNATURE SPECIAL',
      'icon': Icons.lunch_dining_rounded,
      'videoAssetPath': 'assets/videos/hero/avocado_truffle_burger.mp4',
      'tags': ['Double Smash', 'Hass Avocado', 'House Truffle'],
    },
    {
      'title': 'Sandwich',
      'category': '🥪 Sandwich',
      'description':
          'Tandoori-spiced organic paneer, fresh stone-ground mint chutney, roasted bell peppers, and melted mozzarella on warm rosemary sourdough focaccia.',
      'price': '\$15.99',
      'priceRaw': 15.99,
      'calories': '580 kcal',
      'prepTime': '11 Mins',
      'rating': '4.9 ★',
      'badge': '🟢 SIGNATURE SPECIAL',
      'icon': Icons.bakery_dining_rounded,
      'videoAssetPath': 'assets/videos/hero/sandwich.mp4',
      'tags': ['Tandoori Paneer', 'Rosemary Focaccia', 'Mint Chutney'],
    },
    {
      'title': 'Donut',
      'category': '🍩 Donut',
      'description':
          'Organic ceremonial matcha glaze over almond flour donuts, crowned with crushed Sicilian pistachios. Baked fresh hourly with zero refined sugars.',
      'price': '\$12.00',
      'priceRaw': 12.00,
      'calories': '340 kcal',
      'prepTime': '8 Mins',
      'rating': '5.0 ★',
      'badge': '🟢 SIGNATURE SPECIAL',
      'icon': Icons.cake_rounded,
      'videoAssetPath': 'assets/videos/hero/matcha_pistachio_donut.mp4',
      'tags': ['Ceremonial Matcha', 'Sicilian Pistachio', 'Freshly Baked'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    final filteredDishes = _selectedCategory == '🔥 All Signature'
        ? _signatureDishes
        : _signatureDishes.where((d) => d['category'] == _selectedCategory).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 80,
      ),
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
                    border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryFlame,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'OUR 4 SIGNATURE SPECIAL DISHES',
                        style: AppTextStyles.eyebrow(context).copyWith(
                          color: AppColors.primaryFlame,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Exclusive Culinary Masterpieces',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Text(
                    'Our kitchen focuses exclusively on 4 perfected signature dishes — Pizza, Burger, Sandwich, and Donut. Click any dish to watch live 4K preparation, customize, or order!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.leadBody(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Category Filter Tabs (Pizza, Burger, Sandwich, Donut)
          ScrollReveal(
            delay: const Duration(milliseconds: 100),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppColors.primaryFlame,
                        backgroundColor: AppColors.bgCard,
                        elevation: isSelected ? 4 : 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: isSelected ? AppColors.primaryFlame : AppColors.glassBorder,
                            width: 1.5,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = cat);
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Dish Cards Grid (Responsive 2x2 or 1-column layout)
          LayoutBuilder(
            builder: (context, constraints) {
              final gridCrossAxisCount = constraints.maxWidth < 750 ? 1 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDishes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCrossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: isMobile ? 0.85 : 1.25,
                ),
                itemBuilder: (context, index) {
                  final dish = filteredDishes[index];
                  return ScrollReveal(
                    delay: Duration(milliseconds: 100 * index),
                    child: _SignatureDishBentoCard(dish: dish),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Bento Dish Card for Signature Dishes
class _SignatureDishBentoCard extends StatefulWidget {
  final Map<String, dynamic> dish;

  const _SignatureDishBentoCard({required this.dish});

  @override
  State<_SignatureDishBentoCard> createState() => _SignatureDishBentoCardState();
}

class _SignatureDishBentoCardState extends State<_SignatureDishBentoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.dish['title'] as String;
    final price = widget.dish['price'] as String;
    final priceRaw = widget.dish['priceRaw'] as double;
    final category = widget.dish['category'] as String;
    final desc = widget.dish['description'] as String;
    final prepTime = widget.dish['prepTime'] as String;
    final calories = widget.dish['calories'] as String;
    final rating = widget.dish['rating'] as String;
    final badge = widget.dish['badge'] as String;
    final icon = widget.dish['icon'] as IconData;
    final tags = widget.dish['tags'] as List<String>;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgDarkCharcoal,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isHovered
                ? AppColors.primaryFlame
                : AppColors.primaryFlame.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.primaryFlame.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: _isHovered ? 25 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Badge + Chef Video Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFlame.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => DishVideoModal.show(context, widget.dish),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFlame,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryFlame.withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Watch 4K Prep',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Icon + Category + Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFlame.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.3)),
                  ),
                  child: Icon(icon, color: AppColors.primaryFlame, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: AppColors.secondaryGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              desc,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),

            // Tags (Sourdough, Truffle, etc.)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Price + Add to Cart Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.heroHeading(context).copyWith(
                        color: AppColors.secondaryGold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      '$prepTime • $calories • $rating',
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFlame,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 4,
                  ),
                  onPressed: () {
                    CartManager.addItem(title, priceRaw, icon);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added "$title" to cart! 🛒'),
                        backgroundColor: AppColors.textPrimary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 16),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
