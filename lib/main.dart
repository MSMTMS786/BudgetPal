
import 'package:expense_tracker/screen/home_screen.dart';
import 'package:expense_tracker/screen/splash_screen.dart';

import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:SplashScreen(),
 
  ));
}
