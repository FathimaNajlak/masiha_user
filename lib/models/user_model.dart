// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Map<String, dynamic> toMap() {
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

  // Create UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? '',
      age: map['age'] ?? 0,
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
