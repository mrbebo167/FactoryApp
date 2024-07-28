import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'l10n/app_localization.dart';
import 'login_page.dart';

class PendingPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final String email;

  PendingPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.email,
  });

  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  bool _isRejected = false;
  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  void _checkRegistrationStatus() async {
    var userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.email)
        .get();

    if (userDocs.docs.isNotEmpty) {
      var userDoc = userDocs.docs.first;
      var isAccepted = userDoc['isAccepted'];

      setState(() {
        if (isAccepted == true) {
          _isAccepted = true;
        } else if (isAccepted == false) {
          _isRejected = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('pendingVerification') ?? 'Pending Verification'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeColor: Colors.yellow,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRejected
                  ? localizations.translate('registrationRejected') ?? 'Your registration request was rejected.'
                  : _isAccepted
                      ? localizations.translate('registrationAccepted') ?? 'Your registration request was accepted. You can now log in.'
                      : localizations.translate('registrationPending') ?? 'Your registration request is pending. Please wait for approval.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      isDarkMode: widget.isDarkMode,
                      onThemeChanged: widget.onThemeChanged,
                      onLanguageChanged: widget.onLanguageChanged,
                    ),
                  ),
                );
              },
              child: Text(localizations.translate('backToLogin') ?? 'Back to Login'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
