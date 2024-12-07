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
  List<DoctorDetailsModel> get doctors => _doctors;
  bool _isLoading = false;
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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching doctors: $e');
      notifyListeners();
    }
  }

  // Add method to toggle favorite (you'll need to implement the logic to store favorites)
  Future<void> toggleFavorite(String doctorId) async {
    // Implement favorite logic here
    notifyListeners();
  }
}
