import 'package:firebase_database/firebase_database.dart';

class RegisterController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> registerUser(String fullName, String email, String employeeId, String password) async {
    if (password.length != 8) {
      throw Exception('Password must be 8 characters long');
    }
    DatabaseReference ref = _dbRef.child('users').child(employeeId);
    await ref.set({
      'fullName': fullName,
      'email': email,
      'employeeId': employeeId,
      'password': password,
    });
  }
}