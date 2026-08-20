import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  final List<Map<String, dynamic>> _steps = const [
    {
      'step': '01',
      'title': 'AI Taste Personalization',
      'description':
          'Select your favorite cuisine profile or let our AI analyze your nutritional goals and spice preferences.',
      'icon': Icons.auto_awesome_rounded,
    },
    {
      'step': '02',
      'title': 'Master Chef Prep',
      'description':
          'Michelin-trained chefs execute your order live using fresh organic, locally harvested non-GMO ingredients.',
      'icon': Icons.soup_kitchen_rounded,
    },
    {
      'step': '03',
      'title': 'Thermal Pod Transport',
      'description':
          'Your food is sealed inside temperature-controlled induction pods that maintain exact serving heat during transit.',
      'icon': Icons.electric_bolt_rounded,
    },
    {
      'step': '04',
      'title': 'Instant Doorstep Feast',
      'description':
          'Unbox hot, piping-fresh gourmet dishes in under 15 minutes guaranteed with zero moisture loss.',
      'icon': Icons.verified_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.bgDark,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 100,
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
                    color: AppColors.primaryFlame.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('THE EPICUREX JOURNEY', style: AppTextStyles.eyebrow(context)),
                ),
                const SizedBox(height: 16),
                Text(
                  '4 Steps to Culinary Perfection',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Text(
                    'From kitchen prep to doorstep delivery, every second is optimized for maximum freshness and flavor.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.leadBody(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // 4-Step Cards Row / Column
          if (isMobile)
            Column(
              children: List.generate(_steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: index * 100),
                    child: _StepCard(stepData: _steps[index]),
                  ),
                );
              }),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - (20 * 3)) / 4;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_steps.length, (index) {
                    return Container(
                      width: cardWidth,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : 20),
                      child: ScrollReveal(
                        delay: Duration(milliseconds: index * 100),
                        child: _StepCard(stepData: _steps[index]),
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

class _StepCard extends StatefulWidget {
  final Map<String, dynamic> stepData;

  const _StepCard({required this.stepData});

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final step = widget.stepData['step'] as String;
    final title = widget.stepData['title'] as String;
    final description = widget.stepData['description'] as String;
    final icon = widget.stepData['icon'] as IconData;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(minHeight: 280),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.bgCardHover : AppColors.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? AppColors.primaryFlame : AppColors.glassBorder,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.primaryFlame.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 6),
              )
            else
              const BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFlame.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryFlame,
                    size: 26,
                  ),
                ),
                Text(
                  step,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _isHovered
                        ? AppColors.primaryFlame
                        : AppColors.textMuted.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(context).copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: AppTextStyles.body(context).copyWith(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
