import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(   // 👈 overflow fix
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // --- Logo ---
                  Image.asset(
                    "assets/images/login_logo.png",
                    height: 148,
                  ),
                  const SizedBox(height: 2),

                  // --- Title ---
                  const Text(
                    "Create New Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Phone Field ---
                  _inputField(
                    controller: _phoneController,
                    hint: "Phone number",
                    icon: Icons.phone_outlined,
                    keyboard: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Enter phone number'
                        : v.length < 10
                            ? 'Enter valid phone number'
                            : null,
                  ),
                  const SizedBox(height: 12),

                  // --- Name Field ---
                  _inputField(
                    controller: _nameController,
                    hint: "Full Name",
                    icon: Icons.person_outline,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 12),

                  // --- Email Field ---
                  _inputField(
                    controller: _emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                    keyboard: TextInputType.emailAddress,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Enter email'
                        : !v.contains('@')
                            ? 'Enter valid email'
                            : null,
                  ),
                  const SizedBox(height: 12),

                  // --- Password Field ---
                  _inputField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Enter password'
                        : v.length < 6
                            ? 'Password too short'
                            : null,
                  ),
                  const SizedBox(height: 10),

                  // --- Remember me ---
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) =>
                            setState(() => rememberMe = val!),
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // --- Error ---
                  if (authProvider.error != null)
                    Text(authProvider.error!,
                        style: const TextStyle(color: Colors.red)),

                  // --- Sign Up Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: authProvider.loading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await authProvider.signup(
                                  _nameController.text.trim(),
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (authProvider.user != null) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              }
                            },
                      child: authProvider.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text("Sign Up",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Or Continue With ---
                  const Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("or continue with"),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Social Buttons ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon("assets/images/facebook.png", () {}),
                      const SizedBox(width: 12),
                      _socialIcon("assets/images/google.png", () {}),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Redirect ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable input field
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      validator: validator,
    );
  }

  Widget _socialIcon(String assetPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Image.asset(assetPath, height: 22, width: 22),
      ),
    );
  }
}
