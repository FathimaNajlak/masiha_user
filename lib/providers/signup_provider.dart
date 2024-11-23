import 'dart:io';
import 'package:flutter/material.dart';
import 'package:masiha_user/services/firestore_service.dart';

class SignupProvider with ChangeNotifier {
  String? fullName;
  int? age;
  DateTime? selectedDate;
  String? email;
  File? selectedImage;
  String? selectedGender;
  bool termsAccepted = false;

  void setFullName(String value) {
    fullName = value.trim();
    print('Full Name updated: $fullName');
    notifyListeners();
  }

  void setAge(int value) {
    if (value > 0) {
      age = value;
      print('Age updated: $age');
      notifyListeners();
    } else {
      print('Invalid Age: $value');
    }
  }

  void setDate(DateTime date) {
    selectedDate = date;
    print('Date of Birth updated: $selectedDate');
    notifyListeners();
  }

  void setEmail(String value) {
    if (value.contains('@') && value.contains('.')) {
      email = value.trim();
      print('Email updated: $email');
      notifyListeners();
    } else {
      print('Invalid Email: $value');
    }
  }

  void setSelectedImage(File image) {
    selectedImage = image;
    print('Image selected: ${image.path}');
    notifyListeners();
  }

  void setGender(String value) {
    selectedGender = value;
    print('Gender updated: $selectedGender');
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    termsAccepted = value;
    print('Terms accepted: $termsAccepted');
    notifyListeners();
  }

  void toggleTerms(bool value) {
    termsAccepted = value;
    notifyListeners();
  }

  Future<bool> saveUserData() async {
    print('Saving data...');
    print(
        'Full Name: $fullName, Age: $age, DOB: $selectedDate, Email: $email, Gender: $selectedGender');

    if (fullName == null ||
        age == null ||
        selectedDate == null ||
        email == null ||
        selectedGender == null) {
      print('Missing required data!');
      return false;
    }

    final service = FirebaseUserService();
    return await service.storeUserData(
      fullName: fullName!,
      age: age!,
      dateOfBirth: selectedDate!,
      email: email!,
      gender: selectedGender!,
    );
  }
}
