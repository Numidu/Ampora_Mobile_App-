import 'package:carousel_slider/carousel_slider.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
import 'package:flutter/material.dart';
import 'package:electric_app/service/vehicle_service.dart';
import 'package:provider/provider.dart';
import 'package:electric_app/models/vehicle.dart';
import 'package:electric_app/models/colorThem.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<String> images = [
    'images/car1.jpeg',
    'images/car2.jpeg',
    'images/car3.jpeg',
  ];

  final VehicleService vehicleService = VehicleService();

  String? userId;

  late Future<List<Vehicle>> _vehiclesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _search = "";
  int _carouselIndex = 0;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;

    if (userId != null) {
      _vehiclesFuture = vehicleService.fetchVehicles(userId!);
    } else {
      _vehiclesFuture = Future.error("User not logged in");
    }
  }

  Future<void> _refresh() async {
    if (userId == null) return;

    setState(() {
      print("userId djjdkf $userId");
      _vehiclesFuture = vehicleService.fetchVehicles(userId!);
    });

    await _vehiclesFuture;
  }

  Future<void> _deleteVehicle(String id) async {
    try {
      await vehicleService.deleteVehicle(id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Vehicle deleted successfully'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        _refresh();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Delete failed'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Theme-aware colors

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.background(context),
      body: RefreshIndicator(
        color: const Color(0xFF00C896),
        backgroundColor: AppTheme.card(context),
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 6),

            // Header
            Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.text(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Manage your electric vehicles",
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary(context),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Carousel
            CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, realIdx) {
                final imagePath = images[index];
                return GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Slide ${index + 1} tapped'),
                      backgroundColor: const Color(0xFF00C896),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ],
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        'Featured',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (i, _) => setState(() => _carouselIndex = i),
              ),
            ),

            const SizedBox(height: 12),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == _carouselIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF00C896)
                        : AppTheme.border(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Charge Points Card
            Container(
              decoration: BoxDecoration(
                color: AppTheme.card(context),
                borderRadius: BorderRadius.circular(24),
                border: isDark
                    ? Border.all(color: AppTheme.border(context), width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icon box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.iconBg(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xFF00C896),
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Text block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Scan QR Code",
                            style: TextStyle(
                              color: AppTheme.textSecondary(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Tap to scan",
                            style: TextStyle(
                              color: AppTheme.text(context),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scan button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C896),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C896).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'screen/ScanPage');
                        },
                        icon: const Icon(
                          Icons.qr_code,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Search + quick add
            Row(children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.searchField(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.border(context),
                      width: 1.5,
                    ),
                  ),
                  child: Row(children: [
                    Icon(
                      Icons.search,
                      color: AppTheme.textSecondary(context),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.text(context),
                        ),
                        decoration: InputDecoration(
                          hintText: "Search vehicles",
                          hintStyle: TextStyle(
                            color: AppTheme.textSecondary(context)
                                .withOpacity(0.6),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (s) => setState(() => _search = s),
                      ),
                    ),
                    if (_search.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _search = "");
                        },
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: AppTheme.textSecondary(context),
                        ),
                      )
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00C896),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C896).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                        context, 'screens/AddVehicle');
                    if (result == true) {
                      _refresh();
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 22),
                        SizedBox(width: 6),
                        Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),

            SizedBox(height: screenHeight * 0.025),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "My Vehicles",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text(context),
                ),
              ),
              TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Filter tapped'),
                    backgroundColor: const Color(0xFF00C896),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                icon: const Icon(Icons.filter_list, size: 20),
                label: const Text(
                  "Filter",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00C896),
                ),
              ),
            ]),

            const SizedBox(height: 12),

            FutureBuilder<List<Vehicle>>(
              future: _vehiclesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: LogoLoader()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: const Color(0xFFFF6B6B).withOpacity(0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary(context),
                          fontSize: 15,
                        ),
                      ),
                    ]),
                  );
                }
                final vehicles = snapshot.data ?? [];
                final filtered = _search.isEmpty
                    ? vehicles
                    : vehicles
                        .where((v) => (v.modelName)
                            .toLowerCase()
                            .contains(_search.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.iconBg(context),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car_outlined,
                          size: 64,
                          color: Color(0xFF00C896),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No vehicles found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.text(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first vehicle to get started',
                        style: TextStyle(
                          color: AppTheme.textSecondary(context),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, 'screens/AddVehicle'),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add Vehicle'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C896),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ]),
                  );
                }

                // responsive columns
                final crossAxisCount =
                    MediaQuery.of(context).size.width > 600 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) =>
                      _buildVehicleCard(context, filtered[index]),
                );
              },
            ),

            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Vehicle v) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final capacityLabel = '${v.variant.toStringAsFixed(1)} ';
    final efficiencyLabel = '${v.rangeKm.toStringAsFixed(1)} km/kWh';

    final connector = v.connectorType.toUpperCase();
    final connectorColor =
        connector.contains('CCS') || connector.contains('TYPE')
            ? const Color(0xFF00C896)
            : const Color(0xFFFF9800);

    return InkWell(
      onTap: () => _showVehicleDetails(context, v),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(20),
          border: isDark
              ? Border.all(color: AppTheme.border(context), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon circle
            Hero(
              tag: 'vehicle-${v.vehicleId}',
              child: Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.iconBg(context),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.ev_station,
                  size: 36,
                  color: Color(0xFF00C896),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  v.modelName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text(context),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // connector chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: connectorColor.withOpacity(isDark ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                v.connectorType,
                style: TextStyle(
                  fontSize: 12,
                  color: connectorColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // capacity
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.battery_charging_full,
                  size: 16,
                  color: Color(0xFF00C896),
                ),
                const SizedBox(width: 6),
                Text(
                  capacityLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // efficiency
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.speed,
                  size: 16,
                  color: Color(0xFF00C896),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    efficiencyLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary(context),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton(
                onPressed: () => _showVehicleDetails(context, v),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  side: const BorderSide(
                    color: Color(0xFF00C896),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00C896),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleDetails(BuildContext context, Vehicle v) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.card(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: isDark
                ? Border.all(color: AppTheme.border(context), width: 1)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.border(context),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Hero(
                tag: 'vehicle-${v.vehicleId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/gemina.png',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                v.modelName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text(context),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark
                      ? const Color(0xFF252D3C)
                      : const Color(0xFFF7FFFE),
                ),
                child: Column(children: [
                  _buildDetailRow(
                    context,
                    Icons.battery_charging_full,
                    'Battery Capacity',
                    '${v.variant.toStringAsFixed(1)}',
                    const Color(0xFF00C896),
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    context,
                    Icons.speed,
                    'Efficiency',
                    '${v.rangeKm.toStringAsFixed(1)} km/kWh',
                    const Color(0xFF00C896),
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    context,
                    Icons.power,
                    'Connector Type',
                    v.connectorType,
                    const Color(0xFF00C896),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C896),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    _deleteVehicle(v.vehicleId);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                    side: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label,
      String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.25 : 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary(context),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.text(context),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
