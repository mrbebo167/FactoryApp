import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';
import 'theme_manager.dart'; // Ensure the correct import path

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCompany;

  // Example list of companies
  final List<String> _companies = ['Company A', 'Company B', 'Company C'];

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('contactUs')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
       
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCompany,
                items: _companies.map((String company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: localizations.translate('selectCompany'),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('selectCompany');
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedCompany = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('yourName'),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('yourName');
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('yourEmail'),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('yourEmail');
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('yourMessage'),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('yourMessage');
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.translate('messageSent'))),
                    );
                  }
                },
                child: Text(localizations.translate('submit')),
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onPrimary, backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
