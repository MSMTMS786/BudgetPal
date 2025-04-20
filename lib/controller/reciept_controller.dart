// receipt_controller.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptController extends GetxController {
  final Transaction transaction;
  final GlobalKey receiptKey = GlobalKey();
  final DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm');
  
  ReceiptController({required this.transaction});
  
  String get formattedDate => formatter.format(transaction.date);
  String get transactionType => transaction.isExpense ? 'Expense' : 'Income';
  String get formattedAmount => transaction.amount.toStringAsFixed(2);
  
  // Method to handle capturing and sharing receipt
  Future<void> captureAndShareReceipt(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          receiptKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/receipt.png');
      await imagePath.writeAsBytes(pngBytes);

      await Share.shareXFiles([
        XFile(imagePath.path),
      ], text: 'Here is your BudgetPal receipt!');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error capturing receipt: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  // Navigate back
  void goBack() {
    Get.back();
  }
}