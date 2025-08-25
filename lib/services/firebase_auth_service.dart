// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    // Dummy method, does nothing
    return null;
  }

  Future<UserModel?> signup(String name, String email, String password) async {
    // Dummy method, does nothing
    return null;
  }

  Future<void> logout() async {
    // Dummy method, does nothing
  }

  // User? get currentUser => _auth.currentUser;
}