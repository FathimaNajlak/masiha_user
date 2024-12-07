// import 'package:flutter/material.dart';
// import 'package:masiha_user/consts/colors.dart';

// class CategorySection extends StatelessWidget {
//   const CategorySection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Category',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text('See All'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildCategoryItem(Icons.home, 'General', AppColors.darkcolor),
//             _buildCategoryItem(
//                 Icons.medical_services, 'Dentist', AppColors.darkcolor),
//             _buildCategoryItem(
//                 Icons.remove_red_eye, 'Ophthal', AppColors.darkcolor),
//             _buildCategoryItem(Icons.psychology, 'Neuro', AppColors.darkcolor),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildCategoryItem(
//                 Icons.restaurant_menu, 'Nutrition', AppColors.darkcolor),
//             _buildCategoryItem(
//                 Icons.child_care, 'Pediatric', AppColors.darkcolor),
//             _buildCategoryItem(Icons.healing, 'nephro', AppColors.darkcolor),
//             _buildCategoryItem(Icons.more_horiz, 'More', AppColors.darkcolor),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryItem(IconData icon, String label, Color color) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: color),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/screens/home/doctor_list.dart'; // Ensure you have this import

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of categories with their corresponding icons and specialties
    final categories = [
      {
        'icon': Icons.home,
        'label': 'General',
        'specialty': 'General Physician'
      },
      {
        'icon': Icons.medical_services,
        'label': 'Dentist',
        'specialty': 'dental'
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
        'specialty': 'Nutrition'
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed:
                  () {}, // You can implement a "see all" functionality if needed
              child: const Text('See All'),
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
    final categories = [
      {'icon': icon, 'label': label, 'specialty': specialty}
    ]; // Pass relevant categories if needed

    return GestureDetector(
      onTap: () {
        // Navigate to doctors list screen with the selected specialty and categories
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorsListScreen(
              specialty: specialty,
              categories: categories, // Pass the categories list
            ),
          ),
        );
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
