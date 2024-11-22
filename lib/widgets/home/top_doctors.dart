import 'package:flutter/material.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/widgets/home/doctor_card.dart';
import 'package:provider/provider.dart';

class TopDoctorsSection extends StatelessWidget {
  const TopDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get available height (screen height minus other elements)
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight -
        topPadding -
        kToolbarHeight -
        250; // Adjust 250 based on other widgets' heights

    return SizedBox(
      height: availableHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View all'),
                ),
              ],
            ),
          ),

          // Doctors list - wrapped in Expanded
          Expanded(
            child: Consumer<DoctorProvider>(
              builder: (context, provider, _) {
                // if (provider.isLoading) {
                //   return const Center(child: CircularProgressIndicator());
                // }

                // if (provider.error.isNotEmpty) {
                //   return Center(child: Text(provider.error));
                // }

                if (provider.doctors.isEmpty) {
                  return const Center(
                    child: Text('No doctors available'),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: provider.doctors.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: DoctorCard(
                      doctor: provider.doctors[index],
                      onFavorite: () => provider
                          .toggleFavorite(provider.doctors[index].id as int),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
