import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class DoctorProvider with ChangeNotifier {
  List<DoctorDetailsModel> _doctors = [];
  List<DoctorDetailsModel> _filteredDoctors = [];
  List<String> _favoriteDoctorIds = [];
  bool _isLoading = false;

  // Update the getter to return filtered doctors when search is active
  List<DoctorDetailsModel> get doctors =>
      _filteredDoctors.isEmpty ? _doctors : _filteredDoctors;

  // Getter for favorite doctors
  List<DoctorDetailsModel> get favoriteDoctors => _doctors
      .where((doctor) => _favoriteDoctorIds.contains(doctor.requestId))
      .toList();

  bool get isLoading => _isLoading;

  DoctorProvider() {
    // Fetch favorite doctor IDs when the provider is created
    _fetchFavoriteDoctorIds();
  }

  Future<void> _fetchFavoriteDoctorIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final favoritesDoc = await FirebaseFirestore.instance
          .collection('userFavorites')
          .doc(user.uid)
          .get();

      if (favoritesDoc.exists) {
        final data = favoritesDoc.data();
        _favoriteDoctorIds = List<String>.from(data?['favoriteDoctor'] ?? []);
      } else {
        // Initialize an empty list of favorite doctors if the document doesn't exist
        _favoriteDoctorIds = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching favorite doctors: $e');
      _favoriteDoctorIds = [];
      notifyListeners();
    }
  }

  Future<void> fetchAcceptedDoctors() async {
    try {
      _isLoading = true;
      notifyListeners();

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctorRequests')
          .where('requestStatus', isEqualTo: 'approved')
          .get();

      _doctors = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final doctor = DoctorDetailsModel.fromJson(data)..requestId = doc.id;

        // Add a flag to indicate if the doctor is a favorite
        doctor.isFavorite = _favoriteDoctorIds.contains(doc.id);

        return doctor;
      }).toList();

      // Reset filtered doctors when fetching new data
      _filteredDoctors = [];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching doctors: $e');
      notifyListeners();
    }
  }

  // Add search functionality
  void searchDoctors(String query) {
    if (query.trim().isEmpty) {
      _filteredDoctors = [];
    } else {
      _filteredDoctors = _doctors.where((doctor) {
        final nameMatch =
            doctor.fullName?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        final specialtyMatch =
            doctor.specialty?.toLowerCase().contains(query.toLowerCase()) ??
                false;
        final hospitalMatch =
            doctor.hospitalName?.toLowerCase().contains(query.toLowerCase()) ??
                false;

        return nameMatch || specialtyMatch || hospitalMatch;
      }).toList();
    }
    notifyListeners();
  }

  // Clear search results
  void clearSearch() {
    _filteredDoctors = [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String doctorId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userFavoritesRef =
          FirebaseFirestore.instance.collection('userFavorites').doc(user.uid);

      // Check if the document exists, create it if not
      final docSnapshot = await userFavoritesRef.get();
      if (!docSnapshot.exists) {
        await userFavoritesRef.set({
          'favoriteDoctor': [doctorId]
        });
        _favoriteDoctorIds = [doctorId];
      } else {
        if (_favoriteDoctorIds.contains(doctorId)) {
          // Remove from favorites
          await userFavoritesRef.update({
            'favoriteDoctor': FieldValue.arrayRemove([doctorId])
          });
          _favoriteDoctorIds.remove(doctorId);
        } else {
          // Add to favorites
          await userFavoritesRef.update({
            'favoriteDoctor': FieldValue.arrayUnion([doctorId])
          });
          _favoriteDoctorIds.add(doctorId);
        }
      }

      // Update the doctor's favorite status in the local list
      final doctorIndex =
          _doctors.indexWhere((doctor) => doctor.requestId == doctorId);
      if (doctorIndex != -1) {
        _doctors[doctorIndex].isFavorite =
            _favoriteDoctorIds.contains(doctorId);
      }

      notifyListeners();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }
}
