import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double total;
  final String status;
  final String address;
  final String paymentMethod;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String imageUrl;
  final Map<String, double> location;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.orderDate,
    required this.deliveryDate,
    required this.imageUrl,
    required this.location,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      address: map['address'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      deliveryDate: (map['deliveryDate'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'] ?? '',
      location: Map<String, double>.from(map['location'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'total': total,
      'status': status,
      'address': address,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate,
      'deliveryDate': deliveryDate,
      'imageUrl': imageUrl,
      'location': location,
    };
  }
}