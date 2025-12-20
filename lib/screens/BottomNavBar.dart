import 'package:electric_app/screens/BillScreen.dart';
import 'package:electric_app/screens/HomeScreen.dart';
import 'package:electric_app/screens/ProfileScreen.dart';
import 'package:electric_app/screens/TripPlanner.dart';

import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({Key? key}) : super(key: key);

  @override
  State<Bottomnavbar> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Bottomnavbar> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    Homescreen(),
    const TripPlanner(),
    const Billscreen(),
    const Profilescreen()
  ];

  void _onTap(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00c6b3),
                Color(0xFF009daa),
                Color(0xFF007b8d),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
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
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                // Handle profile tap
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('images/profile.jpg'),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Pill background
            Container(
              height: 64,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navItem(Icons.map_outlined, "Map", 1),
                  _navItem(Icons.ev_station_outlined, "Charge", 2),

                  const SizedBox(width: 56), // space for center button

                  _navItem(Icons.account_balance_wallet_outlined, "E-Pouch", 3),
                  _navItem(Icons.more_horiz, "More", 4),
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
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: selected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
