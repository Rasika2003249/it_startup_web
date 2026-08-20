import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/navbar.dart';
import '../widgets/video_showcase_section.dart';
import '../widgets/our_menu_promo_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/testimonial_section.dart';
import '../widgets/cta_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/cart_drawer.dart';

/// Main Home Screen composing 4 cinematic full-screen video showcase sections,
/// the "Our Menu" promo section, and all brand sections into a flagship web experience.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  final GlobalKey _pizzaKey = GlobalKey();
  final GlobalKey _burgerKey = GlobalKey();
  final GlobalKey _sandwichKey = GlobalKey();
  final GlobalKey _dessertKey = GlobalKey();
  final GlobalKey _menuPromoKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _statsKey = GlobalKey();
  final GlobalKey _reviewsKey = GlobalKey();

  final List<String> _mobileNavItems = [
    '🍕 Pizza Showcase',
    '🍔 Burger Showcase',
    '🥪 Sandwich Showcase',
    '🍩 Dessert Showcase',
    '🌿 Our Menu',
    '🚴 How It Works',
    '📊 Impact & Stats',
    '⭐ Reviews',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    GlobalKey targetKey;
    switch (index) {
      case 0:
        targetKey = _pizzaKey;
        break;
      case 1:
        targetKey = _burgerKey;
        break;
      case 2:
        targetKey = _sandwichKey;
        break;
      case 3:
        targetKey = _dessertKey;
        break;
      case 4:
        targetKey = _menuPromoKey;
        break;
      case 5:
        targetKey = _howItWorksKey;
        break;
      case 6:
        targetKey = _statsKey;
        break;
      case 7:
        targetKey = _reviewsKey;
        break;
      default:
        targetKey = _pizzaKey;
    }

    final context = targetKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 1150;

    return Scaffold(
      backgroundColor: AppColors.bgCream,
      endDrawer: isCompact
          ? Drawer(
              backgroundColor: AppColors.bgCream,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('VELORA', style: AppTextStyles.cardTitle(context).copyWith(color: AppColors.primaryFlame, letterSpacing: 1.0)),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ...List.generate(_mobileNavItems.length, (idx) {
                        return ListTile(
                          title: Text(_mobileNavItems[idx], style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollToSection(idx);
                          },
                        );
                      }),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryFlame, padding: const EdgeInsets.symmetric(vertical: 16)),
                          onPressed: () {
                            Navigator.pop(context);
                            CartDrawer.show(context);
                          },
                          child: const Text('View Cart Drawer 🛒', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main Scrollable Page Layout
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Pizza Showcase (pizza.mp4)
                Container(
                  key: _pizzaKey,
                  child: const VideoShowcaseSection(
                    videoAssetPath: 'assets/videos/hero/pizza.mp4',
                    category: '🍕 WOOD-FIRED SOURDOUGH PIZZA',
                    title: 'Wood-Fired Truffle Burrata Pizza',
                    description: '72-hour organic sourdough crust topped with creamy Puglia burrata, wild chanterelle mushrooms, and cold-pressed white truffle oil.',
                    price: '\$19.99',
                    priceRaw: 19.99,
                    icon: Icons.local_pizza_rounded,
                    layoutStyle: ShowcaseLayout.fullBackground,
                    isFirstSection: true,
                  ),
                ),

                // 2. Burger Showcase (avocado_truffle_burger.mp4)
                Container(
                  key: _burgerKey,
                  child: const VideoShowcaseSection(
                    videoAssetPath: 'assets/videos/hero/8879537-uhd_4096_2160_25fps.mp4',
                    category: '🍔 GOURMET SMASH BURGER',
                    title: 'Avocado Truffle Gourmet Smash Burger',
                    description: 'Double smash patty seared on 500°F cast iron, layered with melted sharp cheddar, Hass avocado, and house truffle mayo.',
                    price: '\$18.99',
                    priceRaw: 18.99,
                    icon: Icons.lunch_dining_rounded,
                    layoutStyle: ShowcaseLayout.videoLeft,
                  ),
                ),

                // 3. Sandwich Showcase (sandwich.mp4)
                Container(
                  key: _sandwichKey,
                  child: const VideoShowcaseSection(
                    videoAssetPath: 'assets/videos/hero/sandwich.mp4',
                    category: '🥪 ARTISANAL FOCACCIA SANDWICH',
                    title: 'Artisan Gourmet Focaccia Sandwich',
                    description: 'Tandoori-spiced organic paneer, fresh stone-ground mint chutney, and roasted bell peppers on warm rosemary sourdough focaccia.',
                    price: '\$15.99',
                    priceRaw: 15.99,
                    icon: Icons.bakery_dining_rounded,
                    layoutStyle: ShowcaseLayout.videoRight,
                  ),
                ),

                // 4. Dessert Showcase (matcha_pistachio_donut.mp4)
                Container(
                  key: _dessertKey,
                  child: const VideoShowcaseSection(
                    videoAssetPath: 'assets/videos/hero/matcha_pistachio_donut.mp4',
                    category: '🍩 ARTISANAL DESSERT',
                    title: 'Matcha Pistachio Glazed Donuts',
                    description: 'Organic ceremonial matcha glaze over almond flour donuts, crowned with crushed Sicilian pistachios. Baked fresh hourly with zero refined sugar.',
                    price: '\$12.00',
                    priceRaw: 12.00,
                    icon: Icons.cake_rounded,
                    layoutStyle: ShowcaseLayout.fullBackground,
                  ),
                ),

                // 5. "Our Menu" & Visit Us Promotional Section
                Container(
                  key: _menuPromoKey,
                  child: OurMenuPromoSection(
                    onExploreTap: () => _scrollToSection(0),
                  ),
                ),

                // 6. How It Works Section (3-Step Animated Timeline + Connecting Line)
                Container(
                  key: _howItWorksKey,
                  child: const HowItWorksSection(),
                ),

                // 7. Stats & Impact Section (Dark Charcoal + Count-Up Numbers)
                Container(
                  key: _statsKey,
                  child: const StatsSection(),
                ),

                // 8. Testimonials Wall (Auto Carousel + Star-by-Star animation)
                Container(
                  key: _reviewsKey,
                  child: const TestimonialSection(),
                ),

                // 9. VIP CTA Section (Orange-Mustard Shifting Gradient + Pulsing Button)
                const CtaSection(),

                // 10. Footer Section
                FooterSection(
                  onNavTap: _scrollToSection,
                ),
              ],
            ),
          ),

          // Sticky Transparent-to-Solid Navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(
              isScrolled: _isScrolled,
              onNavTap: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }
}
