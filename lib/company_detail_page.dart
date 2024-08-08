import 'package:factory_app/theme_manager.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'l10n/app_localization.dart';

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
    var localizations = AppLocalizations.of(context)!;
    final profileUrl = _getProfileUrl(companyName);

    return Scaffold(
      appBar: AppBar(
        title: Text(companyName),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('about') ?? 'About',
              style: theme.textTheme.headlineSmall!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              aboutText,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await _checkPermission()) {
                  final path = await _downloadPDF(context, profileUrl);
                  if (path != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerPage(path: path),
                      ),
                    );
                  }
                }
              },
              child: Text(localizations.translate('downloadProfile') ?? 'Download Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              localizations.translate('services') ?? 'Services',
              style: theme.textTheme.headlineSmall!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            ...services.map((service) => ListTile(
              leading: Icon(Icons.check, color: theme.colorScheme.secondary),
              title: Text(service, style: theme.textTheme.bodyLarge),
            )),
            SizedBox(height: 20),
            Text(
              localizations.translate('products') ?? 'Products',
              style: theme.textTheme.headlineSmall!.copyWith(fontSize: 24),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/rfqForm');
              },
              child: Text(localizations.translate('requestForQuotation') ?? 'Request for Quotation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              localizations.translate('certificates') ?? 'Certificates',
              style: theme.textTheme.headlineSmall!.copyWith(fontSize: 24),
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

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<String?> _downloadPDF(BuildContext context, String url) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        return null;
      }
      final fileName = url.split('/').last;
      final path = '${directory.path}/$fileName';
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      FlutterDownloader.registerCallback((id, status, progress) {
        if (id == taskId && status == DownloadTaskStatus.complete) {
          _openDownloadedPDF(context, path);
        }
      });

      return path;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  void _openDownloadedPDF(BuildContext context, String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(path: path),
      ),
    );
  }

  String _getProfileUrl(String companyName) {
    switch (companyName) {
      case 'ELECTRICAL ENGINEERING SYSTEMS "EES"':
        return 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/EES%20Company%20Profile..pdf?alt=media&token=65c1f989-f140-4a7e-becb-52d7c3207a9f';
      case 'Heavy Metal industries':
        return 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/Heavy%20Metal%20Industries%20Profile.pdf?alt=media&token=43bac023-dcac-472f-b1b7-6c4a195c0d35';
      case 'Steel Galvanizing':
        return 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/Steel%20Galvanizing%20Profile.pdf?alt=media&token=fde97187-b06f-45a4-874f-06d1d727a78d';
      case 'HVAC Division':
        return 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/HVAC%20Division%20Profile.pdf?alt=media&token=44247617-9c5f-42ed-9b11-b9fbb4bacefa';
      case 'Equipment Rental':
        return 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/Equipment%20Division%20Profile%20REV%20002.pdf?alt=media&token=80cac72f-6ae3-4376-97ad-37fec83b8e5e';
      case 'Energy Services Division "EQTASID"':
        return 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/EQTASID%20Profile.pdf?alt=media&token=43af472b-34a6-4ae6-9634-dac2f43896e5';
      default:
        return '';
    }
  }
}

class PDFViewerPage extends StatelessWidget {
  final String path;

  PDFViewerPage({required this.path});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('companyProfile') ?? 'Company Profile'),
      ),
      body: SfPdfViewer.file(File(path)),
    );
  }
}
