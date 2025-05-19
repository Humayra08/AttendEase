import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessfulScreen extends StatelessWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(158, 213, 197, 1.0),
        title: const Text(
          'Success',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(222, 245, 229, 1.0),
              Color.fromRGBO(158, 213, 197, 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FractionallySizedBox(
            heightFactor: 0.65,
            widthFactor: 0.92,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 25), // Added space to move Lottie down
                  Lottie.asset(
                    'assets/Successful.json',
                    height: 150,
                    repeat: false,
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'Your account has been created successfully!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50), // Increased space
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'loginScreen');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(158, 213, 197, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 22), // Increased size
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}