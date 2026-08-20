import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Stats Section with rich dark charcoal contrast background (#1A1410),
/// animated count-up numbers when scrolled into view, and subtle pulse icon animations.
class StatsSection extends StatefulWidget {
  const StatsSection({super.key});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _countUpController;

  late Animation<double> _ordersCount;
  late Animation<double> _ratingCount;
  late Animation<double> _deliveryCount;
  late Animation<double> _restaurantsCount;

  bool _hasAnimated = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();

    // Subtle pulsing icon animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Count-up numbers controller
    _countUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _ordersCount = Tween<double>(begin: 0, end: 50).animate(CurvedAnimation(
      parent: _countUpController,
      curve: Curves.easeOutCubic,
    ));

    _ratingCount = Tween<double>(begin: 0.0, end: 4.9).animate(CurvedAnimation(
      parent: _countUpController,
      curve: Curves.easeOutCubic,
    ));

    _deliveryCount = Tween<double>(begin: 0, end: 30).animate(CurvedAnimation(
      parent: _countUpController,
      curve: Curves.easeOutCubic,
    ));

    _restaurantsCount = Tween<double>(begin: 0, end: 120).animate(CurvedAnimation(
      parent: _countUpController,
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
          _scrollPosition?.removeListener(_checkVisibility);
          _scrollPosition = position;
          _scrollPosition?.addListener(_checkVisibility);
        }
      }
    } catch (_) {}

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    try {
      final renderObject = context.findRenderObject() as RenderBox?;
      if (renderObject == null || !renderObject.attached || !renderObject.hasSize) {
        return;
      }

      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      if (position.dy < screenHeight * 0.85) {
        _hasAnimated = true;
        _scrollPosition?.removeListener(_checkVisibility);
        _countUpController.forward();
      }
    } catch (_) {
      if (mounted && !_hasAnimated) {
        _hasAnimated = true;
        _countUpController.forward();
      }
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    _pulseController.dispose();
    _countUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 80,
      ),
      color: AppColors.bgDarkCharcoal,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _countUpController,
            builder: (context, child) {
              return Wrap(
                spacing: 32,
                runSpacing: 40,
                alignment: WrapAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context: context,
                    icon: Icons.delivery_dining_rounded,
                    value: '${_ordersCount.value.toInt()}K+',
                    label: 'Orders Delivered',
                    isMobile: isMobile,
                  ),
                  _buildStatItem(
                    context: context,
                    icon: Icons.star_rounded,
                    value: '${_ratingCount.value.toStringAsFixed(1)}★',
                    label: 'Average Rating',
                    iconColor: AppColors.secondaryGold,
                    isMobile: isMobile,
                  ),
                  _buildStatItem(
                    context: context,
                    icon: Icons.timer_rounded,
                    value: '${_deliveryCount.value.toInt()} Min',
                    label: 'Avg Delivery Time',
                    isMobile: isMobile,
                  ),
                  _buildStatItem(
                    context: context,
                    icon: Icons.storefront_rounded,
                    value: '${_restaurantsCount.value.toInt()}+',
                    label: 'Partner Kitchens',
                    iconColor: AppColors.forestGreen,
                    isMobile: isMobile,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    Color iconColor = AppColors.primaryFlame,
    required bool isMobile,
  }) {
    final itemWidth = isMobile ? (MediaQuery.of(context).size.width - 80) / 2 : 220.0;

    return SizedBox(
      width: itemWidth,
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1.06).animate(
              CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.heroHeading(context).copyWith(
              fontSize: isMobile ? 32 : 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(context).copyWith(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
