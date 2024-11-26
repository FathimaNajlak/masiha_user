import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/models/doctor.dart';
import 'package:provider/provider.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/providers/doctor_filter_provider.dart';

class DoctorSearchScreen extends StatelessWidget {
  const DoctorSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorFilterProvider(),
      child: const DoctorSearchContent(),
    );
  }
}

class DoctorSearchContent extends StatelessWidget {
  const DoctorSearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final filterProvider = Provider.of<DoctorFilterProvider>(context);
    final doctors = doctorProvider.doctors;

    // Initialize filtered doctors if empty
    if (filterProvider.filteredDoctors.isEmpty &&
        filterProvider.searchQuery.isEmpty &&
        filterProvider.selectedSpecialty.isEmpty) {
      filterProvider.setSearchQuery('', doctors);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Doctors',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(doctors: doctors),
          ),
          SpecialtyFilter(doctors: doctors),
          const Expanded(
            child: DoctorsList(),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final List<Doctor> doctors;

  const SearchBar({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<DoctorFilterProvider>(context);

    return TextField(
      decoration: InputDecoration(
        hintText: 'Search doctors',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: filterProvider.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => filterProvider.setSearchQuery('', doctors),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) => filterProvider.setSearchQuery(value, doctors),
    );
  }
}

class SpecialtyFilter extends StatelessWidget {
  final List<Doctor> doctors;

  const SpecialtyFilter({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<DoctorFilterProvider>(context);
    final specialties =
        doctors.map((doctor) => doctor.specialty).toSet().toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: filterProvider.selectedSpecialty.isEmpty,
            onSelected: (_) => filterProvider.setSpecialty('', doctors),
          ),
          const SizedBox(width: 8),
          ...specialties.map((specialty) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(specialty),
                  selected: filterProvider.selectedSpecialty == specialty,
                  onSelected: (_) =>
                      filterProvider.setSpecialty(specialty, doctors),
                ),
              )),
        ],
      ),
    );
  }
}

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<DoctorFilterProvider>(context);
    final doctorProvider = Provider.of<DoctorProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filterProvider.filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filterProvider.filteredDoctors[index];
        final originalIndex = doctorProvider.doctors.indexOf(doctor);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    doctor.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.hospital,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        doctor.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: doctor.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () =>
                          doctorProvider.toggleFavorite(originalIndex),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement booking functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
