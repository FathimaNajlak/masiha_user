import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/add_details/image_source.dart';
import 'package:masiha_user/widgets/costum_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:masiha_user/models/user_model.dart';
import 'package:masiha_user/providers/user_details_provider.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDetails();
    });
  }

  Future<void> _loadUserDetails() async {
    final provider = Provider.of<UserDetailsProvider>(context, listen: false);
    await provider.fetchLatestUserDetails();

    final userDetails = provider.currentUserDetails;
    if (userDetails != null) {
      setState(() {
        _nameController.text = userDetails.fullName ?? '';
        _ageController.text = userDetails.age?.toString() ?? '';
        _emailController.text = userDetails.email ?? '';
        _selectedDate = userDetails.dateOfBirth;
        _selectedGender = userDetails.gender;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    final provider = Provider.of<UserDetailsProvider>(context, listen: false);

    if (!provider.formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = UserModel(
        fullName: _nameController.text,
        age: int.tryParse(_ageController.text),
        email: _emailController.text,
        dateOfBirth: _selectedDate,
        gender: _selectedGender,
        imagePath: provider.currentUserDetails?.imagePath,
      );

      if (provider.imageFile != null) {
        final imageUrl = await provider.updateDoctorImage(provider.imageFile!);
        updatedUser.imagePath = imageUrl;
      }

      final success = await provider.updateUserDetails(updatedUser);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Consumer<UserDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileImage(context, provider),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: provider.validateName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: provider.validateAge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: provider.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Save Changes',
                    isLoading: _isLoading,
                    onTap: _saveChanges,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(
      BuildContext context, UserDetailsProvider provider) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: provider.imageFile != null
              ? FileImage(provider.imageFile!)
              : (provider.currentUserDetails?.imagePath != null
                  ? NetworkImage(provider.currentUserDetails!.imagePath!)
                  : null) as ImageProvider?,
          child: (provider.imageFile == null &&
                  provider.currentUserDetails?.imagePath == null)
              ? const Icon(Icons.person, size: 60)
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              onPressed: () {
                ImageSourceDialog.show(context, provider);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
