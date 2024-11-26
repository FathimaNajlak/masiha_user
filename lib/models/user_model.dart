// lib/models/user_model.dart

class UserModel {
  final String fullName;
  final int age;
  final DateTime dateOfBirth;
  final String email;
  final String gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.fullName,
    required this.age,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to Map for Firestore
  toJson() {
    return {
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'gender': gender,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }
}
