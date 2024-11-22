import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    //Image.asset('assets/wave.png', height: 16),
                  ],
                ),
                Text(
                  'Have a nice day',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        // actions: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () => _showLogoutDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        // ],
      ],
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  Future<void> signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google
      await GoogleSignIn().signOut();

      // Navigate back to login screen
      Navigator.pushReplacementNamed(context, '/letin');
    } catch (error) {
      // Handle any errors during sign out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $error')),
      );
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              signOut(context); // Perform the logout action
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
