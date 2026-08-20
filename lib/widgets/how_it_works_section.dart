import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';

/// How It Works Section featuring a 3-step timeline (Order -> Cook -> Deliver)
/// with self-drawing animated connector lines and looping icon micro-animations.
class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection>
    with TickerProviderStateMixin {
  // Looping Icon Animation Controllers
  late AnimationController _orderPulseController;
  late AnimationController _cookSteamController;
  late AnimationController _deliverWheelController;

  @override
  void initState() {
    super.initState();
    // 1. Order Mobile Pulse
    _orderPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // 2. Cook Steam Rotation
    _cookSteamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 3. Delivery Bike Wheel Rotation
    _deliverWheelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _orderPulseController.dispose();
    _cookSteamController.dispose();
    _deliverWheelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 24 : 80,
      ),
      color: AppColors.bgCardSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          ScrollReveal(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'OUR THREE-STEP CULINARY JOURNEY',
                    style: AppTextStyles.eyebrow(context).copyWith(
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'How Freshness Reaches You',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    'From instant AI taste dispatch to Michelin wood-fired cooking and thermal express delivery.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.leadBody(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // 3-Step Timeline
          if (isMobile)
            Column(
              children: [
                _buildStepCard(
                  stepNum: '01',
                  title: 'Instant Order & AI Customization',
                  desc: 'Pick your gourmet dish, adjust spice levels, or customize ingredients in real-time.',
                  widgetIcon: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.1).animate(
                      CurvedAnimation(parent: _orderPulseController, curve: Curves.easeInOut),
                    ),
                    child: const Icon(Icons.touch_app_rounded, color: AppColors.primaryFlame, size: 40),
                  ),
                ),
                const SizedBox(height: 32),
                _buildStepCard(
                  stepNum: '02',
                  title: 'Michelin Master Chef Assembly',
                  desc: 'Hand-kneaded sourdough, seared Beyond smash patties, and 900°F wood-fired baking.',
                  widgetIcon: RotationTransition(
                    turns: Tween<double>(begin: 0, end: 1).animate(_cookSteamController),
                    child: const Icon(Icons.soup_kitchen_rounded, color: AppColors.secondaryGold, size: 40),
                  ),
                ),
                const SizedBox(height: 32),
                _buildStepCard(
                  stepNum: '03',
                  title: 'Sub-30 Min Thermal Express',
                  desc: 'Sealed inside smart induction transport pods to maintain 165°F sizzle to your door.',
                  widgetIcon: RotationTransition(
                    turns: Tween<double>(begin: 0, end: 1).animate(_deliverWheelController),
                    child: const Icon(Icons.two_wheeler_rounded, color: AppColors.forestGreen, size: 40),
                  ),
                ),
              ],
            )
          else
            ScrollReveal(
              delay: const Duration(milliseconds: 150),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Self-drawing connecting line between steps
                  Positioned(
                    top: 60,
                    left: 120,
                    right: 120,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeInOut,
                      builder: (context, val, child) {
                        return CustomPaint(
                          size: const Size(double.infinity, 4),
                          painter: TimelineConnectorPainter(progress: val),
                        );
                      },
                    ),
                  ),

                  // Horizontal Cards Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildStepCard(
                          stepNum: '01',
                          title: 'Instant Order & AI Prep',
                          desc: 'Pick your gourmet dish, adjust spice levels, or customize ingredients in real-time.',
                          widgetIcon: ScaleTransition(
                            scale: Tween<double>(begin: 0.95, end: 1.1).animate(
                              CurvedAnimation(parent: _orderPulseController, curve: Curves.easeInOut),
                            ),
                            child: const Icon(Icons.touch_app_rounded, color: AppColors.primaryFlame, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildStepCard(
                          stepNum: '02',
                          title: 'Michelin Master Assembly',
                          desc: 'Hand-kneaded sourdough, seared Beyond smash patties, and 900°F wood-fired baking.',
                          widgetIcon: RotationTransition(
                            turns: Tween<double>(begin: 0, end: 1).animate(_cookSteamController),
                            child: const Icon(Icons.soup_kitchen_rounded, color: AppColors.secondaryGold, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildStepCard(
                          stepNum: '03',
                          title: 'Sub-30 Min Express Pod',
                          desc: 'Sealed inside smart induction transport pods to maintain 165°F sizzle to your door.',
                          widgetIcon: RotationTransition(
                            turns: Tween<double>(begin: 0, end: 1).animate(_deliverWheelController),
                            child: const Icon(Icons.two_wheeler_rounded, color: AppColors.forestGreen, size: 40),
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
    );
  }

  Widget _buildStepCard({
    required String stepNum,
    required String title,
    required String desc,
    required Widget widgetIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.bgCream,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Center(child: widgetIcon),
              ),
              Text(
                stepNum,
                style: AppTextStyles.heroHeading(context).copyWith(
                  fontSize: 32,
                  color: AppColors.primaryFlame.withValues(alpha: 0.25),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppTextStyles.cardTitle(context).copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              desc,
              style: AppTextStyles.body(context).copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter for self-drawing animated connecting line between timeline steps
class TimelineConnectorPainter extends CustomPainter {
  final double progress;

  TimelineConnectorPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryFlame.withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * progress, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TimelineConnectorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
