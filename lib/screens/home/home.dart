import 'package:flutter/material.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/screens/profile_screen.dart';
import 'package:masiha_user/widgets/home/bottom_nav_bar.dart';
import 'package:masiha_user/screens/home/catogary.dart';
import 'package:masiha_user/widgets/home/header.dart';
import 'package:masiha_user/screens/home/top_doctors.dart';
import 'package:masiha_user/widgets/home/search_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctors = doctorProvider.doctors;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: const UserHeader(),
                ),
                const SizedBox(height: 24),
                const DoctorSearchBar(),
                const SizedBox(height: 24),
                const CategorySection(),
                const SizedBox(height: 24),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
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
