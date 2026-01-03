import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/models/user.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/provider/theme_provider.dart';
import 'package:electric_app/service/user_service.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
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
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.text(context),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.background(context),
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.text(context)),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: _loaded
                ? const Center(child: LogoLoader())
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
                            color: AppTheme.card(context),
                            borderRadius: BorderRadius.circular(24),
                            border: isDark
                                ? Border.all(
                                    color: AppTheme.border(context), width: 1)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDark ? 0.3 : 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _namecontroller,
                                hintText: "Enter your full name",
                                icon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: screenheight * 0.02),
                              _buildTextField(
                                controller: _emailcontroller,
                                hintText: "Enter your email address",
                                icon: Icons.email_outlined,
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
                            color: AppTheme.card(context),
                            borderRadius: BorderRadius.circular(24),
                            border: isDark
                                ? Border.all(
                                    color: AppTheme.border(context), width: 1)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDark ? 0.3 : 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _passwordcontroller,
                                hintText: "Enter new password",
                                icon: Icons.lock_outline,
                                obscureText: true,
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
                              _buildTextField(
                                controller: _confirmpasswordcontroller,
                                hintText: "Confirm new password",
                                icon: Icons.lock_outline,
                                obscureText: true,
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
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Settings saved successfully!'),
                                      ],
                                    ),
                                    backgroundColor: AppTheme.primaryGreen,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                            color: AppTheme.card(context),
                            borderRadius: BorderRadius.circular(24),
                            border: isDark
                                ? Border.all(
                                    color: AppTheme.border(context), width: 1)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDark ? 0.3 : 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
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
                              Divider(
                                  height: 1, color: AppTheme.border(context)),
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
                              Divider(
                                  height: 1, color: AppTheme.border(context)),
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
                          ),
                        ),

                        SizedBox(height: screenheight * 0.03),
                      ],
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
            color: AppTheme.iconBg(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text(context),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 15, color: AppTheme.text(context)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppTheme.textSecondary(context).withOpacity(0.6),
          fontSize: 15,
        ),
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryGreen,
          size: 22,
        ),
        filled: true,
        fillColor: AppTheme.iconBg(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.border(context),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.border(context),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppTheme.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B6B),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B6B),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedTheme == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryGreen.withOpacity(0.15)
                    : AppTheme.iconBg(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryGreen
                    : AppTheme.textSecondary(context),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.text(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedTheme,
              onChanged: (_) => onTap(),
              activeColor: AppTheme.primaryGreen,
            )
          ],
        ),
      ),
    );
  }
}
