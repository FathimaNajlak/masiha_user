import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Appointments',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _TabButton(
                    title: 'Upcoming',
                    isSelected: _showUpcoming,
                    onTap: () => setState(() => _showUpcoming = true),
                  ),
                  const SizedBox(width: 20),
                  _TabButton(
                    title: 'Completed',
                    isSelected: !_showUpcoming,
                    onTap: () => setState(() => _showUpcoming = false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _AppointmentsList(showUpcoming: _showUpcoming),
              ),
              _BottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final bool showUpcoming;

  const _AppointmentsList({required this.showUpcoming});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId',
              isEqualTo: FirebaseAuth
                  .instance.currentUser?.uid) // Replace with actual user ID
          // .orderBy('appointmentDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data!.docs.where((doc) {
          final appointmentDate =
              DateFormat('yyyy-MM-dd').parse(doc['appointmentDate'] as String);
          return showUpcoming
              ? appointmentDate.isAfter(now)
              : appointmentDate.isBefore(now);
        }).toList();

        if (appointments.isEmpty) {
          return Center(
            child: Text(
              showUpcoming
                  ? 'No upcoming appointments'
                  : 'No completed appointments',
            ),
          );
        }

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _AppointmentCard(
              doctorName: appointment['doctorName'] as String,
              hospital: appointment['hospital'] as String,
              specialty: appointment['specialty'] as String,
              date: appointment['appointmentDate'] as String,
              time: appointment['timeSlot'] as String,
              isFavorite: appointment['isFavorite'] as bool? ?? false,
            );
          },
        );
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String hospital;
  final String specialty;
  final String date;
  final String time;
  final bool isFavorite;

  const _AppointmentCard({
    required this.doctorName,
    required this.hospital,
    required this.specialty,
    required this.date,
    required this.time,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            doctorName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ],
                      ),
                      Text(
                        '$specialty | $hospital',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$date at $time',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle cancel appointment
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text('Cancel Appointment'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle reschedule
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200],
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
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
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 2,
              width: 60,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(icon: Icons.home, isSelected: false),
          _BottomNavItem(icon: Icons.access_time, isSelected: true),
          _BottomNavItem(icon: Icons.favorite_border, isSelected: false),
          _BottomNavItem(icon: Icons.person_outline, isSelected: false),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _BottomNavItem({
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: isSelected ? Colors.blue : Colors.grey,
    );
  }
}
