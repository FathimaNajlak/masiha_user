// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

// Future<void> _signOut(BuildContext context) async {
//   try {
//     // Sign out from Firebase
//     await FirebaseAuth.instance.signOut();

//     // Sign out from Google
//     await GoogleSignIn().signOut();

//     // Navigate back to login screen
//     Navigator.pushReplacementNamed(context, '/login');
//   } catch (error) {
//     // Handle any errors during sign out
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Sign out failed: $error')),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.black,
//           onPressed: () {
//             Navigator.pushReplacementNamed(context, '/login');
//           },
//         ),
//         title: const Text('Home Screen'),
// actions: [
//   IconButton(
//     icon: const Icon(Icons.logout, color: Colors.black),
//     onPressed: () => _signOut(context),
//   ),
// ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Home Screen"),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _signOut(context),
//               child: const Text('Sign Out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/home/bottom_nav_bar.dart';
import 'package:masiha_user/widgets/home/catogary.dart';
import 'package:masiha_user/widgets/home/header.dart';
import 'package:masiha_user/widgets/home/search.dart';
import 'package:masiha_user/widgets/home/top_doctors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserHeader(),
                const SizedBox(height: 16),
                const Search(),
                const SizedBox(height: 24),
                const CategorySection(),
                const SizedBox(height: 24),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.4, // Limited height
                  child: const TopDoctorsSection(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
