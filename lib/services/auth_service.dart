import 'package:data_capture/models/user.dart';
import 'package:data_capture/services/database_service.dart';
import 'package:data_capture/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  Future<UserData> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _databaseService.saveUserInfo(name, userCredential);
      await LocalStorageService.saveUserData(
          UserData(name: name, email: email, userId: userCredential.user!.uid));

      return UserData(
          name: name, email: email, userId: userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw 'Error occurred while registering: ${e.message}';
      }
    } catch (e) {
      throw '$e';
    }
  }

  Future<UserData> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final user = await _databaseService.getUserData(userCredential.user!.uid);
      await LocalStorageService.saveUserData(user!);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      } else {
        throw '${e.message}';
      }
    } catch (e) {
      throw 'Error occurred while logging in: $e';
    }
  }
}
