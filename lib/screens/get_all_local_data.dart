// ignore_for_file: use_build_context_synchronously

import 'package:data_capture/global/global_var.dart';
import 'package:data_capture/models/captured_data_model.dart';
import 'package:data_capture/screens/single_data.dart';
import 'package:data_capture/services/database_service.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:data_capture/themes/assets.dart';
import 'package:data_capture/themes/colors.dart';
import 'package:data_capture/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetAllLocalData extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const GetAllLocalData());
  const GetAllLocalData({super.key});

  @override
  State<GetAllLocalData> createState() => _GetAllLocalDataState();
}

class _GetAllLocalDataState extends State<GetAllLocalData> {
  bool _loading = false;
  final _localStorageService = LocalStorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Captured Data'),
      ),
      body: FutureBuilder<List<CapturedData>>(
        future: _localStorageService.getCapturedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<CapturedData> capturedDataList = snapshot.data ?? [];

            if (capturedDataList.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      AppAssets.empty,
                      semanticsLabel: 'Empty',
                      width: MediaQuery.of(context).size.width * 0.50,
                    ),
                  ),
                  const Center(child: Text('No captured data available.')),
                ],
              );
            }

            return ListView.builder(
              itemCount: capturedDataList.length,
              itemBuilder: (context, index) {
                CapturedData data = capturedDataList[index];
                return ListTile(
                  onTap: () => Navigator.of(context).push(SingleData.route(capturedData: data)),
                  title: Text('Owner: ${data.owner.name}'),
                  subtitle: Text(
                    'House Number: ${data.houseNumber} Street Number: ${data.streetNumber}\nlatitude: ${data.position.latitude}  longitude: ${data.position.longitude}',
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      try {
                        await _localStorageService
                            .deleteCapturedData(data.createdAt);
                        showSuccessSnackbar(
                            context, 'Record deleted successfully');
                        setState(() {});
                      } catch (e) {
                        showErrorSnackbar(context, e.toString());
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.error,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading
            ? null
            : () async {
                try {
                  setState(() {
                    _loading = true;
                  });
                  final data = await LocalStorageService().getCapturedData();
                  if (data.isNotEmpty) {
                    await DatabaseService().addCapturedDataToFirestore(
                      data,
                      user: currentUser,
                    );

                    setState(() {
                      _loading = false;
                    });
                    LocalStorageService.clearDataField();
                    Navigator.of(context).pop();
                    showSuccessSnackbar(
                        context, 'All data synced successfully');
                  } else {
                    setState(() {
                      _loading = false;
                    });
                    showErrorSnackbar(context, 'No data available to sync');
                  }
                } catch (e) {
                  showErrorSnackbar(context, e.toString());
                  setState(() {
                    _loading = false;
                  });
                }
              },
        label: _loading
            ? const CircularProgressIndicator()
            : const Text('Sync Data'),
      ),
    );
  }
}
