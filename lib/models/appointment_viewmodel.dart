import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/providers/booking_provider.dart';
import 'package:masiha_user/providers/doctor_details_provider.dart';
import 'package:masiha_user/screens/booking/payment_confirmation_screen.dart';
import 'package:masiha_user/services/booking_service.dart';

class AppointmentViewModel extends ChangeNotifier {
  final BookingService _bookingService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _error;

  AppointmentViewModel({
    required BookingService bookingService,
    required DoctorDetailsProvider doctorProvider,
  }) : _bookingService = bookingService;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> confirmAppointment(
    BuildContext context, {
    required DoctorDetailsModel doctor,
    required DateTime appointmentDate,
    required String appointmentTime,
    required PatientDetails patientDetails,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Process payment first
      await _bookingService.makeAppointmentPayment(
        doctor: doctor,
      );

      // 2. Create appointment record in Firestore
      final String appointmentId = await _createAppointmentRecord(
        doctor: doctor,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        patientDetails: patientDetails,
      );

      // 3. Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // 4. Navigate to appointment details or back
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                const PaymentConfirmationScreen(), // Replace SuccessPage with your desired page
          ),
        ); // or navigate to appointment details screen
      }
    } catch (e) {
      _error = e.toString();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _createAppointmentRecord({
    required DoctorDetailsModel doctor,
    required DateTime appointmentDate,
    required String appointmentTime,
    required PatientDetails patientDetails,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create appointment document
      final appointmentRef = _firestore.collection('appointments').doc();

      final appointmentData = {
        'appointmentId': appointmentRef.id,
        'userId': userId,
        'doctorId': doctor.requestId,
        'doctorName': doctor.fullName,
        'doctorSpecialization': doctor.specialty,
        'patientName': patientDetails.name,
        'patientAge': patientDetails.age,

        'appointmentDate': Timestamp.fromDate(appointmentDate),
        'appointmentTime': appointmentTime,
        'consultationFee': doctor.consultationFees,
        'status': 'scheduled', // pending, completed, cancelled
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Create the appointment document
      await appointmentRef.set(appointmentData);

      // Also add to doctor's appointments collection
      await _firestore
          .collection('doctors')
          .doc(doctor.requestId)
          .collection('appointments')
          .doc(appointmentRef.id)
          .set(appointmentData);

      // Add to user's appointments collection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .doc(appointmentRef.id)
          .set(appointmentData);

      return appointmentRef.id;
    } catch (e) {
      throw Exception('Failed to create appointment record: $e');
    }
  }
}
