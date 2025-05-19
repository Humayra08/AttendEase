import 'package:firebase_database/firebase_database.dart';

class ProfileController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<bool> saveProfileData(
      String employeeId, String firstName, String lastName, String dob, String address, String email, String phone, String? imagePath) async {
    try {
      DatabaseEvent event = await _dbRef.child('users').child(employeeId).once();
      Map<String, dynamic> currentData = Map<String, dynamic>.from(event.snapshot.value as Map);
      String currentPassword = currentData['password'];

      await _dbRef.child('users').child(employeeId).set({
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'address': address,
        'email': email,
        'phone': phone,
        'profileImage': imagePath ?? '',
        'password': currentPassword,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfileData(String employeeId) async {
    try {
      DatabaseEvent event = await _dbRef.child('users').child(employeeId).once();
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}