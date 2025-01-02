import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:masiha_user/models/user_model.dart';
import 'package:masiha_user/services/cloudinary_service.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserDetailsProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  String? _currentUserDocId;
  final UserModel _user = UserModel();
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _imageError;
  final List<File> _certificateFiles = [];

  UserModel? _currentUserDetails;
  UserModel? get currentUserDetails => _currentUserDetails;

  // Getters
  UserModel get user => _user;
  File? get imageFile => _imageFile;
  GlobalKey<FormState> get formKey => _formKey;
  bool get isLoading => _isLoading;
  String? get imageError => _imageError;
  List<File> get certificateFiles => _certificateFiles;

  // Future<void> fetchLatestUserDetails() async {
  //   try {
  //     // Get the currently logged-in user
  //     User? currentUser = _auth.currentUser;

  //     if (currentUser == null) {
  //       print('No authenticated user found');
  //       _currentUserDetails = null;
  //       notifyListeners();
  //       return;
  //     }

  //     // Fetch user document using the UID
  //     DocumentSnapshot userDoc =
  //         await _firestore.collection('users').doc(currentUser.uid).get();

  //     if (userDoc.exists) {
  //       // Convert Firestore document to UserModel
  //       Map<String, dynamic>? userData =
  //           userDoc.data() as Map<String, dynamic>?;

  //       if (userData != null) {
  //         _currentUserDetails = UserModel.fromJson({
  //           ...userData,
  //           'id': userDoc.id, // Add document ID to the data
  //         });

  //         notifyListeners();
  //       } else {
  //         print('User data is null');
  //         _currentUserDetails = null;
  //         notifyListeners();
  //       }
  //     } else {
  //       print('No user document found');
  //       _currentUserDetails = null;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error fetching user details: $e');
  //     _currentUserDetails = null;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
  Future<void> fetchLatestUserDetails() async {
    try {
      setLoadingState(true);

      if (_currentUserDocId != null) {
        // Fetch specific document if ID is known
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(_currentUserDocId).get();

        if (doc.exists) {
          _currentUserDetails = UserModel.fromJson({
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          });
        }
      } else {
        // Query for most recent user document
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot latestDoc = querySnapshot.docs.first;
          _currentUserDetails = UserModel.fromJson({
            ...latestDoc.data() as Map<String, dynamic>,
            'id': latestDoc.id,
          });
          _currentUserDocId = latestDoc.id;
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
      _currentUserDetails = null;
    } finally {
      setLoadingState(false);
      notifyListeners();
    }
  }

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

  Future<String> updateDoctorImage(File imageFile) async {
    try {
      final cloudinaryUrl =
          await _cloudinaryService.uploadProfileImage(imageFile);
      notifyListeners();
      return cloudinaryUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
  // Future<String> saveImageLocally(File imageFile) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final fileName =
  //         'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
  //     final savedImage = await imageFile.copy('${directory.path}/$fileName');
  //     return savedImage.path;
  //   } catch (e) {
  //     throw Exception('Failed to save image locally');
  //   }
  // }

  // Main Validation and Save Method
  Future<bool> validateAndSave() async {
    _imageError = _imageFile == null ? 'Profile image is required' : null;

    if (!_formKey.currentState!.validate()) {
      notifyListeners();
      return false;
    }

    if (_imageFile == null) {
      _imageError = 'Profile image is required';
      notifyListeners();
      return false;
    }

    _formKey.currentState!.save();
    setLoadingState(true);

    try {
      if (_imageFile != null) {
        final imageUrl = await updateDoctorImage(_imageFile!);
        // final imageUrl = await saveImageLocally(_imageFile!);
        _user.imagePath = imageUrl; // Store the public URL
      }
      // Create user data with timestamp
      final userData = {
        ..._user.toJson(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add new document with auto-generated ID
      DocumentReference docRef =
          await _firestore.collection('users').add(userData);

      _currentUserDocId = docRef.id; // Store the new document ID

      // Update current user details after saving
      _currentUserDetails = UserModel(
        fullName: _user.fullName,
        age: _user.age,
        dateOfBirth: _user.dateOfBirth,
        email: _user.email,
        gender: _user.gender,
        imagePath: _user.imagePath,
      );

      notifyListeners();
      setLoadingState(false);
      return true;
    } catch (e) {
      setLoadingState(false);
      throw Exception('Failed to save user details: $e');
    }
  }

  Future<bool> updateUserDetails(UserModel updatedUser) async {
    if (_currentUserDocId == null) return false;

    try {
      setLoadingState(true);

      final userData = {
        ...updatedUser.toJson(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(_currentUserDocId)
          .update(userData);

      _currentUserDetails = updatedUser;
      notifyListeners();
      setLoadingState(false);
      return true;
    } catch (e) {
      setLoadingState(false);
      throw Exception('Failed to update user details: $e');
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
