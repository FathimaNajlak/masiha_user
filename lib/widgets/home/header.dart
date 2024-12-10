import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masiha_user/providers/user_details_provider.dart';
import 'package:provider/provider.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  _UserHeaderState createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  Future<void> _refreshUserDetails() async {
    await Provider.of<UserDetailsProvider>(context, listen: false)
        .fetchLatestUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsProvider>(
      builder: (context, provider, child) {
        final userDetails = provider.currentUserDetails;

        if (userDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
            onRefresh: _refreshUserDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: userDetails.imagePath != null &&
                              File(userDetails.imagePath!).existsSync()
                          ? FileImage(File(userDetails.imagePath!))
                          : const AssetImage('assets/images/profile.jpg')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userDetails.fullName ?? 'User',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Have a nice day 👋🏼',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
