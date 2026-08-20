import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'cart_drawer.dart';

/// Interactive modal dialog for ordering signature dishes and reserving table seats.
class OrderModal extends StatefulWidget {
  final String initialDish;

  const OrderModal({
    super.key,
    this.initialDish = 'Burger',
  });

  static void show(BuildContext context, {String initialDish = 'Burger'}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.70),
      builder: (context) => OrderModal(initialDish: initialDish),
    );
  }

  @override
  State<OrderModal> createState() => _OrderModalState();
}

class _OrderModalState extends State<OrderModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  late String _selectedDish;
  String _orderType = '🚚 Express Thermal Delivery'; // Delivery vs Table Booking
  String _selectedPortion = 'Single Portion';
  String _guestSeats = '2 Guests';
  String _reservationTime = '8:00 PM Today';
  bool _isSubmitting = false;
  bool _isSuccess = false;

  // Strictly our 4 Special Dishes: Burger, Pizza, Sandwich, Donut
  final List<String> _dishes = [
    'Burger',
    'Pizza',
    'Sandwich',
    'Donut',
  ];

  final List<String> _orderTypes = [
    '🚚 Express Thermal Delivery',
    '🍽️ Reserve Table & Dine-In',
  ];

  final List<String> _portions = [
    'Single Portion',
    'Gourmet Duo (+50%)',
    'Party Feast Pack (+120%)',
  ];

  final List<String> _seatOptions = [
    '1 Guest',
    '2 Guests',
    '4 Guests',
    '6+ VIP Table',
  ];

  final List<String> _timeSlots = [
    '7:00 PM Today',
    '8:00 PM Today',
    '9:00 PM Today',
    '1:00 PM Tomorrow',
  ];

  @override
  void initState() {
    super.initState();
    final initLower = widget.initialDish.toLowerCase();
    if (initLower.contains('burger')) {
      _selectedDish = 'Burger';
    } else if (initLower.contains('pizza')) {
      _selectedDish = 'Pizza';
    } else if (initLower.contains('sandwich')) {
      _selectedDish = 'Sandwich';
    } else if (initLower.contains('donut')) {
      _selectedDish = 'Donut';
    } else {
      _selectedDish = 'Burger';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      double itemPrice = 18.99;
      IconData itemIcon = Icons.lunch_dining_rounded;

      if (_selectedDish == 'Burger') {
        itemPrice = 18.99;
        itemIcon = Icons.lunch_dining_rounded;
      } else if (_selectedDish == 'Pizza') {
        itemPrice = 19.99;
        itemIcon = Icons.local_pizza_rounded;
      } else if (_selectedDish == 'Sandwich') {
        itemPrice = 15.99;
        itemIcon = Icons.bakery_dining_rounded;
      } else if (_selectedDish == 'Donut') {
        itemPrice = 12.00;
        itemIcon = Icons.cake_rounded;
      }

      // Add to CartManager so top navbar cart badge updates in real time!
      CartManager.addItem(_selectedDish, itemPrice, itemIcon);

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
            constraints: const BoxConstraints(maxWidth: 620),
            padding: EdgeInsets.all(isMobile ? 20 : 36),
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
              child: _isSuccess ? _buildSuccessView(context) : _buildFormView(context, isMobile),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    final isTableBooking = _orderType.contains('Reserve Table');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryFlame,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFlame.withValues(alpha: 0.4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Icon(
            isTableBooking ? Icons.event_seat_rounded : Icons.restaurant_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isTableBooking ? 'Table Reserved & Chef Preparing! 🥂' : 'Chef Cooking Your Order! 👨‍🍳',
          textAlign: TextAlign.center,
          style: AppTextStyles.cardTitle(context).copyWith(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          isTableBooking
              ? 'Reservation confirmed for ${_nameController.text.trim()} for $_guestSeats at $_reservationTime. Your dish ($_selectedDish) will be served hot upon arrival!'
              : 'Order confirmed for ${_nameController.text.trim()}. Your dish ($_selectedDish) has been added to your cart and will be dispatched in a smart thermal pod. ETA: ~14 Mins.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body(context).copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF261E18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(
                isTableBooking ? Icons.table_restaurant_rounded : Icons.timer_rounded,
                color: AppColors.secondaryGold,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTableBooking ? 'VIP Seat Reservation Active' : 'Live Pod Tracking Active',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isTableBooking ? 'Table for $_guestSeats • $_reservationTime' : 'Delivering to: ${_addressController.text.trim()}',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primaryFlame,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back to Menu',
              style: AppTextStyles.buttonLabel(context).copyWith(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormView(BuildContext context, bool isMobile) {
    final isTableBooking = _orderType.contains('Reserve Table');

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryFlame.withValues(alpha: 0.35),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Order Food',
                    style: AppTextStyles.cardTitle(context).copyWith(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Delivery vs Table Booking Toggle
          Row(
            children: _orderTypes.map((type) {
              final isSelected = _orderType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _orderType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryFlame : const Color(0xFF261E18),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryFlame : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Select Dish Dropdown (Burger, Pizza, Sandwich, Donut)
          _buildDishDropdown(context),
          const SizedBox(height: 18),

          // If Table Booking selected -> Show Seat Count & Time Pickers
          if (isTableBooking) ...[
            const Text(
              'Select Total Seats / Guests',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _seatOptions.map((seat) {
                final isSelected = _guestSeats == seat;
                return ChoiceChip(
                  label: Text(seat),
                  selected: isSelected,
                  selectedColor: AppColors.primaryFlame,
                  backgroundColor: const Color(0xFF261E18),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryFlame : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _guestSeats = seat);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Text(
              'Reservation Date & Time Slot',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final isSelected = _reservationTime == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: AppColors.secondaryGold,
                  backgroundColor: const Color(0xFF261E18),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.secondaryGold : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _reservationTime = slot);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ] else ...[
            // Portion Size Pills for Delivery
            const Text(
              'Portion Size',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _portions.map((portion) {
                final isSelected = _selectedPortion == portion;
                return ChoiceChip(
                  label: Text(portion),
                  selected: isSelected,
                  selectedColor: AppColors.primaryFlame,
                  backgroundColor: const Color(0xFF261E18),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryFlame : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedPortion = portion);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Name & Email
          if (isMobile) ...[
            _buildTextField('Full Name', _nameController, 'Enter your name', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildTextField('Email Address', _emailController, 'Enter email for receipt', Icons.email_outlined, isEmail: true),
          ] else
            Row(
              children: [
                Expanded(child: _buildTextField('Full Name', _nameController, 'Enter your name', Icons.person_outline_rounded)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Email Address', _emailController, 'Enter email for receipt', Icons.email_outlined, isEmail: true)),
              ],
            ),
          const SizedBox(height: 16),

          // Delivery Address or Table Notes
          _buildTextField(
            isTableBooking ? 'Special Table Seating Requests' : 'Delivery Address',
            _addressController,
            isTableBooking ? 'e.g. Window booth, anniversary table...' : 'Enter street address & apartment unit',
            isTableBooking ? Icons.event_seat_rounded : Icons.location_on_outlined,
            requiredField: !isTableBooking,
          ),
          const SizedBox(height: 16),

          // Special Instructions
          _buildTextField(
            'Dietary Preferences / Chef Notes',
            _notesController,
            'e.g. Extra spicy, extra sauce...',
            Icons.notes_rounded,
            maxLines: 2,
            requiredField: false,
          ),
          const SizedBox(height: 28),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryFlame,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
                shadowColor: AppColors.primaryFlame.withValues(alpha: 0.4),
              ),
              onPressed: _isSubmitting ? null : _submitOrder,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isTableBooking ? 'Confirm Seat Reservation & Order' : 'Place Instant Order',
                          style: AppTextStyles.buttonLabel(context).copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isEmail = false,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          validator: (value) {
            if (!requiredField) return null;
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            if (isEmail && (!value.contains('@') || !value.contains('.'))) {
              return 'Enter a valid email address';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.primaryFlame, size: 18),
            filled: true,
            fillColor: const Color(0xFF261E18),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primaryFlame),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDishDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Dish',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _selectedDish,
          dropdownColor: const Color(0xFF261E18),
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.restaurant_menu_rounded, color: AppColors.primaryFlame, size: 18),
            filled: true,
            fillColor: const Color(0xFF261E18),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primaryFlame),
            ),
          ),
          items: _dishes.map((dish) {
            return DropdownMenuItem(
              value: dish,
              child: Text(
                dish,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedDish = val);
            }
          },
        ),
      ],
    );
  }
}
