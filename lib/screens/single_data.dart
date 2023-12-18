import 'package:data_capture/models/captured_data_model.dart';
import 'package:flutter/material.dart';

class SingleData extends StatelessWidget {
  final CapturedData capturedData;
  static Route route({required CapturedData capturedData}) => MaterialPageRoute(
      builder: (_) => SingleData(
            capturedData: capturedData,
          ));
  const SingleData({super.key, required this.capturedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: const Text(' Single Data'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _buildListItem('Owner Name', capturedData.owner.name, Icons.person),
          _buildListItem('Owner Phone', capturedData.owner.phone, Icons.phone),
          _buildListItem(
              'Street Number', capturedData.streetNumber, Icons.location_on),
          _buildListItem('House Number', capturedData.houseNumber, Icons.home),
          _buildListItem('Number of Rooms',
              capturedData.numberOfRooms.toString(), Icons.weekend),
          _buildListItem(
              'Weekly Average Recharge Amount',
              capturedData.weeklyAverageRechargeAmount.toString(),
              Icons.attach_money),
          _buildListItem('Community Name', capturedData.communityName,
              Icons.location_city),
          _buildListItem('LGA', capturedData.lga, Icons.location_city),
          _buildListItem('Created At', capturedData.createdAt.toString(),
              Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String value, IconData leadingIcon) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }
}
