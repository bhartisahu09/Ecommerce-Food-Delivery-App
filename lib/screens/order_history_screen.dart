import 'package:delivery_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;
    final locationProvider = Provider.of<LocationProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: orders.isEmpty
          ? const Center(child: Text("No orders placed yet"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final order = orders[i];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order #${order.id}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),

                        Text(
                          "Order placed on ${order.formattedDate}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),

                        /// --- ITEMS INSIDE ORDER ---
                        ...order.items.map<Widget>((item) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imageUrl'] ?? order.imageUrl,
                                  width: 90,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${item['qty'] ?? 0} x ${item['name'] ?? 'Unknown'} = ₹${(item['price'] ?? 0) * (item['qty'] ?? 0)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              if (item['discount'] != null &&
                                  item['discount'] > 0)
                                Text(
                                  '${item['discount']}% OFF',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 11,
                                  ),
                                ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  final itemId = item['id']?.toString();
                                  if (itemId != null) {
                                    orderProvider.removeItemFromOrder(
                                        order.id, itemId);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Item ID not found, cannot delete!")),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        }).toList(),

                        const Divider(),
                        Text("Total: ₹${order.total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),

                        Text(
                          locationProvider.currentLocation != null
                              ? "Location: ${locationProvider.currentLocation}"
                              : "Location: Not available",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Text("Payment: ${order.paymentMethod}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            )),

                        Text("Order status: Pending",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
