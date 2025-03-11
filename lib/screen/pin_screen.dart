import 'package:expense_tracker/screen/home_screen.dart';
import 'package:flutter/material.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final int pinLength = 4;
  String currentPin = '';

  // Handle number press
  void _handleNumberPress(String number) {
    setState(() {
      if (currentPin.length < pinLength) {
        currentPin += number;
      }

      // If pin is complete, you can add validation logic here
      if (currentPin.length == pinLength) {
        // For example: validate PIN and navigate to next screen
        // For demo, we'll just print the PIN
        print('PIN entered: $currentPin');
        Future.delayed(Duration(milliseconds: 200), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        });
      }
    });
  }

  // Handle backspace
  void _handleBackspace() {
    setState(() {
      if (currentPin.isNotEmpty) {
        currentPin = currentPin.substring(0, currentPin.length - 1);
      }
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
        child: SafeArea(
          child: Column(
            children: [
              // Status bar space
              const SizedBox(height: 40),

              // Enter Pin text
              const Text(
                'Enter Pin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 50),

              // PIN dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pinLength,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          index < currentPin.length
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              // Spacer
              const Spacer(),

              // Number pad
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    // Row 1: 1, 2, 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('1'),
                        _buildNumberButton('2'),
                        _buildNumberButton('3'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Row 2: 4, 5, 6
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('4'),
                        _buildNumberButton('5'),
                        _buildNumberButton('6'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Row 3: 7, 8, 9
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('7'),
                        _buildNumberButton('8'),
                        _buildNumberButton('9'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Row 4: empty, 0, backspace
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Empty space for alignment
                        const SizedBox(width: 60),

                        // 0 button
                        _buildNumberButton('0'),

                        // Backspace button
                        GestureDetector(
                          onTap: _handleBackspace,
                          child: Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.backspace_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom space
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build number buttons
  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _handleNumberPress(number),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// Update your existing HomeScreen to implement this
// For example:
class HomeScreenWithPin extends StatelessWidget {
  const HomeScreenWithPin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: Column(children: [const PinScreen()]),
      ),
    );
  }
}
