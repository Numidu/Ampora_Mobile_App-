import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/vehicle_service.dart';
import 'package:electric_app/widget/Custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart%20';

class Addvehicle extends StatefulWidget {
  const Addvehicle({super.key});

  @override
  State<Addvehicle> createState() => _AddvehicleState();
}

class _AddvehicleState extends State<Addvehicle>
    with SingleTickerProviderStateMixin {
  String? userId;
  final TextEditingController _efficience = TextEditingController();
  final TextEditingController _vehiModel = TextEditingController();
  final TextEditingController _BattryCapacity = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        _clearForm();
        // Navigate back after short delay
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
            backgroundColor: Colors.red.shade600,
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
          backgroundColor: Colors.red.shade600,
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add Vehicle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009daa), Color(0xFF00c6d7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Card with Illustration
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF009daa), Color(0xFF00c6d7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF009daa).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car_filled,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Register Your Vehicle',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your electric vehicle details to get started with tracking and management',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form Section Header
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF009daa),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Vehicle Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CustomTextfield(
                    controller: _vehiModel,
                    hintTexts: 'Vehicle Model (e.g., Tesla Model 3)',
                    prefixIcons: const Icon(
                      Icons.directions_car,
                      color: Color(0xFF009daa),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter vehicle model';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  CustomTextfield(
                    controller: _BattryCapacity,
                    hintTexts: 'Battery Capacity (kWh)',
                    keyboardType: TextInputType.number,
                    prefixIcons: const Icon(
                      Icons.battery_charging_full,
                      color: Color(0xFF009daa),
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

                  CustomTextfield(
                    controller: _efficience,
                    hintTexts: 'Efficiency (km/kWh)',
                    keyboardType: TextInputType.number,
                    prefixIcons: const Icon(
                      Icons.speed,
                      color: Color(0xFF009daa),
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

                  // Enhanced Dropdown
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedValue,
                      decoration: InputDecoration(
                        hintText: "Select Connector Type",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.power,
                              color: Color(0xFF009daa),
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF009daa),
                            width: 2,
                          ),
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
                                color: const Color(0xFF009daa),
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
                  ),

                  const SizedBox(height: 32),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.shade100,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 24,
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

                  // Submit Button
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF009daa), Color(0xFF00c6d7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF009daa).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : registerVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
