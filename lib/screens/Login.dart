import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscure = true;

  void login() {
    Navigator.pushReplacementNamed(context, 'screens/Home');
  }

  void register() {
    Navigator.pushNamed(context, 'screens/SignIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌍 Language Icon

              const SizedBox(height: 10),

              // 🔷 App Name
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Ampora",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF009daa),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "Charging App for All",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🖼️ Illustration
              Center(
                child: Image.asset(
                  "images/ev_login.png",
                  height: 220,
                ),
              ),

              const SizedBox(height: 20),

              // 🔐 Login Title
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // 👤 Username
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email),
                  hintText: "Username",
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // 🔒 Password
              TextField(
                controller: _passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  ),
                  border: const UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // ✅ Remember + Forgot
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: const Color(0xFF009daa),
                    onChanged: (v) {
                      setState(() => rememberMe = v!);
                    },
                  ),
                  const Text("Remember Me"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF009daa)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔵 Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009daa),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 🟢 Register Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: register,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF009daa),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009daa),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ➖ OR Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // 🔴 Google Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    "images/google.png",
                    height: 22,
                  ),
                  label: const Text(
                    "Login with Google",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(side: BorderSide.none),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
