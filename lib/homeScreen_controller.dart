import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class HomeScreenController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final loc.Location location = loc.Location();

  // Fetch check-in time for the employee
  Future<String> getCheckInTime(String employeeId) async {
    try {
      DatabaseReference employeeRef = _dbRef.child('employees').child(employeeId).child('attendance');
      DataSnapshot snapshot = await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).get();

      if (snapshot.exists) {
        Map<String, dynamic> attendance = Map<String, dynamic>.from(snapshot.value as Map);
        return attendance['checkIn'] ?? 'Not checked in';
      } else {

        String checkInTime = DateFormat('hh:mm').format(DateTime.now());
        await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).set({
          'checkIn': checkInTime,
          'checkOut': '----'
        });
        return checkInTime;
      }
    } catch (e) {
      print('Error fetching check-in time: $e');
      return 'Not checked in';
    }
  }

  Future<String> getCheckOutTime(String employeeId) async {
    try {
      DatabaseReference employeeRef = _dbRef.child('employees').child(employeeId).child('attendance');
      DataSnapshot snapshot = await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).get();

      if (snapshot.exists) {
        Map<String, dynamic> attendance = Map<String, dynamic>.from(snapshot.value as Map);
        return attendance['checkOut'] ?? '----';
      } else {
        return '----';
      }
    } catch (e) {
      print('Error fetching check-out time: $e');
      return '----';
    }
  }

  // Get the location (for both check-in and check-out)
  Future<String> getDeviceLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      loc.PermissionStatus permission = await location.hasPermission();

      if (!serviceEnabled || permission != loc.PermissionStatus.granted) {
        return "Location permission not granted";
      }

      loc.LocationData locationData = await location.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
      return "${placemarks[0].street}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].country}";
    } catch (e) {
      print("Error fetching location: $e");
      return "Location not available";
    }
  }

  Future<String> getCheckOutLocation(String employeeId) async {
    try {
      DatabaseReference employeeRef = _dbRef.child('employees').child(employeeId).child('attendance');
      DataSnapshot snapshot = await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).get();

      if (snapshot.exists) {
        Map<String, dynamic> attendance = Map<String, dynamic>.from(snapshot.value as Map);
        return attendance['checkOutLocation'] ?? '----';
      } else {
        return '----';
      }
    } catch (e) {
      print('Error fetching check-out location: $e');
      return '----';
    }
  }

  Future<void> updateCheckOut(String employeeId, String checkOutLocation) async {
    try {
      DatabaseReference employeeRef = _dbRef.child('employees').child(employeeId).child('attendance');
      DataSnapshot snapshot = await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).get();

      if (snapshot.exists) {
        Map<String, dynamic> attendance = Map<String, dynamic>.from(snapshot.value as Map);
        String checkIn = attendance['checkIn'];

        // Update check-out time and location in real-time database
        await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).update({
          'checkIn': checkIn,
          'checkOut': DateFormat('hh:mm').format(DateTime.now()),
          'checkOutLocation': checkOutLocation, // Save check-out location
        });
      } else {
        await employeeRef.child(DateFormat('dd MMMM yyyy').format(DateTime.now())).set({
          'checkIn': DateFormat('hh:mm').format(DateTime.now()),
          'checkOut': DateFormat('hh:mm').format(DateTime.now()),
          'checkOutLocation': checkOutLocation,
        });
      }
    } catch (e) {
      print('Error updating check-out: $e');
    }
  }
}
