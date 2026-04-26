import 'package:flutter/material.dart';
import 'package:ostrea/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/Mar.jpg',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/ostreaLogoNoName.jpg',
                  width: 150, // Adjust size as needed
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}