import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'profile_page_customer.dart';
import 'contact_us_page.dart';
import 'about_us_page.dart';
import 'company_detail_page.dart';
import 'rfq_form_page.dart';
import 'order_service.dart';
import 'video_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
    debug: true, // Optional: set to false to disable printing logs to console
  );

  await _checkAndRequestPermissions();

  runApp(MyApp());
}

Future<void> _checkAndRequestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  Locale _locale = Locale('en');

  @override
  void initState() {
    super.initState();
    _loadThemeAndLanguage();
  }

  void onThemeChanged(bool value) {
    setState(() {
      isDarkMode = value;
    });
    _saveThemeToPreferences(value);
  }

  void onLanguageChanged(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
    _saveLanguageToPreferences(languageCode);
  }

  void _loadThemeAndLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedTheme = prefs.getBool('isDarkMode');
    String? savedLanguage = prefs.getString('languageCode');

    if (savedTheme != null) {
      setState(() {
        isDarkMode = savedTheme;
      });
    } else {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      setState(() {
        isDarkMode = brightness == Brightness.dark;
      });
    }

    if (savedLanguage != null) {
      setState(() {
        _locale = Locale(savedLanguage);
      });
    }
  }

  void _saveThemeToPreferences(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void _saveLanguageToPreferences(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<OrderService>(create: (_) => OrderService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            theme: ThemeManager.lightTheme,
            darkTheme: ThemeManager.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
                  return IntroductionPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                    onGetStarted: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  );
                } else {
                  return StreamBuilder<User?>(
                    stream: authService.authStateChanges,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        User? user = snapshot.data;

                        if (user == null) {
                          return VideoScreen(
                            onVideoEnd: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
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
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/guestHome': (context) => GuestHomePage(
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/notifications': (context) => NotificationsPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/pending': (context) => PendingPage(
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                    email: '', // Ensure to pass the correct email
                  ),
              '/profile': (context) => CustomerProfilePage(
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/contactUs': (context) => ContactUsPage(),
              '/aboutUs': (context) => AboutUsPage(),
              '/companyDetails': (context) => CompanyDetailPage(
                    companyName: '',
                    aboutText: '',
                    services: [],
                    certificates: [],
                  ),
              '/rfqForm': (context) => RFQFormPage(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
              '/pdfViewer': (context) => PDFViewerPage(
                    path: '',
                  ),
              '/login': (context) => LoginPage(
                    onThemeChanged: onThemeChanged,
                    onLanguageChanged: onLanguageChanged,
                  ),
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
