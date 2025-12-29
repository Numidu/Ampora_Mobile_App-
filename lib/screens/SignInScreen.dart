import 'package:electric_app/service/user_service.dart';
import 'package:electric_app/widget/custom_button.dart';
import 'package:flutter/material.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final useservice = UserService();
  final _formKey = GlobalKey<FormState>();

  Future<void> registerUser() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String phone = _phoneController.text.trim();

    if (password != confirmPassword) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      bool issucess = await useservice.registerUser({
        'fullName': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': "USER"
      });
      if (issucess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushReplacementNamed(context, 'screens/Login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF00c4b4),
                Color(0xFF009daa),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF009daa).withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Center(
              child: Text(
                "SignUp / Profile",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Welcome Back 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009daa),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Login to continue your journey',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const SizedBox(height: 20),
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Name TextField
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF009daa)),
                          filled: true,
                          fillColor: const Color(0xFFf6f9fc),
                          hintText: 'Numidu Dulanga',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Name required' : null,
                      ),
                      const SizedBox(height: 20),
                      // Email Label
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF009daa)),
                          filled: true,
                          fillColor: const Color(0xFFf6f9fc),
                          hintText: 'you@example.com',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email required';
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(v)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Label
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF009daa)),
                          filled: true,
                          fillColor: const Color(0xFFf6f9fc),
                          hintText: 'Ndd@12345',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 6)
                            return 'Minimum 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Password TextField
                      TextFormField(
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF009daa)),
                          filled: true,
                          fillColor: const Color(0xFFf6f9fc),
                          hintText: 'Ndd@12345',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Password TextField
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Color(0xFF009daa)),
                          filled: true,
                          fillColor: const Color(0xFFf6f9fc),
                          hintText: '0710805748',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (!RegExp(r'^(07[0-9]{8})$').hasMatch(v ?? ''))
                            return 'Invalid phone';
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                          text: "Save",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser();
                            }
                          },
                          color: const Color(0xFF009daa))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    // Password TextField
  }
}
