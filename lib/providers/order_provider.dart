import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'package:intl/intl.dart';

/// Order Model
class Order {
  final String id;
  final List<Map<String, dynamic>>
      items; // [{id, name, qty, price, subtotal, imageUrl}]
  final double total;
  final DateTime date;
  final String address;
  final String subtotal;
  final String imageUrl; 
  final String paymentMethod;
  final double? discount; 
  final double? discountedPrice;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.address,
    required this.subtotal,
    required this.imageUrl,
    required this.paymentMethod,
    this.discount,
    this.discountedPrice = 0.0,
  });

  DateTime now = DateTime.now();

  String get formattedDate => DateFormat("d MMM yyyy, h:mma").format(now);
}

class OrderProvider with ChangeNotifier {
  //CART
  final Map<String, int> _cart = {}; // itemId -> quantity
  Map<String, int> get cart => _cart;

  //ORDERS
  final List<Order> _orders = [];
  List<Order> get orders => _orders;

  //Checkout Details
  String? deliveryAddress;
  String? paymentMethod;
  bool freeShipping = false;
  double discountPercent = 0.0;

  // --- CART MANAGEMENT ---
  void addToCart(String itemId) {
    _cart.update(itemId, (qty) => qty + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    if (_cart.containsKey(itemId)) {
      if (_cart[itemId]! > 1) {
        _cart[itemId] = _cart[itemId]! - 1;
      } else {
        _cart.remove(itemId);
      }
      notifyListeners();
    }
  }

  void removeItemCompletely(String itemId) {
    _cart.remove(itemId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // --- PROMOTIONS ---
  void setAddress(String address) {
    deliveryAddress = address;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  void applyPromotion({bool freeShip = false, double discount = 0.0}) {
    freeShipping = freeShip;
    discountPercent = discount;
    notifyListeners();
  }

  // --- PRICE CALCULATION ---
  double calculateSubtotal(List<ItemModel> items) {
    double subtotal = 0.0;
    _cart.forEach((itemId, qty) {
      final item = items.firstWhere((e) => e.id == itemId);
      //subtotal += (item.price) * qty;
      subtotal += (item.discount > 0 ? item.discountedPrice : item.price) * qty;
    });
    return subtotal;
  }

  double calculateDiscount(List<ItemModel> items) {
    double discountValue = 0.0;
    _cart.forEach((itemId, qty) {
      final item = items.firstWhere((e) => e.id == itemId);
      if (item.discount > 0) {
        discountValue += (item.price - item.discountedPrice) * qty;
      }
    });
    // promotion discount
    discountValue += calculateSubtotal(items) * discountPercent;
    return discountValue;
  }

  double calculateDeliveryFee(double subtotal) {
    return (subtotal > 500 || freeShipping) ? 0.0 : 50.0;
  }

  double calculateTotal(List<ItemModel> items) {
    final subtotal = calculateSubtotal(items);
    final discount = calculateDiscount(items);
    final delivery = calculateDeliveryFee(subtotal);
    return subtotal - discount + delivery;
  }

  // --- PLACE ORDER ---
  void placeOrder(List<ItemModel> items) {
    if (_cart.isEmpty || deliveryAddress == null || paymentMethod == null)
      return;

    final orderItems = _cart.entries.map((entry) {
      final item = items.firstWhere((e) => e.id == entry.key);
      return {
        "id": item.id,
        "name": item.name,
        "qty": entry.value,
        "price": (item.discount > 0 ? item.discountedPrice : item.price),
        // "imageUrl": item.imageUrl,
        "imageUrl": (item.imageUrl.isNotEmpty)
            ? item.imageUrl
            : "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80",
        "subtotal": (item.discount > 0 ? item.discountedPrice : item.price) *
            entry.value,
        "discount": item.discount,
        "discountedPrice": item.discountedPrice,
      };
    }).toList();

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: orderItems,
      total: calculateTotal(items),
      date: DateTime.now(),
      address: deliveryAddress!,
      subtotal: calculateSubtotal(items).toStringAsFixed(2),
      imageUrl:
          items.isNotEmpty ? items.first.imageUrl : '', // Use first item's
      paymentMethod: paymentMethod!,
      discount: calculateDiscount(items),
      discountedPrice:
          (calculateSubtotal(items) - calculateDiscount(items)) ?? 0.0,
    );

    _orders.insert(0, order); 
    clearCart();
    notifyListeners();
  }

  void addOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String subtotal,
    required String deliveryAddress,
    required String paymentMethod,
    required String imageUrl,
    required double discount,
    required double discountedPrice,
  }) {
    final processedItems = items.map((e) {
      return {
        'id': e['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'name': e['name'],
        'qty': e['qty'],
        'price': e['price'],
      };
    }).toList();

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: processedItems,
      total: total,
      date: DateTime.now(),
      address: deliveryAddress,
      subtotal: subtotal,
      imageUrl: imageUrl,
      paymentMethod: paymentMethod,
      discount: discount,
      discountedPrice: discountedPrice,
    );

    _orders.add(order);
    notifyListeners();
  }

  ///Cart Clear
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  void removeItemFromOrder(String orderId, String itemId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);

    if (orderIndex != -1) {
      final order = _orders[orderIndex];

      order.items.removeWhere((item) => item['id'] == itemId);

      if (order.items.isEmpty) {
        _orders.removeAt(orderIndex);
      }

      notifyListeners();
    } else {
      print("Order ID not found!");
    }
  }
}
