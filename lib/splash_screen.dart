import 'package:flutter/material.dart';
import 'dart:async';
import 'l10n/app_localization.dart';
import 'video_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  SplashScreen({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoScreen(
            onVideoEnd: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Text(
          localizations.translate('Shuwayer') ?? 'Factory App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
