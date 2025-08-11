import 'package:data_capture/global/global_var.dart';
import 'package:data_capture/models/user.dart';
import 'package:data_capture/screens/home.dart';
import 'package:data_capture/screens/login.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:data_capture/services/location_service.dart';
import 'package:data_capture/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserDetails();
  }

  void checkUserDetails() async {
    try {
      final position = await LocationService().getCurrentLocation();
      currentLocation = position;
      UserData? userData = await LocalStorageService.getUserData();
      if (userData != null && userData.userId.isNotEmpty) {
        currentUser = userData;
        Navigator.pushReplacement(context, HomeScreen.route(userData));
      } else {
        Navigator.pushReplacement(context, LoginPage.route());
      }
    } catch (e) {
      Navigator.pushReplacement(context, LoginPage.route());
      showErrorSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 200,
            ),
            SizedBox(height: 15),
            Text(
              'Data Capture',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
