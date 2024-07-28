import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'introduction_page.dart';
import 'login_page.dart';

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
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(Duration(seconds: 3)); // Display splash screen for 3 seconds
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenIntroduction = prefs.getBool('seenIntroduction') ?? false;

    if (seenIntroduction) {
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
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IntroductionPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash.gif', fit: BoxFit.cover, height: double.infinity, width: double.infinity),
      ),
    );
  }
}
