import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'l10n/app_localization.dart';
import 'setting.dart';
import 'registration_page.dart';
import 'horizontal_scroll_bar.dart';
import 'company_detail_page.dart';
import 'theme_manager.dart';

class GuestHomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  GuestHomePage({
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
      HomeScreen(),
      RegistrationPage(
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      SettingsPage(
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    // Example list of companies
    final companies = ["Company A", "Company B", "Company C", "Company D"];
    // Example list of packs
    final packs = [
      {'title': 'ELECTRICAL ENGINEERING SYSTEMS "EES"', 'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company1.png?alt=media&token=58eea9a1-2c66-4032-b5a0-e0771eaaa9fe'},
      {'title': 'Heavy Metal industries', 'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company2.png?alt=media&token=43bac023-dcac-472f-b1b7-6c4a195c0d35'},
      {'title': 'Steel Galvanizing', 'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company3.png?alt=media&token=fde97187-b06f-45a4-874f-06d1d727a78d'},
      {'title': 'HVAC Division', 'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company4.png?alt=media&token=44247617-9c5f-42ed-9b11-b9fbb4bacefa'},
      {'title': 'Equipment Rental', 'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company5.png?alt=media&token=9c2e2b36-c37f-4ff5-8d14-37ac3ec76780'},
      {'title': 'Energy Services Division "EQTASID"', 'image': 'https://firebasestorage.googleapis.com/v0/b/factoryapp-7775e.appspot.com/o/company6.png?alt=media&token=43af472b-34a6-4ae6-9634-dac2f43896e5'},
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
                childAspectRatio: 0.8,
              ),
              itemCount: packs.length,
              itemBuilder: (context, index) {
                return PackCard(
                  title: packs[index]['title'] as String,
                  image: packs[index]['image'] as String,
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
  final String image;

  PackCard({
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailPage(
              companyName: title,
              aboutText: 'Detailed description about $title',
              services: ['Service 1', 'Service 2', 'Service 3'],
              certificates: ['Certificate 1', 'Certificate 2'],
            ),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
