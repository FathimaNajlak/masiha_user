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
    String? paymentIntentId;
    bool paymentSuccess = false;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Process payment first
      final paymentResult = await _bookingService.makeAppointmentPayment(
        doctor: doctor,
      );

      // Update payment status
      paymentSuccess = true;

      // 2. Create appointment record in Firestore with payment details
      final String appointmentId = await _createAppointmentRecord(
        doctor: doctor,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        patientDetails: patientDetails,
        paymentIntentId: paymentIntentId,
        paymentStatus: 'completed',
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
        );
      }
    } catch (e) {
      // If payment was successful but storing failed, we should still store the record
      if (paymentSuccess) {
        try {
          await _createAppointmentRecord(
            doctor: doctor,
            appointmentDate: appointmentDate,
            appointmentTime: appointmentTime,
            patientDetails: patientDetails,
            paymentIntentId: paymentIntentId,
            paymentStatus: 'completed',
            isRetry: true,
          );
        } catch (storeError) {
          print('Error storing appointment after payment: $storeError');
        }
      }

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
    String? paymentIntentId,
    required String paymentStatus,
    bool isRetry = false,
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
        // Payment related fields
        'payment': {
          'status': paymentStatus,
          'amount': doctor.consultationFees,
          'currency': 'INR',
          'paymentIntentId': paymentIntentId,
          'paymentMethod': 'stripe',
          'timestamp': FieldValue.serverTimestamp(),
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isRetry': isRetry, // Flag to indicate if this was a retry storage
      };

      // Use a batch write to ensure all documents are created atomically
      final batch = _firestore.batch();

      // Main appointments collection
      batch.set(appointmentRef, appointmentData);

      // Doctor's appointments subcollection
      final doctorAppointmentRef = _firestore
          .collection('doctors')
          .doc(doctor.requestId)
          .collection('appointments')
          .doc(appointmentRef.id);
      batch.set(doctorAppointmentRef, appointmentData);

      // User's appointments subcollection
      final userAppointmentRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('appointments')
          .doc(appointmentRef.id);
      batch.set(userAppointmentRef, appointmentData);

      // Commit the batch
      await batch.commit();

      return appointmentRef.id;
    } catch (e) {
      throw Exception('Failed to create appointment record: $e');
    }
  }
}
