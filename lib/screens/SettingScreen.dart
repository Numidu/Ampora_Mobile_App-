import 'package:electric_app/models/user.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/provider/theme_provider.dart';
import 'package:electric_app/service/user_service.dart';
import 'package:electric_app/widget/Custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namecontroller = TextEditingController();
  late final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();

  late String _selectedTheme;

  String? userId;
  final _userService = UserService();
  User? user;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = context.read<ThemeProvider>().themeMode;
    _selectedTheme = theme == ThemeMode.dark
        ? 'Dark'
        : theme == ThemeMode.system
            ? 'Auto'
            : 'Light';
    user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
    print(userId);
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (userId == null) return;

    final fetchedUser = await _userService.getuserId(userId!);
    _namecontroller.text = user!.fullName;
    _emailcontroller.text = user!.email;

    setState(() {
      user = fetchedUser;
      _loaded = false;
    });
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _emailcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009daa), Color(0xFF00c6d7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: _loaded
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Section Header
                          _buildSectionHeader(
                            icon: Icons.person_outline,
                            title: "Profile Information",
                            subtitle: "Update your personal details",
                          ),
                          SizedBox(height: screenheight * 0.025),

                          // Profile Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                CustomTextfield(
                                  controller: _namecontroller,
                                  hintTexts: "Enter your full name",
                                  prefixIcons: const Icon(Icons.person_outline,
                                      color: Color(0xFF009daa), size: 20),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenheight * 0.02),
                                CustomTextfield(
                                  controller: _emailcontroller,
                                  hintTexts: "Enter your email address",
                                  prefixIcons: const Icon(Icons.email_outlined,
                                      color: Color(0xFF009daa), size: 20),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenheight * 0.04),

                          // Security Section Header
                          _buildSectionHeader(
                            icon: Icons.lock_outline,
                            title: "Security",
                            subtitle: "Change your password",
                          ),
                          SizedBox(height: screenheight * 0.025),

                          // Security Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                CustomTextfield(
                                  controller: _passwordcontroller,
                                  hintTexts: "Enter new password",
                                  prefixIcons: const Icon(Icons.lock_outline,
                                      color: Color(0xFF009daa), size: 20),
                                  validator: (value) {
                                    if (value != null &&
                                        value.isNotEmpty &&
                                        value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenheight * 0.02),
                                CustomTextfield(
                                  controller: _confirmpasswordcontroller,
                                  hintTexts: "Confirm new password",
                                  prefixIcons: const Icon(Icons.lock_outline,
                                      color: Color(0xFF009daa), size: 20),
                                  validator: (value) {
                                    if (_passwordcontroller.text.isNotEmpty &&
                                        value != _passwordcontroller.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenheight * 0.04),

                          // Save Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF009daa), Color(0xFF00c6d7)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF009daa).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Handle save settings
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: const [
                                          Icon(Icons.check_circle,
                                              color: Colors.white),
                                          SizedBox(width: 12),
                                          Text('Settings saved successfully!'),
                                        ],
                                      ),
                                      backgroundColor: const Color(0xFF009daa),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenheight * 0.04),

                          // Appearance Section Header
                          _buildSectionHeader(
                            icon: Icons.palette_outlined,
                            title: "Appearance",
                            subtitle: "Customize your theme",
                          ),
                          SizedBox(height: screenheight * 0.025),

                          // Theme Card
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _buildThemeOption(
                                    title: 'Light Theme',
                                    subtitle: 'Bright and clean interface',
                                    icon: Icons.light_mode_outlined,
                                    value: 'Light',
                                    onTap: () {
                                      setState(() => _selectedTheme = 'Light');
                                      context.read<ThemeProvider>().setLight();
                                    },
                                  ),
                                  Divider(height: 1, color: Colors.grey[200]),
                                  _buildThemeOption(
                                    title: 'Dark Theme',
                                    subtitle: 'Easy on the eyes',
                                    icon: Icons.dark_mode_outlined,
                                    value: 'Dark',
                                    onTap: () {
                                      setState(() => _selectedTheme = 'Dark');
                                      context.read<ThemeProvider>().setDark();
                                    },
                                  ),
                                  Divider(height: 1, color: Colors.grey[200]),
                                  _buildThemeOption(
                                    title: 'Auto',
                                    subtitle: 'Match system settings',
                                    icon: Icons.brightness_auto_outlined,
                                    value: 'Auto',
                                    onTap: () {
                                      setState(() => _selectedTheme = 'Auto');
                                      context.read<ThemeProvider>().setAuto();
                                    },
                                  ),
                                ],
                              )),

                          SizedBox(height: screenheight * 0.03),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF009daa), Color(0xFF00c6d7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF009daa).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2d3748),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required VoidCallback onTap, // ✅ add this
  }) {
    final isSelected = _selectedTheme == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF009daa) : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedTheme,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF009daa),
            )
          ],
        ),
      ),
    );
  }
}
