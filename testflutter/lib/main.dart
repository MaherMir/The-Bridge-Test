import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD9QXD9wXGP9xmrW7Exf8VMaRifx43ma8Q",
            authDomain: "testflut-a3736.firebaseapp.com",
            projectId: "testflut-a3736",
            storageBucket: "testflut-a3736.firebasestorage.app",
            messagingSenderId: "767715371971",
            appId: "1:767715371971:web:469544440e2b8c805e6b76"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Platform',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LandingPage(),
    );
  }
}
