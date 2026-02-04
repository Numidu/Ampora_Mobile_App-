import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/screens/BillScreen.dart';
import 'package:electric_app/screens/HomeScreen.dart';
import 'package:electric_app/screens/ProfileScreen.dart';
import 'package:electric_app/screens/StationScreen.dart';
import 'package:electric_app/screens/TripPlanner.dart';
import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Homescreen(),
    TripPlanner(),
    Billscreen(),
    Stationscreen(),
    Profilescreen(),
  ];

  void _onTap(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00c6b3),
                Color(0xFF2ECC71),
                Color(0xFF27AE60),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        title: const Text(
          '⚡ Electric App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = 4); // Navigate to profile
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('images/profile.jpg'),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Pill Bar
            Container(
              height: 64,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.card(context),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navItem(Icons.map_outlined, "Map", 1),
                  _navItem(Icons.subscriptions_outlined, "Charge", 2),
                  const SizedBox(width: 56),
                  _navItem(Icons.ev_station_outlined, "E-Pouch", 3),
                  _navItem(Icons.settings_outlined, "Setting", 4),
                ],
              ),
            ),

            // Center Home Button
            Positioned(
              bottom: 28,
              child: GestureDetector(
                onTap: () => _onTap(0),
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.home_rounded,
                      color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 22,
              color: selected
                  ? AppTheme.primaryGreen
                  : AppTheme.textSecondary(context)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppTheme.primaryGreen
                    : AppTheme.textSecondary(context),
              )),
        ],
      ),
    );
  }
}
