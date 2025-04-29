import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; // Import your login screen file
import 'screens/home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harvest Hub',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LoginScreen(), // Set LoginScreen as the first screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),// Define route for LoginScreen
      },
    );

  }
}
