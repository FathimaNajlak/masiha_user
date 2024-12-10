import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/screens/home/doctor_details.dart';

class DoctorsListScreen extends StatelessWidget {
  final String specialty;
  final List<Map<String, dynamic>> categories;

  const DoctorsListScreen({
    super.key,
    required this.specialty,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$specialty Doctors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctorRequests')
            .where('requestStatus', isEqualTo: 'approved')
            .where('specialty', isEqualTo: specialty)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.medical_services_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No doctors available in $specialty',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Convert snapshot to list of DoctorDetailsModel
          final doctors = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: doctor.imagePath != null
                        ? CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(doctor.imagePath!),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person),
                          ),
                    title: Text(
                      doctor.fullName ?? 'Unknown Doctor',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('🏥 ${doctor.hospitalName ?? 'N/A'}'),
                        Text(
                            '💼 ${doctor.yearOfExperience ?? 0} years experience'),
                        if (doctor.educations?.isNotEmpty ?? false)
                          Text(
                              '🎓 ${doctor.educations!.first.degree ?? 'N/A'}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorDetailsScreen(doctor: doctor),
                        ),
                      );
                    }),
              );
            },
          );
        },
      ),
    );
  }
}
