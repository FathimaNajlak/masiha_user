import 'package:flutter/material.dart';
import 'package:masiha_user/models/user_model.dart';
import 'package:masiha_user/providers/user_details_provider.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserDetailsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<UserDetailsProvider>(context, listen: false);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _provider.fetchLatestUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
      ),
      body: Consumer<UserDetailsProvider>(
        builder: (context, provider, child) {
          final user = provider.currentUserDetails;

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return const Center(child: Text('No user details found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: user.fullName,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                    validator: provider.validateName,
                    onSaved: (value) => user.fullName = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: user.age?.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    validator: provider.validateAge,
                    onSaved: (value) => user.age = int.tryParse(value ?? ''),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: user.email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: provider.validateEmail,
                    onSaved: (value) => user.email = value,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _saveUserDetails(user),
                    child:
                        Text(provider.isLoading ? 'Saving...' : 'Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveUserDetails(UserModel user) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final success = await _provider.updateUserDetails(user);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Details updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating details: $e')),
          );
        }
      }
    }
  }
}
