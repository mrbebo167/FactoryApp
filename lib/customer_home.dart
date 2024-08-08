import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_settings_page.dart';
import 'l10n/app_localization.dart';
import 'company_detail_page.dart';
import 'auth_service.dart';
import 'profile_page_customer.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';

class CustomerHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  CustomerHomeScreen({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    List<Widget> _pages = [
      CustomerHomePage(),
      VirtualTourPage(),
      CustomerSettingsPage(
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      CustomerProfilePage(
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('customerHome') ?? 'Customer Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: localizations.translate('home') ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tour),
            label: localizations.translate('virtualTour') ?? 'Virtual Tour',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.translate('settings') ?? 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: localizations.translate('profile') ?? 'Profile',
          ),
        ],
      ),
    );
  }
}

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final companies = [
      {
        'title': 'ELECTRICAL ENGINEERING SYSTEMS "EES"',
        'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company1.png?alt=media&token=58eea9a1-2c66-4032-b5a0-e0771eaaa9fe'
      },
      {
        'title': 'Heavy Metal industries',
        'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company2.png?alt=media&token=43bac023-dcac-472f-b1b7-6c4a195c0d35'
      },
      {
        'title': 'Steel Galvanizing',
        'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company3.png?alt=media&token=fde97187-b06f-45a4-874f-06d1d727a78d'
      },
      {
        'title': 'HVAC Division',
        'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company4.png?alt=media&token=44247617-9c5f-42ed-9b11-b9fbb4bacefa'
      },
      {
        'title': 'Equipment Rental',
        'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company5.png?alt=media&token=9c2e2b36-c37f-4ff5-8d14-37ac3ec76780'
      },
      {
        'title': 'Energy Services Division "EQTASID"',
        'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company6.png?alt=media&token=43af472b-34a6-4ae6-9634-dac2f43896e5'
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyDetailPage(
                  companyName: company['title']!,
                  aboutText: 'About text for ${company['title']}',
                  services: ['Service 1', 'Service 2', 'Service 3'],
                  certificates: ['Certificate 1', 'Certificate 2'],
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      company['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    company['title']!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VirtualTourPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('virtualTour') ?? 'Virtual Tour'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'ELECTRICAL ENGINEERING SYSTEMS "EES"',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // Navigate to EES virtual tour page
            },
          ),
          ListTile(
            title: Text(
              'Heavy Metal industries',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // Navigate to Heavy Metal industries virtual tour page
            },
          ),
          ListTile(
            title: Text(
              'Steel Galvanizing',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // Navigate to Steel Galvanizing virtual tour page
            },
          ),
          ListTile(
            title: Text(
              'HVAC Division',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // Navigate to HVAC Division virtual tour page
            },
          ),
          ListTile(
            title: Text(
              'Equipment Rental',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // Navigate to Equipment Rental virtual tour page
            },
          ),
          ListTile(
            title: Text(
              'Energy Services Division "EQTASID"',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // Navigate to EQTASID virtual tour page
            },
          ),
        ],
      ),
    );
  }
}
