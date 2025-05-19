import 'package:flutter/material.dart';
import 'register_controller.dart';
import 'successfulScreen.dart'; // Import the successful.dart file

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final RegisterController _registerController = RegisterController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void _register() async {
    try {
      await _registerController.registerUser(
        _fullNameController.text,
        _emailController.text,
        _employeeIdController.text,
        _passwordController.text,
      );
      // Navigate to the Successful screen after registration
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessfulScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(158, 213, 197, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goBack,
        ),
        title: const Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(222, 245, 229, 1.0),
                        Color.fromRGBO(158, 213, 197, 0.8),
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 22),
                    child: Text(
                      'Create Your\nAccount',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _offsetAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        color: Colors.white,
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'Full Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'Email Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            TextField(
                              controller: _employeeIdController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'Employee ID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
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
                            const SizedBox(height: 10),
                            const SizedBox(height: 70),
                            Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromRGBO(158, 213, 197, 1.0),
                              ),
                              child: TextButton(
                                onPressed: _register,
                                child: const Center(
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }
}