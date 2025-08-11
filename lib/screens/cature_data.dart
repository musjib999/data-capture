// ignore_for_file: use_build_context_synchronously

import 'package:data_capture/models/captured_data_model.dart';
import 'package:data_capture/models/position.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:data_capture/services/location_service.dart';
import 'package:data_capture/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class CaptureDataScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const CaptureDataScreen());
  const CaptureDataScreen({super.key});

  @override
  State<CaptureDataScreen> createState() => _CaptureDataScreenState();
}

class _CaptureDataScreenState extends State<CaptureDataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LocalStorageService _localStorageService = LocalStorageService();

  final _ownerNameController = TextEditingController();
  final _ownerPhoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _houseNumber = TextEditingController();
  final _streetNumber = TextEditingController();
  final _noOfRooms = TextEditingController();
  final _weeklyAmount = TextEditingController();

  final _grains = TextEditingController();

  double latitude = 0.0;
  double longitude = 0.0;
  bool _loading = false;

  String selectedLga = '';
  String selectedCommunity = '';
  String selectedHouseType = '';
  String selectedEnergy = '';
  String selectedTransportMeans = '';

  List<String> communities = [];
  List<String> houseTypes = ['Family', 'Stand alone'];
  List<String> sourceOfEnergy = ['Generator', 'Solar Kit', 'None'];
  List<String> meansOfTransport = ['Bicycle', 'Motorcycle', 'Car', 'None'];

  final Map<String, List<String>> communityByLga = {
    'BIRNIN KUDU': [
      'RUMBUYA',
      'BADUNGU',
      'GUNA\'A DAMAU',
      'TUDU BABBA',
      'KADANGARE'
    ],
    'JAHUN': [
      'KANWA',
      'TINIBU',
      'MAKANGAWA',
      'JABARNA',
      'IDANDUNA',
      'DAMUTAWA'
    ],
    'SULE TANKARKAR': ['ALBASU'],
    'GURI': ['ABUNABO', 'ZUGOBIYA'],
    'AUYO': ['GADDIMARI', 'AFARMO'],
    'BIRNIWA': ['KIRILLA'],
    'KAFIN HAUSA': ['MAJERIN GABAS'],
    'RINGIM': ['GILIMA', 'KWARI'],
    'GARKI': ['KARGO'],
  };

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerPhoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Capture Data',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Owner's Name Field
                _buildInputField(
                  icon: Icons.person_outline,
                  hint: "Enter owner's full name",
                  controller: _ownerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Owner Name is required';
                    }
                    return null;
                  },
                ),

                // Phone Number Field
                _buildInputField(
                  icon: Icons.phone_outlined,
                  hint: "Enter phone number",
                  controller: _ownerPhoneNumberController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  showCounter: true,
                ),

                // House Number Field
                _buildInputField(
                  icon: Icons.home_outlined,
                  hint: "Enter house number",
                  controller: _houseNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'House number is required';
                    }
                    return null;
                  },
                ),

                // Street Number Field
                _buildInputField(
                  icon: Icons.location_on_outlined,
                  hint: "Enter street number",
                  controller: _streetNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Street number is required';
                    }
                    return null;
                  },
                ),

                // House Type Dropdown
                _buildDropdownField(
                  icon: Icons.home_filled,
                  hint: "Select House Type",
                  value: selectedHouseType.isEmpty ? null : selectedHouseType,
                  items: houseTypes,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHouseType = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a house type';
                    }
                    return null;
                  },
                ),

                // Number of Rooms Field
                _buildInputField(
                  icon: Icons.meeting_room_outlined,
                  hint: "Enter number of rooms",
                  controller: _noOfRooms,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of rooms is required';
                    }
                    return null;
                  },
                ),

                // LGA Dropdown
                _buildDropdownField(
                  icon: Icons.location_city_outlined,
                  hint: "Select LGA",
                  value: selectedLga.isEmpty ? null : selectedLga,
                  items: communityByLga.keys.toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLga = newValue!;
                      communities = communityByLga[selectedLga] ?? [];
                      selectedCommunity = '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a LGA';
                    }
                    return null;
                  },
                ),

                // Community Dropdown
                _buildDropdownField(
                  icon: Icons.location_city_outlined,
                  hint: "Select Community",
                  value: selectedCommunity.isEmpty ? null : selectedCommunity,
                  items: communities,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCommunity = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Community';
                    }
                    return null;
                  },
                ),

                // Source of Energy Dropdown
                _buildDropdownField(
                  icon: Icons.flash_on_outlined,
                  hint: "Select Source of Energy",
                  value: selectedEnergy.isEmpty ? null : selectedEnergy,
                  items: sourceOfEnergy,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEnergy = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a source of energy';
                    }
                    return null;
                  },
                ),

                // Weekly Amount Field
                _buildInputField(
                  icon: Icons.attach_money_outlined,
                  hint: "Weekly average recharge amount (₦)",
                  controller: _weeklyAmount,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Average amount is required';
                    }
                    return null;
                  },
                ),

                // Means of Transportation Dropdown
                _buildDropdownField(
                  icon: Icons.directions_car_outlined,
                  hint: "Select Means of Transportation",
                  value: selectedTransportMeans.isEmpty
                      ? null
                      : selectedTransportMeans,
                  items: meansOfTransport,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTransportMeans = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select means of transportation';
                    }
                    return null;
                  },
                ),

                // Grains Production Field
                _buildInputField(
                  icon: Icons.grass,
                  hint: "Annual grain production (kg)",
                  controller: _grains,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Grains produce is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Location Section
                if (latitude != 0.0 && longitude != 0.0) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Location Captured',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lat: ${latitude.toStringAsFixed(6)}\nLng: ${longitude.toStringAsFixed(6)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _loading ? null : _getCurrentLocation,
                          icon: _loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.location_on, size: 20),
                          label: Text(_loading
                              ? 'Getting Location...'
                              : 'Get Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
    bool showCounter = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: showCounter ? maxLength : null,
        validator: validator,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          suffixText: showCounter && maxLength != null ? '0/$maxLength' : null,
          suffixStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: "", // Hide the default counter
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
    String? value,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        final position = await LocationService().getCurrentLocation();
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          _loading = false;
        });
      } catch (e) {
        setState(() {
          _loading = false;
        });
        showErrorSnackbar(context, e.toString());
      }
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (latitude == 0.0 || longitude == 0.0) {
        showErrorSnackbar(context, 'Please get current location');
      } else {
        try {
          await _localStorageService.saveCapturedData(
            CapturedData(
              owner: Owner(
                name: _ownerNameController.text,
                phone: _ownerPhoneNumberController.text,
              ),
              houseNumber: _houseNumber.text,
              streetNumber: _streetNumber.text,
              numberOfRooms: int.parse(_noOfRooms.text),
              weeklyAverageRechargeAmount: double.parse(_weeklyAmount.text),
              position: Position(
                latitude: latitude,
                longitude: longitude,
              ),
              communityName: selectedCommunity,
              lga: selectedLga,
              createdAt: DateTime.now(),
              houseType: selectedHouseType,
              sourceOfEnergy: selectedEnergy,
              grainsPerAnnum: num.parse(_grains.text),
              meansOfTransport: selectedTransportMeans,
            ),
          );

          // Clear all fields
          _ownerNameController.clear();
          _ownerPhoneNumberController.clear();
          _addressController.clear();
          _houseNumber.clear();
          _streetNumber.clear();
          _weeklyAmount.clear();
          _noOfRooms.clear();
          _grains.clear();

          // Reset dropdowns
          setState(() {
            selectedLga = '';
            selectedCommunity = '';
            selectedHouseType = '';
            selectedEnergy = '';
            selectedTransportMeans = '';
            communities = [];
            latitude = 0.0;
            longitude = 0.0;
          });

          showSuccessSnackbar(context, 'Data saved successfully');
        } catch (e) {
          showErrorSnackbar(context, e.toString());
        }
      }
    }
  }
}
