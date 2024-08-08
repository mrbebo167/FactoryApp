import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';
import 'theme_manager.dart';

class VirtualTourPage extends StatelessWidget {
  final bool isDarkMode;

  VirtualTourPage({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final companies = [
      "ELECTRICAL ENGINEERING SYSTEMS \"EES\"",
      "Heavy Metal industries",
      "Steel Galvanizing",
      "HVAC Division",
      "Equipment Rental",
      "Energy Services Division \"EQTASID\""
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('virtualTour') ?? 'Virtual Tour'),
      ),
      body: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(companies[index]),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to the virtual tour for the selected company
            },
          );
        },
      ),
    );
  }
}
