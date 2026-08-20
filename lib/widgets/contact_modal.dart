import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Modal dialog for customer inquiries, VIP bookings, and catering requests.
class ContactModal extends StatefulWidget {
  final String initialService;

  const ContactModal({
    super.key,
    this.initialService = 'Signature Catering & Events',
  });

  static void show(BuildContext context, {String initialService = 'Signature Catering & Events'}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => ContactModal(initialService: initialService),
    );
  }

  @override
  State<ContactModal> createState() => _ContactModalState();
}

class _ContactModalState extends State<ContactModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  late String _selectedService;
  bool _isSubmitting = false;
  bool _isSuccess = false;

  final List<String> _services = [
    'Signature Catering & Events',
    'VIP Table Reservation Pass',
    'Franchise & Culinary Partnership',
    'General Inquiry',
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService;
    if (!_services.contains(_selectedService)) {
      _selectedService = _services.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.all(isMobile ? 24 : 36),
            decoration: BoxDecoration(
              color: AppColors.bgDarkCharcoal,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryFlame.withValues(alpha: 0.2),
                  blurRadius: 35,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: _isSuccess
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFlame,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.primaryFlame.withValues(alpha: 0.4), blurRadius: 15),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Inquiry Sent Successfully! 📨',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.cardTitle(context).copyWith(fontSize: 22, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Thank you, ${_nameController.text.trim()}. Our concierge team has received your message regarding "$_selectedService" and will contact you via email shortly.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryFlame,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Back to Website', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                          ),
                        ),
                      ],
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryFlame.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.mail_outline_rounded, color: AppColors.primaryFlame, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Contact Concierge',
                                    style: AppTextStyles.cardTitle(context).copyWith(color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.white70),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          const Text('Select Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedService,
                            dropdownColor: const Color(0xFF261E18),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF261E18),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primaryFlame)),
                            ),
                            items: _services.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white)))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedService = val);
                            },
                          ),
                          const SizedBox(height: 16),

                          const Text('Full Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your name' : null,
                            decoration: InputDecoration(
                              hintText: 'Enter your full name',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13),
                              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryFlame, size: 18),
                              filled: true,
                              fillColor: const Color(0xFF261E18),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primaryFlame)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                            decoration: InputDecoration(
                              hintText: 'Enter your email address',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13),
                              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryFlame, size: 18),
                              filled: true,
                              fillColor: const Color(0xFF261E18),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primaryFlame)),
                            ),
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryFlame,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 4,
                              ),
                              onPressed: _isSubmitting ? null : _submitForm,
                              child: _isSubmitting
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Send Message ➔', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
