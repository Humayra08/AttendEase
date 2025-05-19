import 'package:firebase_database/firebase_database.dart';

class LoginController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<bool> loginUser(String employeeId, String password) async {
    DatabaseReference ref = _dbRef.child('users').child(employeeId);
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      Map<String, dynamic> user = Map<String, dynamic>.from(event.snapshot.value as Map);
      if (user['password'] == password) {
        return true;
      } else {
        throw Exception('Wrong password');
      }
    } else {
      throw Exception('Employee ID not found');
    }
  }
}

