import 'package:flutter/material.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:masiha_user/providers/booking_provider.dart';

class TimeSlotsWidget extends StatelessWidget {
  final BookingProvider provider;

  const TimeSlotsWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.selectedDate == null) {
      return const SizedBox();
    }

    final timeSlots = provider.generateTimeSlots();

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final timeSlot = timeSlots[index];
          final isBooked = provider.bookedSlots.contains(timeSlot);

          return ElevatedButton(
            onPressed: isBooked
                ? null
                : () {
                    provider.selectedTimeSlot = timeSlot;
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBooked
                  ? Colors.grey[300]
                  : provider.selectedTimeSlot == timeSlot
                      ? AppColors.darkcolor
                      : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              timeSlot,
              style: TextStyle(
                color: isBooked
                    ? Colors.grey[600]
                    : provider.selectedTimeSlot == timeSlot
                        ? Colors.white
                        : AppColors.darkcolor,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}
