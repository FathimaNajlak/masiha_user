import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor.dart';

class DoctorFilterProvider with ChangeNotifier {
  String _searchQuery = '';
  String _selectedSpecialty = '';
  List<Doctor> _filteredDoctors = [];

  String get searchQuery => _searchQuery;
  String get selectedSpecialty => _selectedSpecialty;
  List<Doctor> get filteredDoctors => _filteredDoctors;

  void setSearchQuery(String query, List<Doctor> allDoctors) {
    _searchQuery = query;
    _filterDoctors(allDoctors);
    notifyListeners();
  }

  void setSpecialty(String specialty, List<Doctor> allDoctors) {
    _selectedSpecialty = specialty;
    _filterDoctors(allDoctors);
    notifyListeners();
  }

  void _filterDoctors(List<Doctor> allDoctors) {
    _filteredDoctors = allDoctors.where((doctor) {
      final matchesSearch = doctor.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSpecialty = _selectedSpecialty.isEmpty ||
          doctor.specialty.toLowerCase() == _selectedSpecialty.toLowerCase();
      return matchesSearch && matchesSpecialty;
    }).toList();
  }
}
