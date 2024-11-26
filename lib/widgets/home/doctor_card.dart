// import 'package:flutter/material.dart';
// import 'package:masiha_user/models/doctor.dart';

// class DoctorCard extends StatelessWidget {
//   final Doctor doctor;
//   final VoidCallback onFavorite;

//   const DoctorCard({
//     super.key,
//     required this.doctor,
//     required this.onFavorite,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: AssetImage(doctor.imageUrl),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctor.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '${doctor.specialty} • ${doctor.hospital}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: Icon(
//                 doctor.isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: doctor.isFavorite ? Colors.red : Colors.grey,
//               ),
//               onPressed: onFavorite,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onFavorite;
  final VoidCallback onTap; // Add onTap parameter

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onFavorite,
    required this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Use GestureDetector for tap detection
      onTap: onTap, // Call onTap when the card is tapped
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(doctor.imageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${doctor.specialty} • ${doctor.hospital}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  doctor.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: doctor.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
