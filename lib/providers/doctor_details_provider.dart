// doctor_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:masiha_user/models/doctor_details_model.dart';

class DoctorDetailsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, Map<String, dynamic>> _doctorAdditionalDetails = {};
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Map<String, dynamic>?> getDoctorAdditionalDetails(
      DoctorDetailsModel doctor) async {
    try {
      // Check if we already have cached data
      if (_doctorAdditionalDetails.containsKey(doctor.requestId)) {
        return _doctorAdditionalDetails[doctor.requestId];
      }

      // Indicate loading without notifying listeners immediately
      _isLoading = true;

      // Fetch data from Firestore
      final requestDoc = await _firestore
          .collection('doctorRequests')
          .doc(doctor.requestId)
          .get();

      if (!requestDoc.exists) {
        _error = 'Doctor request not found';
        _isLoading = false;
        // Defer notification to avoid build conflicts
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return null;
      }

      final userId = requestDoc.data()?['userId'];
      if (userId == null) {
        _error = 'User ID not found in doctor request';
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return null;
      }

      // Get additional details
      final docSnapshot =
          await _firestore.collection('doctors').doc(userId).get();

      if (!docSnapshot.exists) {
        _error = 'Doctor details not found';
        _isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return null;
      }

      final additionalDetails = docSnapshot.data()!;
      _doctorAdditionalDetails[doctor.requestId!] = additionalDetails;

      _error = null;
      _isLoading = false;

      // Defer notification to avoid build conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      return additionalDetails;
    } catch (e) {
      _error = 'Error loading doctor details: $e';
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return null;
    }
  }

  void clearCache() {
    _doctorAdditionalDetails.clear();
    notifyListeners();
  }
}
