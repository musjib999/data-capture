// ignore_for_file: use_build_context_synchronously

import 'package:data_capture/models/captured_data_model.dart';
import 'package:data_capture/models/position.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:data_capture/services/location_service.dart';
import 'package:data_capture/themes/text_styles.dart';
import 'package:data_capture/widgets/app_input_field.dart';
import 'package:data_capture/widgets/dialogs.dart';
import 'package:data_capture/widgets/primary_raised_button.dart';
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

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _houseNumber = TextEditingController();
  final _streetNumber = TextEditingController();
  final _noOfRooms = TextEditingController();
  final _weeklyAmount = TextEditingController();
  final _communityName = TextEditingController();
  final _lga = TextEditingController();

  double latitude = 0.0;
  double longitude = 0.0;
  bool _loading = false;

  String selectedLga = '';
  String selectedCommunity = '';
  List<String> communities = [];

  final Map<String, List<String>> communityByLga = {
    'LGA 1': ['Community 1', 'Community 2', 'Community 3'],
    'LGA 2': ['Community 4', 'Community 5', 'Community 6'],
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
      appBar: AppBar(
        title: const Text('Capture Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInputField(
                  prefixIcon: Icons.person_2_outlined,
                  hintText: 'Owner Name',
                  labelText: 'Owner Name',
                  controller: _ownerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Owner Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppInputField(
                  prefixIcon: Icons.phone_outlined,
                  hintText: 'Owner Phone Number',
                  labelText: 'Owner Phone Number',
                  keyboardType: TextInputType.phone,
                  controller: _ownerPhoneNumberController,
                  maxLength: 11,
                ),
                const SizedBox(height: 12),
                AppInputField(
                  prefixIcon: Icons.location_city_rounded,
                  hintText: 'House number',
                  labelText: 'House number',
                  controller: _houseNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'House number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppInputField(
                  prefixIcon: Icons.location_city_rounded,
                  hintText: 'Street number',
                  labelText: 'Street number',
                  controller: _streetNumber,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Street number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppInputField(
                  prefixIcon: Icons.location_city_rounded,
                  hintText: 'Number of rooms',
                  labelText: 'Number of rooms',
                  controller: _noOfRooms,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Number of rooms is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a LGA';
                    }
                    return null;
                  },
                  hint: const Text('Select LGA'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLga = newValue!;
                      communities = communityByLga[selectedLga] ?? [];
                      selectedCommunity = '';
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  items: communityByLga.keys
                      .map<DropdownMenuItem<String>>(
                        (String lga) => DropdownMenuItem<String>(
                          value: lga,
                          child: Text(lga),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Community';
                    }
                    return null;
                  },
                  hint: const Text('Select Community'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCommunity = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  items: communities
                      .map<DropdownMenuItem<String>>(
                        (String community) => DropdownMenuItem<String>(
                          value: community,
                          child: Text(community),
                        ),
                      )
                      .toList(),
                ),
                // AppInputField(
                //   prefixIcon: Icons.location_city_rounded,
                //   hintText: 'Community Name',
                //   labelText: 'Community Name',
                //   controller: _communityName,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Community Name is required';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 12),
                // AppInputField(
                //   prefixIcon: Icons.location_city_rounded,
                //   hintText: 'LGA',
                //   labelText: 'LGA',
                //   controller: _lga,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'LGA is required';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 12),
                AppInputField(
                  prefixIcon: Icons.attach_money_outlined,
                  hintText: 'Weekly average recharge amount',
                  labelText: 'Average amount',
                  controller: _weeklyAmount,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Average amount is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                latitude != 0.0 && longitude != 0.0
                    ? Column(
                        children: [
                          ClickableInputField(
                            icon: Icons.location_on_outlined,
                            hintText: latitude.toString(),
                          ),
                          const SizedBox(height: 20),
                          ClickableInputField(
                            icon: Icons.location_on_outlined,
                            hintText: longitude.toString(),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        setState(() {
                                          _loading = true;
                                        });
                                        final position = await LocationService()
                                            .getCurrentLocation();
                                        setState(() {
                                          latitude = position.latitude;
                                          longitude = position.longitude;
                                          _loading = false;
                                        });
                                      } catch (e) {
                                        showErrorSnackbar(
                                            context, e.toString());
                                      }
                                    }
                                  },
                            child: _loading
                                ? const CircularProgressIndicator()
                                : const Text('Get Location'),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                AppPrimaryRaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (latitude == 0.0 || longitude == 0.0) {
                        showErrorSnackbar(
                            context, 'Please get current locaion');
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
                              weeklyAverageRechargeAmount:
                                  double.parse(_weeklyAmount.text),
                              position: Position(
                                latitude: latitude,
                                longitude: longitude,
                              ),
                              communityName: _communityName.text,
                              lga: _lga.text,
                              createdAt: DateTime.now(),
                            ),
                          );
                          _ownerNameController.clear();
                          _ownerPhoneNumberController.clear();
                          _addressController.clear();
                          _houseNumber.clear();
                          _streetNumber.clear();
                          _weeklyAmount.clear();
                          _noOfRooms.clear();

                          setState(() {
                            latitude = 0.0;
                            longitude = 0.0;
                          });
                          showSuccessSnackbar(
                              context, 'Data saved successfully');
                        } catch (e) {
                          showErrorSnackbar(context, e.toString());
                        }
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    style: AppTextStyle.buttonTitle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
