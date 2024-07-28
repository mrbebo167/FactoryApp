import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'login_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final String email;

  VerifyEmailPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.email,
  });

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isSendingVerification = false;

  void _sendVerificationEmail() async {
    setState(() {
      _isSendingVerification = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent! Please check your inbox.')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() {
        _isSendingVerification = false;
      });
    }
  }

  void _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user?.emailVerified ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder<Widget>(
            future: Provider.of<AuthService>(context, listen: false).handleAuth(
              widget.isDarkMode,
              widget.onThemeChanged,
              widget.onLanguageChanged,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data!;
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email not verified yet.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('A verification email has been sent to ${widget.email}. Please verify your email to continue.'),
            SizedBox(height: 20),
            _isSendingVerification
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendVerificationEmail,
                    child: Text('Resend Verification Email'),
                  ),
            ElevatedButton(
              onPressed: _checkEmailVerified,
              child: Text('I have verified my email'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
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
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
