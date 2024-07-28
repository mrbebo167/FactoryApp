import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('faq') ?? 'FAQ'),
        backgroundColor: isDarkMode ? Colors.black : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.yellow : Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          localizations.translate('faqContent') ??
              'This is the FAQ page. Provide frequently asked questions and answers here.',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
