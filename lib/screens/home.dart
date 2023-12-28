import 'package:data_capture/models/captured_data_model.dart';
import 'package:data_capture/models/user.dart';
import 'package:data_capture/screens/cature_data.dart';
import 'package:data_capture/screens/get_all_local_data.dart';
import 'package:data_capture/screens/single_data.dart';
import 'package:data_capture/services/database_service.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:data_capture/themes/assets.dart';
import 'package:data_capture/themes/text_styles.dart';
import 'package:data_capture/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final UserData user;
  static Route route(UserData user) => MaterialPageRoute(
      builder: (_) => HomeScreen(
            user: user,
          ));
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService databaseService = DatabaseService();
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     print('Loading...');
      //     // await databaseService.updateAllDocumentsLGA('BIRNIN KUDU');
      //     final allData = await databaseService.getAllSyncedData();
      //     LocalStorageService().exportData(allData);
      //     print('Finshed...');
      //     print(allData.length);
      //   },
      //   child: const Text('Press'),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30.0,
                        child: Icon(
                          Icons.person,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      FutureBuilder<UserData?>(
                        future: databaseService.getUserData(
                          widget.user.userId,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'loading...',
                                  style: AppTextStyle.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'loading...',
                                  style: AppTextStyle.body,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nil',
                                  style: AppTextStyle.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Nil',
                                  style: AppTextStyle.body,
                                ),
                              ],
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Center(
                              child: Text(
                                'No user data found',
                              ), // Display message if no user data is available
                            );
                          } else {
                            UserData userData = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userData.name,
                                  style: AppTextStyle.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  userData.email,
                                  style: AppTextStyle.body,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: DasboardCard(
                          icon: Icons.edit_document,
                          title: 'Capture Data',
                          onTap: () => Navigator.of(context).push(
                            CaptureDataScreen.route(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: DasboardCard(
                          icon: Icons.storage,
                          title: 'Local Data',
                          onTap: () => Navigator.of(context).push(
                            GetAllLocalData.route(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Recent Captured Data',
                    style: AppTextStyle.subTitle,
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    child: SizedBox(
                      height: 300,
                      child: FutureBuilder<List<CapturedData>>(
                        future: LocalStorageService().getCapturedData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<CapturedData> capturedDataList =
                                snapshot.data ?? [];

                            if (capturedDataList.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SvgPicture.asset(
                                      AppAssets.empty,
                                      semanticsLabel: 'Empty',
                                      width: 200,
                                    ),
                                  ),
                                  const Center(
                                      child:
                                          Text('No captured data available.')),
                                ],
                              );
                            }

                            return ListView.builder(
                              itemCount: capturedDataList.length < 5
                                  ? capturedDataList.length
                                  : 5,
                              itemBuilder: (context, index) {
                                CapturedData data = capturedDataList[index];
                                return ListTile(
                                  onTap: () => Navigator.of(context).push(
                                      SingleData.route(capturedData: data)),
                                  title: Text('Owner: ${data.owner.name}'),
                                  subtitle: Text(
                                      'House Number: ${data.houseNumber} Street Number: ${data.streetNumber}\nlatitude: ${data.position.latitude}  longitude: ${data.position.longitude}'),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
