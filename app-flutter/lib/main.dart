import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDJHz86qDPVpn0AkEznJz2xtE8GyEVxebA',
      appId: '1:36394319098:android:948f3c2370c788218fdd43',
      messagingSenderId: '36394319098',
      projectId: 'placementprediction-5f550',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // No custom font specified
      ),
      home: HomePage(), // Directly navigate to HomePage since Firebase is already initialized
    );
  }
}
