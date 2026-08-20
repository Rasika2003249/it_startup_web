import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Multi-column Footer Section with brand blurb, quick navigation links,
/// contact details, social media icons, and an interactive newsletter signup with animated submit button.
class FooterSection extends StatefulWidget {
  final Function(int index) onNavTap;

  const FooterSection({
    super.key,
    required this.onNavTap,
  });

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  final TextEditingController _newsletterController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubscribed = false;

  @override
  void dispose() {
    _newsletterController.dispose();
    super.dispose();
  }

  void _handleSubscribe() async {
    final email = _newsletterController.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSubscribed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 24 : 80,
      ),
      color: AppColors.bgDarkCharcoal,
      child: Column(
        children: [
          // Main Columns
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandBlurb(context),
                const SizedBox(height: 36),
                _buildQuickLinks(context),
                const SizedBox(height: 36),
                _buildContactInfo(context),
                const SizedBox(height: 36),
                _buildNewsletter(context),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 3, child: _buildBrandBlurb(context)),
                const SizedBox(width: 40),
                Expanded(flex: 2, child: _buildQuickLinks(context)),
                const SizedBox(width: 40),
                Expanded(flex: 3, child: _buildContactInfo(context)),
                const SizedBox(width: 40),
                Expanded(flex: 4, child: _buildNewsletter(context)),
              ],
            ),
          const SizedBox(height: 60),

          const Divider(color: AppColors.borderDark, height: 1),
          const SizedBox(height: 30),

          // Bottom Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 VELORA — Taste, Reimagined. All rights reserved.',
                style: AppTextStyles.body(context).copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              Row(
                children: const [
                  Text('Privacy Policy', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  SizedBox(width: 16),
                  Text('Terms of Service', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandBlurb(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryFlame,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'VELORA',
              style: AppTextStyles.cardTitle(context).copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Michelin-crafted artisanal gourmet delivery. Delivered in under 30 minutes in smart thermal pods.',
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildSocialIcon(Icons.camera_alt_rounded),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.share_rounded),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.play_circle_fill_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.borderDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white70, size: 18),
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK LINKS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _buildLinkItem('Menu Showcase', () => widget.onNavTap(1)),
        _buildLinkItem('Featured Dishes', () => widget.onNavTap(2)),
        _buildLinkItem('How It Works', () => widget.onNavTap(3)),
        _buildLinkItem('Impact & Stats', () => widget.onNavTap(4)),
        _buildLinkItem('Reviews', () => widget.onNavTap(5)),
      ],
    );
  }

  Widget _buildLinkItem(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONTACT & LOCATION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Icon(Icons.location_on_rounded, color: AppColors.primaryFlame, size: 16),
            SizedBox(width: 8),
            Text('742 Gourmet Ave, Culinary District', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Icon(Icons.phone_rounded, color: AppColors.secondaryGold, size: 16),
            SizedBox(width: 8),
            Text('+1 (800) VELORA-FINE', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Icon(Icons.email_rounded, color: AppColors.primaryFlame, size: 16),
            SizedBox(width: 8),
            Text('concierge@velora.com', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildNewsletter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VIP GOURMET NEWSLETTER',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Subscribe for weekly secret chef menu drops & 20% off perks.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _isSubscribed
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.forestGreen),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_rounded, color: AppColors.forestGreen, size: 20),
                    SizedBox(width: 10),
                    Text('Subscribed! Welcome to VIP Club 🎉', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newsletterController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter your email address...',
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        filled: true,
                        fillColor: AppColors.borderDark,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryFlame,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onPressed: _isSubmitting ? null : _handleSubscribe,
                    child: _isSubmitting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
      ],
    );
  }
}
