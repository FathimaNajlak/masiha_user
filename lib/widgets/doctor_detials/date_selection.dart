import 'package:flutter/material.dart';

class DateSelection extends StatelessWidget {
  final Map<String, dynamic> availability;

  const DateSelection({
    super.key,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    // Filter only available days
    List<String> availableDays = availability.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableDays
                  .map((day) => _buildDateChip(day, availableDays.first == day))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(String day, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(day),
        backgroundColor: Colors.grey[200],
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
