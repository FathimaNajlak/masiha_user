import 'package:flutter/material.dart';
import 'dart:io';

class RegistrationProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  File? _profileImage;

  String _fullName = '';
  String _age = '';
  String _dateOfBirth = '';
  String _email = '';
  String _gender = '';

  File? get profileImage => _profileImage;
  GlobalKey<FormState> get getFormKey => formKey;

  bool get isFormValid =>
      _profileImage != null && formKey.currentState?.validate() == true;

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }

  void clearImage() {
    _profileImage = null;
    notifyListeners();
  }

  void resetForm() {
    _profileImage = null;
    _fullName = '';
    _age = '';
    _dateOfBirth = '';
    _email = '';
    _gender = '';
    dateController.clear();
    notifyListeners();
  }

  void setFormData({
    String? fullName,
    String? age,
    String? dateOfBirth,
    String? email,
    String? gender,
  }) {
    _fullName = fullName ?? _fullName;
    _age = age ?? _age;
    _dateOfBirth = dateOfBirth ?? _dateOfBirth;
    _email = email ?? _email;
    _gender = gender ?? _gender;
    notifyListeners();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}
