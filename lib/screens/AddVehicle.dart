import 'package:electric_app/models/brand.dart';
import 'package:electric_app/models/model.dart';
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/brand_service.dart';
import 'package:electric_app/service/model_service.dart';
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
  final TextEditingController _rangeKm = TextEditingController();
  final TextEditingController _plate = TextEditingController();
  final TextEditingController _variant = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  bool _isLoading = false;
  List<brand> brands = [];
  List<model> allModels = [];
  List<model> filteredModels = [];
  final ModelService _modelService = ModelService();
  final BrandService _brandService = BrandService();
  int? selectedBrandId;
  int? selectedModelId;
  bool isLoadingModels = false;

  @override
  void initState() {
    super.initState();
    fetchBrandsAndModels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;
    print("User ID in AddVehicle: $userId");
  }

  @override
  void dispose() {
    _rangeKm.dispose();
    _plate.dispose();
    _variant.dispose();
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

    double? rangeKm = double.tryParse(_rangeKm.text.trim());
    String plate = _plate.text.trim();
    double? variant = double.tryParse(_variant.text.trim());
    String connectorType = selectedValue ?? '';
    int model = selectedModelId!;
    int brand = selectedBrandId!;

    try {
      bool issucess = await VehicleService().registerVehicle({
        'variant': variant,
        'plate': plate,
        'rangeKm': rangeKm,
        'connectorType': connectorType,
        "userId": userId,
        'brand_id': brand,
        'model_id': model,
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
          if (mounted) Navigator.pop(context, true);
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
      _variant.clear();
      _plate.clear();
      _rangeKm.clear();
      selectedModelId = null;
      selectedBrandId = null;
      selectedValue = null;
    });
  }

  Future<void> fetchBrandsAndModels() async {
    try {
      final brandData = await _brandService.fetchBrands();
      final modelData = await _modelService.fetchmodels();

      setState(() {
        brands = brandData;
        allModels = modelData;
      });

      print("Brands: ${brands.length}");
      print("Models: ${allModels.length}");
    } catch (e) {
      print("ERROR loading data: $e");
    }
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

                      //brand dropdown
                      const Text(
                        'Select Brand',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        initialValue: selectedBrandId,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A2332),
                        ),
                        hint: const Text(
                          "Select brand",
                          style: TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.branding_watermark, // brand icon
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
                        items: brands.map((b) {
                          return DropdownMenuItem<int>(
                            value: b.id,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.factory, // brand item icon
                                  size: 20,
                                  color: Color(0xFF00C896),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  b.name,
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
                            selectedBrandId = value;
                            selectedModelId = null;

                            // 🔥 FRONTEND FILTER
                            filteredModels = allModels
                                .where((m) => m.brand_id == value)
                                .toList();

                            print("Filtered models: ${filteredModels.length}");
                          });
                        },
                      ),

                      //model dropdown

                      const SizedBox(height: 20),
                      const Text(
                        'Select Model',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        initialValue: selectedModelId,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A2332),
                        ),
                        hint: const Text(
                          "Select model",
                          style: TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.directions_car,
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
                        items: filteredModels.map((m) {
                          return DropdownMenuItem<int>(
                            value: m.id,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.car_rental,
                                  size: 20,
                                  color: Color(0xFF00C896),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  m.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: filteredModels.isEmpty
                            ? null
                            : (value) {
                                setState(() {
                                  selectedModelId = value;
                                });
                              },
                      ),

                      const SizedBox(height: 20),

                      // Battery Capacity
                      const Text(
                        'Efficiency (kWh)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _variant,
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
                            return 'Please enter variant';
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
                        'Range Km',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _rangeKm,
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
                            return 'Please enter range Km ';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Variant',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      //vehicle plate
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _plate,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'CC 123 AA',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.confirmation_number,
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter plate number';
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
                        initialValue: selectedValue,
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
                          {"value": "TYPE1", "icon": Icons.power},
                          {"value": "TYPE2", "icon": Icons.power_outlined},
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
