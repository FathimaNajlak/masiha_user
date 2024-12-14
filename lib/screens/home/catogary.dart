import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/screens/home/all_catogary.dart';
import 'package:masiha_user/screens/home/doctor_list.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of categories with their corresponding icons and specialties
    final categories = [
      {'icon': Icons.home, 'label': 'General', 'specialty': 'General Practice'},
      {
        'icon': Icons.medical_services,
        'label': 'Dentist',
        'specialty': 'General Dentistry'
      },
      {
        'icon': Icons.remove_red_eye,
        'label': 'Ophthal',
        'specialty': 'Ophthalmology'
      },
      {'icon': Icons.psychology, 'label': 'Neuro', 'specialty': 'Neurology'},
      {
        'icon': Icons.restaurant_menu,
        'label': 'Nutrition',
        'specialty': 'Endocrinology'
      },
      {
        'icon': Icons.child_care,
        'label': 'Pediatric',
        'specialty': 'Pediatrics'
      },
      {'icon': Icons.healing, 'label': 'Nephro', 'specialty': 'Nephrology'},
      {'icon': Icons.more_horiz, 'label': 'More', 'specialty': 'Other'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryItem(
              context,
              icon: category['icon'] as IconData,
              label: category['label'] as String,
              specialty: category['specialty'] as String,
              color: AppColors.darkcolor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String specialty,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == 'More') {
          // Navigate to AllCategoriesScreen when 'More' is clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AllCategoriesScreen(),
            ),
          );
        } else {
          // Existing logic for other categories
          FirebaseFirestore.instance
              .collection('doctorRequests')
              .where('requestStatus', isEqualTo: 'approved')
              .where('specialty', isEqualTo: specialty)
              .get()
              .then((doctorsSnapshot) {
            final doctors = doctorsSnapshot.docs.map((doc) {
              final data = doc.data();
              return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
            }).toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorsListScreen(
                  specialty: specialty,
                  categories: [
                    {'specialty': specialty}
                  ],
                ),
              ),
            );
          });
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
