import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';
import 'setting.dart';
import 'registration_page.dart';
import 'horizontal_scroll_bar.dart'; // Ensure the correct import path
import 'company_detail_page.dart'; // Import the company detail page

class GuestHomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  GuestHomePage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _GuestHomePageState createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    List<Widget> _pages = [
      HomeScreen(isDarkMode: widget.isDarkMode),
      RegistrationPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      SettingsPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('guestHome') ?? 'Guest Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
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
            icon: Icon(Icons.app_registration),
            label: localizations.translate('register') ?? 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.translate('settings') ?? 'Settings',
          ),
        ],
        selectedItemColor: widget.isDarkMode ? Colors.yellow : Colors.yellow,
        unselectedItemColor: widget.isDarkMode ? Colors.white : Colors.grey,
        backgroundColor: widget.isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;

  HomeScreen({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    final companies = [
      {'title': 'ELECTRICAL ENGINEERING SYSTEMS "EES"', 'image': 'assets/company1.png'},
      {'title': 'Heavy Metal industries', 'image': 'assets/company2.png'},
      {'title': 'Steel Galvanizing', 'image': 'assets/company3.png'},
      {'title': 'HVAC Division', 'image': 'assets/company4.png'},
      {'title': 'Equipment Rental', 'image': 'assets/company5.png'},
      {'title': 'Energy Services Division "EQTASID"', 'image': 'assets/company6.png'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          HorizontalScrollBar(companies: companies.map((c) => c['title']!).toList()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: companies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyDetailPage(
                          companyName: companies[index]['title']!,
                          aboutText: 'About text from file',
                          services: ['Service 1', 'Service 2', 'Service 3'],
                          certificates: ['Certificate 1', 'Certificate 2'],
                        ),
                      ),
                    );
                  },
                  child: PackCard(
                    title: companies[index]['title']!,
                    exercises: '',
                    image: companies[index]['image']!,
                    isDarkMode: isDarkMode,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PackCard extends StatelessWidget {
  final String title;
  final String exercises;
  final String image;
  final bool isDarkMode;

  PackCard({
    required this.title,
    required this.exercises,
    required this.image,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
