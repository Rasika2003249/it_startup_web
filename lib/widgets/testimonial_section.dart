import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';

/// Testimonial Section with auto-rotating carousel of customer quotes,
/// smooth crossfade transitions, and 5-star rating that animates star-by-star.
class TestimonialSection extends StatefulWidget {
  const TestimonialSection({super.key});

  @override
  State<TestimonialSection> createState() => _TestimonialSectionState();
}

class _TestimonialSectionState extends State<TestimonialSection> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, String>> _reviews = const [
    {
      'quote':
          '“Velora has set a new benchmark for fine dining. The Truffle Burrata sourdough pizza arrived at 165°F in a thermal pod, tasting like it came straight out of a 900°F Naples oven!”',
      'author': 'Chef Elena Rostova',
      'role': 'Michelin 3-Star Culinary Critic',
      'avatar': '👩‍🍳',
    },
    {
      'quote':
          '“As a gourmet food enthusiast, the Avocado Truffle Smash Burger blew me away. Watching the live 4K chef prep video before ordering makes the whole experience feel like high-end dining.”',
      'author': 'Marcus Vance',
      'role': 'Gourmet Today Magazine',
      'avatar': '👨‍💼',
    },
    {
      'quote':
          '“Sub-15 minute delivery with zero compromise on artisanal quality. The Almond Pesto Quinoa Power Bowl is now my daily go-to lunch!”',
      'author': 'Sophia Chen',
      'role': 'Food & Tech Editor',
      'avatar': '👩‍💻',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-rotate reviews every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _reviews.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScrollReveal(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CRITICS & GOURMET LOVERS',
                    style: AppTextStyles.eyebrow(context).copyWith(
                      color: AppColors.secondaryGold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Wall of Michelin Praise',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeading(context),
                ),
                const SizedBox(height: 24),

                // Star-by-Star Animated 5-Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (starIndex) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (starIndex * 150)),
                      curve: Curves.elasticOut,
                      builder: (context, val, child) {
                        return Transform.scale(
                          scale: val,
                          child: const Icon(
                            Icons.star_rounded,
                            color: AppColors.secondaryGold,
                            size: 28,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Auto-rotating Carousel Container with Crossfade Transition
          ScrollReveal(
            delay: const Duration(milliseconds: 150),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, anim) {
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<int>(_currentIndex),
                  padding: EdgeInsets.all(isMobile ? 28 : 44),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.borderLight, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _reviews[_currentIndex]['quote']!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardTitle(context).copyWith(
                          fontSize: isMobile ? 18 : 24,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.bgCream,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Text(
                              _reviews[_currentIndex]['avatar']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _reviews[_currentIndex]['author']!,
                                style: AppTextStyles.body(context).copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _reviews[_currentIndex]['role']!,
                                style: AppTextStyles.body(context).copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Carousel Indicators (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_reviews.length, (idx) {
              final isActive = _currentIndex == idx;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 28 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primaryFlame : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
