import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/appointments_provider.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
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
                    return AppointmentCard(
                      appointment: appointment,
                      appointmentId: appointments[index].id,
                      showActions: provider.showUpcoming,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.appointmentId,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppointmentsProvider>();

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
                // Using FutureBuilder to fetch doctor's image
                // FutureBuilder<Map<String, dynamic>?>(
                //   future: context
                //       .read<DoctorDetailsProvider>()
                //       .getDoctorAdditionalDetails(
                //         DoctorDetailsModel()
                //           ..requestId = appointment['doctorRequestId'],
                //       ),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const CircleAvatar(
                //         radius: 30,
                //         child: CircularProgressIndicator(),
                //       );
                //     }

                //     final doctorDetails = snapshot.data;
                //     final imagePath = doctorDetails?['imagePath'] ??
                //         appointment['doctorImage'];

                //     return imagePath != null
                //         ? CircleAvatar(
                //             radius: 30,
                //             backgroundImage: NetworkImage(imagePath),
                //           )
                //         : const CircleAvatar(
                //             radius: 30,
                //             child: Icon(Icons.person),
                //           );
                //   },
                // ),
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
                          const Icon(Icons.favorite_border),
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
    // Navigate to reschedule screen
    // Implement your navigation logic here
  }
}
