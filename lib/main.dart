import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginScreen.dart';
import 'splashScreen.dart';
import 'forgotPassword.dart';
import 'register.dart';
import 'home_screen.dart';
import 'successfulScreen.dart';
import 'profile.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAhSRLcpdMycmSZeqb2J1cAmARa8rD5H8k',
          appId: '1:725969285278:android:061dc7aaf6f255e7f38b8f',
          messagingSenderId: '725969285278',
          projectId: 'attendease-c439e',
          databaseURL: 'https://attendease-c439e-default-rtdb.firebaseio.com/',
        ),
      );
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RGB Color Example',
      initialRoute: 'splashScreen',
      routes: {
        'splashScreen': (context) => SplashScreen(),
        'loginScreen': (context) => LoginScreen(),
        'forgotPassword': (context) => ForgotPassword(),
        'register': (context) => RegScreen(),
        'profile' : (context) => ProfileScreen(employeeId: '',),
        'home': (context) {
          final employeeId = ModalRoute.of(context)!.settings.arguments as String;
          return HomeScreen(employeeId: employeeId);
        },
        'successful': (context) => SuccessfulScreen(),
      },
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
    );
  }
}