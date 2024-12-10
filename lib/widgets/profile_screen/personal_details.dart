import 'package:flutter/material.dart';
import 'package:masiha_user/models/user_model.dart';
import 'package:masiha_user/providers/user_details_provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
  
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  UserModel? _user;
  final _formKey = GlobalKey<FormState>();
  final _provider = UserDetailsProvider();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      await _provider.fetchLatestUserDetails();
    } catch (e) {
      // Handle the error, e.g., show an error message to the user
      print('Error fetching user details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personal Details'),
        ),
        body: FutureBuilder<void>(
            future: _fetchUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching user details'));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: _user != null
                      ? Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                initialValue: _user?.fullName,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                ),
                                validator: (value) =>
                                    _provider.validateName(value),
                                onSaved: (value) => _user?.fullName = value,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: _user?.age?.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    _provider.validateAge(value),
                                onSaved: (value) =>
                                    _user?.age = int.parse(value!),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: _user?.email,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    _provider.validateEmail(value),
                                onSaved: (value) => _user?.email = value,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _saveUserDetails,
                                child: const Text('Save Changes'),
                              ),
                            ],
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              );
            }));
  }

  Future<void> _saveUserDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _provider.updateUserDetails(_user!);
      // Navigate back to the profile screen or show a success message
    }
  }
}
