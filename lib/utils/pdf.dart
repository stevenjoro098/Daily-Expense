import 'dart:io';
import 'package:daily_expenses/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sqflite/sqflite.dart';

class PDFGeneratorWidget extends StatelessWidget {
  const PDFGeneratorWidget({Key? key}) : super(key: key);

  // Fetch data from SQLite
  Future<List<Map<String, dynamic>>> fetchSQLData() async {

    // Query the database and get the data
    final List<Map<String, dynamic>> data = await AllExpenseList('9', '2024');
    return data;
  }

  // Generate PDF from the SQL data
  Future<void> generatePDF(List<Map<String, dynamic>> sqlData) async {
    final pdf = pw.Document();

    // Add page to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('SQL Data PDF', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                data: <List<String>>[
                  <String>['Id', 'expense_amount'],
                  ...sqlData.map((row) => [
                    row['id'].toString(),
                    row['column1'].toString(),

                  ])
                ],
              ),
            ],
          );
        },
      ),
    );

    // Get the document directory to save the PDF file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example.pdf');

    // Save the PDF file
    await file.writeAsBytes(await pdf.save());

    // Optionally, you can also display or print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Trigger the SQL data fetching and PDF generation
  void generatePDFfromSQL(BuildContext context) async {
    try {
      // Fetch SQL data
      List<Map<String, dynamic>> data = await fetchSQLData();

      // Generate PDF with the fetched data
      await generatePDF(data);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF generated successfully!')),
      );
    } catch (e) {
      // Show an error message in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate PDF from SQL Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => generatePDFfromSQL(context),
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}
