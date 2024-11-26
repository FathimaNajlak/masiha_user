import 'package:flutter/material.dart';
import 'time_slot.dart';

class WorkingHours extends StatelessWidget {
  const WorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    return workingHours();
  }

  Widget workingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Working Hours',
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
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TimeSlot(time: '10:00 AM', isSelected: false),
            TimeSlot(time: '11:00 AM', isSelected: true),
            TimeSlot(time: '12:00 PM', isSelected: false),
          ],
        ),
      ],
    );
  }
}
