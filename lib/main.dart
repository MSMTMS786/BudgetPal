import 'package:expense_tracker/controller/budget_controller.dart' show BudgetController;
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:expense_tracker/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  Get.put(TransactionController(), permanent: true);
  Get.put(BudgetController(), permanent: true);

  runApp(GetMaterialApp
  (
    debugShowCheckedModeBanner: false,
     home: SplashScreen()
     )
     );
}
