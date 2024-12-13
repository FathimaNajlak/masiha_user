import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchDoctorsBySpecialty(
      String specialty) async {
    try {
      // Query for approved doctors with the specific specialty
      QuerySnapshot querySnapshot = await _firestore
          .collection('doctors')
          .where('specialty', isEqualTo: specialty)
          .where('isApproved', isEqualTo: true)
          .get();

      // Convert query results to list of doctor data
      return querySnapshot.docs.map((doc) {
        // Convert document to map and include document ID
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      print('Error fetching doctors by specialty: $e');
      return [];
    }
  }
}
