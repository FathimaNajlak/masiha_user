import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? selectedDate;
  String? selectedTimeSlot;
  Map<String, dynamic>? doctorAvailability;
  List<String> bookedSlots = [];
  bool isLoading = false;
  String? error;

  Future<void> loadDoctorAvailability(String doctorId) async {
    try {
      isLoading = true;
      notifyListeners();

      final docSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['availability'] != null) {
          doctorAvailability = data['availability'];
          notifyListeners();
        } else {
          error = 'Doctor availability data is missing.';
        }
      } else {
        error = 'Doctor document does not exist.';
      }
    } catch (e) {
      error = 'Error loading doctor availability: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookedSlots(String doctorId, DateTime date) async {
    try {
      isLoading = true;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate',
              isEqualTo: DateFormat('yyyy-MM-dd').format(date))
          .get();

      bookedSlots = querySnapshot.docs
          .map((doc) => doc.data()['timeSlot'] as String)
          .toList();
    } catch (e) {
      error = 'Error loading booked slots: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isDoctorAvailable(DateTime date) {
    if (doctorAvailability == null || doctorAvailability!['days'] == null) {
      return false;
    }

    final dayName = DateFormat('EEEE').format(date).toLowerCase();
    return doctorAvailability!['days'][dayName] ?? false;
  }

  List<String> generateTimeSlots() {
    if (doctorAvailability == null ||
        doctorAvailability!['startTime'] == null ||
        doctorAvailability!['endTime'] == null) {
      return [];
    }

    final startTime = TimeOfDay(
      hour: doctorAvailability!['startTime']['hour'],
      minute: doctorAvailability!['startTime']['minute'],
    );
    final endTime = TimeOfDay(
      hour: doctorAvailability!['endTime']['hour'],
      minute: doctorAvailability!['endTime']['minute'],
    );

    List<String> slots = [];
    var currentTime = startTime;

    while (_timeOfDayToDouble(currentTime) < _timeOfDayToDouble(endTime)) {
      final timeString = _formatTimeOfDay(currentTime);
      slots.add(timeString);

      // Increment by 30 minutes
      final totalMinutes = currentTime.hour * 60 + currentTime.minute + 30;
      currentTime = TimeOfDay(
        hour: totalMinutes ~/ 60,
        minute: totalMinutes % 60,
      );
    }

    return slots;
  }

  double _timeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> bookAppointment(
      String doctorId, DateTime date, String timeSlot) async {
    try {
      // Validate availability
      await loadBookedSlots(doctorId, date);

      if (bookedSlots.contains(timeSlot)) {
        throw Exception('This slot has already been booked.');
      }

      // Add appointment to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': doctorId,
        'appointmentDate': DateFormat('yyyy-MM-dd').format(date),
        'timeSlot': timeSlot,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }
}
