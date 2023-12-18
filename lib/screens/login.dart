// ignore_for_file: use_build_context_synchronously

import 'package:data_capture/global/global_var.dart';
import 'package:data_capture/screens/home.dart';
import 'package:data_capture/screens/register.dart';
import 'package:data_capture/services/auth_service.dart';
import 'package:data_capture/themes/text_styles.dart';
import 'package:data_capture/widgets/dialogs.dart';
import 'package:data_capture/widgets/primary_raised_button.dart';
import 'package:flutter/material.dart';

import '../widgets/app_input_field.dart';

class LoginScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const LoginScreen());
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _submitted = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Center(
                    child: FlutterLogo(
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Login',
                    style: AppTextStyle.title,
                  ),
                  Text(
                    'Please login to continue',
                    style: AppTextStyle.headline,
                  ),
                  const SizedBox(height: 30),
                  AppInputField(
                    prefixIcon: Icons.email_outlined,
                    controller: email,
                    hintText: 'Email',
                    labelText: 'Enter email',
                    validator: (text) {
                      String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                      RegExp regExp = RegExp(pattern);
                      if (text!.isEmpty) {
                        return 'Email is required';
                      } else if (!regExp.hasMatch(text)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                  ),
                  const SizedBox(height: 25.0),
                  AppInputField(
                    prefixIcon: Icons.lock_outline,
                    controller: pwd,
                    hintText: 'Password',
                    labelText: 'Enter password',
                    obscureText: true,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Password is required';
                      } else if (text.length < 6) {
                        return 'Password should be at least 6 characters';
                      }
                      return null;
                    },
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacement(Register.route()),
                        child: const Text('Don\'t have an account? Register'),
                      )
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  AppPrimaryRaisedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              _formKey.currentState!.save();
                              try {
                                AuthService authService = AuthService();
                                final user = await authService.login(
                                    email.text, pwd.text);
                                currentUser = user;

                                Navigator.pushReplacement(
                                  context,
                                  HomeScreen.route(user),
                                );
                              } catch (e) {
                                setState(() {
                                  _loading = false;
                                });
                                showErrorSnackbar(context, '$e');
                              }
                            }
                          },
                    child: _loading
                        ? const CircularProgressIndicator()
                        : Text(
                            'Login',
                            style: AppTextStyle.buttonTitle,
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
