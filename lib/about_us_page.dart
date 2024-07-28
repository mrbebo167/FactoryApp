import 'package:flutter/material.dart';
import 'l10n/app_localization.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text(localizations.translate('aboutUs') ?? 'About Us'),
        backgroundColor: isDarkMode ? Colors.black : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.yellow : Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSectionTitle(localizations.translate('mission') ?? 'Our Mission', isDarkMode),
            _buildSectionContent(localizations.translate('missionContent') ?? 'Our mission is to...', isDarkMode),
            _buildSectionTitle(localizations.translate('vision') ?? 'Our Vision', isDarkMode),
            _buildSectionContent(localizations.translate('visionContent') ?? 'Our vision is to...', isDarkMode),
            _buildSectionTitle(localizations.translate('values') ?? 'Our Values', isDarkMode),
            _buildSectionContent(localizations.translate('valuesContent') ?? 'We value...', isDarkMode),
            _buildSectionTitle(localizations.translate('ourTeam') ?? 'Our Team', isDarkMode),
            _buildSectionContent(localizations.translate('teamContent') ?? 'Meet our dedicated team...', isDarkMode),
            _buildSectionTitle(localizations.translate('contactInfo') ?? 'Contact Information', isDarkMode),
            _buildContactInfo(localizations, isDarkMode),
            _buildSectionTitle(localizations.translate('gallery') ?? 'Gallery', isDarkMode),
            _buildImageGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.yellow : Colors.black,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildContactInfo(AppLocalizations localizations, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactItem(Icons.phone, localizations.translate('phone') ?? 'Phone: +123 456 7890', isDarkMode),
        _buildContactItem(Icons.email, localizations.translate('email') ?? 'Email: info@factoryapp.com', isDarkMode),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: isDarkMode ? Colors.yellow : Colors.black),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGalleryImage('assets/about1.jpg'),
          _buildGalleryImage('assets/about2.jpg'),
          _buildGalleryImage('assets/about3.jpg'),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
