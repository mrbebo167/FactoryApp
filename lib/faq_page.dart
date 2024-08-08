import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';
import 'theme_manager.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.translate('faq') ?? 'FAQ'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          localizations.translate('faqContent') ??
              'This is the FAQ page. Provide frequently asked questions and answers here.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
