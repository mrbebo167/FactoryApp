import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class Translations {
  Translations(this.locale);

  final Locale locale;

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Login',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'register': 'Register',
      'forgot_password': 'Forgot Password?',
      'remember_me': 'Remember me',
      'continue_as_guest': 'Continue as Guest',
    },
    'ar': {
      'title': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'login': 'تسجيل الدخول',
      'register': 'تسجيل',
      'forgot_password': 'نسيت كلمة المرور؟',
      'remember_me': 'تذكرني',
      'continue_as_guest': 'الدخول كضيف',
    },
  };

  String? translate(String key) {
    return _localizedValues[locale.languageCode]![key];
  }

  static const LocalizationsDelegate<Translations> delegate = TranslationsDelegate();
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) {
    return SynchronousFuture<Translations>(Translations(locale));
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
