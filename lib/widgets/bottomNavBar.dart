import 'package:flutter/material.dart';
import '../screen/home_screen.dart';

import '../screen/pin_screen.dart';

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
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // showSelectedLabels: true,
      showUnselectedLabels: false,
      // fixedColor: Colors.black,
      selectedIconTheme: IconThemeData(color: Colors.black),
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _onItemTapped(index);
      },
      items: const [
        BottomNavigationBarItem(
          
          icon: Icon(Icons.home,color: Color(0xFF3F0D49)),
           label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet,color: Color(0xFF3F0D49)),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart,color: Color(0xFF3F0D49)),
          label: 'Stats',
        ),
        BottomNavigationBarItem(icon:  Icon(Icons.person,color: Color(0xFF3F0D49)),
          label: 'Profile',
        ),
      ],
      selectedItemColor: const Color(0xFF3F0D49),
      unselectedItemColor: Colors.grey,
     
    );
  }
}
