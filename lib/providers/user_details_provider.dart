import 'dart:io';

import 'package:masiha_user/models/user_model.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserDetailsProvider extends ChangeNotifier {
  final UserModel _user = UserModel();
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _imageError;
  final List<File> _certificateFiles = [];

  // Getters
  UserModel get user => _user;
  File? get imageFile => _imageFile;
  GlobalKey<FormState> get formKey => _formKey;
  bool get isLoading => _isLoading;
  String? get imageError => _imageError;
  List<File> get certificateFiles => _certificateFiles;

  // Validation Methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateDateOfBirth(DateTime? date) {
    if (date == null) {
      return 'Date of birth is required';
    }

    return null;
  }

  // Image Handling Methods
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Validate file size (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          _imageError = 'Image size should be less than 5MB';
          notifyListeners();
          return;
        }

        _imageFile = file;
        _imageError = null;
        notifyListeners();
      }
    } catch (e) {
      _imageError = 'Error picking image. Please try again.';
      notifyListeners();
    }
  }

  Future<String> saveImageLocally(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final savedImage = await imageFile.copy('${directory.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      throw Exception('Failed to save image locally');
    }
  }

  // Education Methods

  // Main Validation and Save Method
  Future<bool> validateAndSave() async {
    // Reset any previous errors
    _imageError = _imageFile == null ? 'Profile image is required' : null;

    // Validate all required fields
    if (!_formKey.currentState!.validate()) {
      notifyListeners();
      return false;
    }

    // Validate non-form fields
    if (_imageFile == null) {
      _imageError = 'Profile image is required';
      notifyListeners();
      return false;
    }

    // If all validation passes, proceed with saving
    _formKey.currentState!.save();
    setLoadingState(true);

    try {
      // Upload profile image to Supabase
      if (_imageFile != null) {
        final imageUrl = await saveImageLocally(_imageFile!);
        _user.imagePath = imageUrl; // Store the public URL
      }

      // Similar modification for certificates

      // Rest of your existing save logic
      await saveToFirestore('users', _user.toJson());

      return true;
    } catch (e) {
      setLoadingState(false);
      throw Exception('Failed to save user details: $e');
    }
  }

  Future<void> saveToFirestore(
      String collection, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).add(data);
  }

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
