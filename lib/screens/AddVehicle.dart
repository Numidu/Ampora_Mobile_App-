import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/vehicle_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart%20';

class Addvehicle extends StatefulWidget {
  const Addvehicle({super.key});

  @override
  State<Addvehicle> createState() => _AddvehicleState();
}

class _AddvehicleState extends State<Addvehicle> {
  String? userId;
  final TextEditingController _efficience = TextEditingController();
  final TextEditingController _vehiModel = TextEditingController();
  final TextEditingController _BattryCapacity = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
  }

  @override
  void dispose() {
    _efficience.dispose();
    _vehiModel.dispose();
    _BattryCapacity.dispose();
    super.dispose();
  }

  Future<void> registerVehicle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Please select a connector type'),
            ],
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    double? vehiEfficience = double.tryParse(_efficience.text.trim());
    String vehiModel = _vehiModel.text.trim();
    double? battryCapacity = double.tryParse(_BattryCapacity.text.trim());
    String connectorType = selectedValue ?? '';

    try {
      bool issucess = await VehicleService().registerVehicle({
        'model': vehiModel,
        'batteryCapacityKwh': battryCapacity,
        'efficiencyKmPerKwh': vehiEfficience,
        'connectorType': connectorType,
        "userId": userId
      });

      setState(() {
        _isLoading = false;
      });

      if (issucess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Vehicle registered successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF00C896),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        _clearForm();
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Failed to register vehicle'),
              ],
            ),
            backgroundColor: const Color(0xFFFF6B6B),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Error: $e')),
            ],
          ),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _clearForm() {
    setState(() {
      _vehiModel.clear();
      _BattryCapacity.clear();
      _efficience.clear();
      selectedValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F9F5),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A2332),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFE8F9F5),
        title: const Text(
          "Add Vehicle",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2332),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register Your Vehicle",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2332),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add your electric vehicle details to get started",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF5A6C7D),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Form Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Model
                      const Text(
                        'Vehicle Model',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _vehiModel,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'e.g., Tesla Model 3',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.directions_car_outlined,
                            color: Color(0xFF00C896),
                            size: 22,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7FFFE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00C896),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vehicle model';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Battery Capacity
                      const Text(
                        'Battery Capacity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _BattryCapacity,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'kWh (e.g., 75)',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.battery_charging_full,
                            color: Color(0xFF00C896),
                            size: 22,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7FFFE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00C896),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter battery capacity';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Efficiency
                      const Text(
                        'Efficiency',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _efficience,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'km/kWh (e.g., 6.5)',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.speed_outlined,
                            color: Color(0xFF00C896),
                            size: 22,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7FFFE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00C896),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter efficiency';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Connector Type
                      const Text(
                        'Connector Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedValue,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A2332),
                        ),
                        decoration: InputDecoration(
                          hintText: "Select connector type",
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.power,
                            color: Color(0xFF00C896),
                            size: 22,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7FFFE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E7ED),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF00C896),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        items: [
                          {"value": "NACS", "icon": Icons.bolt},
                          {"value": "Type 1", "icon": Icons.power},
                          {"value": "Type 2", "icon": Icons.power_outlined},
                          {"value": "CCS2", "icon": Icons.ev_station},
                        ].map((type) {
                          return DropdownMenuItem(
                            value: type["value"] as String,
                            child: Row(
                              children: [
                                Icon(
                                  type["icon"] as IconData,
                                  size: 20,
                                  color: const Color(0xFF00C896),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  type["value"] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFBBDEFB),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF1976D2),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Make sure all details are accurate for optimal charging recommendations',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Add Vehicle Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : registerVehicle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C896),
                            disabledBackgroundColor: const Color(0xFFB8E6D9),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Add Vehicle',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
