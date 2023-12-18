// ignore_for_file: use_build_context_synchronously

import 'package:data_capture/global/global_var.dart';
import 'package:data_capture/screens/home.dart';
import 'package:data_capture/screens/login.dart';
import 'package:data_capture/services/auth_service.dart';
import 'package:data_capture/widgets/app_input_field.dart';
import 'package:data_capture/widgets/dialogs.dart';
import 'package:data_capture/widgets/primary_raised_button.dart';
import 'package:flutter/material.dart';

import '../themes/text_styles.dart';

class Register extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const Register());
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController confirmPwd = TextEditingController();

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
                    'Register',
                    style: AppTextStyle.title,
                  ),
                  Text(
                    'Please register to continue',
                    style: AppTextStyle.headline,
                  ),
                  const SizedBox(height: 30),
                  AppInputField(
                    prefixIcon: Icons.person,
                    controller: name,
                    hintText: 'Name',
                    labelText: 'Enter your name',
                    obscureText: false,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                  ),
                  const SizedBox(height: 25.0),
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
                  const SizedBox(height: 25.0),
                  AppInputField(
                    prefixIcon: Icons.lock_outline,
                    controller: confirmPwd,
                    hintText: 'Confirm Password',
                    labelText: 'Re-enter password',
                    obscureText: true,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return 'Please re-enter your password';
                      } else if (text != pwd.text) {
                        return 'Passwords do not match';
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
                        onPressed: () =>
                            Navigator.of(context).push(LoginScreen.route()),
                        child: const Text('Already have an account? Login'),
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
                                final user = await authService.register(
                                  email.text,
                                  confirmPwd.text,
                                  name.text,
                                );
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
