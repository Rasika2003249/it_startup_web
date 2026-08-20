import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'order_modal.dart';

/// CTA Section with rich orange-to-mustard gradient background,
/// subtle moving pattern texture animation, and continuous soft pulsing Order Now button.
class CtaSection extends StatefulWidget {
  final VoidCallback? onContactTap;

  const CtaSection({super.key, this.onContactTap});

  @override
  State<CtaSection> createState() => _CtaSectionState();
}

class _CtaSectionState extends State<CtaSection>
    with TickerProviderStateMixin {
  late AnimationController _gradientMoveController;
  late AnimationController _pulseGlowController;

  bool _isBtnHovered = false;

  @override
  void initState() {
    super.initState();
    // Continuous subtle background gradient shift
    _gradientMoveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Continuous soft pulse glow on Order Now button
    _pulseGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientMoveController.dispose();
    _pulseGlowController.dispose();
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
        horizontal: isMobile ? 20 : 80,
      ),
      child: ScrollReveal(
        child: AnimatedBuilder(
          animation: _gradientMoveController,
          builder: (context, child) {
            final shift = _gradientMoveController.value;
            return Container(
              padding: EdgeInsets.all(isMobile ? 32 : 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    AppColors.primaryFlame,
                    AppColors.secondaryGold,
                    AppColors.primaryFlame,
                  ],
                  stops: [0.0, 0.5 + (shift * 0.3), 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryFlame.withValues(alpha: 0.35),
                    blurRadius: 36,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Subtle Moving Pattern Texture Overlay
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: CustomPaint(
                        painter: PatternTexturePainter(progress: shift),
                      ),
                    ),
                  ),

                  // Main Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                        ),
                        child: const Text(
                          '🎟️ VIP CULINARY PASS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Ready to Taste Culinary Perfection?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heroHeading(context).copyWith(
                          color: Colors.white,
                          fontSize: isMobile ? 32 : 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Text(
                          'Claim your instant 20% discount on your first artisanal meal. Delivered in under 30 minutes in smart thermal express pods.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.leadBody(context).copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Continuous Soft Pulse/Glow "Order Now" Button
                      AnimatedBuilder(
                        animation: _pulseGlowController,
                        builder: (context, child) {
                          final pulseVal = _pulseGlowController.value;
                          return MouseRegion(
                            onEnter: (_) => setState(() => _isBtnHovered = true),
                            onExit: (_) => setState(() => _isBtnHovered = false),
                            child: AnimatedScale(
                              scale: _isBtnHovered ? 1.06 : (1.0 + (pulseVal * 0.03)),
                              duration: const Duration(milliseconds: 200),
                              child: GestureDetector(
                                onTap: () => OrderModal.show(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgDarkCharcoal,
                                    borderRadius: BorderRadius.circular(36),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.bgDarkCharcoal.withValues(
                                          alpha: 0.4 + (pulseVal * 0.2),
                                        ),
                                        blurRadius: 20 + (pulseVal * 10),
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.flash_on_rounded,
                                        color: AppColors.secondaryGold,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Order Feast Now',
                                        style: AppTextStyles.buttonLabel(context).copyWith(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// CustomPainter for subtle moving grid/pattern texture
class PatternTexturePainter extends CustomPainter {
  final double progress;

  PatternTexturePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final step = 40.0;
    final offset = progress * step;

    for (double x = -step; x < size.width + step; x += step) {
      canvas.drawLine(Offset(x + offset, 0), Offset(x + offset + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant PatternTexturePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
