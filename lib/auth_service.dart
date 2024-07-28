import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_home.dart';
import 'customer_home.dart';
import 'guest_home.dart';
import 'pending_page.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Getter to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String firstName, String lastName) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': 'customer',
        'isAccepted': false, // Ensure the field is set during registration
      });
    }

    notifyListeners();
  }

  Future<String> getUserRole() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      return userDoc.get('role') ?? 'guest';
    }
    return 'guest';
  }

  Future<void> setCustomClaims(String userId, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({'role': role});
  }

  Future<bool> isAdmin() async {
    String role = await getUserRole();
    return role == 'admin';
  }

  Future<Widget> handleAuth(bool isDarkMode, Function(bool) onThemeChanged, Function(String) onLanguageChanged) async {
    if (currentUser == null) {
      return PendingPage(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onLanguageChanged: onLanguageChanged,
        email: '',
      );
    }

    await currentUser!.reload(); // Ensure the latest user data is loaded
    User? updatedUser = _auth.currentUser;

    if (!updatedUser!.emailVerified) {
      return PendingPage(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onLanguageChanged: onLanguageChanged,
        email: updatedUser.email ?? '',
      );
    }

    String role;
    try {
      role = await getUserRole();
    } catch (e) {
      print("Error getting user role: $e");
      return PendingPage(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onLanguageChanged: onLanguageChanged,
        email: updatedUser.email ?? '',
      );
    }

    DocumentSnapshot userDoc;
    try {
      userDoc = await FirebaseFirestore.instance.collection('users').doc(updatedUser.uid).get();
    } catch (e) {
      print("Error getting user document: $e");
      return PendingPage(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onLanguageChanged: onLanguageChanged,
        email: updatedUser.email ?? '',
      );
    }

    bool isAccepted;
    try {
      isAccepted = userDoc.get('isAccepted') ?? false;
    } catch (e) {
      print("Error getting isAccepted field: $e");
      return PendingPage(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onLanguageChanged: onLanguageChanged,
        email: updatedUser.email ?? '',
      );
    }

    if (!isAccepted) {
      print("User is not accepted, returning PendingPage");
      return PendingPage(
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        onLanguageChanged: onLanguageChanged,
        email: updatedUser.email ?? '',
      );
    }

    switch (role) {
      case 'admin':
        print("Navigating to AdminHomePage");
        return AdminHomePage(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
          onLanguageChanged: onLanguageChanged,
        );
      case 'customer':
        print("Navigating to CustomerHomeScreen");
        return CustomerHomeScreen(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
          onLanguageChanged: onLanguageChanged,
        );
      default:
        print("Navigating to GuestHomePage");
        return GuestHomePage(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
          onLanguageChanged: onLanguageChanged,
        );
    }
  }
}
