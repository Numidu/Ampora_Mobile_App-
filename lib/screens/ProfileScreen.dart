import 'package:electric_app/models/user.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart%20';
import 'package:url_launcher/url_launcher.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  static const Color primaryBlue = Color(0xFF009DAA);
  static const Color lightBlue = Color(0xFFE6F7F9);
  static const Color darkText = Color(0xFF1F2937);

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
      backgroundColor: Colors.grey[50],
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
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
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Profilescreen.primaryBlue,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon:
                          const Icon(Icons.edit, size: 16, color: Colors.white),
                      onPressed: () {
                        if (user == null) return;
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => _EditProfileSheet(user: user!),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Numidu Dulanga",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Profilescreen.darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "dnumidu@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                  const Text(
                    "Account Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Profilescreen.darkText,
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
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Profilescreen.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Profilescreen.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Profilescreen.primaryBlue),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Profilescreen.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Profilescreen.primaryBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final User user;
  const _EditProfileSheet({super.key, required this.user});

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
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Center(
            child: Text(
              "Edit Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 24),

          // Name field
          const Text("Full Name"),
          const SizedBox(height: 6),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your name",
            ),
          ),

          const SizedBox(height: 16),

          // Email field
          const Text("Email"),
          const SizedBox(height: 6),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your email",
            ),
          ),

          const SizedBox(height: 24),

          const Text("password"),
          const SizedBox(height: 6),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your password",
            ),
          ),

          const SizedBox(height: 24),
          // Save button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // 👉 Save logic here (Firebase / API)
                Navigator.pop(context);
              },
              child: const Text(
                "Save Changes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
