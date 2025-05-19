import 'package:flutter/material.dart';
import 'forgotPassword_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final ForgotPasswordController _forgotPasswordController = ForgotPasswordController();

  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void resetPassword() async {
    try {
      String? errorMessage = await _forgotPasswordController.resetPassword(
        employeeIdController.text.trim(),
        newPasswordController.text.trim(),
        confirmPasswordController.text.trim(),
      );

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(158, 213, 197, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goBack,
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
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
                    'Reset Your\nPassword',
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
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height - 200,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: employeeIdController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.check,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Enter Employee ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: newPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'New Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Confirm New Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
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
                              onPressed: resetPassword,
                              child: const Center(
                                child: Text(
                                  'Done',
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
    );
  }
}