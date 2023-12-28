import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_capture/models/captured_data_model.dart';
import 'package:data_capture/models/position.dart';
import 'package:data_capture/models/user.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserInfo(String name, UserCredential userCredential) async {
    try {
      String userId =
          userCredential.user!.uid; // Get the user ID from UserCredential

      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': userCredential.user!.email,
        'userId': userId,
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    } catch (e) {
      throw 'Error occurred while saving user info: $e';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserInfo(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot;
      } else {
        throw 'User info not found';
      }
    } catch (e) {
      throw 'Error occurred while getting user info: $e';
    }
  }

  Future<UserData?> getUserData(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>>? snapshot =
            await getUserInfo(id);
        if (snapshot != null && snapshot.exists) {
          UserData userData = UserData.fromJson(snapshot.data()!);
          return userData;
        } else {
          return null;
        }
      } else {
        return await LocalStorageService.getUserData();
      }
    } on SocketException catch (_) {
      return await LocalStorageService.getUserData();
    } catch (e) {
      throw 'Error occurred while fetching user data: $e';
    }
  }

  Future<List<FirestoreData>> getAllSyncedData() async {
    try {
      final query = await _firestore.collection('data').get();

      return query.docs
          .map(
            (e) => FirestoreData(
              id: e.id,
              owner: Owner.fromJson(e.data()['owner']),
              streetNumber: e.data()["streetNumber"],
              houseNumber: e.data()["houseNumber"],
              numberOfRooms: e.data()["numberOfRooms"],
              weeklyAverageRechargeAmount:
                  e.data()["weeklyAverageRechargeAmount"].toDouble(),
              position: Position.fromJson(e.data()["position"]),
              communityName: e.data()["communityName"],
              lga: e.data()["lga"],
              createdAt: DateTime.parse(e.data()["createdAt"]),
            ),
          )
          .toList();
    } catch (e) {
      print('Error retrieving documents: $e');
      rethrow;
    }
  }

  Future<void> updateAllDocumentsLGA(String newValue) async {
    CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('data');

    QuerySnapshot querySnapshot = await dataCollection.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var doc in querySnapshot.docs) {
      // Get a reference to each document and update the 'lga' field
      DocumentReference docRef = dataCollection.doc(doc.id);
      batch.update(docRef, {'lga': newValue});
    }

    try {
      // Commit the batched write operation
      await batch.commit();
      print('All documents updated successfully with new LGA value');
    } catch (e) {
      print('Error updating documents: $e');
      throw e;
    }
  }

  Future<bool> addCapturedDataToFirestore(List<CapturedData> capturedDataList,
      {required UserData user}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        CollectionReference dataCollection =
            FirebaseFirestore.instance.collection('data');

        for (var data in capturedDataList) {
          dataCollection.add(data.toJson());
        }
      }

      return true;
    } on SocketException catch (_) {
      throw 'No internet connection, please try again later';
    } catch (e) {
      throw e.toString();
    }
  }
}
