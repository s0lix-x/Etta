import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  Future<void> register() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Register berhasil')));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Register gagal')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/Etta.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "ETTA",
              style: GoogleFonts.newsreader(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: const Color(0xff111111),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Color(0xff111111),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Start reading, curating lists, and sharing your ideas with a deliberate community.",
            style: TextStyle(fontSize: 16, color: Color(0xff111111)),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person_2_outlined,
                color: Color(0xff111111),
              ),
              labelText: "Username",
              labelStyle: const TextStyle(color: Color(0xff111111)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xffe8e6df)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xffe8e6df)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xff111111)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.mail_outline,
                color: Color(0xff111111),
              ),
              labelText: "Email",
              labelStyle: const TextStyle(color: Color(0xff111111)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xffe8e6df)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xffe8e6df)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xff111111)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email wajib diisi';
              } else if (!value.contains('@') || !value.contains('.')) {
                return 'Format email tidak valid';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xff111111),
              ),
              labelText: "Password",
              labelStyle: const TextStyle(color: Color(0xff111111)),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xff111111),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xffe8e6df)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xffe8e6df)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: Color(0xff111111)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password wajib diisi';
              }
              if (value.length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await register();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff111111),
                foregroundColor: const Color(0xfffaf9f5),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              child: const Text("CREATE ACCOUNT"),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(color: Color(0xff111111)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Color(0xffb84a2a),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
