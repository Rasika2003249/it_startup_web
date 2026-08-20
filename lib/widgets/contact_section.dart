import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'scroll_reveal.dart';
import 'contact_modal.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 90,
      ),
      child: ScrollReveal(
        child: Container(
          padding: EdgeInsets.all(isMobile ? 28 : 50),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.glassBorder, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0E000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentEmerald.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.headset_mic_rounded, color: AppColors.accentEmerald, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'CONTACT MASTER CHEFS & PRIVATE CATERING',
                      style: AppTextStyles.eyebrow(context).copyWith(
                        color: AppColors.accentEmerald,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Have Custom Dietary Requests or Party Orders?',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionHeading(context).copyWith(fontSize: isMobile ? 24 : 32),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Text(
                  'Our Michelin-trained culinary team crafts bespoke gourmet culinary menus for private events, corporate galas, and custom dining experiences.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.leadBody(context),
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 20,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentEmerald,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      elevation: 4,
                      shadowColor: AppColors.accentEmerald.withValues(alpha: 0.4),
                    ),
                    onPressed: () => ContactModal.show(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Contact Chef Team',
                          style: AppTextStyles.buttonLabel(context).copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(color: AppColors.accentEmerald, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                    ),
                    onPressed: () => ContactModal.show(context, initialService: 'VIP Membership Pass'),
                    child: Text(
                      'Reserve Tasting Table',
                      style: AppTextStyles.buttonLabel(context).copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
