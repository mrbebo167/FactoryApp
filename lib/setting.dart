import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contact_us_page.dart';
import 'about_us_page.dart';
import 'l10n/app_localization.dart';
import 'terms_and_conditions_page.dart';
import 'faq_page.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  SettingsPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool value) async {
    widget.onThemeChanged(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void _changeLanguage(String languageCode) {
    widget.onLanguageChanged(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('settings') ?? 'Settings'),
        backgroundColor: isDarkMode ? Colors.black : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.yellow : Colors.black),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.contact_mail, color: isDarkMode ? Colors.yellow : Colors.black),
            title: Text(localizations.translate('contactUs') ?? 'Contact Us', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward, color: isDarkMode ? Colors.yellow : Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: isDarkMode ? Colors.yellow : Colors.black),
            title: Text(localizations.translate('aboutUs') ?? 'About Us', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward, color: isDarkMode ? Colors.yellow : Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description, color: isDarkMode ? Colors.yellow : Colors.black),
            title: Text(localizations.translate('termsAndConditions') ?? 'Terms and Conditions', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward, color: isDarkMode ? Colors.yellow : Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer, color: isDarkMode ? Colors.yellow : Colors.black),
            title: Text(localizations.translate('faq') ?? 'FAQ', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: Icon(Icons.arrow_forward, color: isDarkMode ? Colors.yellow : Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQPage()),
              );
            },
          ),
          SwitchListTile(
            activeColor: Colors.yellow,
            title: Text(localizations.translate('darkMode') ?? 'Dark Mode', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _toggleTheme(value);
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: isDarkMode ? Colors.yellow : Colors.black),
            title: Text(localizations.translate('language') ?? 'Language', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            trailing: DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _changeLanguage(newValue);
                }
              },
              items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'en' ? 'English' : 'Arabic', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                );
              }).toList(),
              dropdownColor: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
