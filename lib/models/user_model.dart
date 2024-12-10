import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? fullName;
  int? age;
  DateTime? dateOfBirth;
  String? email;
  String? gender;
  String? imagePath;

  UserModel({
    this.id,
    this.fullName,
    this.age,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.imagePath,
  });

  // Robust fromJson method
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      age: _parseAge(json['age']),
      dateOfBirth: _parseDateTime(json['dateOfBirth']),
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }

  // Helper method to parse age
  static int? _parseAge(dynamic age) {
    if (age == null) return null;
    if (age is int) return age;
    if (age is String) return int.tryParse(age);
    return null;
  }

  // Helper method to parse date
  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    if (date is DateTime) return date;
    return null;
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'gender': gender,
      'imagePath': imagePath,
    };
  }
}
