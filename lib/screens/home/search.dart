import 'package:flutter/material.dart';
import 'package:masiha_user/models/doctor.dart';
import 'package:masiha_user/providers/doctor_filter_provider.dart';
import 'package:masiha_user/providers/doctor_provider.dart';
import 'package:masiha_user/widgets/home/search/doctor_list.dart';
import 'package:provider/provider.dart';

class DoctorSearchScreen extends StatelessWidget {
  const DoctorSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorFilterProvider(),
      child: const DoctorSearchContent(),
    );
  }
}

class DoctorSearchContent extends StatefulWidget {
  const DoctorSearchContent({super.key});

  @override
  State<DoctorSearchContent> createState() => _DoctorSearchContentState();
}

class _DoctorSearchContentState extends State<DoctorSearchContent> {
  @override
  void initState() {
    super.initState();
    // Initialize the filtered doctors list after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctorProvider =
          Provider.of<DoctorProvider>(context, listen: false);
      final filterProvider =
          Provider.of<DoctorFilterProvider>(context, listen: false);
      // Initialize with empty search to show all doctors
      filterProvider.setSearchQuery('', doctorProvider.doctors);
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctors = doctorProvider.doctors;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Doctors',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(doctors: doctors),
          ),
          //SpecialtyFilter(doctors: doctors),
          const Expanded(
            child: DoctorsList(),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final List<Doctor> doctors;

  const SearchBar({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<DoctorFilterProvider>(context);

    return TextField(
      decoration: InputDecoration(
        hintText: 'Search doctors',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: filterProvider.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => filterProvider.setSearchQuery('', doctors),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) => filterProvider.setSearchQuery(value, doctors),
    );
  }
}
