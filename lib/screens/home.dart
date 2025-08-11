import 'package:data_capture/models/user.dart';
import 'package:data_capture/screens/cature_data.dart';
import 'package:data_capture/screens/get_all_local_data.dart';
import 'package:data_capture/services/database_service.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:flutter/material.dart';

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
  int totalRecords = 0;
  int pendingSync = 0;
  int todayRecords = 0;
  String lastSync = "Just now";

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final capturedData = await LocalStorageService().getCapturedData();
      final syncedData = await databaseService.getAllSyncedData();

      setState(() {
        totalRecords = capturedData.length + syncedData.length;
        pendingSync = capturedData.length; // Assuming local data needs sync
        todayRecords = capturedData.where((data) {
          // Filter today's records based on your date field
          return true; // Implement your date filtering logic here
        }).length;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
    }
  }

  Future<void> _refreshData() async {
    await _loadDashboardData();
  }

  Future<void> _syncData() async {
    // Implement your sync logic here
    print('Syncing data...');
    final allData = await databaseService.getAllSyncedData();
    LocalStorageService().exportData(allData);
    setState(() {
      lastSync = "Just now";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // Dashboard Title
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitor your data collection progress',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Stats Grid
                  _buildStatsGrid(),
                  const SizedBox(height: 30),

                  // Quick Actions Section
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
          ),
          child: FutureBuilder<UserData?>(
            future: databaseService.getUserData(widget.user.userId),
            builder: (context, snapshot) {
              String initials = 'U';
              if (snapshot.hasData && snapshot.data != null) {
                final name = snapshot.data!.name;
                if (name.isNotEmpty) {
                  final nameParts = name.split(' ');
                  initials = nameParts.length > 1
                      ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
                      : name[0].toUpperCase();
                }
              }
              return Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: FutureBuilder<UserData?>(
            future: databaseService.getUserData(widget.user.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 16,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Enumerator',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              } else {
                UserData userData = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Enumerator',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Online',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          icon: Icons.description_outlined,
          iconColor: Colors.blue,
          title: 'Total Records',
          value: totalRecords.toString(),
        ),
        _buildStatCard(
          icon: Icons.cloud_upload_outlined,
          iconColor: Colors.orange,
          title: 'Pending Sync',
          value: pendingSync.toString(),
        ),
        _buildStatCard(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          title: 'Today',
          value: todayRecords.toString(),
        ),
        _buildStatCard(
          icon: Icons.access_time,
          iconColor: Colors.purple,
          title: 'Last Sync',
          value: lastSync,
          isTime: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    bool isTime = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            isTime ? value : value,
            style: TextStyle(
              fontSize: isTime ? 16 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2,
      children: [
        _buildActionButton(
          icon: Icons.add,
          title: 'Capture Data',
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          onTap: () => Navigator.of(context).push(CaptureDataScreen.route()),
        ),
        _buildActionButton(
          icon: Icons.visibility_outlined,
          title: 'View Data',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          onTap: () => Navigator.of(context).push(GetAllLocalData.route()),
        ),
        _buildActionButton(
          icon: Icons.cloud_upload_outlined,
          title: 'Sync Data',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          onTap: _syncData,
        ),
        _buildActionButton(
          icon: Icons.bar_chart_outlined,
          title: 'Reports',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          onTap: () {
            // Navigate to reports screen
            print('Navigate to reports');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      elevation: backgroundColor == Colors.white ? 1 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: backgroundColor == Colors.white
                ? Border.all(color: Colors.grey.withOpacity(0.2))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: textColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
