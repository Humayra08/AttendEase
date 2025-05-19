import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'login_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final LoginController _loginController = LoginController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _errorMessage = null;
    });
    try {
      bool success = await _loginController.loginUser(
        _employeeIdController.text,
        _passwordController.text,
      );
      if (success) {
        // Navigate to the homepage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(employeeId: _employeeIdController.text), // Pass employeeId here
          ),
        );

      }
    } catch (e) {
      setState(() {
        // Extracting only the relevant error message
        if (e.toString().contains('Wrong password')) {
          _errorMessage = 'Wrong password';
        } else if (e.toString().contains('Employee ID not found')) {
          _errorMessage = 'Employee ID not found';
        } else {
          _errorMessage = 'An error occurred. Please try again.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(222, 245, 229, 1.0),
                  Color.fromRGBO(106, 156, 137, 1.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              widthFactor: 0.92,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7), // opacity
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 34,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Employee ID",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 16),
                              child: TextFormField(
                                controller: _employeeIdController,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: SvgPicture.asset(
                                      "assets/office.svg",
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromRGBO(142, 195, 176, 1.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromRGBO(142, 195, 176, 1.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromRGBO(142, 195, 176, 1.0)),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white60,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            const Text(
                              "Password",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: SvgPicture.asset(
                                      "assets/lock.svg",
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromRGBO(142, 195, 176, 1.0)), // Constant border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromRGBO(142, 195, 176, 1.0)), // Constant border color
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromRGBO(142, 195, 176, 1.0)), // Constant border color
                                  ),
                                  filled: true,
                                  fillColor: Colors.white60,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'forgotPassword');
                                      // Handle forgot password action
                                    },
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(158, 213, 197, 1.0),
                                minimumSize: const Size(double.infinity, 56),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              icon: const Icon(CupertinoIcons.arrow_right, color: Colors.black),
                              label: const Text(
                                "Sign In",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: const Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Colors.black26,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register'); // Handle sign up action
                                  },
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}