import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem(Icons.home, 'General', Colors.blue),
            _buildCategoryItem(Icons.medical_services, 'Dentist', Colors.blue),
            _buildCategoryItem(Icons.remove_red_eye, 'Ophthal', Colors.blue),
            _buildCategoryItem(Icons.psychology, 'Neuro', Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem(Icons.restaurant_menu, 'Nutrition', Colors.blue),
            _buildCategoryItem(Icons.child_care, 'Pediatric', Colors.blue),
            _buildCategoryItem(Icons.healing, 'nephro', Colors.blue),
            _buildCategoryItem(Icons.more_horiz, 'More', Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return Column(
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
    );
  }
}
