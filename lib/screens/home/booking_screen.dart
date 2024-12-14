import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masiha_user/models/doctor_details_model.dart';

class BookingScreen extends StatefulWidget {
  final DoctorDetailsModel doctor;

  const BookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? _selectedTimeslot;
  String? _fullName;
  String? _phoneNumber;
  String? _problem;
  int? _age;
  String? _gender;

  Future<void> _saveAppointment() async {
    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctor.id,
        'userId': 'current_user_id', // Replace with actual user ID
        'timeslot': _selectedTimeslot,
        'fullName': _fullName,
        'phoneNumber': _phoneNumber,
        'problem': _problem,
        'age': _age,
        'gender': _gender,
      });

      // Navigate to the payment screen or show a success message
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentPreviewScreen(
            doctor: widget.doctor,
            timeslot: _selectedTimeslot!,
            fullName: _fullName!,
            phoneNumber: _phoneNumber!,
            problem: _problem!,
            age: _age!,
            gender: _gender!,
          ),
        ),
      );
    } catch (e) {
      // Handle any errors that occurred during the save process
      print('Error saving appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
              onChanged: (value) => _fullName = value,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              onChanged: (value) => _phoneNumber = value,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Write Your Problem',
              ),
              onChanged: (value) => _problem = value,
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Your Age',
              ),
              onChanged: (value) => _age = int.tryParse(value),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
              value: _gender,
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) => _gender = value,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (_fullName != null &&
                    _phoneNumber != null &&
                    _problem != null &&
                    _age != null &&
                    _gender != null) {
                  _saveAppointment();
                } else {
                  // Show an error message or handle the missing fields
                }
              },
              child: const Text('Proceed To Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPreviewScreen extends StatelessWidget {
  final DoctorDetailsModel doctor;
  final String timeslot;
  final String fullName;
  final String phoneNumber;
  final String problem;
  final int age;
  final String gender;

  const PaymentPreviewScreen({
    super.key,
    required this.doctor,
    required this.timeslot,
    required this.fullName,
    required this.phoneNumber,
    required this.problem,
    required this.age,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: Dr. ${doctor.fullName}'),
            const SizedBox(height: 16.0),
            Text('Appointment Time: $timeslot'),
            const SizedBox(height: 16.0),
            Text('Full Name: $fullName'),
            const SizedBox(height: 16.0),
            Text('Phone Number: $phoneNumber'),
            const SizedBox(height: 16.0),
            Text('Problem: $problem'),
            const SizedBox(height: 16.0),
            Text('Age: $age'),
            const SizedBox(height: 16.0),
            Text('Gender: $gender'),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Proceed to the payment process
              },
              child: const Text('Confirm and Pay'),
            ),
          ],
        ),
      ),
    );
  }
}
