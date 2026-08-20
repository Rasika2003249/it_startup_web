import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'order_modal.dart';

/// Global Cart State Manager
class CartManager {
  static final ValueNotifier<List<Map<String, dynamic>>> cartItemsNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([
    {
      'title': 'Pizza',
      'price': 19.99,
      'quantity': 1,
      'image': Icons.local_pizza_rounded,
    },
    {
      'title': 'Burger',
      'price': 18.99,
      'quantity': 1,
      'image': Icons.lunch_dining_rounded,
    },
    {
      'title': 'Donut',
      'price': 12.00,
      'quantity': 2,
      'image': Icons.bakery_dining_rounded,
    },
  ]);

  static List<Map<String, dynamic>> get items => cartItemsNotifier.value;

  static int get totalItemCount {
    int total = 0;
    for (var item in cartItemsNotifier.value) {
      total += (item['quantity'] as int);
    }
    return total;
  }

  static double get totalAmount {
    double total = 0.0;
    for (var item in cartItemsNotifier.value) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }

  static void addItem(String title, double price, IconData icon) {
    final currentList = List<Map<String, dynamic>>.from(cartItemsNotifier.value);
    final existingIndex = currentList.indexWhere((item) => item['title'] == title);

    if (existingIndex >= 0) {
      currentList[existingIndex]['quantity'] =
          (currentList[existingIndex]['quantity'] as int) + 1;
    } else {
      currentList.add({
        'title': title,
        'price': price,
        'quantity': 1,
        'image': icon,
      });
    }
    cartItemsNotifier.value = currentList;
  }

  static void updateQuantity(int index, int delta) {
    final currentList = List<Map<String, dynamic>>.from(cartItemsNotifier.value);
    if (index >= 0 && index < currentList.length) {
      final newQty = (currentList[index]['quantity'] as int) + delta;
      if (newQty <= 0) {
        currentList.removeAt(index);
      } else {
        currentList[index]['quantity'] = newQty;
      }
      cartItemsNotifier.value = currentList;
    }
  }

  static void clear() {
    cartItemsNotifier.value = [];
  }
}

/// Interactive Slide-Over Shopping Cart Drawer styled matching the luxury dark brand theme.
class CartDrawer extends StatefulWidget {
  const CartDrawer({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'CartDrawer',
      barrierColor: Colors.black.withValues(alpha: 0.65),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, anim1, anim2) => const CartDrawer(),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  @override
  State<CartDrawer> createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  final TextEditingController _promoController = TextEditingController();
  bool _discountApplied = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final drawerWidth = isMobile ? width * 0.90 : 440.0;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: drawerWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgDarkCharcoal, // Deep luxury dark theme matching website background
            border: Border(left: BorderSide(color: AppColors.primaryFlame.withValues(alpha: 0.3), width: 1.5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 40,
                offset: Offset(-10, 0),
              ),
            ],
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: CartManager.cartItemsNotifier,
              builder: (context, cartItems, child) {
                final rawSubtotal = CartManager.totalAmount;
                final discount = _discountApplied ? rawSubtotal * 0.20 : 0.0;
                final finalTotal = rawSubtotal - discount;
                const freeDeliveryThreshold = 50.0;
                final progress = (rawSubtotal / freeDeliveryThreshold).clamp(0.0, 1.0);

                return Padding(
                  padding: EdgeInsets.all(isMobile ? 20 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

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
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryFlame.withValues(alpha: 0.35),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Your Gourmet Cart',
                                style: AppTextStyles.cardTitle(context).copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: -0.3,
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

                      // Free Delivery Progress Bar (Crisp Light Text on Dark Card)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF261E18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  progress >= 1.0 ? Icons.check_circle_rounded : Icons.local_shipping_rounded,
                                  color: progress >= 1.0 ? AppColors.secondaryGold : AppColors.primaryFlame,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    progress >= 1.0
                                        ? '🎉 FREE Express Thermal Delivery Unlocked!'
                                        : 'Add \$${(freeDeliveryThreshold - rawSubtotal).toStringAsFixed(2)} for FREE Express Delivery',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: progress >= 1.0 ? AppColors.secondaryGold : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                color: AppColors.primaryFlame,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Cart Items List
                      Expanded(
                        child: cartItems.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.remove_shopping_cart_rounded, color: Colors.white38, size: 44),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Your cart is empty', style: AppTextStyles.cardTitle(context).copyWith(fontSize: 18, color: Colors.white)),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Explore our gourmet menu and add meals!',
                                      style: AppTextStyles.body(context).copyWith(fontSize: 13, color: Colors.white60),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];
                                  final title = item['title'] as String;
                                  final price = item['price'] as double;
                                  final qty = item['quantity'] as int;
                                  final icon = item['image'] as IconData;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF261E18),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                      boxShadow: const [
                                        BoxShadow(color: Color(0x1A000000), blurRadius: 10),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Item Icon Thumbnail
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryFlame.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: AppColors.primaryFlame.withValues(alpha: 0.3)),
                                          ),
                                          child: Icon(icon, color: AppColors.primaryFlame, size: 22),
                                        ),
                                        const SizedBox(width: 12),

                                        // Title & Price
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  height: 1.2,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${(price * qty).toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.secondaryGold,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Quantity Controls (- 1 +)
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => CartManager.updateQuantity(index, -1),
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.08),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.remove_rounded, color: Colors.white70, size: 16),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(
                                                '$qty',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => CartManager.updateQuantity(index, 1),
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primaryFlame,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Promo Code Box
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Enter Promo (e.g. EPICURE20)',
                                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 12),
                                filled: true,
                                fillColor: const Color(0xFF261E18),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryFlame,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              elevation: 2,
                            ),
                            onPressed: () {
                              if (_promoController.text.trim().toUpperCase() == 'EPICURE20') {
                                setState(() => _discountApplied = true);
                              }
                            },
                            child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      if (_discountApplied)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            '🎉 20% VIP Promo Applied!',
                            style: TextStyle(color: AppColors.secondaryGold, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Subtotal Summary & Checkout Button
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF261E18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                Text('\$${rawSubtotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                              ],
                            ),
                            if (_discountApplied)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('20% VIP Discount', style: TextStyle(color: AppColors.secondaryGold, fontSize: 14)),
                                    Text('-\$${discount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.secondaryGold, fontWeight: FontWeight.w700, fontSize: 14)),
                                  ],
                                ),
                              ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(color: Colors.white12, height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                                Text(
                                  '\$${finalTotal.toStringAsFixed(2)}',
                                  style: AppTextStyles.heroHeading(context).copyWith(
                                    fontSize: 24,
                                    color: AppColors.secondaryGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryFlame,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 6,
                                  shadowColor: AppColors.primaryFlame.withValues(alpha: 0.4),
                                ),
                                onPressed: cartItems.isEmpty
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                        OrderModal.show(context);
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Proceed to Checkout',
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
