import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/screens/home/doctor_list.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Specialties'),
        backgroundColor: AppColors.darkcolor,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }

          final categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildSpecialtyCard(context, category);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialtyCard(
      BuildContext context, Map<String, dynamic> category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorsListScreen(
                specialty: category['specialty'],
                categories: [
                  {'specialty': category['specialty']}
                ],
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min, // Add this
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Reduced padding
                decoration: BoxDecoration(
                  color: AppColors.darkcolor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSpecialtyIcon(category['specialty']),
                  color: AppColors.darkcolor,
                  size: 24, // Reduced size
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              Flexible(
                // Add Flexible
                child: Text(
                  category['specialty'],
                  style: const TextStyle(
                    fontSize: 14, // Reduced font size
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              FutureBuilder<List<DoctorDetailsModel>>(
                future: _fetchDoctorsBySpecialty(category['specialty']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(fontSize: 12),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text(
                      'Error loading',
                      style: TextStyle(fontSize: 12),
                    );
                  }
                  final doctorCount = snapshot.data?.length ?? 0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Add this
                    children: [
                      Text(
                        '$doctorCount ${doctorCount == 1 ? 'Doctor' : 'Doctors'}',
                        style: TextStyle(
                          color: doctorCount > 0 ? Colors.green : Colors.red,
                          fontSize: 12, // Reduced font size
                        ),
                      ),
                      if (doctorCount == 0)
                        const Text(
                          'None available',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10, // Reduced font size
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSpecialtyIcon(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'general practice':
        return FontAwesomeIcons.hospitalUser;
      case 'internal medicine':
        return FontAwesomeIcons.stethoscope;
      case 'pediatrics':
        return FontAwesomeIcons.babyCarriage;
      case 'obstetrics and gynecology':
        return FontAwesomeIcons.personPregnant;
      case 'surgery':
        return FontAwesomeIcons.syringe;
      case 'psychiatry':
        return FontAwesomeIcons.brain;
      case 'dermatology':
        // ignore: deprecated_member_use
        return FontAwesomeIcons.allergies;
      case 'cardiology':
        return FontAwesomeIcons.heartPulse;
      case 'neurology':
        return FontAwesomeIcons.brain;
      case 'orthopedics':
        return FontAwesomeIcons.bone;
      case 'ophthalmology':
        return FontAwesomeIcons.eye;
      case 'ent (otolaryngology)':
        return FontAwesomeIcons.earDeaf;
      case 'urology':
        return FontAwesomeIcons.child;
      case 'oncology':
        return FontAwesomeIcons.disease;
      case 'endocrinology':
        return FontAwesomeIcons.flask;
      case 'gastroenterology':
        return FontAwesomeIcons.child;
      case 'pulmonology':
        return FontAwesomeIcons.lungs;
      case 'nephrology':
        return FontAwesomeIcons.child;
      case 'rheumatology':
        return FontAwesomeIcons.bone;
      case 'emergency medicine':
        return FontAwesomeIcons.truckMedical;
      case 'general dentistry':
        return FontAwesomeIcons.tooth;
      default:
        return FontAwesomeIcons.userDoctor;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAllCategories() async {
    final List<String> specialties = [
      'General Practice',
      'Internal Medicine',
      'Pediatrics',
      'Obstetrics and Gynecology',
      'Surgery',
      'Psychiatry',
      'Dermatology',
      'Cardiology',
      'Neurology',
      'Orthopedics',
      'Ophthalmology',
      'ENT (Otolaryngology)',
      'Urology',
      'Oncology',
      'Endocrinology',
      'Gastroenterology',
      'Pulmonology',
      'Nephrology',
      'Rheumatology',
      'Emergency Medicine',
      'General Dentistry',
    ];

    return specialties
        .map((specialty) => {
              'specialty': specialty,
              'label': specialty,
            })
        .toList();
  }

  Future<List<DoctorDetailsModel>> _fetchDoctorsBySpecialty(
      String specialty) async {
    final doctorsSnapshot = await FirebaseFirestore.instance
        .collection('doctorRequests')
        .where('requestStatus', isEqualTo: 'approved')
        .where('specialty', isEqualTo: specialty)
        .get();

    return doctorsSnapshot.docs.map((doc) {
      final data = doc.data();
      return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
    }).toList();
  }
}
