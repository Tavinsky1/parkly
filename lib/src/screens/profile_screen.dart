import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as: \${user?.email}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
