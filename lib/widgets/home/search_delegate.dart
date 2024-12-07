import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DoctorSearchDelegate extends SearchDelegate<DoctorDetailsModel> {
  @override
  String get searchFieldLabel => 'Search doctors, specialties, hospitals...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Return null when closing without selection
        close(context, DoctorDetailsModel());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final doctors = doctorProvider.doctors;

    if (query.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Search for doctors, specialties, or hospitals',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final filteredDoctors = doctors.where((doctor) {
      final searchQuery = query.toLowerCase();
      final name = doctor.fullName?.toLowerCase() ?? '';
      final specialty = doctor.specialty?.toLowerCase() ?? '';
      final hospital = doctor.hospitalName?.toLowerCase() ?? '';

      return name.contains(searchQuery) ||
          specialty.contains(searchQuery) ||
          hospital.contains(searchQuery);
    }).toList();

    if (filteredDoctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$query"',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filteredDoctors[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: doctor.imagePath != null
                  ? CachedNetworkImageProvider(doctor.imagePath!)
                  : const AssetImage('assets/images/doctor_placeholder.png')
                      as ImageProvider,
            ),
            title: Text(
              doctor.fullName ?? 'Unknown Doctor',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(doctor.specialty ?? 'N/A'),
                if (doctor.hospitalName != null)
                  Text('🏥 ${doctor.hospitalName}'),
                Text('💼 ${doctor.yearOfExperience ?? 0} years experience'),
              ],
            ),
            onTap: () {
              close(context, doctor);
            },
          ),
        );
      },
    );
  }
}
