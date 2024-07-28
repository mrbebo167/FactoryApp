import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'guest_home.dart';
import 'l10n/app_localization.dart';
import 'login_page.dart';
import 'forgot_password_page.dart';
import 'notifications_page.dart';
import 'pending_page.dart';
import 'admin_home.dart';
import 'customer_home.dart';
import 'registration_page.dart';
import 'splash_screen.dart';
import 'introduction_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  Locale _locale = Locale('en');

  void onThemeChanged(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void onLanguageChanged(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            locale: _locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'),
              const Locale('ar'),
            ],
            home: SplashScreen(
              isDarkMode: isDarkMode,
              onThemeChanged: onThemeChanged,
              onLanguageChanged: onLanguageChanged,
            ),
            routes: {
              '/forgotPassword': (context) => ForgotPasswordPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/register': (context) => RegistrationPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/guestHome': (context) => GuestHomePage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/notifications': (context) => NotificationsPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/pending': (context) => PendingPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                    email: '',
                  ),
              '/introduction': (context) => IntroductionPage(),
              '/login': (context) => LoginPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              // Define other routes here
            },
          );
        },
      ),
    );
  }
}
