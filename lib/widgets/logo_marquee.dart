import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class LogoMarquee extends StatefulWidget {
  const LogoMarquee({super.key});

  @override
  State<LogoMarquee> createState() => _LogoMarqueeState();
}

class _LogoMarqueeState extends State<LogoMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<String> _partners = const [
    '⭐ MICHELIN GUIDE',
    '🏆 FORBES GOURMET',
    '🔥 CHEF TABLE TV',
    '🥗 FARM FRESH DIRECT',
    '⚡ CLOUD KITCHEN CO',
    '🌱 ZERO WASTE EARTH',
    '🚀 TECHCRUNCH FOOD',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doubleList = [..._partners, ..._partners, ..._partners, ..._partners];

    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final offset = _controller.value * (totalWidth * 0.5);

                return Transform.translate(
                  offset: Offset(-offset, 0),
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: doubleList.map((partner) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Center(
                            child: Text(
                              partner,
                              style: AppTextStyles.body(context).copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary.withValues(alpha: 0.8),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
