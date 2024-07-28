import 'package:flutter/material.dart';
import 'package:factory_app/theme_manager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'rfq_form_page.dart';

class CompanyDetailPage extends StatelessWidget {
  final String companyName;
  final String aboutText;
  final List<String> services;
  final List<String> certificates;

  CompanyDetailPage({
    required this.companyName,
    required this.aboutText,
    required this.services,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(companyName),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: theme.textTheme.displayLarge!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              aboutText,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerPage(),
                  ),
                );
              },
              child: Text('Download Profile'),
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary, backgroundColor: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Services',
              style: theme.textTheme.displayLarge!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            ...services.map((service) => ListTile(
              leading: Icon(Icons.check, color: theme.colorScheme.secondary),
              title: Text(service, style: theme.textTheme.bodyLarge),
            )),
            SizedBox(height: 20),
            Text(
              'Products',
              style: theme.textTheme.displayLarge!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RFQFormPage(isDarkMode: theme.brightness == Brightness.dark),
                  ),
                );
              },
              child: Text('Request for Quotation'),
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary, backgroundColor: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Certificates',
              style: theme.textTheme.displayLarge!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            ...certificates.map((certificate) => ListTile(
              leading: Icon(Icons.verified, color: theme.colorScheme.secondary),
              title: Text(certificate, style: theme.textTheme.bodyLarge),
            )),
          ],
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile'),
      ),
      body: Center(
        child: SfPdfViewer.asset('assets/EES Company Profile..pdf'),
      ),
    );
  }
}
