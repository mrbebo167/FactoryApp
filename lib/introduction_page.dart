import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localization.dart';

class IntroductionPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final VoidCallback onGetStarted;

  IntroductionPage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onGetStarted,
  });

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    List<Widget> _pages = [
      _buildPage(
        context,
        localizations,
        image: 'assets/intro1.png',
        title: localizations.translate('welcomeTitle') ?? 'Welcome to the Factory App!',
        description: localizations.translate('welcomeDescription') ?? 'Manage factory operations efficiently and effectively.',
      ),
      _buildPage(
        context,
        localizations,
        image: 'assets/intro2.png',
        title: localizations.translate('trackOrdersTitle') ?? 'Track Orders',
        description: localizations.translate('trackOrdersDescription') ?? 'Keep track of all your orders in one place.',
      ),
      _buildPage(
        context,
        localizations,
        image: 'assets/intro3.png',
        title: localizations.translate('manageNotificationsTitle') ?? 'Manage Notifications',
        description: localizations.translate('manageNotificationsDescription') ?? 'Receive real-time updates and notifications.',
      ),
      _buildPage(
        context,
        localizations,
        image: 'assets/intro4.png',
        title: localizations.translate('getStartedTitle') ?? 'Get Started',
        description: localizations.translate('getStartedDescription') ?? 'Let\'s get started with the Factory App!',
        isLastPage: true,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _currentPage < _pages.length - 1
                ? TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seenIntroduction', true);
                      widget.onGetStarted();
                    },
                    child: Text(
                      localizations.translate('skip') ?? 'SKIP',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage > 0
                    ? TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          localizations.translate('back') ?? 'BACK',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Row(
                  children: List.generate(_pages.length, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
                _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          localizations.translate('next') ?? 'NEXT',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, AppLocalizations localizations, {required String image, required String title, required String description, bool isLastPage = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          if (isLastPage) ...[
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seenIntroduction', true);
                widget.onGetStarted();
              },
              child: Text(localizations.translate('getStarted') ?? 'Get Started'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
