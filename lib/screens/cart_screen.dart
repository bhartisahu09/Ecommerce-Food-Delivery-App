import 'package:delivery_app/providers/location_provider.dart';
import 'package:delivery_app/screens/order_success_screen.dart';
import 'package:delivery_app/screens/payment/payment_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../providers/order_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final provider = Provider.of<OrderProvider>(context);
    final cart = itemProvider.cart;
    final items = itemProvider.items;

    double subtotal = 0.0;
    double discountValue = 0.0;
    double deliveryFee = 0;

    cart.forEach((itemId, qty) {
      final item = items.firstWhere((e) => e.id == itemId);

      // if discount available
      if (item.discount > 0) {
        // subtotal += item.discountedPrice * qty;
        subtotal += item.price * qty;
        discountValue += (item.price - item.discountedPrice) * qty;
      } else {
        subtotal += item.price * qty;
      }
    });

    // free delivery if cart > 500
    if (subtotal > 500) deliveryFee = 0;

    final total = subtotal + deliveryFee - discountValue;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                /// --- CART ITEMS LIST ---
                Expanded(
                  child: ListView(
                    children: cart.entries.map((entry) {
                      final item = items.firstWhere((e) => e.id == entry.key);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl.isNotEmpty
                                    ? item.imageUrl
                                    : 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '₹${(item.discount > 0 ? item.discountedPrice : item.price).toStringAsFixed(2)} x ${entry.value}'),
                                if (item.discount > 0)
                                  Row(
                                    children: [
                                      Text('${item.discount}% OFF',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 11)),
                                      const SizedBox(width: 6),
                                      Text(
                                        '₹${item.price}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color:
                                          Color.fromARGB(255, 112, 112, 112)),
                                  onPressed: () =>
                                      itemProvider.removeFromCart(item.id),
                                ),
                                Text('${entry.value}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color:
                                          Color.fromARGB(255, 112, 112, 112)),
                                  onPressed: () =>
                                      itemProvider.addToCart(item.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => itemProvider
                                      .removeItemCompletely(item.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                /// --- ORDER SUMMARY + ACTIONS ---
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2))
                    ],
                  ),
                  child: Column(
                    children: [
                      /// --- Delivery Section ---
                      Consumer<LocationProvider>(
                        builder: (context, locationProvider, _) {
                          return ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Colors.red),
                            title: Text(
                              locationProvider.currentLocation.isNotEmpty
                                  ? locationProvider.currentLocation
                                  : "Select Your Location",
                              style: TextStyle(
                                color: locationProvider.currentLocation.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final selectedAddress = await Navigator.pushNamed(
                                context,
                                '/location',
                              );

                              if (selectedAddress != null &&
                                  selectedAddress is String) {
                                locationProvider.setLocation(selectedAddress);
                              }
                            },
                          );
                        },
                      ),

                      /// --- Payment Method ---
                      ListTile(
                        leading: const Icon(Icons.account_balance_wallet,
                            color: Colors.redAccent),
                        title: Text(
                          provider.paymentMethod ?? "Select Payment Method",
                          style: TextStyle(
                            color: provider.paymentMethod == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final selectedMethod = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentMethodsScreen(),
                            ),
                          );

                          if (selectedMethod != null) {
                            provider.setPaymentMethod(selectedMethod);
                          }
                        },
                      ),

                      /// --- Promotions ---
                      ListTile(
                        leading:
                            const Icon(Icons.local_offer, color: Colors.red),
                        title: provider.discountPercent == 0.0
                            ? const Text("Select Your Discounts",
                                style: TextStyle(color: Colors.grey))
                            : Row(
                                children: [
                                  if (provider.freeShipping)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: const Text("FREE SHIPPING",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  // if (provider.discountPercent > 0)
                                  //   Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 6, vertical: 2),
                                  //     decoration: BoxDecoration(
                                  //         color: Colors.yellow,
                                  //         borderRadius:
                                  //             BorderRadius.circular(4)),
                                  //     child:
                                  //     Text("${(provider.discountPercent * 100).toInt()}%",
                                  //         // Text('${item.discount}% OFF',
                                  //         style: const TextStyle(
                                  //             fontWeight: FontWeight.bold)),
                                  //   ),
                                ],
                              ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          provider.applyPromotion(
                              freeShip: true, discount: 0.20);
                        },
                      ),

                      const Divider(thickness: 1),

                      /// --- Price Summary ---
                      _priceRow("Subtotal", "₹ ${subtotal.toStringAsFixed(2)}"),
                      _priceRow(
                        "Delivery Fee",
                        deliveryFee == 0
                            ? "FREE"
                            : "₹ ${deliveryFee.toStringAsFixed(2)}",
                      ),
                      _priceRow(
                        "Discount",
                        discountValue == 0
                            ? "—"
                            : "- ₹ ${discountValue.toStringAsFixed(2)}",
                      ),
                      const Divider(thickness: 1),
                      _priceRow("Total", "₹ ${total.toStringAsFixed(2)}",
                          bold: true),

                      const SizedBox(height: 12),

                      /// --- Place Order Button ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹ ${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              //Order data save
                              provider.addOrder(
                                // items: cart.map((id, qty) {
                                //   final item = items.firstWhere((e) => e.id == id);
                                //   return MapEntry(
                                //     item.name,
                                //     {'qty': qty, 'price': item.price},
                                //   );
                                // }),
                                items: cart.entries.map((entry) {
                                  final item = items
                                      .firstWhere((e) => e.id == entry.key);
                                  return {
                                    'name': item.name,
                                    'qty': entry.value,
                                    'price': item.price,
                                  };
                                }).toList(),
                                total: total,
                                subtotal: subtotal.toStringAsFixed(2),
                                imageUrl: items
                                    .firstWhere((e) => e.id == cart.keys.first)
                                    .imageUrl,
                                paymentMethod: provider.paymentMethod ??
                                    'Cash on Delivery',
                                deliveryAddress:
                                    provider.deliveryAddress ?? 'Not specified',
                                discount: discountValue,
                                discountedPrice: subtotal - discountValue,
                              );

                              itemProvider.clearCart();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderSuccessScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Place Order",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _priceRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w400)),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w400)),
        ],
      ),
    );
  }
}
