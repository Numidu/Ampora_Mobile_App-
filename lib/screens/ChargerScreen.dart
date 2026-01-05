import 'package:electric_app/models/charger.dart';
import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/service/charger_service.dart';
import 'package:electric_app/widget/ChargerCard.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
import 'package:flutter/material.dart';

class Chargerscreen extends StatelessWidget {
  const Chargerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String stationName =
        ModalRoute.of(context)!.settings.arguments as String;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      appBar: AppBar(
        backgroundColor: AppTheme.background(context),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.text(context),
            size: 20,
          ),
        ),
        title: Text(
          "Chargers",
          style: TextStyle(
            color: AppTheme.text(context),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Station Info Header
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.card(context),
              borderRadius: BorderRadius.circular(20),
              border: isDark
                  ? Border.all(color: AppTheme.border(context), width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.iconBg(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.ev_station,
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stationName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.text(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Available Chargers",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chargers List
          Expanded(
            child: FutureBuilder<List<Charger>>(
              future: ChargerService().fetchChargers(stationName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LogoLoader());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Color(0xFFFF6B6B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Error loading chargers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.text(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.iconBg(context),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.ev_station_outlined,
                              size: 60,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No chargers found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.text(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This station currently has no available chargers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final chargers = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: chargers.length,
                  itemBuilder: (context, index) {
                    final c = chargers[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChargerCard(
                        power: c.powerKw.toString(),
                        type: c.type,
                        status: c.status,
                        id: c.chargerID,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
