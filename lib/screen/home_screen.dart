import 'package:expense_tracker/screen/add_expense_income.dart';
import 'package:expense_tracker/widgets/Drawer.dart';
import 'package:expense_tracker/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Set the key here
      drawer: MyDrawer(), // Add the drawer here
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Use GlobalKey to open drawer
          },
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        backgroundColor: Color(0xFF3F0D49),
        
        title: Center(
          child: Text(
            'Welcome',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),

      body: Container(
        
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3F0D49), // Purple at top
              Color(0xFF1A1A2E), // Dark blue at bottom
              
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar with menu and welcome
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Just a spacer to balance the menu icon
                    const SizedBox(width: 28),
                  ],
                ),
              ),

              // Available Balance Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(
                      child: Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        '₹1,05,284',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Percentage Gauges
              Container(
                height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGauge('29%', Colors.purple),
                      _buildGauge('61%', Colors.cyan),
                      _buildGauge('46%', Colors.orange),
                    ],
                  ),
                ),
                
            

              // My Transactions Text
              Container(
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'My transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Transaction List
              Container(
                child: Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildTransactionItem(
                        icon: null,
                        fallbackIcon: 'S',
                        fallbackColor: Colors.red,
                        name: 'Shell',
                        date: 'Sep 02, 2022',
                        amount: '-₹45',
                        color: Colors.orange,
                      ),
                      _buildTransactionItem(
                        icon: null,
                        fallbackIcon: 'S',
                        fallbackColor: Colors.pink[100]!,
                        name: 'SM Supermart',
                        date: 'Sep 01, 2022',
                        amount: '-₹235',
                        color: Colors.cyan,
                      ),
                      _buildTransactionItem(
                        icon: null,
                        fallbackIcon: 'M',
                        fallbackColor: Colors.green[200]!,
                        name: 'Mango Store',
                        date: 'Mar 02, 2035',
                        amount: '-₹564',
                        color: Colors.orange,
                      ),
                      _buildTransactionItem(
                        icon: null,
                        fallbackIcon: 'P',
                        fallbackColor: Colors.green[200]!,
                        name: 'PinelabsPOS',
                        date: 'Aug 31, 2022',
                        amount: '-₹164',
                        color: Colors.orange,
                      ),
                      _buildTransactionItem(
                        icon: null,
                        fallbackIcon: 'A',
                        fallbackColor: Colors.white,
                        name: 'AMAZON',
                        date: 'Aug 31, 2022',
                        amount: '-₹83',
                        color: Colors.purple,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen()));
                        },
                        child: Icon(Icons.add, color: Color(0xFF1A1A2E)),
                        backgroundColor: Color(0xFFFFD700),
                      ),
                    ],
                  ),
                ),
              ),
          
              // Bottom Navigation Bar
              BottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build gauge widgets
  Widget _buildGauge(String percentage, Color color) {
    return Container(
      // width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(painter: GaugePainter(color)),
          ),
          Text(
            percentage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build transaction items
  Widget _buildTransactionItem({
    required String? icon,
    required String fallbackIcon,
    required Color fallbackColor,
    required String name,
    required String date,
    required String amount,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252547),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon or letter
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: icon == null ? fallbackColor : Colors.white,
              shape: BoxShape.circle,
            ),
            child:
                icon == null
                    ? Center(
                      child: Text(
                        fallbackIcon,
                        style: TextStyle(
                          color:
                              fallbackIcon == 'S' ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : ClipOval(
                      child: Image.asset(
                        icon,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
          const SizedBox(width: 16),
          // Name and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Colored indicator
          Container(
            width: 5,
            height: 40,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build navigation items
  // Widget _buildNavItem(IconData icon, bool isActive) {
  //   return Container(
  //     width: 50,
  //     height: 50,
  //     decoration: BoxDecoration(
  //       color: isActive ? Color(0xFFFFD700) : Colors.transparent,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Icon(
  //       icon,
  //       color: isActive ? Color(0xFF1A1A2E) : Colors.white,
  //     ),
  //   );
  // }
}

// Custom painter for the gauge
class GaugePainter extends CustomPainter {
  final Color color;

  GaugePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.grey[800]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10;

    final Paint activePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5 * 3.14159, // Start at 9 o'clock position
      1 * 3.14159, // Half circle (180 degrees)
      false,
      paint,
    );

    // Draw active arc - adjust sweep for percentage
    double percentage = 0.6; // Represents percentage like 60%
    if (color == Colors.purple) percentage = 0.29;
    if (color == Colors.cyan) percentage = 0.61;
    if (color == Colors.orange) percentage = 0.46;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5 * 3.14159, // Start at 9 o'clock position
      percentage * 3.14159, // Percentage of 180 degrees
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// You'll need to add these assets to your pubspec.yaml:
// assets:
//   - assets/shell_logo.png
//   - assets/amazon_logo.png
