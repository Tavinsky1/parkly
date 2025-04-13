import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';

class ParklyApp extends StatelessWidget {
  const ParklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      routes: {
        '/map': (context) => const MapScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
