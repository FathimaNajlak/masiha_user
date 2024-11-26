import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/Doctordetails/date_option.dart';

class SelectDate extends StatelessWidget {
  const SelectDate({super.key});

  @override
  Widget build(BuildContext context) {
    return dateSelection();
  }

  Widget dateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Date',
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
          children: [
            DateOption(day: 'Sun', isSelected: true),
            SizedBox(width: 12),
            DateOption(day: 'Sun', isSelected: false),
            SizedBox(width: 12),
            DateOption(day: 'Sun', isSelected: false),
          ],
        ),
      ],
    );
  }
}
