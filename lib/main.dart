import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import '../layouts/login.dart';
import '../logics/auth_controller.dart';
import '../resources/colors.dart';

SharedPreferences? prefs;

Brightness brightness = Brightness.light;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDKU2BkBa3BrCIUIEbDyKidAsn44SWrLko",
      authDomain: "emergencyaccidentalertsystem.firebaseapp.com",
      projectId: "emergencyaccidentalertsystem",
      storageBucket: "emergencyaccidentalertsystem.appspot.com",
      messagingSenderId: "930329931092",
      appId: "1:930329931092:web:a045dc83b02f95667decc1",
      measurementId: "G-BYJS5MD9SR",
    ),
  );
  setPathUrlStrategy();
  runApp(
    MaterialApp(
      title: "Emergency Alert Responder",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: "vt323", fontSize: 20, color: Colors.white)),
          colorScheme: ColorScheme(
              brightness: brightness,
              primary: darkRed,
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: Colors.black,
              error: lightRed,
              onError: Colors.white,
              background: veryLightGrey,
              onBackground: Colors.yellow,
              surface: Colors.white,
              onSurface: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  navigate() {
    if (prefs?.getBool("isResponderLoggedinBefore") != null &&
        prefs?.getBool("isResponderLoggedinBefore") == true) {
      AuthUser(
              context: context,
              email: prefs?.getString("email"),
              password: prefs?.getString("password"))
          .login();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0), () {
      navigate();
    });
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: CupertinoActivityIndicator(
            radius: 12,
          ),
        ),
      ),
    );
  }
}
