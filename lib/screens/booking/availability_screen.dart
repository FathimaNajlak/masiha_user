import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/consts/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AvialabilityScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;

  const AvialabilityScreen({
    super.key,
    required this.doctor,
  });

  void _showPatientDetailsDialog(
      BuildContext context, BookingProvider provider) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final issueController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    if (provider.patientDetails != null) {
      nameController.text = provider.patientDetails!.name;
      ageController.text = provider.patientDetails!.age.toString();
      issueController.text = provider.patientDetails!.issue;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Patient Details'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter patient name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter patient age';
                      }
                      final age = int.parse(value);
                      if (age < 0 || age > 120) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: issueController,
                    decoration: const InputDecoration(
                      labelText: 'Medical Issue',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe the medical issue';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Save patient details
                  final patientDetails = PatientDetails(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    issue: issueController.text,
                  );

                  // Set patient details in provider
                  provider.setPatientDetails(patientDetails);

                  // Close dialog
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          BookingProvider(doctor)..loadDoctorAvailability(doctor.requestId!),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Date and Time '),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.error}'),
                    ElevatedButton(
                      onPressed: () =>
                          provider.loadDoctorAvailability(doctor.requestId!),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Custom Calendar Builder
                CalendarDatePicker(
                  initialDate: provider.selectedDate ?? DateTime.now(),
                  currentDate: provider.selectedDate,
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
                  selectableDayPredicate: (DateTime date) {
                    // Only allow selection of available days
                    return provider.isDoctorAvailable(date);
                  },
                ),

                // Available Days Legend
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.darkcolor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Available Slots'),
                      const SizedBox(width: 16),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Selected Slots'),
                    ],
                  ),
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
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            _showPatientDetailsDialog(context, provider),
                        icon: Icon(
                          provider.patientDetails != null
                              ? Icons.edit
                              : Icons.add,
                          color: AppColors.darkcolor,
                        ),
                        label: Text(
                          provider.patientDetails != null
                              ? 'Edit Details'
                              : 'Add Details',
                          style: const TextStyle(color: AppColors.darkcolor),
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.patientDetails != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      child: ListTile(
                        title: Text(provider.patientDetails!.name),
                        subtitle: Text(
                          'Age: ${provider.patientDetails!.age}, Issue: ${provider.patientDetails!.issue}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showPatientDetailsDialog(context, provider),
                        ),
                      ),
                    ),
                  ),
                // Book Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: (provider.selectedDate != null &&
                            provider.selectedTimeSlot != null &&
                            provider.patientDetails != null)
                        ? () => provider.bookAppointment(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkcolor,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Book Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}