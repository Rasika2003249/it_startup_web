import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  final List<Map<String, dynamic>> _techShowcase = const [
    {
      'title': 'Smart Thermal Induction Pods',
      'category': 'HARDWARE TECH',
      'description':
          'Proprietary wireless induction packaging that maintains precise dish serving temperatures (165°F hot / 38°F chilled) during courier travel.',
      'metrics': '165°F Thermal Stability • 0% Condensation',
      'icon': Icons.thunderstorm_rounded,
      'details':
          'Our thermal pods feature smart IoT temperature sensors connected to couriers’ vehicles, ensuring your wood-fired pizzas stay crispy and smoothies stay icy cold.',
    },
    {
      'title': 'Farm-to-Kitchen Direct Supply',
      'category': 'SUSTAINABILITY',
      'description':
          'Automated daily ingredient sourcing from certified local organic farms within a 50-mile radius of each cloud kitchen hub.',
      'metrics': '100% Non-GMO Organic • Harvested Daily',
      'icon': Icons.agriculture_rounded,
      'details':
          'We eliminate middle-man storage facilities. Organic farm produce and fresh herbs are harvested at 4 AM and delivered straight to our kitchen stations by 7 AM.',
    },
    {
      'title': 'AI Zero-Waste Engine',
      'category': 'SOFTWARE & DATA',
      'description':
          'Machine learning demand forecasting that predicts hourly neighborhood appetite patterns to reduce food waste to less than 0.2%.',
      'metrics': '99.8% Waste Reduction • Real-time Demand AI',
      'icon': Icons.psychology_rounded,
      'details':
          'By analyzing micro-weather, sports events, and regional ordering history, our AI engine prepares precise batch prep counts to guarantee freshness.',
    },
    {
      'title': '100% Bio-Degradable Eco Packaging',
      'category': 'ECO SYSTEM',
      'description':
          'Eco-friendly organic fiber containers and sugarcane straw cutlery that naturally compost in under 45 days.',
      'metrics': '0% Single-Use Plastic • 45-Day Compostable',
      'icon': Icons.eco_rounded,
      'details':
          'Every container is manufactured without toxic PFAS coating, offering a 100% leak-proof experience while protecting our planet.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: AppColors.bgCard,
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
                  child: Text('PROPRIETARY KITCHEN TECH', style: AppTextStyles.eyebrow(context)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Engineering the Future of Food Delivery',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Text(
                    'Explore how our patent-pending thermal hardware and AI algorithms revolutionize food quality.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.leadBody(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Tech Showcase Grid
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  children: _techShowcase.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _TechCard(tech: item),
                    );
                  }).toList(),
                );
              }

              final itemWidth = (constraints.maxWidth - 24) / 2;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: _techShowcase.map((item) {
                  return SizedBox(
                    width: itemWidth,
                    child: _TechCard(tech: item),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TechCard extends StatefulWidget {
  final Map<String, dynamic> tech;

  const _TechCard({required this.tech});

  @override
  State<_TechCard> createState() => _TechCardState();
}

class _TechCardState extends State<_TechCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.tech['title'] as String;
    final category = widget.tech['category'] as String;
    final description = widget.tech['description'] as String;
    final metrics = widget.tech['metrics'] as String;
    final icon = widget.tech['icon'] as IconData;
    final details = widget.tech['details'] as String;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(minHeight: 280),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.bgCardHover : AppColors.bgDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? AppColors.primaryFlame : AppColors.glassBorder,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.primaryFlame.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Icon(icon, color: AppColors.primaryFlame, size: 26),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentEmber.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.eyebrow(context).copyWith(
                          fontSize: 11,
                          color: AppColors.accentEmber,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: AppTextStyles.cardTitle(context).copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: AppTextStyles.body(context),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.accentEmerald, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          metrics,
                          style: AppTextStyles.body(context).copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    _showDetailsModal(context, title, category, details, metrics);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Read Tech Specs',
                        style: AppTextStyles.buttonLabel(context).copyWith(
                          color: _isHovered ? AppColors.primaryFlame : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _isHovered ? AppColors.primaryFlame : AppColors.textSecondary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsModal(
    BuildContext context,
    String title,
    String category,
    String details,
    String metrics,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryFlame.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.biotech_rounded, color: AppColors.primaryFlame, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTextStyles.cardTitle(context))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: AppTextStyles.eyebrow(context).copyWith(fontSize: 12)),
            const SizedBox(height: 12),
            Text(details, style: AppTextStyles.body(context)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Text(metrics, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryFlame)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryFlame, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
