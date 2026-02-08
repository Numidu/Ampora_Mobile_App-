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
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Traveler"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.person_outline),
          )
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: "Find station or booking...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔁 Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Stations"),
                Tab(text: "My Bookings"),
              ],
            ),
          ),

          const SizedBox(height: 12),

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
