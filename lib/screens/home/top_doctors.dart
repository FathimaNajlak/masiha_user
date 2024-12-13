// import 'package:flutter/material.dart';
// import 'package:masiha_user/providers/doctor_provider.dart';
// import 'package:masiha_user/screens/home/doctor_details.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class AvailableDoctorsSection extends StatefulWidget {
//   const AvailableDoctorsSection({super.key});

//   @override
//   State<AvailableDoctorsSection> createState() =>
//       _AvailableDoctorsSectionState();
// }

// class _AvailableDoctorsSectionState extends State<AvailableDoctorsSection> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch doctors when the widget is initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<DoctorProvider>().fetchAcceptedDoctors();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final topPadding = MediaQuery.of(context).padding.top;
//     final availableHeight = screenHeight - topPadding - kToolbarHeight - 250;

//     return SizedBox(
//       height: availableHeight,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Available Doctors',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Implement view all functionality
//                   },
//                   child: const Text('View all'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Consumer<DoctorProvider>(
//               builder: (context, provider, _) {
//                 if (provider.isLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 if (provider.doctors.isEmpty) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.medical_services_outlined,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'No doctors available',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: EdgeInsets.zero,
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: provider.doctors.length,
//                   itemBuilder: (context, index) {
//                     final doctor = provider.doctors[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Card(
//                         elevation: 2,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       DoctorDetailsScreen(doctor: doctor)),
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               children: [
//                                 if (doctor.imagePath != null)
//                                   CircleAvatar(
//                                     radius: 30,
//                                     backgroundImage: CachedNetworkImageProvider(
//                                       doctor.imagePath!,
//                                     ),
//                                   )
//                                 else
//                                   const CircleAvatar(
//                                     radius: 30,
//                                     child: Icon(Icons.person),
//                                   ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         doctor.fullName ?? 'Unknown Doctor',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         doctor.specialty ?? 'N/A',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                       Text(
//                                         '${doctor.yearOfExperience ?? 0} years experience',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.favorite_border),
//                                   onPressed: () {
//                                     provider.toggleFavorite(
//                                       doctor.requestId ?? '',
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/screens/home/doctor_details.dart';
import 'package:masiha_user/widgets/home/all_doctors_creen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

class TopDoctorsSection extends StatefulWidget {
  const TopDoctorsSection({super.key});

  @override
  State<TopDoctorsSection> createState() => _TopDoctorsSectionState();
}

class _TopDoctorsSectionState extends State<TopDoctorsSection> {
  @override
  void initState() {
    super.initState();
    // Fetch doctors when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().fetchAcceptedDoctors();
    });
  }

  List<dynamic> getTopDoctors(List<dynamic> doctors, {int count = 4}) {
    // If doctors list is empty or has fewer doctors than requested
    if (doctors.isEmpty) return [];

    // Shuffle the list and take the first 'count' doctors
    final random = Random();
    final shuffledDoctors = List.from(doctors)..shuffle(random);
    return shuffledDoctors.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - topPadding - kToolbarHeight - 250;

    return SizedBox(
      height: availableHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all doctors screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllDoctorsScreen(),
                      ),
                    );
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DoctorProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final topDoctors = getTopDoctors(provider.doctors);

                if (topDoctors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No doctors available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: topDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = topDoctors[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorDetailsScreen(doctor: doctor)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                if (doctor.imagePath != null)
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                      doctor.imagePath!,
                                    ),
                                  )
                                else
                                  const CircleAvatar(
                                    radius: 30,
                                    child: Icon(Icons.person),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.fullName ?? 'Unknown Doctor',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        doctor.specialty ?? 'N/A',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '${doctor.yearOfExperience ?? 0} years experience',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    doctor.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        doctor.isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    provider.toggleFavorite(
                                      doctor.requestId ?? '',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
