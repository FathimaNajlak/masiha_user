import 'package:flutter/material.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;

  const BookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          BookingProvider()..loadDoctorAvailability(doctor.requestId!),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Appointment'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }

            return Column(
              children: [
                // Calendar Picker
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  onDateChanged: (date) async {
                    if (provider.isDoctorAvailable(date)) {
                      provider.selectedDate = date;
                      await provider.loadBookedSlots(doctor.requestId!, date);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Doctor is not available on ${DateFormat('EEEE').format(date)}'),
                        ),
                      );
                    }
                  },
                ),

                // Time Slots
                if (provider.selectedDate != null)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: provider.generateTimeSlots().length,
                      itemBuilder: (context, index) {
                        final timeSlot = provider.generateTimeSlots()[index];
                        final isBooked =
                            provider.bookedSlots.contains(timeSlot);

                        return ElevatedButton(
                          onPressed: isBooked
                              ? null
                              : () {
                                  provider.selectedTimeSlot = timeSlot;
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                provider.selectedTimeSlot == timeSlot
                                    ? AppColors.darkcolor
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                              color: provider.selectedTimeSlot == timeSlot
                                  ? Colors.white
                                  : AppColors.darkcolor,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Book Button
                ElevatedButton(
                  onPressed: (provider.selectedDate != null &&
                          provider.selectedTimeSlot != null)
                      ? () async {
                          try {
                            await provider.bookAppointment(
                                doctor.requestId!,
                                provider.selectedDate!,
                                provider.selectedTimeSlot!);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Appointment booked successfully!'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      : null,
                  child: const Text('Book Appointment'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
