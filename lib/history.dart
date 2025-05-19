import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'loginScreen.dart';

class HistoryScreen extends StatefulWidget {
  final String employeeId;

  HistoryScreen({required this.employeeId});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime selectedDate = DateTime.now();
  int daysAttended = 0;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('employees').child(widget.employeeId).child('attendance');
    DataSnapshot snapshot = await _dbRef.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> recordsMap = snapshot.value as Map<dynamic, dynamic>;
      List<DateTime> attendanceDays = recordsMap.entries.map((entry) {
        try {
          DateTime recordDate = DateFormat('d MMMM yyyy').parse(entry.key);
          return recordDate;
        } catch (e) {
          print('Error parsing date: ${entry.key}');
          return null;
        }
      }).where((record) => record != null).toList().cast<DateTime>();

      final uniqueDays = attendanceDays
          .where((date) => date.month == selectedDate.month && date.year == selectedDate.year)
          .toSet()
          .length;

      setState(() {
        daysAttended = uniqueDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('employees').child(widget.employeeId).child('attendance');

    return Scaffold(
      backgroundColor: const Color.fromRGBO(222, 245, 229, 0.8),
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Color.fromRGBO(158, 213, 197, 1),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 2),
              child: Text(
                "Attendance Log",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 12),
                  child: Text(
                    DateFormat('MMMM yyyy').format(selectedDate),
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      size: screenWidth / 11,
                    ),
                    onPressed: () async {
                      print("Calendar icon pressed");
                      final DateTime? picked = await showMonthYearPicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Center(
                            child: Container(
                              width: screenWidth * 0.9,
                              height: 500,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color.fromRGBO(158, 213, 197, 1),
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                    secondary: Color.fromRGBO(158, 213, 197, 1),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color.fromRGBO(158, 213, 197, 1),
                                    ),
                                  ),
                                ),
                                child: child!,
                              ),
                            ),
                          );
                        },
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                        _fetchAttendanceData();
                      }
                      print("Selected date: $selectedDate");
                    },
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 2),
              child: Text(
                "Days Attended: $daysAttended",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            StreamBuilder<DatabaseEvent>(
              stream: _dbRef.onValue,
              builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> recordsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<dynamic> recordsList = recordsMap.entries.map((entry) {
                    try {
                      DateTime recordDate = DateFormat('d MMMM yyyy').parse(entry.key);
                      if (recordDate.month == selectedDate.month && recordDate.year == selectedDate.year) {
                        return {
                          'date': entry.key,
                          'checkIn': entry.value['checkIn'],
                          'checkOut': entry.value['checkOut']
                        };
                      }
                    } catch (e) {
                      print('Error parsing date: ${entry.key}');
                    }
                    return null;
                  }).where((record) => record != null).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recordsList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 25),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 40),
                              padding: const EdgeInsets.all(16.0),
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 60),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check-in",
                                        style: TextStyle(
                                          fontSize: screenWidth / 22,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        recordsList[index]['checkIn'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth / 20,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Check-out",
                                        style: TextStyle(
                                          fontSize: screenWidth / 22,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        recordsList[index]['checkOut'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth / 20,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 135,
                                height: 190,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(158, 213, 197, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    recordsList[index]['date'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth / 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                } else {
                  return Center(child: Text("No attendance records found."));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}