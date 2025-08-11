import 'package:flutter/material.dart';
import 'package:data_capture/global/global_var.dart';
import 'package:data_capture/screens/home.dart';
import 'package:data_capture/screens/register.dart';
import 'package:data_capture/services/auth_service.dart';
import 'package:data_capture/widgets/dialogs.dart';

class LoginPage extends StatefulWidget {
  static Route route({Function()? onSwitchToRegister}) => MaterialPageRoute(
      builder: (_) => LoginPage(onSwitchToRegister: onSwitchToRegister));
  final Function()? onSwitchToRegister;

  const LoginPage({super.key, this.onSwitchToRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  bool _loading = false;
  String _errorMessage = "";

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _errorMessage = "";
      });
      _formKey.currentState!.save();
      try {
        AuthService authService = AuthService();
        final user = await authService.login(email.text, pwd.text);
        currentUser = user;

        Navigator.pushReplacement(
          context,
          HomeScreen.route(user),
        );
      } catch (e) {
        setState(() {
          _loading = false;
          _errorMessage = e.toString();
        });
        showErrorSnackbar(context, '$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_circle, size: 64, color: primaryColor),
                const SizedBox(height: 12),
                Text(
                  "Welcome Back",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Sign in to your enumerator account",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Email
                _buildInputField(
                  icon: Icons.email_outlined,
                  hint: "Email",
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  showCounter: true,
                  validator: (text) {
                    if (text!.isEmpty) return 'Email is required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(text)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),

                // Password
                _buildInputField(
                  icon: Icons.lock_outline,
                  hint: "Password",
                  controller: pwd,
                  keyboardType: TextInputType.visiblePassword,
                  maxLength: 20,
                  showCounter: true,
                  validator: (text) {
                    if (text!.isEmpty) return 'Password is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Error alert
                if (_errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMessage.isNotEmpty) const SizedBox(height: 16),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _loading ? null : _handleLogin,
                    child: _loading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text("Signing in..."),
                            ],
                          )
                        : const Text("Sign In"),
                  ),
                ),
                const SizedBox(height: 16),

                // Switch to Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, Register.route());
                      },
                      child: const Text("Sign up"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
    bool showCounter = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: showCounter ? maxLength : null,
        validator: validator,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          suffixText: showCounter && maxLength != null ? '0/$maxLength' : null,
          suffixStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: "", // Hide the default counter
        ),
      ),
    );
  }
}
