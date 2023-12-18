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
