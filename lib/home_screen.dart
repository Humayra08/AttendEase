import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';
import 'homeScreen_controller.dart';  // Import the controller
import 'history.dart';  // Import the history screen
import 'loginScreen.dart'; // Import the login screen
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final String employeeId;

  const HomeScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final HomeScreenController _homeScreenController = HomeScreenController();

  String checkInLocation = 'Fetching location...';
  String checkOutLocation = '----';
  String checkInTime = '';
  String checkOutTime = '';

  @override
  void initState() {
    super.initState();
    _fetchTimes();
    _fetchLocations();
  }

  // Fetch both Check-in and Check-out times
  Future<void> _fetchTimes() async {
    String checkIn = await _homeScreenController.getCheckInTime(widget.employeeId);
    String checkOut = await _homeScreenController.getCheckOutTime(widget.employeeId);
    setState(() {
      checkInTime = checkIn;
      checkOutTime = checkOut;
    });
  }

  // Fetch both Check-in and Check-out locations
  Future<void> _fetchLocations() async {
    String inLocation = await _homeScreenController.getDeviceLocation();
    String outLocation = await _homeScreenController.getCheckOutLocation(widget.employeeId);
    setState(() {
      checkInLocation = inLocation;
      checkOutLocation = outLocation;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      HistoryScreen(employeeId: widget.employeeId),
      HomeScreenContent(employeeId: widget.employeeId),
      ProfileScreen(employeeId: widget.employeeId),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: const Color.fromRGBO(222, 245, 229, 0.8),
        items: <Widget>[
          _buildIcon('assets/History.json', _selectedIndex == 0, 40, 40),
          _buildIcon('assets/Home.json', _selectedIndex == 1, 35, 35),
          _buildIcon('assets/Profile.json', _selectedIndex == 2, 30, 30),
        ],
        onTap: _onItemTapped,
        color: const Color.fromRGBO(158, 213, 197, 1),
        buttonBackgroundColor: const Color.fromRGBO(158, 213, 197, 1),
        height: 68,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildIcon(String assetName, bool isSelected, double width, double height) {
    return Lottie.asset(
      assetName,
      width: width,
      height: height,
      repeat: isSelected,
      animate: isSelected,
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final String employeeId;

  const HomeScreenContent({Key? key, required this.employeeId}) : super(key: key);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final HomeScreenController _homeScreenController = HomeScreenController();

  String checkInTime = '';
  String checkOutTime = '';
  String checkInLocation = 'Fetching location...';
  String checkOutLocation = '----';

  @override
  void initState() {
    super.initState();
    _fetchTimes();
    _fetchLocations();
  }

  // Fetch both Check-in and Check-out times
  Future<void> _fetchTimes() async {
    String checkIn = await _homeScreenController.getCheckInTime(widget.employeeId);
    String checkOut = await _homeScreenController.getCheckOutTime(widget.employeeId);
    setState(() {
      checkInTime = checkIn;
      checkOutTime = checkOut;
    });
  }

  // Fetch both Check-in and Check-out locations
  Future<void> _fetchLocations() async {
    String inLocation = await _homeScreenController.getDeviceLocation();
    String outLocation = await _homeScreenController.getCheckOutLocation(widget.employeeId);
    setState(() {
      checkInLocation = inLocation;
      checkOutLocation = outLocation;
    });
  }

  void _showCheckOutDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          content: Container(
            height: 120,
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final Color primary = Color.fromRGBO(158, 213, 197, 1);

    // Get current date
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: primary,
        automaticallyImplyLeading: true, // Remove back button
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
      body: Container(
        color: const Color.fromRGBO(222, 245, 229, 0.8),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 15),
                child: Text(
                  "Today's Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              // Date and Time display
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 13),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
              // Check-in and Check-out display
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 170,
                decoration: BoxDecoration(
                  color: primary,  // Changed to match app bar color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                              fontSize: screenWidth / 22,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            checkInTime.isNotEmpty ? checkInTime : "Not checked in",  // Show check-in time or placeholder
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 20,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                              fontSize: screenWidth / 22,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            checkOutTime.isNotEmpty ? checkOutTime : "----",  // Initially show empty check-out time
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 20,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),  // Add more spacing between the Date/Time and the Slide to Check Out bar
              Container(
                child: Builder(
                  builder: (context) {
                    final GlobalKey<SlideActionState> key = GlobalKey();
                    return SlideAction(
                      text: "Slide to Check Out",
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaRegular",
                      ), // TextStyle
                      outerColor: Color.fromRGBO(158, 213, 197, 1.0),
                      innerColor: Color.fromRGBO(222, 245, 229, 1.0),
                      key: key,
                      onSubmit: () async {
                        // Update check-out time and location
                        String checkoutTime = DateFormat('hh:mm').format(DateTime.now());
                        String checkOutLocation = await _homeScreenController.getDeviceLocation();
                        setState(() {
                          checkOutTime = checkoutTime;
                          this.checkOutLocation = checkOutLocation;
                        });

                        await _homeScreenController.updateCheckOut(widget.employeeId, checkOutLocation);

                        _showCheckOutDialog(context, 'Check-out time recorded successfully!');
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 40), // Add some spacing above the slide bar
              // Check-in and Check-out locations in white boxes with colored headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth * 0.45,
                    height: 220,  // Fixed height for the entire container
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,  // Increased height for the colored box
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(158, 213, 197, 1.0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Check-in Location',
                              style: TextStyle(
                                fontSize: screenWidth / 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              checkInLocation,
                              style: TextStyle(fontSize: screenWidth / 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.45,
                    height: 220,  // Fixed height for the entire container
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,  // Increased height for the colored box
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(158, 213, 197, 1.0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Check-out Location',
                              style: TextStyle(
                                fontSize: screenWidth / 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              checkOutLocation,
                              style: TextStyle(fontSize: screenWidth / 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}