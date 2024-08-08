import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contact_us_page.dart';
import 'auth_service.dart';
import 'about_us_page.dart';
import 'l10n/app_localization.dart';
import 'terms_and_conditions_page.dart';
import 'faq_page.dart';
import 'theme_manager.dart';

class CustomerSettingsPage extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  CustomerSettingsPage({
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings') ?? 'Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text(localizations.translate('contactUs') ?? 'Contact Us', style: theme.textTheme.bodyLarge),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(localizations.translate('aboutUs') ?? 'About Us', style: theme.textTheme.bodyLarge),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text(localizations.translate('termsAndConditions') ?? 'Terms and Conditions', style: theme.textTheme.bodyLarge),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text(localizations.translate('faq') ?? 'FAQ', style: theme.textTheme.bodyLarge),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQPage()),
              );
            },
          ),
          SwitchListTile(
            activeColor: ThemeManager.primaryColor,
            title: Text(localizations.translate('darkMode') ?? 'Dark Mode', style: theme.textTheme.bodyLarge),
            value: theme.brightness == Brightness.dark,
            onChanged: onThemeChanged,
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(localizations.translate('language') ?? 'Language', style: theme.textTheme.bodyLarge),
            trailing: DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onLanguageChanged(newValue);
                }
              },
              items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'en' ? 'English' : 'Arabic', style: theme.textTheme.bodyLarge),
                );
              }).toList(),
              dropdownColor: theme.scaffoldBackgroundColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(localizations.translate('signOut') ?? 'Sign Out', style: theme.textTheme.bodyLarge),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
