import 'package:flutter/material.dart';
import 'package:masiha_user/widgets/signup/pick_image.dart';
import 'dart:io';

class ProfileImageField extends StatelessWidget {
  final Function(File) onImageSelected;
  final String? errorText;

  const ProfileImageField({
    super.key,
    required this.onImageSelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileImagePicker(
          onImageSelected: onImageSelected,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
