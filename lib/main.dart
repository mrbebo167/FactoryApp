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
import 'theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    _loadThemeAndLanguage();
  }

  void _loadThemeAndLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedTheme = prefs.getBool('isDarkMode');
    String? savedLanguage = prefs.getString('languageCode');

    if (savedTheme != null) {
      setState(() {
        isDarkMode = savedTheme;
      });
    }

    if (savedLanguage != null) {
      setState(() {
        _locale = Locale(savedLanguage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            theme: ThemeManager.lightTheme,
            darkTheme: ThemeManager.darkTheme,
            themeMode: ThemeMode.system,
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
            home: FutureBuilder<bool>(
              future: _checkIntroductionSeen(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  );
                } else if (snapshot.data == false) {
                  return IntroductionPage();
                } else {
                  return StreamBuilder<User?>(
                    stream: authService.authStateChanges,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        User? user = snapshot.data;

                        if (user == null) {
                          return LoginPage(
                            isDarkMode: isDarkMode,
                            onThemeChanged: onThemeChanged,
                            onLanguageChanged: onLanguageChanged,
                          );
                        } else {
                          return FutureBuilder<Widget>(
                            future: authService.handleAuth(
                              isDarkMode,
                              onThemeChanged,
                              onLanguageChanged,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return snapshot.data!;
                                } else if (snapshot.hasError) {
                                  return Scaffold(
                                    body: Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    ),
                                  );
                                } else {
                                  return Scaffold(
                                    body: Center(
                                      child: Text('Unknown error'),
                                    ),
                                  );
                                }
                              } else {
                                return Scaffold(
                                  body: Center(child: CircularProgressIndicator()),
                                );
                              }
                            },
                          );
                        }
                      } else {
                        return Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  );
                }
              },
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
                    email: '', // Ensure to pass the correct email
                  ),
              // Define other routes here
            },
          );
        },
      ),
    );
  }

  Future<bool> _checkIntroductionSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenIntroduction') ?? false;
  }
}
