import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailTakenError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    return _emailTakenError;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  void _submit() {
    _emailTakenError = null;
    if (!_formKey.currentState!.validate()) return;

    final success = AuthService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!success) {
      setState(() => _emailTakenError = 'An account with this email already exists.');
      _formKey.currentState!.validate();
      return;
    }

    // Navigator method: pushReplacementNamed — go straight to Home and
    // pass the entered name as the route argument (per lab requirement).
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: _nameController.text.trim(),
    );
  }

  InputDecoration _fieldDecoration({required String label, required IconData icon}) {
    final radius = BorderRadius.circular(14);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryBrown),
      filled: true,
      fillColor: AppColors.primaryBrown.withOpacity(0.04),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primaryBrown.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primaryBrown, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryBrown.withOpacity(0.10), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_add_alt_1_outlined,
                              size: 56, color: AppColors.primaryBrown),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBrown)),
                      const SizedBox(height: 6),
                      Text('Sign up to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textDark.withOpacity(0.7), fontSize: 15)),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBrown.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: _validateName,
                              decoration: _fieldDecoration(label: 'Full Name', icon: Icons.badge_outlined),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              onChanged: (_) => setState(() => _emailTakenError = null),
                              decoration: _fieldDecoration(label: 'Email', icon: Icons.email_outlined),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: _validatePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryBrown),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                filled: true,
                                fillColor: AppColors.primaryBrown.withOpacity(0.04),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              validator: _validateConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryBrown),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () => setState(
                                      () => _obscureConfirmPassword = !_obscureConfirmPassword),
                                ),
                                filled: true,
                                fillColor: AppColors.primaryBrown.withOpacity(0.04),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _submit,
                                child: const Text('Sign Up',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: TextStyle(color: AppColors.textDark.withOpacity(0.7))),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: Text('Log In',
                                style: TextStyle(
                                    color: AppColors.primaryBrown, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
