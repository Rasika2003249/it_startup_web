import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'cart_drawer.dart';

/// Sticky Navbar widget that starts transparent over the Hero section and transitions
/// to a solid warm cream background with soft elevation shadow when scrolled down.
class Navbar extends StatefulWidget {
  final bool isScrolled;
  final Function(int index) onNavTap;

  const Navbar({
    super.key,
    required this.isScrolled,
    required this.onNavTap,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  int _hoveredIndex = -1;
  late AnimationController _flameAnimationController;

  final List<String> _navItems = [
    'Pizza',
    'Burger',
    'Sandwich',
    'Dessert',
    'Our Menu',
    'How It Works',
    'Stats',
    'Reviews',
  ];

  @override
  void initState() {
    super.initState();
    // Continuous subtle pulsing animation for the logo flame icon
    _flameAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flameAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 1150; // Responsive threshold for compact screens (mobile & tablets)
    final isSmallMobile = width < 600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: widget.isScrolled
            ? AppColors.bgCream.withValues(alpha: 0.96)
            : Colors.black.withValues(alpha: 0.25),
        boxShadow: widget.isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallMobile ? 16 : 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Logo with Animated Flame Icon
                GestureDetector(
                  onTap: () => widget.onNavTap(0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.08).animate(
                          CurvedAnimation(
                            parent: _flameAnimationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFlame,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryFlame.withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: AppTextStyles.cardTitle(context).copyWith(
                                fontSize: isSmallMobile ? 18 : 22,
                                letterSpacing: 1.0,
                              ),
                              children: [
                                TextSpan(
                                  text: 'VELORA',
                                  style: TextStyle(
                                    color: widget.isScrolled ? AppColors.textPrimary : Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'TASTE, REIMAGINED',
                            style: TextStyle(
                              color: AppColors.primaryFlame,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. Desktop Navigation Links (Only shown when width >= 1150px)
                if (!isCompact)
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_navItems.length, (index) {
                          final isHovered = _hoveredIndex == index;
                          return MouseRegion(
                            onEnter: (_) => setState(() => _hoveredIndex = index),
                            onExit: (_) => setState(() => _hoveredIndex = -1),
                            child: GestureDetector(
                              onTap: () => widget.onNavTap(index + 1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? AppColors.primaryFlame.withValues(alpha: 0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _navItems[index],
                                  style: AppTextStyles.body(context).copyWith(
                                    color: isHovered
                                        ? AppColors.primaryFlame
                                        : (widget.isScrolled ? AppColors.textPrimary : Colors.white),
                                    fontWeight: isHovered ? FontWeight.w700 : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                // 3. Right Actions (Shopping Cart Drawer Trigger + Mobile Menu)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: CartManager.cartItemsNotifier,
                      builder: (context, items, child) {
                        final count = CartManager.totalItemCount;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => CartDrawer.show(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFlame.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primaryFlame.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppColors.primaryFlame,
                                  size: 20,
                                ),
                              ),
                            ),
                            if (count > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryFlame,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    // Mobile / Tablet Drawer Trigger Button
                    if (isCompact)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.menu_rounded,
                            color: widget.isScrolled ? AppColors.textPrimary : Colors.white,
                            size: 26,
                          ),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
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
  }
}
