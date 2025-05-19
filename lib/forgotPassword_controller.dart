import 'package:firebase_database/firebase_database.dart';

class ForgotPasswordController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<String?> resetPassword(String employeeId, String newPassword, String confirmPassword) async {
    try {
      if (employeeId.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        return 'All fields must be filled';
      }

      if (newPassword.length < 8) {
        return 'Password must be at least 8 characters long';
      }

      if (newPassword != confirmPassword) {
        return 'Passwords do not match';
      }

      DatabaseReference ref = _dbRef.child('users').child(employeeId);
      DatabaseEvent event = await ref.once();

      if (event.snapshot.value != null) {
        await ref.update({'password': newPassword});
        return null;
      } else {
        return 'Employee ID not found';
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }
}