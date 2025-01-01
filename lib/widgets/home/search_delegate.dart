import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/home/filter_doctor.dart';
import 'package:provider/provider.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

// class DoctorSearchDelegate extends SearchDelegate<DoctorDetailsModel> {
//   @override
//   String get searchFieldLabel => 'Search doctors, specialties, hospitals...';

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final theme = Theme.of(context);
//     return theme.copyWith(
//       appBarTheme: AppBarTheme(
//         backgroundColor: theme.scaffoldBackgroundColor,
//         elevation: 0,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: InputBorder.none,
//         hintStyle: TextStyle(color: Colors.grey[600]),
//       ),
//     );
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       if (query.isNotEmpty)
//         IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             query = '';
//             showSuggestions(context);
//           },
//         ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         // Return null when closing without selection
//         close(context, DoctorDetailsModel());
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults(context);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildSearchResults(context);
//   }

//   Widget _buildSearchResults(BuildContext context) {
//     final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
//     final doctors = doctorProvider.doctors;

//     if (query.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.search,
//               size: 64,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Search for doctors, specialties, or hospitals',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     final filteredDoctors = doctors.where((doctor) {
//       final searchQuery = query.toLowerCase();
//       final name = doctor.fullName?.toLowerCase() ?? '';
//       final specialty = doctor.specialty?.toLowerCase() ?? '';
//       final hospital = doctor.hospitalName?.toLowerCase() ?? '';

//       return name.contains(searchQuery) ||
//           specialty.contains(searchQuery) ||
//           hospital.contains(searchQuery);
//     }).toList();

//     if (filteredDoctors.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.search_off,
//               size: 64,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No results found for "$query"',
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: filteredDoctors.length,
//       itemBuilder: (context, index) {
//         final doctor = filteredDoctors[index];
//         return Card(
//           elevation: 2,
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(12),
//             leading: CircleAvatar(
//               radius: 30,
//               backgroundImage: doctor.imagePath != null
//                   ? CachedNetworkImageProvider(doctor.imagePath!)
//                   : const AssetImage('assets/images/doctor_placeholder.png')
//                       as ImageProvider,
//             ),
//             title: Text(
//               doctor.fullName ?? 'Unknown Doctor',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 4),
//                 Text(doctor.specialty ?? 'N/A'),
//                 if (doctor.hospitalName != null)
//                   Text('🏥 ${doctor.hospitalName}'),
//                 Text('💼 ${doctor.yearOfExperience ?? 0} years experience'),
//               ],
//             ),
//             onTap: () {
//               close(context, doctor);
//             },
//           ),
//         );
//       },
//     );
//   }
// }
class DoctorSearchDelegate extends SearchDelegate<DoctorDetailsModel> {
  final DoctorFilters filters;

  DoctorSearchDelegate()
      : filters = DoctorFilters(),
        super();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pushNamed(context, '/home'),
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
      IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.filter_list),
            if (filters.hasActiveFilters)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '•',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onPressed: () => _showFilterDialog(context),
      ),
    ];
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final doctors = doctorProvider.doctors;

    // Extract unique specialties and hospitals
    final specialties =
        doctors.map((d) => d.specialty).whereType<String>().toSet();
    final hospitals =
        doctors.map((d) => d.hospitalName).whereType<String>().toSet();

    // Get max experience and fees for ranges
    final maxExperience = doctors
        .map((d) => d.yearOfExperience ?? 0)
        .reduce((max, exp) => exp > max ? exp : max);
    final maxConsultationFees = doctors
        .map((d) => d.consultationFees ?? 0)
        .reduce((max, fees) => fees > max ? fees : max);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Doctors',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Specialties Filter
              const Text(
                'Specialties',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: specialties.map((specialty) {
                  return FilterChip(
                    label: Text(specialty),
                    selected: filters.selectedSpecialties.contains(specialty),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          filters.selectedSpecialties.add(specialty);
                        } else {
                          filters.selectedSpecialties.remove(specialty);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Hospitals Filter
              const Text(
                'Hospitals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: hospitals.map((hospital) {
                  return FilterChip(
                    label: Text(hospital),
                    selected: filters.selectedHospitals.contains(hospital),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          filters.selectedHospitals.add(hospital);
                        } else {
                          filters.selectedHospitals.remove(hospital);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Apply and Clear Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        filters.selectedSpecialties.clear();
                        filters.selectedHospitals.clear();
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showResults(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
    var doctors = doctorProvider.doctors;

    // Apply filters
    if (filters.hasActiveFilters) {
      doctors = doctors.where((doctor) {
        bool matchesSpecialty = filters.selectedSpecialties.isEmpty ||
            (doctor.specialty != null &&
                filters.selectedSpecialties.contains(doctor.specialty));

        bool matchesHospital = filters.selectedHospitals.isEmpty ||
            (doctor.hospitalName != null &&
                filters.selectedHospitals.contains(doctor.hospitalName));

        return matchesSpecialty && matchesHospital;
      }).toList();
    }

    // Apply search query
    if (query.isNotEmpty) {
      doctors = doctors.where((doctor) {
        final searchQuery = query.toLowerCase();
        final name = doctor.fullName?.toLowerCase() ?? '';
        final specialty = doctor.specialty?.toLowerCase() ?? '';
        final hospital = doctor.hospitalName?.toLowerCase() ?? '';

        return name.contains(searchQuery) ||
            specialty.contains(searchQuery) ||
            hospital.contains(searchQuery);
      }).toList();
    }

    if (query.isEmpty && !filters.hasActiveFilters) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for doctors or use filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              filters.hasActiveFilters
                  ? 'No doctors match the selected filters'
                  : 'No results found for "$query"',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
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
            onTap: () => close(context, doctor),
          ),
        );
      },
    );
  }
}
