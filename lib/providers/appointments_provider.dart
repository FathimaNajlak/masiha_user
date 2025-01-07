import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showUpcoming = true;
  bool _isLoading = false;
  String? _error;

  bool get showUpcoming => _showUpcoming;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void toggleView(bool showUpcoming) {
    _showUpcoming = showUpcoming;
    notifyListeners();
  }

  Stream<QuerySnapshot> getAppointments() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: _showUpcoming ? 'scheduled' : 'completed')
        .where('payment.status', isEqualTo: 'completed')
        .orderBy('appointmentDate')
        .snapshots()
        .handleError((error) {
      print('Error in stream: $error');
      _error = 'Failed to fetch appointments: $error';
      notifyListeners();
      throw error;
    });
  }

  Widget buildAppointmentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: getAppointments(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No appointments found'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final appointmentDate =
                (data['appointmentDate'] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(data['doctorName'] ?? 'No name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient: ${data['patientName']}'),
                    Text(
                        'Date: ${DateFormat('MMM dd, yyyy').format(appointmentDate)}'),
                    Text('Time: ${data['appointmentTime']}'),
                    Text('Specialization: ${data['doctorSpecialization']}'),
                    Text('Status: ${data['status']}'),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> cancelAppointment(String appointmentId) async {
    if (_isLoading) return;

    try {
      _setLoading(true);

      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _error = 'Failed to cancel appointment: $e';
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
