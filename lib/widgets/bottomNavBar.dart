import 'package:flutter/material.dart';
import '../screen/home_screen.dart';
import '../screen/pin_screen.dart';
import '../screen/add_expense_income.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    PinScreen(),
    AddTransactionScreen(),
    PinScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Change screen based on selected index
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Update selected index on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF3F0D49)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet, color: Color(0xFF3F0D49)),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Color(0xFF3F0D49)),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xFF3F0D49)),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF3F0D49),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
