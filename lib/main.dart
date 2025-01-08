import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_menu/pages/splash_page.dart';
import 'firebase_options.dart'; // Import the generated Firebase options

late FirebaseApp secondaryApp; // Initialize the secondary Firebase app

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with platform-specific options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize the secondary Firebase app
  secondaryApp = await Firebase.initializeApp(
    name: 'AlumbradoPublicoNte', // Name for the secondary instance
    options: FirebaseOptions(
      apiKey: "AIzaSyCGuGpJEWo1_9gWwgSv3JO9s1051wDpY6E",
      authDomain: "alumbradopubliconte.firebaseapp.com",
      databaseURL: "https://alumbradopubliconte-default-rtdb.firebaseio.com",
      projectId: "alumbradopubliconte",
      storageBucket: "alumbradopubliconte.appspot.com",
      messagingSenderId: "842157703635",
      appId: "1:842157703635:web:64db480e6191f6c0326f26",
      measurementId: "G-H4PG2MM8S5",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SlashScreen(), // Replace with your initial screen
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}
