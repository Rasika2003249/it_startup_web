import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'order_modal.dart';

/// Promotional "Our Menu" section encouraging cafe visits and table reservations,
/// featuring rich motion background, scroll reveal animations, and hover-glow CTAs.
class OurMenuPromoSection extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const OurMenuPromoSection({super.key, this.onExploreTap});

  @override
  State<OurMenuPromoSection> createState() => _OurMenuPromoSectionState();
}

class _OurMenuPromoSectionState extends State<OurMenuPromoSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isHoveredVisit = false;
  bool _isHoveredReserve = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: AppColors.bgCream,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: ScrollReveal(
            child: Container(
              padding: EdgeInsets.all(isMobile ? 32 : 60),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: AppColors.borderLight, width: 1.5),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFlame.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🌿 Michelin-Crafted Culinary Atelier',
                      style: AppTextStyles.eyebrow(context).copyWith(
                        color: AppColors.primaryFlame,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'This Is What We Bring To Your Table',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.sectionHeading(context).copyWith(
                      fontSize: isMobile ? 32 : 48,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Text(
                      'From 72-hour wood-fired sourdough pizzas to double smash burgers — every dish crafted fresh daily with organic ingredients. Every visit is an unforgettable culinary experience.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.leadBody(context).copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isMobile ? 15 : 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Call to Action Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      // Visit Us Today Button
                      MouseRegion(
                        onEnter: (_) => setState(() => _isHoveredVisit = true),
                        onExit: (_) => setState(() => _isHoveredVisit = false),
                        child: AnimatedScale(
                          scale: _isHoveredVisit ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryFlame,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                              elevation: _isHoveredVisit ? 8 : 2,
                            ),
                            onPressed: () => OrderModal.show(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Visit Our Cafe Today',
                                  style: AppTextStyles.buttonLabel(context).copyWith(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Reserve Your Table Button
                      MouseRegion(
                        onEnter: (_) => setState(() => _isHoveredReserve = true),
                        onExit: (_) => setState(() => _isHoveredReserve = false),
                        child: AnimatedScale(
                          scale: _isHoveredReserve ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              side: const BorderSide(color: AppColors.primaryFlame, width: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            ),
                            onPressed: () => OrderModal.show(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.table_restaurant_rounded, color: AppColors.primaryFlame, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Reserve Your Table',
                                  style: AppTextStyles.buttonLabel(context).copyWith(color: AppColors.textPrimary, fontSize: 16),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
