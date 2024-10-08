import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'l10n/app_localization.dart';
import 'pending_page.dart';
import 'theme_manager.dart';

class RegistrationPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  RegistrationPage({
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Send email verification
        await userCredential.user?.sendEmailVerification();

        // Store user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'role': 'customer',
          'profilePicture': '', // Placeholder for profile picture
          'numberOfOrders': 0,
          'emailVerified': false, // Initial status
          'isAccepted': false, // Pending by default
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful. Please verify your email.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PendingPage(
              onThemeChanged: widget.onThemeChanged,
              onLanguageChanged: widget.onLanguageChanged,
              email: _emailController.text,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
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
                localizations.translate('createNewAccount') ?? 'Create New Account',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              Text(
                localizations.translate('registerToContinue') ?? 'Register to continue',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: localizations.translate('firstName') ?? 'First Name',
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: true,
                  labelStyle: theme.textTheme.bodyLarge,
                  border: theme.inputDecorationTheme.border,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourFirstName') ?? 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: localizations.translate('lastName') ?? 'Last Name',
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: true,
                  labelStyle: theme.textTheme.bodyLarge,
                  border: theme.inputDecorationTheme.border,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourLastName') ?? 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localizations.translate('email') ?? 'Email',
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: true,
                  labelStyle: theme.textTheme.bodyLarge,
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
                  labelStyle: theme.textTheme.bodyLarge,
                  border: theme.inputDecorationTheme.border,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('pleaseEnterYourPassword') ?? 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return localizations.translate('passwordMustBeAtLeast6CharactersLong') ?? 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: localizations.translate('confirmPassword') ?? 'Confirm Password',
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: true,
                  labelStyle: theme.textTheme.bodyLarge,
                  border: theme.inputDecorationTheme.border,
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return localizations.translate('passwordsDoNotMatch') ?? 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      child: Text(localizations.translate('register') ?? 'Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: theme.textTheme.labelLarge,
                      ),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  localizations.translate('alreadyHaveAnAccountLogin') ?? 'Already have an account? Login',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
