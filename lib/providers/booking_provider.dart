import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/models/doctor_details_model.dart';
import 'package:masiha_user/screens/booking/appointment_confirmation.dart';

class PatientDetails {
  String name;
  int age;
  String issue;

  PatientDetails({
    required this.name,
    required this.age,
    required this.issue,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'issue': issue,
    };
  }
}

class BookingProvider with ChangeNotifier {
  final DoctorDetailsModel doctor;

  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  Map<String, dynamic>? _doctorAvailability;
  List<String> _bookedSlots = [];
  bool _isLoading = false;
  String? _error;
  PatientDetails? _patientDetails;
  // Getters
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  Map<String, dynamic>? get doctorAvailability => _doctorAvailability;
  List<String> get bookedSlots => _bookedSlots;
  bool get isLoading => _isLoading;
  String? get error => _error;
  PatientDetails? get patientDetails => _patientDetails;
  BookingProvider(this.doctor);

  // Setters with proper state management
  set selectedDate(DateTime? date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      _selectedTimeSlot = null; // Reset time slot when date changes
      notifyListeners();
      if (date != null) {
        loadBookedSlots(doctor.requestId!, date);
      }
    }
  }

  set selectedTimeSlot(String? timeSlot) {
    if (_selectedTimeSlot != timeSlot) {
      _selectedTimeSlot = timeSlot;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> loadDoctorAvailability(String doctorId) async {
    try {
      _setLoading(true);
      _setError(null);

      final docSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (!docSnapshot.exists) {
        _setError('Doctor document does not exist.');
        return;
      }

      final data = docSnapshot.data();
      if (data == null) {
        _setError('Doctor data is missing.');
        return;
      }

      _doctorAvailability = {
        'days': {
          'Monday': data['availability']?['Monday'] ?? false,
          'Tuesday': data['availability']?['Tuesday'] ?? false,
          'Wednesday': data['availability']?['Wednesday'] ?? false,
          'Thursday': data['availability']?['Thursday'] ?? false,
          'Friday': data['availability']?['Friday'] ?? false,
          'Saturday': data['availability']?['Saturday'] ?? false,
          'Sunday': data['availability']?['Sunday'] ?? false,
        },
        'startTime': data['workingHours']?['start'] ?? '09:00',
        'endTime': data['workingHours']?['end'] ?? '17:00',
      };

      // Find the next available date
      DateTime checkDate = DateTime.now();
      for (int i = 0; i < 30; i++) {
        if (isDoctorAvailable(checkDate)) {
          selectedDate = checkDate; // This will trigger loadBookedSlots
          break;
        }
        checkDate = checkDate.add(const Duration(days: 1));
      }

      notifyListeners();
    } catch (e) {
      _setError('Error loading doctor availability: $e');
    } finally {
      _setLoading(false);
    }
  }

  bool isDoctorAvailable(DateTime date) {
    if (_doctorAvailability == null || _doctorAvailability!['days'] == null) {
      return false;
    }

    final dayName = DateFormat('EEEE').format(date);
    return _doctorAvailability!['days'][dayName] ?? false;
  }

  Future<void> loadBookedSlots(String doctorId, DateTime date) async {
    try {
      _setLoading(true);
      _setError(null);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate',
              isEqualTo: DateFormat('yyyy-MM-dd').format(date))
          .get();

      _bookedSlots = querySnapshot.docs
          .map((doc) => doc.data()['timeSlot'] as String)
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Error loading booked slots: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<String> generateTimeSlots() {
    if (_doctorAvailability == null) return [];

    final workingHoursStart =
        _parseTimeString(_doctorAvailability!['startTime']);
    final workingHoursEnd = _parseTimeString(_doctorAvailability!['endTime']);

    List<String> slots = [];
    var currentTime = workingHoursStart;

    while (
        _timeOfDayToDouble(currentTime) < _timeOfDayToDouble(workingHoursEnd)) {
      slots.add(_formatTimeOfDay(currentTime));

      // Increment by 30 minutes
      final totalMinutes = currentTime.hour * 60 + currentTime.minute + 30;
      currentTime = TimeOfDay(
        hour: totalMinutes ~/ 60,
        minute: totalMinutes % 60,
      );
    }

    return slots;
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
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

  void setPatientDetails(PatientDetails details) {
    _patientDetails = details;
    notifyListeners();
  }

  Future<void> bookAppointment(BuildContext context) async {
    if (_selectedDate == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    if (_patientDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide patient details')),
      );
      return;
    }

    try {
      _setLoading(true);

      // Recheck availability
      await loadBookedSlots(doctor.requestId!, _selectedDate!);
      if (_bookedSlots.contains(_selectedTimeSlot)) {
        throw Exception('This slot has already been booked.');
      }

      // Add appointment to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': doctor.requestId,
        'appointmentDate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'timeSlot': _selectedTimeSlot,
        'patientDetails': _patientDetails!.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigate to confirmation screen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentConfirmationScreen(
              doctor: doctor,
              appointmentDate: _selectedDate!,
              appointmentTime: _selectedTimeSlot!,
              patientDetails: _patientDetails!,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: $e')),
        );
      }
    } finally {
      _setLoading(false);
    }
  }
}
