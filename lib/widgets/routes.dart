import 'package:expense_tracker/screen/addtransaction_screen.dart';
import 'package:get/get.dart';
import '../screen/home_screen.dart';
import '../screen/pin_screen.dart';
import '../screen/splash_screen.dart';
class AppRoutes {
  static const String splash = '/splash';
  static const String pinScreen = '/pinScreen';
  static const String homeScreen = '/home';
  static const String addTransaction = '/addTransaction';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: pinScreen, page: () => PinScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: addTransaction, page: () => TransactionEntryScreen()),
  ];
}
