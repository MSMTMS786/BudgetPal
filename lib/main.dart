import 'package:expense_tracker/screen/addtransaction_screen.dart';
import 'package:expense_tracker/screen/onboarding_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnBoard(),
  ));
}
