import 'package:data_capture/themes/colors.dart';
import 'package:flutter/material.dart';

class AppPrimaryRaisedButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const AppPrimaryRaisedButton(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
