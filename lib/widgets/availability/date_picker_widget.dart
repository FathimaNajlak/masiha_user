import 'package:flutter/material.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final BookingProvider provider;

  const DatePickerWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: provider.selectedDate ?? DateTime.now(),
      currentDate: provider.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      onDateChanged: (date) async {
        if (provider.isDoctorAvailable(date)) {
          provider.selectedDate = date;
          await provider.loadBookedSlots(provider.doctor.requestId!, date);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Doctor is not available on ${DateFormat('EEEE').format(date)}'),
            ),
          );
        }
      },
      selectableDayPredicate: provider.isDoctorAvailable,
    );
  }
}
