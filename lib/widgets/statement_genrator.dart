import 'dart:io';
import 'package:expense_tracker/model/model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class StatementGenerator {
  static Future<void> generateAndShareStatement(List<Transaction> transactions) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm a');

    // Calculate total income and expenses
    double totalIncome = transactions
        .where((tx) => !tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    double totalExpense = transactions
        .where((tx) => tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    double balance = totalIncome - totalExpense;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header with balance info
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('BudgetPal - Transaction Statement',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      )),
                  pw.SizedBox(height: 8),
                  pw.Text('Total Available Balance: RS${balance.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                      )),
                  pw.Text('Total Expense: RS${totalExpense.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                      )),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Table
            pw.Table.fromTextArray(
              headers: [
                'S/N',
                'Category',
                'Description',
                'Amount',
                'Date & Time'
              ],
              data: List<List<String>>.generate(
                transactions.length,
                (index) {
                  final tx = transactions[index];
                  return [
                    '${index + 1}',
                    tx.category,
                    tx.description,
                    (tx.isExpense ? '-' : '+') +
                        'RS${tx.amount.toStringAsFixed(2)}',
                    dateFormat.format(tx.date),
                  ];
                },
              ),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.indigo,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: const pw.FixedColumnWidth(40),
                1: const pw.FixedColumnWidth(70),
                2: const pw.FlexColumnWidth(),
                3: const pw.FixedColumnWidth(85),
                4: const pw.FixedColumnWidth(120),
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/BudgetPal_Statement.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)],
        text: 'BudgetPal Transaction Statement');
  }

  static Future<void> shareStatement(List<Transaction> transactions) async {
    await generateAndShareStatement(transactions);
  }
}
