import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('contactUs') ?? 'Contact Us'),
        backgroundColor: isDarkMode ? Colors.black : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.yellow : Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCompany,
                items: _companies.map((String company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(
                      company,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: localizations.translate('selectCompany') ?? 'Select Company',
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  filled: true,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('selectCompany') ?? 'Please select a company';
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
                  labelText: localizations.translate('yourName') ?? 'Your Name',
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  filled: true,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourName') ?? 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('yourEmail') ?? 'Your Email',
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  filled: true,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourEmail') ?? 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return localizations.translate('pleaseEnterAValidEmailAddress') ?? 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('yourMessage') ?? 'Your Message',
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  filled: true,
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourMessage') ?? 'Please enter your message';
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
                      SnackBar(content: Text(localizations.translate('messageSent') ?? 'Message Sent')),
                    );
                  }
                },
                child: Text(localizations.translate('submit') ?? 'Submit'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
