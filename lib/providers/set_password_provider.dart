import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetPasswordProvider extends ChangeNotifier {
  String _password = '';
  String _confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _passwordError;
  String? _confirmPasswordError;

  // Getters
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setPassword(String value) {
    _password = value;
    validatePassword();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    validateConfirmPassword();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  bool validatePassword() {
    if (_password.isEmpty) {
      _passwordError = 'Password is required';
      return false;
    }
    if (_password.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
      return false;
    }
    if (!_password.contains(RegExp(r'[A-Z]'))) {
      _passwordError = 'Password must contain at least one uppercase letter';
      return false;
    }
    if (!_password.contains(RegExp(r'[0-9]'))) {
      _passwordError = 'Password must contain at least one number';
      return false;
    }
    if (!_password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordError = 'Password must contain at least one special character';
      return false;
    }
    _passwordError = null;
    return true;
  }

  bool validateConfirmPassword() {
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = 'Please confirm your password';
      return false;
    }
    if (_confirmPassword != _password) {
      _confirmPasswordError = 'Passwords do not match';
      return false;
    }
    _confirmPasswordError = null;
    return true;
  }

  Future<bool> createNewPassword(String email) async {
    if (!validatePassword() || !validateConfirmPassword()) {
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Print debug information
      print('Attempting to create user with email: $email');

      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: _password.trim(),
      );

      print('User created successfully: ${userCredential.user?.uid}');

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      print('Firebase Auth Error: ${e.code} - ${e.message}'); // Debug print

      switch (e.code) {
        case 'weak-password':
          _passwordError = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          _passwordError = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          _passwordError = 'The email address is not valid.';
          break;
        default:
          _passwordError =
              e.message ?? 'An error occurred while creating account.';
      }

      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      print('General Error: $e'); // Debug print
      _passwordError = 'An unexpected error occurred.';
      notifyListeners();
      return false;
    }
  }
}
