import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';
import 'setting.dart';
import 'registration_page.dart';
import 'horizontal_scroll_bar.dart'; // Ensure the correct import path

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
    // Example list of companies with images
    final companies = [
      {'name': 'EES', 'image': 'assets/company1.png'},
      {'name': 'INDUSTRIAS', 'image': 'assets/company2.png'},
      {'name': 'STEEL', 'image': 'assets/company3.png'},
      {'name': 'CAC', 'image': 'assets/company4.png'},
      {'name': 'RENTAL', 'image': 'assets/company5.png'},
      {'name': 'EQTASID', 'image': 'assets/company6.png'},
    ];
    // Example list of packs
    final packs = [
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
          HorizontalScrollBar(companies: companies),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // Adjust the aspect ratio to make the boxes bigger or smaller
              ),
              itemCount: packs.length,
              itemBuilder: (context, index) {
                return PackCard(
                  title: packs[index]['title']!,
                  image: packs[index]['image']!,
                  isDarkMode: isDarkMode,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalScrollBar extends StatelessWidget {
  final List<Map<String, String>> companies;

  HorizontalScrollBar({required this.companies});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320, // Increase the height to accommodate images
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: companies.length,
        itemBuilder: (context, index) {
          return Container(
            width: 320,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      companies[index]['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  companies[index]['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PackCard extends StatelessWidget {
  final String title;
  final String image;
  final bool isDarkMode;

  PackCard({
    required this.title,
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
