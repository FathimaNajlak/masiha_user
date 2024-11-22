import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor.dart';

class DoctorProvider with ChangeNotifier {
  final List<Doctor> _doctors = [
    Doctor(
      id: "1",
      name: 'dr. Upul',
      specialty: 'Dental',
      hospital: 'Persahabatan Hospital',
      imageUrl: 'assets/images/doctor1.jpg',
    ),
    Doctor(
      id: "2",
      name: 'dr. Shabil Chan',
      specialty: 'Dental',
      hospital: 'Columbia Asia Hospital',
      imageUrl: 'assets/images/doctor2.jpg',
    ),
    Doctor(
      id: "3",
      name: 'dr. Mustakim',
      specialty: 'Eye',
      hospital: 'Columbia Carolus Hospital',
      imageUrl: 'assets/images/doctor3.jpg',
    ),
  ];

  List<Doctor> get doctors => _doctors;

  void toggleFavorite(int index) {
    _doctors[index].isFavorite = !_doctors[index].isFavorite;
    notifyListeners();
  }
}
