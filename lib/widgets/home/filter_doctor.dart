class DoctorFilters {
  final Set<String> selectedSpecialties;
  final Set<String> selectedHospitals;
  final double? maxFees;

  DoctorFilters({
    Set<String>? selectedSpecialties,
    Set<String>? selectedHospitals,
    this.maxFees,
  })  : selectedSpecialties = selectedSpecialties ?? {},
        selectedHospitals = selectedHospitals ?? {};

  bool get hasActiveFilters =>
      selectedSpecialties.isNotEmpty ||
      selectedHospitals.isNotEmpty ||
      maxFees != null;
}
