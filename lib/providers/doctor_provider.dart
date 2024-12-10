// import 'package:flutter/material.dart';
// import 'package:masiha_user/models/doctor.dart';

// class DoctorProvider with ChangeNotifier {
//   final List<Doctor> _doctors = [
//     Doctor(
//       id: "1",
//       name: 'dr. Upul',
//       specialty: 'Dental',
//       hospital: 'Persahabatan Hospital',
//       imageUrl: 'assets/images/doctor1.jpg',
//     ),
//     Doctor(
//       id: "2",
//       name: 'dr. Shabil Chan',
//       specialty: 'Dental',
//       hospital: 'Columbia Asia Hospital',
//       imageUrl: 'assets/images/doctor2.jpg',
//     ),
//     Doctor(
//       id: "3",
//       name: 'dr. Mustakim',
//       specialty: 'Eye',
//       hospital: 'Columbia Carolus Hospital',
//       imageUrl: 'assets/images/doctor3.jpg',
//     ),
//   ];

//   List<Doctor> get doctors => _doctors;

//   void toggleFavorite(int index) {
//     _doctors[index].isFavorite = !_doctors[index].isFavorite;
//     notifyListeners();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class DoctorProvider with ChangeNotifier {
  List<DoctorDetailsModel> _doctors = [];
  List<DoctorDetailsModel> _filteredDoctors = [];
  bool _isLoading = false;

  // Update the getter to return filtered doctors when search is active
  List<DoctorDetailsModel> get doctors =>
      _filteredDoctors.isEmpty ? _doctors : _filteredDoctors;
  bool get isLoading => _isLoading;

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
        return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
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
    // Implement favorite logic here
    notifyListeners();
  }
}
