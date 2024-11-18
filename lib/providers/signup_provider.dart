import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _termsAccepted = false;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedGender => _selectedGender;
  bool get termsAccepted => _termsAccepted;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void toggleTerms(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }
}
