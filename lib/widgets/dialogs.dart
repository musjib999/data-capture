import 'package:data_capture/themes/colors.dart';
import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showInformationPopUp(BuildContext context,
    {required String title,
    required String info,
    required void Function()? onYes}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(info),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: onYes,
              child: const Text(
                'Yes',
                style: TextStyle(color: AppColors.primaryColor),
              ),
            )
          ],
        );
      });
}
