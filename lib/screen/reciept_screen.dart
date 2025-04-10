import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:expense_tracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';

class ReceiptScreen extends StatefulWidget {
  final Transaction transaction;

  const ReceiptScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> with WidgetsBindingObserver {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        // Force rebuild on resume
      });
    }
  }

  Future<void> _captureAndShareReceipt(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing receipt: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final formatter = DateFormat('MMM dd, yyyy HH:mm');
    final formattedDate = formatter.format(transaction.date);
    final transactionColor = transaction.isExpense ? Colors.red : Colors.green;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Receipt Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF252836),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'RECEIPT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          30,
                          (index) => Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF252836),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              'Transaction Type:',
                              transaction.isExpense ? 'EXPENSE' : 'INCOME',
                              valueColor: transactionColor,
                              isBold: true,
                            ),
                            const Divider(height: 24),
                            _infoRow(
                              'Amount:',
                              'RS. ${transaction.amount.toStringAsFixed(2)}',
                              valueColor: transactionColor,
                              isBold: true,
                              valueSize: 20,
                            ),
                            const Divider(height: 24),
                            _infoRow(
                              'Category:',
                              transaction.category,
                              isBold: true,
                            ),
                            const Divider(height: 24),
                            _infoRow(
                              'Payment Method:',
                              transaction.paymentMethod,
                              isBold: true,
                            ),
                            const Divider(height: 24),
                            _infoRow(
                              'Transaction ID:',
                              transaction.id.substring(0, 8),
                              fontFamily: 'monospace',
                            ),
                            const Divider(height: 24),
                            const Text(
                              'Description:',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              transaction.description,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: const Text(
                        'Thank you for using BudgetPal!',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _captureAndShareReceipt(context),
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text(
                'Share Receipt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String title,
    String value, {
    Color? valueColor,
    bool isBold = false,
    double valueSize = 16,
    String? fontFamily,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black,
            fontSize: valueSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontFamily: fontFamily,
          ),
        ),
      ],
    );
  }
}
