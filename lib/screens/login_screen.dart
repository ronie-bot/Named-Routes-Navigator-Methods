import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  // Errors that come from checking the registered accounts
  String? _emailAuthError;
  String? _passwordAuthError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------- VALIDATORS ----------
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email / Username is required.';
    }
    return _emailAuthError; // "No account found..." (or null)
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return _passwordAuthError; // "Incorrect password." (or null)
  }

  void _login() {
    // Clear the old account-check errors first
    _emailAuthError = null;
    _passwordAuthError = null;

    // Step 1: format validation (blank fields, 6+ characters)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    // Step 2: check if the account is registered
    final AppUser? user = AuthService.findByEmail(_emailController.text);
    if (user == null) {
      setState(() {
        _emailAuthError = 'No account found with this email.';
        _isSubmitting = false;
      });
      _formKey.currentState!.validate(); // re-run to show the red border
      return;
    }
    if (user.password != _passwordController.text) {
      setState(() {
        _passwordAuthError = 'Incorrect password.';
        _isSubmitting = false;
      });
      _formKey.currentState!.validate();
      return;
    }

    // Step 3: registered account + correct password -> go to Home
    // Navigator method #1: pushReplacementNamed
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: user.name,
    );
  }

  void _goToSignUp() {
    // Navigator method #2: pushNamed
    Navigator.pushNamed(context, '/signup');
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final radius = BorderRadius.circular(14);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryBrown),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.primaryBrown.withOpacity(0.04),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primaryBrown.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primaryBrown.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primaryBrown, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
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
            colors: [
              AppColors.primaryBrown.withOpacity(0.10),
              Colors.white,
            ],
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
                      // ---------- Header ----------
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_person_outlined,
                            size: 56,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBrown,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Log in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textDark.withOpacity(0.7),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ---------- Form Card ----------
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
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              onChanged: (_) =>
                                  setState(() => _emailAuthError = null),
                              decoration: _fieldDecoration(
                                label: 'Email / Username',
                                icon: Icons.person_outline,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: _validatePassword,
                              onChanged: (_) =>
                                  setState(() => _passwordAuthError = null),
                              decoration: _fieldDecoration(
                                label: 'Password',
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.primaryBrown.withOpacity(0.6),
                                  ),
                                  onPressed: () {
                                    setState(() =>
                                        _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBrown,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shadowColor:
                                      AppColors.primaryBrown.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          valueColor:
                                              AlwaysStoppedAnimation(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                          ),
                          TextButton(
                            onPressed: _goToSignUp,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.primaryBrown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
