import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';

/// Interactive Live Pizza & Burger Assembly Cooking Animation Widget.
class CookingAnimationWidget extends StatefulWidget {
  const CookingAnimationWidget({super.key});

  @override
  State<CookingAnimationWidget> createState() => _CookingAnimationWidgetState();
}

class _CookingAnimationWidgetState extends State<CookingAnimationWidget>
    with SingleTickerProviderStateMixin {
  bool _isBurgerMode = true;
  int _currentStep = 0;
  Timer? _autoTimer;

  final List<Map<String, dynamic>> _burgerSteps = [
    {
      'title': '1. Toasting Brioche Bun',
      'desc': 'Golden brioche bun toasted at 350°F with organic French butter.',
      'icon': Icons.bakery_dining_rounded,
      'badge': 'PREP 350°F',
      'color': Color(0xFFD97706),
    },
    {
      'title': '2. Sizzling A5 Wagyu Patty',
      'desc': 'Hand-pressed Wagyu patty seared on cast iron for 90 seconds per side.',
      'icon': Icons.local_fire_department_rounded,
      'badge': 'SEARING',
      'color': Color(0xFFFF4D2D),
    },
    {
      'title': '3. Melting Gruyère Cheese',
      'desc': 'Aged Gruyère cheese melted directly over the hot patty under glass cloche.',
      'icon': Icons.local_pizza_rounded,
      'badge': 'MELTING',
      'color': Color(0xFFFF9200),
    },
    {
      'title': '4. Black Truffle Aioli Drizzle',
      'desc': 'House-made Perigord black truffle aioli and balsamic caramelized onions.',
      'icon': Icons.auto_awesome_rounded,
      'badge': 'INFUSING',
      'color': Color(0xFF7C5CFC),
    },
    {
      'title': '5. Crown & Thermal Seal',
      'desc': 'Crisp organic arugula added and sealed in thermal pod at 165°F.',
      'icon': Icons.verified_rounded,
      'badge': 'READY 165°F',
      'color': Color(0xFF10B981),
    },
  ];

  final List<Map<String, dynamic>> _pizzaSteps = [
    {
      'title': '1. Hand-Stretching Dough',
      'desc': '72-hour cold fermented sourdough stretched by hand to 12 inches.',
      'icon': Icons.blur_on_rounded,
      'badge': '72-HR FERMENT',
      'color': Color(0xFFD97706),
    },
    {
      'title': '2. San Marzano Sauce Spread',
      'desc': 'Crushed DOP San Marzano tomatoes, garlic, extra virgin olive oil & sea salt.',
      'icon': Icons.soup_kitchen_rounded,
      'badge': 'ORGANIC SAUCE',
      'color': Color(0xFFFF4D2D),
    },
    {
      'title': '3. Fresh Puglia Burrata Layer',
      'desc': 'Creamy hand-torn Burrata cheese and Fior di Latte mozzarella.',
      'icon': Icons.grain_rounded,
      'badge': 'FRESH CHEESE',
      'color': Color(0xFFFF9200),
    },
    {
      'title': '4. Wood-Fired 900°F Oven',
      'desc': 'Baked inside Italian stone oven at 900°F for exactly 90 seconds.',
      'icon': Icons.local_fire_department_rounded,
      'badge': '900°F WOOD FIRE',
      'color': Color(0xFFFF4D2D),
    },
    {
      'title': '5. Basil Pesto Drizzle',
      'desc': 'Finished with fresh Genovese basil pesto and shaved Parmigiano Reggiano.',
      'icon': Icons.eco_rounded,
      'badge': 'SERVED HOT',
      'color': Color(0xFF10B981),
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentStep = (_currentStep + 1) % 5;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final activeSteps = _isBurgerMode ? _burgerSteps : _pizzaSteps;
    final currentItem = activeSteps[_currentStep];

    return Container(
      width: double.infinity,
      color: AppColors.bgCard,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 90,
      ),
      child: Column(
        children: [
          // Section Title
          ScrollReveal(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFlame.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('LIVE KITCHEN ASSEMBLY', style: AppTextStyles.eyebrow(context)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Watch Master Chefs Craft Your Meal Live',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Text(
                    'Experience the step-by-step culinary precision behind our signature dishes. Toggle between Burger & Pizza assembly below.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.leadBody(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Mode Toggle (Burger vs Pizza)
          ScrollReveal(
            delay: const Duration(milliseconds: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeButton(
                  label: '🍔 Artisan Wagyu Burger Prep',
                  isSelected: _isBurgerMode,
                  onTap: () {
                    setState(() {
                      _isBurgerMode = true;
                      _currentStep = 0;
                    });
                  },
                ),
                const SizedBox(width: 16),
                _buildModeButton(
                  label: '🍕 Wood-Fired Pizza Prep',
                  isSelected: !_isBurgerMode,
                  onTap: () {
                    setState(() {
                      _isBurgerMode = false;
                      _currentStep = 0;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          // Main Live Assembly Interactive Showcase Box
          ScrollReveal(
            delay: const Duration(milliseconds: 200),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 950),
              padding: EdgeInsets.all(isMobile ? 24 : 44),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.glassBorder, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Step Indicator Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final isActive = index <= _currentStep;
                      final isCurrent = index == _currentStep;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentStep = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.primaryFlame
                                  : (isActive ? AppColors.accentEmber : AppColors.glassBorder),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                if (isCurrent)
                                  BoxShadow(
                                    color: AppColors.primaryFlame.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 36),

                  // Current Step Display Card
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (isMobile) {
                        return Column(
                          children: [
                            _buildVisualStageIcon(currentItem),
                            const SizedBox(height: 24),
                            _buildStepDetails(currentItem, context),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(flex: 4, child: _buildVisualStageIcon(currentItem)),
                          const SizedBox(width: 40),
                          Expanded(flex: 5, child: _buildStepDetails(currentItem, context)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 36),

                  // Manual Step Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: List.generate(5, (index) {
                      final isCurrent = index == _currentStep;
                      return GestureDetector(
                        onTap: () => setState(() => _currentStep = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.primaryFlame : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCurrent ? AppColors.primaryFlame : AppColors.glassBorder,
                            ),
                          ),
                          child: Text(
                            'Step ${index + 1}',
                            style: TextStyle(
                              color: isCurrent ? Colors.white : AppColors.textSecondary,
                              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.bgDark,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primaryFlame : AppColors.glassBorder,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryFlame.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildVisualStageIcon(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    final icon = item['icon'] as IconData;

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // Animated Pulse Ring
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.8, end: 1.1),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              builder: (context, val, child) {
                return Transform.scale(
                  scale: val,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.12),
                    ),
                  ),
                );
              },
            ),
          ),

          // Central Icon Graphic
          Center(
            child: Icon(
              icon,
              size: 72,
              color: color,
            ),
          ),

          // Stage Badge
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item['badge'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDetails(Map<String, dynamic> item, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryFlame.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'STAGE ${_currentStep + 1} OF 5',
                style: const TextStyle(
                  color: AppColors.primaryFlame,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          item['title'] as String,
          style: AppTextStyles.cardTitle(context).copyWith(fontSize: 24),
        ),
        const SizedBox(height: 12),
        Text(
          item['desc'] as String,
          style: AppTextStyles.leadBody(context).copyWith(fontSize: 15),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.accentEmber, size: 18),
            const SizedBox(width: 6),
            Text(
              'Precision Chef Time: ~90 Seconds',
              style: AppTextStyles.body(context).copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
