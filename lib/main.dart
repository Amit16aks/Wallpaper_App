import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint(">>> APP STARTED, INITIALIZING FIREBASE...");
  
  try {
    // Direct Firebase Connection
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAvwtUeO9MKwDJ0orK_FQ_IdxaTcIUPsik', 
        appId: '1:304458629491:android:d9689f9dff2f0bafeb8506', 
        messagingSenderId: '304458629491', 
        projectId: 'hindu-wallpaper-app-61376',
      ),
    ).timeout(const Duration(seconds: 4), onTimeout: () {
      debugPrint(">>> FIREBASE INIT TIMED OUT!");
      return Firebase.app();
    });
    debugPrint(">>> FIREBASE INITIALIZED SUCCESSFULLY");
  } catch (e) {
    debugPrint(">>> Firebase init error: $e");
  }
  
  debugPrint(">>> CALLING RUNAPP");
  runApp(const HinduWallpaperApp());
}

class HinduWallpaperApp extends StatelessWidget {
  const HinduWallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanatani Astha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFFBE9E7),
              body: Center(child: CircularProgressIndicator(color: Colors.deepOrange)),
            );
          }
          if (snapshot.hasData) {
            // User is signed in
            return const NavigationScreen();
          }
          // User is not signed in
          return const LoginScreen();
        },
      ),
    );
  }
}