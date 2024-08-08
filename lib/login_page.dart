import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'l10n/app_localization.dart';
import 'theme_manager.dart';

class LoginPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  LoginPage({
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    bool? rememberMe = prefs.getBool('rememberMe') ?? false;

    if (email != null && password != null && rememberMe) {
      _emailController.text = email;
      _passwordController.text = password;
      setState(() {
        _rememberMe = rememberMe;
      });
    }
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<AuthService>(context, listen: false)
            .signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        // Check if the user is verified and accepted, then redirect accordingly
        bool isVerified = Provider.of<AuthService>(context, listen: false).currentUser!.emailVerified;
        if (!isVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please verify your email first.'),
            ),
          );
          await Provider.of<AuthService>(context, listen: false).signOut();
          return;
        }

        // Check if the user's registration status is accepted
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(Provider.of<AuthService>(context, listen: false).currentUser!.uid).get();
        bool isAccepted = userDoc.get('isAccepted') ?? false;

        if (!isAccepted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your registration has not been accepted yet.'),
            ),
          );
          await Provider.of<AuthService>(context, listen: false).signOut();
          return;
        }

        await _saveCredentials();

        // Navigate to the appropriate page based on role
        Widget homePage = await Provider.of<AuthService>(context, listen: false).handleAuth(
          Theme.of(context).brightness == Brightness.dark,
          widget.onThemeChanged,
          widget.onLanguageChanged,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => homePage),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 100),
              Text(
                localizations.translate('welcomeBack') ?? 'Welcome Back',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                localizations.translate('loginToContinue') ?? 'Login to continue',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localizations.translate('email') ?? 'Email',
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: true,
                  labelStyle: theme.inputDecorationTheme.labelStyle,
                  border: theme.inputDecorationTheme.border,
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
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: localizations.translate('password') ?? 'Password',
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: true,
                  labelStyle: theme.inputDecorationTheme.labelStyle,
                  border: theme.inputDecorationTheme.border,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourPassword') ?? 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  localizations.translate('rememberMe') ?? 'Remember me',
                  style: theme.textTheme.bodyLarge,
                ),
                value: _rememberMe,
                onChanged: (newValue) {
                  setState(() {
                    _rememberMe = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text(localizations.translate('login') ?? 'Login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                        backgroundColor: theme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: theme.textTheme.labelLarge,
                      ),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgotPassword');
                },
                child: Text(
                  localizations.translate('forgotPassword') ?? 'Forgot Password?',
                  style: TextStyle(
                    color: theme.textButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}) ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  localizations.translate('createNewAccount') ?? 'Create new account',
                  style: TextStyle(
                    color: theme.textButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}) ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/guestHome');
                },
                child: Text(
                  localizations.translate('continueAsGuest') ?? 'Continue as Guest',
                  style: TextStyle(
                    color: theme.textButtonTheme.style?.foregroundColor?.resolve({MaterialState.pressed}) ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: Localizations.localeOf(context).languageCode,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                        widget.onLanguageChanged(newValue);
                      }
                    },
                    items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value == 'en' ? 'English' : 'Arabic'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
