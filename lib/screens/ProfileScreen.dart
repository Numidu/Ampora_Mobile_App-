import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/models/user.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/user_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? userId;
  final _userService = UserService();
  User? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (userId == null) return;

    final fetchedUser = await _userService.getuserId(userId!);
    setState(() {
      user = fetchedUser;
    });
  }

  void openHelpLink() async {
    print("connect setting");
    final Uri url = Uri.parse(
        "https://drive.google.com/file/d/1uq0n10vnvN-zAFbbHcJ_VeugtkYsMz8C/view?usp=sharing");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void logout(BuildContext context) {
    final auth = context.read<AuthProvider>();

    auth.logout();

    Navigator.of(context).pushNamedAndRemoveUntil(
      'screens/Login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.card(context),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage("images/profile.jpg"),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon:
                          const Icon(Icons.edit, size: 16, color: Colors.white),
                      onPressed: () {
                        if (user == null) return;
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _EditProfileSheet(user: user!),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Numidu Dulanga",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.text(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "dnumidu@gmail.com",
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary(context),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.electric_car,
                      label: "Vehicles",
                      value: "3",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.ev_station,
                      label: "Charges",
                      value: "24",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.energy_savings_leaf,
                      label: "CO₂ Saved",
                      value: "42kg",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    subtitle: "App preferences & configuration",
                    onTap: () {
                      Navigator.pushNamed(context, 'screens/Settings');
                    },
                  ),
                  const SizedBox(height: 12),
                  _MenuTile(
                    icon: Icons.home_outlined,
                    title: "Charger Home",
                    subtitle: "Manage home charger",
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _MenuTile(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    subtitle: "FAQs & customer support",
                    onTap: () {
                      openHelpLink();
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout, size: 22),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.iconBg(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryGreen,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.text(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.iconBg(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryGreen,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppTheme.textSecondary(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final User user;
  const _EditProfileSheet({required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.user);
    nameController = TextEditingController(text: widget.user.fullName);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.border(context),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text(context),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Name field
            Text(
              "Full Name",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.text(context),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary(context).withOpacity(0.6),
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.person_outline,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Email field
            Text(
              "Email",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.text(context),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary(context).withOpacity(0.6),
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Password field
            Text(
              "Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.text(context),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: password,
              obscureText: true,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary(context).withOpacity(0.6),
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // Save logic here (Firebase / API)
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
