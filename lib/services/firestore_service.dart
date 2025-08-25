import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/item_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User CRUD
  Future<void> createUser(UserModel user) async {
    // TODO: Implement create user
  }

  Future<UserModel?> getUser(String userId) async {
    // TODO: Implement get user
  }

  // Item CRUD
  Future<List<ItemModel>> getItems() async {
    // For now, return an empty list to avoid returning null
    return [];
  }

  // Order CRUD
  Future<void> createOrder(OrderModel order) async {
    // TODO: Implement create order
  }

  Future<List<OrderModel>> getOrders(String userId) async {
    // TODO: Implement get orders
    // For now, return an empty list to avoid returning null
    return [];
  }
}