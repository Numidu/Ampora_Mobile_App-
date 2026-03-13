import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/widget/BookingsList.dart';
import 'package:electric_app/widget/StationsList.dart';
import 'package:flutter/material.dart';

class StationBookingScreen extends StatefulWidget {
  const StationBookingScreen({super.key});

  @override
  State<StationBookingScreen> createState() => _StationBookingScreenState();
}

class _StationBookingScreenState extends State<StationBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String query = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background(context), // 🎨 Background
      child: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              style: TextStyle(
                color: AppTheme.text(context),
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "Find station or booking...",
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary(context),
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.textSecondary(context),
                  size: 22,
                ),
                filled: true,
                fillColor:
                    AppTheme.searchField(context), // 🎨 Search field color
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppTheme.border(context), // 🎨 Border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryGreen, // 🎨 Focus border
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // 🔁 Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.card(context), // 🎨 Tab container
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.border(context), // 🎨 Border
                width: 1,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primaryGreen, // 🎨 Active tab
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white, // 🎨 Active text
              unselectedLabelColor:
                  AppTheme.textSecondary(context), // 🎨 Inactive text
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              tabs: const [
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Stations"),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("My Bookings"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 📋 Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StationsList(query: query),
                BookingsList(query: query),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
