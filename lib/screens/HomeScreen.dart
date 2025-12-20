import 'package:carousel_slider/carousel_slider.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:flutter/material.dart';
import 'package:electric_app/service/vehicle_service.dart';
import 'package:provider/provider.dart%20';
import '../models/vehicle.dart';

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
      _vehiclesFuture = vehicleService.fetchVehicles(userId!);
    });

    await _vehiclesFuture;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
    print(user?.userId);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 6),

          // Header
          const Text("Welcome Back!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Manage your electric vehicles",
              style: TextStyle(fontSize: 15, color: Colors.grey[600])),

          SizedBox(height: screenHeight * 0.03),

          // Carousel
          CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (context, index, realIdx) {
              final imagePath = images[index];
              return GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Slide ${index + 1} tapped'))),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 6))
                    ],
                    image: DecorationImage(
                        image: AssetImage(imagePath), fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.22)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(14),
                    child: const Text('Featured',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 180,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              onPageChanged: (i, _) => setState(() => _carouselIndex = i),
            ),
          ),

          const SizedBox(height: 8),
          // Dots
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == _carouselIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color:
                          active ? Colors.green.shade700 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8)),
                );
              })),

          SizedBox(height: screenHeight * 0.03),

          // Charge Points Card (simple)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.bolt, color: Colors.grey.shade700, size: 28),
                  ),

                  const SizedBox(width: 14),

                  // Text block
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Charge Points",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "0.00",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add points')),
                      );
                    },
                    child:
                        Icon(Icons.add, color: Colors.grey.shade700, size: 26),
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                          hintText: "Search vehicles",
                          border: InputBorder.none),
                      onChanged: (s) => setState(() => _search = s),
                    ),
                  ),
                  if (_search.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _search = "");
                      },
                      icon: const Icon(Icons.close, size: 18),
                    )
                ]),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => Navigator.pushNamed(context, 'screens/AddVehicle'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(12)),
                child: const Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(height: 4),
                  Text("Add",
                      style: TextStyle(color: Colors.white, fontSize: 12))
                ]),
              ),
            ),
          ]),

          SizedBox(height: screenHeight * 0.02),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("My Vehicles",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Filter tapped'))),
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text("Filter"),
              style:
                  TextButton.styleFrom(foregroundColor: Colors.green.shade700),
            ),
          ]),

          const SizedBox(height: 8),

          FutureBuilder<List<Vehicle>>(
            future: _vehiclesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Icon(Icons.error_outline,
                        size: 60, color: Colors.red.shade300),
                    const SizedBox(height: 12),
                    Text('Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.grey[600]))
                  ]),
                );
              }
              final vehicles = snapshot.data ?? [];
              final filtered = _search.isEmpty
                  ? vehicles
                  : vehicles
                      .where((v) => (v.model)
                          .toLowerCase()
                          .contains(_search.toLowerCase()))
                      .toList();

              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(children: [
                    Icon(Icons.car_rental,
                        size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text('No vehicles found',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text('Add your first vehicle to get started',
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, 'screens/AddVehicle'),
                        child: const Text("Add Vehicle"))
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
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) =>
                    _buildVehicleCard(context, filtered[index]),
              );
            },
          ),

          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  // ---------- Improved vehicle card (uses your model fields) ----------
  Widget _buildVehicleCard(BuildContext context, Vehicle v) {
    // Use batteryCapacity & efficiency (no currentCharge available in model)
    final capacityLabel = '${v.batteryCapacity.toStringAsFixed(1)} kWh';
    final efficiencyLabel = '${v.efficiency.toStringAsFixed(1)} kWh';

    final connector = v.connectorType.toUpperCase();
    final connectorColor =
        connector.contains('CCS') || connector.contains('TYPE')
            ? Colors.green.shade700
            : Colors.orange.shade700;

    return InkWell(
      onTap: () => _showVehicleDetails(context, v),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6))
          ],
        ),
        // Important: use MainAxisSize.min so Column doesn't expand beyond content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon circle with hero (fixed size)
            Hero(
              tag: 'vehicle-${v.vehicleId}',
              child: Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50, shape: BoxShape.circle),
                child: const Icon(Icons.ev_station,
                    size: 40, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 10),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  v.model,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // connector chip + capacity (wrap in Row but keep compact)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: connectorColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(v.connectorType,
                      style: TextStyle(
                          fontSize: 12,
                          color: connectorColor,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Text(capacityLabel,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt, size: 14, color: Colors.orange),
                const SizedBox(width: 6),
                Text(efficiencyLabel,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton.icon(
                onPressed: () => _showVehicleDetails(context, v),
                icon: const Icon(Icons.info_outline, size: 16),
                label: const Text('Details'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleDetails(BuildContext context, Vehicle v) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 14),
              Hero(
                  tag: 'vehicle-${v.vehicleId}',
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('images/car1.jpeg',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover))),
              const SizedBox(height: 16),
              Text(v.model,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey.shade50),
                child: Column(children: [
                  _buildDetailRow(
                      Icons.battery_charging_full,
                      'Battery Capacity',
                      '${v.batteryCapacity.toStringAsFixed(1)} kWh',
                      Colors.blue),
                  const Divider(height: 20),
                  _buildDetailRow(Icons.bolt, 'Efficiency',
                      '${v.efficiency.toStringAsFixed(1)} kWh', Colors.orange),
                  const Divider(height: 20),
                  _buildDetailRow(Icons.power, 'Connector Type',
                      v.connectorType, Colors.green),
                ]),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: const Text('Close',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('More actions')));
                  },
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('More'),
                ),
              ]),
              const SizedBox(height: 16),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22)),
      const SizedBox(width: 12),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700))
      ])),
    ]);
  }
}
