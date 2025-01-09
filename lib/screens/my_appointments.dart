import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/appointments_provider.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/screens/booking/availability_screen.dart';
import 'package:masiha_user/widgets/home/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppointmentsProvider(),
      child: const MyAppointmentsContent(),
    );
  }
}

class MyAppointmentsContent extends StatelessWidget {
  const MyAppointmentsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Custom Tab Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    title: 'Upcoming',
                    isSelected: provider.showUpcoming,
                    onTap: () => provider.toggleView(true),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    title: 'Completed',
                    isSelected: !provider.showUpcoming,
                    onTap: () => provider.toggleView(false),
                  ),
                ),
              ],
            ),
          ),
          // Appointments List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: provider.getAppointments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final appointments = snapshot.data?.docs ?? [];

                if (appointments.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${provider.showUpcoming ? 'upcoming' : 'completed'} appointments',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment =
                        appointments[index].data() as Map<String, dynamic>;

                    // Fetch the associated doctor details.
                    final doctor = DoctorDetailsModel(
                      id: appointment['doctorId'],
                      requestId: appointment['doctorId'], // Add requestId
                      fullName: appointment['doctorName'],
                      specialty: appointment['doctorSpecialization'],
                      hospitalName:
                          appointment['hospitalName'] ?? 'Mims Hospital',
                      // Add other available fields from appointment data
                      consultationFees:
                          appointment['consultationFees']?.toDouble(),
                    );

                    return AppointmentCard(
                      appointment: appointment,
                      appointmentId: appointments[index].id,
                      showActions: provider.showUpcoming,
                      doctor: doctor, // Pass the doctor object here
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final String appointmentId;
  final bool showActions;
  final DoctorDetailsModel doctor;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.appointmentId,
    this.showActions = true,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppointmentsProvider>();

    // Convert Timestamp to DateTime and format it
    final appointmentDate =
        (appointment['appointmentDate'] as Timestamp).toDate();
    final formattedDate = DateFormat('MMM dd, yyyy').format(appointmentDate);
    final appointmentTime = appointment['appointmentTime'] ?? 'Not specified';
    final patientName = appointment['patientName'] ?? 'Not specified';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dr. ${appointment['doctorName']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          provider.showUpcoming ? 'Upcoming' : 'Completed',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appointment['doctorSpecialization']} | ${appointment['hospitalName'] ?? 'Mims Hospital'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Patient: $patientName',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Add Date and Time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointmentTime,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleCancel(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel Appointment'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleReschedule(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reschedule'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleCancel(BuildContext context) async {
    final provider = context.read<AppointmentsProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.cancelAppointment(appointmentId);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment cancelled successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  void _handleReschedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AvialabilityScreen(doctor: doctor)),
    );
  }
}
