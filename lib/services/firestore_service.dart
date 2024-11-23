import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masiha_user/models/user_model.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> storeUserData({
    required String fullName,
    required int age,
    required DateTime dateOfBirth,
    required String email,
    required String gender,
  }) async {
    try {
      final String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        print('Error: No authenticated user found');
        return false;
      }

      final UserModel user = UserModel(
        fullName: fullName,
        age: age,
        dateOfBirth: dateOfBirth,
        email: email,
        gender: gender,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('Storing user data: ${user.toMap()}'); // Debug log

      await _firestore.collection('users').doc(userId).set(user.toMap());
      print('User data successfully stored in Firestore');

      return true;
    } catch (e, stackTrace) {
      print('Error storing user data: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  // Fetch user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        print('User data fetched successfully: ${doc.data()}');
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      print('No user data found for userId: $userId');
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData(String userId, UserModel userData) async {
    try {
      print('Updating user data: ${userData.toMap()}');
      await _firestore.collection('users').doc(userId).update(userData.toMap());
      return true;
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }
}
