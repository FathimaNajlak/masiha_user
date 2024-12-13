import 'package:flutter/material.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/screens/home/doctor_details.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure doctors are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().fetchAcceptedDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Doctors'),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.doctors.isEmpty) {
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
            padding: const EdgeInsets.all(8.0),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.doctors.length,
            itemBuilder: (context, index) {
              final doctor = provider.doctors[index];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: doctor.isFavorite ? Colors.red : null,
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
    );
  }
}
