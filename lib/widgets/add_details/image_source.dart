import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masiha_user/providers/user_details_provider.dart'; // Ensure you have this package in your pubspec.yaml

class ImageSourceDialog extends StatelessWidget {
  final UserDetailsProvider userDetailsProvider;

  const ImageSourceDialog({
    super.key,
    required this.userDetailsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Image Source'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              userDetailsProvider.pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              userDetailsProvider.pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  static void show(
      BuildContext context, UserDetailsProvider userDetailsProvider) {
    showDialog(
      context: context,
      builder: (context) =>
          ImageSourceDialog(userDetailsProvider: userDetailsProvider),
    );
  }
}
