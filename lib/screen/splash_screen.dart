
import 'package:expense_tracker/screen/home_screen.dart';
import 'package:expense_tracker/screen/pin_screen.dart';
import 'package:expense_tracker/widgets/custom_paint.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Assuming you'll navigate to a home screen after the splash


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to the next screen after showing splash screen
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  PinScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E), // Dark blue at top
              Color(0xFF3F0D49), // Purple at bottom
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SizedBox(
              height: 120,
              width: 120,
              child: Stack(
                children: [
                  // Dollar bill part
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 80,
                      width: 80,
                      child: CustomPaint(
                        painter: DollarBillPainter(),
                      ),
                    ),
                  ),
                  

                  // Person icon
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5722), // Orange
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // App name
            const Text(
              'BudgetPal',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFA726), // Orange-yellow
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            // Tagline
            const Text(
              'Because Every Expense Tells a Story.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
